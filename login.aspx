<%@ Page Language="C#" %>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0, user-scalable=yes"/>
<link rel="stylesheet" href="style_login.css">
<script runat="server">
void login_Click(object sender, EventArgs e) {
  if (FormsAuthentication.Authenticate(tbUsername.Text, tbPassword.Text)) {
    FormsAuthentication.RedirectFromLoginPage(tbUsername.Text,
      persist.Checked);
  } else {
    Message.Text = "失敗しました。パスワードを確認してください";
  }
}

</script>
</head>
<body>
  <form runat="server">
    <p>ユーザーID : <asp:TextBox id="tbUsername" runat="server" /></p>
    <p>パスワード : <asp:TextBox id="tbPassword" TextMode="Password" runat="server" /></p>
    <p>
      <asp:CheckBox id="persist"
        Text="認証情報を記憶する" runat="server"/>
      <asp:Button id="login" Text="ログイン"
        OnClick="login_Click" runat="server" />
    </p>
    <p><asp:Label id="Message" ForeColor="red" runat="server" /></p>
  </form>
</body>
</html>
