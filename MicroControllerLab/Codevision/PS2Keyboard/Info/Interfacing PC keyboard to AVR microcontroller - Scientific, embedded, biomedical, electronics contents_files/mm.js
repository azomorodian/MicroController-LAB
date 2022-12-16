ch_ad_url = '';
ch_oeh = window.onerror;

function dq(s) { return (s != null) ? '"' + s + '"' : '""'; }
function ch_au(p,v) { if (v) { window.ch_ad_url += '&' + p + '=' + v; } }
function ch_aue(p,v) { if (v) { ch_au(p,escape(v)); } }

function ch_mm() {
  var w = window;
  w.onerror = w.ch_oeh;
  w.ch_ad_url = 'http://mm.chitika.net/minimall?w=' + w.ch_width + '&h=' + ch_height;
  ch_aue('client', w.ch_client);
  ch_aue('accountid', w.ch_accountid);
  ch_aue('noctxt', w.ch_non_contextual);
  ch_aue('partner', w.ch_partner);
  ch_aue('sid', w.ch_sid);
  ch_au('provider', w.ch_provider);
  ch_aue('url', w.ch_pu);

  if ( w['ch_send_title'] && (!w['ch_query'] || w.ch_query == 'INSERT ARTICLE TITLE HERE' )) {
    try {
      w.ch_query = document.getElementsByTagName('title')[0].innerHTML;
    } catch (e) {}
  }

  ch_aue('query', w.ch_query);

  if ( w.ch_type ) {

    if ( w['ch_send_title'] && (!w['ch_queries']) ) {
      w.ch_queries = new Array(document.getElementsByTagName('title')[0].innerHTML);
    }

    ch_au('type', w.ch_type);
    if ( w.ch_queries && w.ch_queries.constructor.toString().indexOf("Array") != -1) {
      if ( w['ch_send_title'] ) {
        try {
          w.ch_queries.push(document.getElementsByTagName('title')[0].innerHTML);
        } catch (e) { }
      }
      ch_aue('mquery', w.ch_queries.join('|') );
    } else if ( w.ch_query ) {
      ch_aue('mquery', w.ch_query);
    }
  }
  ch_aue('tptracker', w.ch_third_party_tracker);
  ch_aue('defaulttab', w.ch_default_tab);
  ch_aue('defaultcat', w.ch_default_category);
  ch_aue('filtercat', w.ch_filter_category);
  ch_aue('cttarget', w.ch_target);
  ch_aue('att', w.ch_att);
  ch_aue('nosearch', w.ch_nosearch);
  ch_aue('noprice', w.ch_noprice);
  ch_aue('vertical', w.ch_vertical);
  ch_aue('cl_border', w.ch_color_border);
  ch_aue('cl_bg', w.ch_color_bg);
  ch_aue('cl_title', w.ch_color_title);
  ch_aue('cl_text', w.ch_color_text);
  ch_aue('fn_title', w.ch_font_title);
  ch_aue('fn_text', w.ch_font_text);
  ch_aue('alturl', w.ch_alternate_ad_url);
  ch_aue('altcss', w.ch_alternate_css_url);
  ch_aue('ref', document.referrer);
  ch_aue('ecpmiwant', w.ch_ecpm_i_want);
  ch_aue('shqueries', w.ch_shufflequeries);
	
  var r = Math.round(Math.random() * 1000);
  ch_au('cb', r);
  w.ch_ad_url = w.ch_ad_url.substring(0, 2048);
  w.ch_ad_url = w.ch_ad_url.replace(/%\w?$/, '');

  document.write('<ifr' + 'ame' + ' name="ch_ad'+r+'"' + ' width=' + dq(w.ch_width) + ' height=' + dq(w.ch_height) + ' frameborder="0"' + ' src=' + dq(w.ch_ad_url) + ' marginwidth="0"' + ' marginheight="0"' + ' vspace="0"' + ' hspace="0"' + ' allowtransparency="true"' + ' scrolling="no">' + '</ifr' + 'ame>');

  w.ch_pu = null;
  w.ch_ad_url = null;
  w.ch_query = null;
  w.ch_type = null;
  w.ch_alternate_css_url = null;
  w.ch_sid = null;
  w.ch_nosearch = null;
  w.ch_noprice = null;
  w.ch_default_tab = null;
  w.ch_default_category = null;
  w.ch_filter_category = null;
  w.ch_vertical = null;
  w.ch_shufflequeries = null;
}

function ch_eh(m,u,l) {
  ch_mm();
  return true;
}

window.onerror = ch_eh;

if (window.ch_pu == null) {
  ch_pu = document.location;
} else {
  ch_loc = document.location;
}

ch_mm();

