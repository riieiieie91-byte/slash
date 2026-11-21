package com.ptj.minibrowser;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.util.ArrayList;

public class MainActivity extends Activity {
    private final ArrayList<WebView> tabs = new ArrayList<>();
    private int active = -1;
    private LinearLayout root, tabBar, pageHost;
    private EditText address;

    private int dp(int n) {
        return (int)(n * getResources().getDisplayMetrics().density + 0.5f);
    }
    private Button btn(String s) {
        Button b = new Button(this); b.setText(s); b.setAllCaps(false); b.setTextSize(12); return b;
    }
    @Override public void onCreate(Bundle b) {
        super.onCreate(b);
        getWindow().setStatusBarColor(Color.rgb(20,23,32));
        getWindow().setNavigationBarColor(Color.rgb(20,23,32));
        root = new LinearLayout(this); root.setOrientation(1);
        root.setBackgroundColor(Color.rgb(20,23,32));
        LinearLayout bar = new LinearLayout(this);
        bar.setGravity(Gravity.CENTER_VERTICAL); bar.setPadding(dp(4),dp(3),dp(4),dp(3));
        bar.setBackgroundColor(Color.rgb(31,36,49));
        Button back=btn("‹"), next=btn("›"), reload=btn("↻"), add=btn("+");
        address = new EditText(this); address.setSingleLine(true); address.setTextSize(14);
        address.setTextColor(Color.WHITE); address.setHintTextColor(Color.LTGRAY);
        address.setHint("Nhập địa chỉ website"); address.setImeOptions(EditorInfo.IME_ACTION_GO);
        address.setPadding(dp(8),0,dp(8),0); address.setBackgroundColor(Color.rgb(52,59,76));
        back.setOnClickListener(v -> current(w -> { if(w.canGoBack()) w.goBack(); }));
        next.setOnClickListener(v -> current(w -> { if(w.canGoForward()) w.goForward(); }));
        reload.setOnClickListener(v -> current(WebView::reload));
        add.setOnClickListener(v -> newTab("https://www.google.com"));
        address.setOnEditorActionListener((v,a,e)->{
            if(a==EditorInfo.IME_ACTION_GO || a==EditorInfo.IME_ACTION_DONE) {
                String s=address.getText().toString().trim();
                if(!s.contains("://")) s=(s.contains(".")?"https://":"https://www.google.com/search?q=")+s.replace(" ","+");
                final String url=s; current(w->w.loadUrl(url)); return true;
            } return false;
        });
        bar.addView(back,new LinearLayout.LayoutParams(dp(40),dp(44)));
        bar.addView(next,new LinearLayout.LayoutParams(dp(40),dp(44)));
        bar.addView(reload,new LinearLayout.LayoutParams(dp(40),dp(44)));
        bar.addView(address,new LinearLayout.LayoutParams(0,dp(42),1));
        bar.addView(add,new LinearLayout.LayoutParams(dp(44),dp(44)));
        root.addView(bar);
        tabBar=new LinearLayout(this); tabBar.setPadding(dp(3),dp(3),dp(3),dp(3));
        tabBar.setBackgroundColor(Color.rgb(24,28,39));
        root.addView(tabBar,new LinearLayout.LayoutParams(-1,dp(44)));
        pageHost=new LinearLayout(this); pageHost.setOrientation(1);
        root.addView(pageHost,new LinearLayout.LayoutParams(-1,0,1));
        setContentView(root);
        newTab("https://www.google.com");
    }
    interface Action { void run(WebView w); }
    private void current(Action a) { if(active>=0 && active<tabs.size()) a.run(tabs.get(active)); }
    private void newTab(String url) {
        WebView w=new WebView(this);
        w.getSettings().setJavaScriptEnabled(true); w.getSettings().setDomStorageEnabled(true);
        w.getSettings().setBuiltInZoomControls(true); w.getSettings().setDisplayZoomControls(false);
        w.setWebChromeClient(new WebChromeClient());
        w.setWebViewClient(new WebViewClient(){
            @Override public void onPageFinished(WebView view,String u) {
                if(tabs.indexOf(view)==active) address.setText(u);
                refreshTabs();
            }
        });
        tabs.add(w); pageHost.addView(w,new LinearLayout.LayoutParams(-1,-1));
        switchTo(tabs.size()-1); w.loadUrl(url);
    }
    private void switchTo(int i) {
        if(i<0 || i>=tabs.size()) return; active=i;
        for(int n=0;n<tabs.size();n++) tabs.get(n).setVisibility(n==active?View.VISIBLE:View.GONE);
        String u=tabs.get(i).getUrl(); address.setText(u==null?"":u); refreshTabs();
    }
    private void refreshTabs() {
        tabBar.removeAllViews();
        for(int i=0;i<tabs.size();i++) {
            final int index=i;
            LinearLayout item=new LinearLayout(this); item.setGravity(Gravity.CENTER);
            item.setBackgroundColor(i==active?Color.rgb(65,79,111):Color.rgb(43,48,63));
            TextView label=new TextView(this); label.setText("Tab "+(i+1));
            label.setTextColor(Color.WHITE); label.setGravity(Gravity.CENTER);
            item.addView(label,new LinearLayout.LayoutParams(0,-1,1));
            TextView close=new TextView(this); close.setText("×"); close.setTextSize(18);
            close.setTextColor(Color.WHITE); close.setGravity(Gravity.CENTER);
            item.addView(close,new LinearLayout.LayoutParams(dp(28),-1));
            close.setOnClickListener(v->closeTab(index));
            item.setOnClickListener(v->switchTo(index));
            LinearLayout.LayoutParams lp=new LinearLayout.LayoutParams(0,-1,1);
            lp.setMargins(dp(2),0,dp(2),0); tabBar.addView(item,lp);
        }
    }
    private void closeTab(int i) {
        if(i<0 || i>=tabs.size()) return;
        WebView w=tabs.remove(i); pageHost.removeView(w); w.stopLoading(); w.destroy();
        if(tabs.isEmpty()) { newTab("https://www.google.com"); return; }
        if(active>=tabs.size()) active=tabs.size()-1;
        else if(i<active) active--;
        switchTo(active);
    }
    @Override public void onBackPressed() {
        if(active>=0 && tabs.get(active).canGoBack()) tabs.get(active).goBack();
        else super.onBackPressed();
    }
    @Override protected void onDestroy() {
        for(WebView w:tabs) { w.stopLoading(); w.destroy(); }
        tabs.clear(); super.onDestroy();
    }
}
