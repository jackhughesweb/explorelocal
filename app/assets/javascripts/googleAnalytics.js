function gaLog(category, action, label) {
  if (typeof ga !== 'undefined') { 
    ga('send', 'event', category, action, label);
  }
}