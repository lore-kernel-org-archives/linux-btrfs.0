From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BTRFS-PROG][PATCH 3/7] The man/btrfs.8.in man page is auto-generated
Date: Wed, 02 Nov 2011 22:23:35 +0100
Message-ID: <16314013.f7H6TtqO7M@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1426448.OjHhO8ukdK"; micalg="pgp-sha1"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1426448.OjHhO8ukdK
Content-Type: multipart/mixed; boundary="nextPart1562190.RBWaYMjKmL"
Content-Transfer-Encoding: 7Bit


--nextPart1562190.RBWaYMjKmL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Warn that the man/btrfs.8.in man page is auto-generated

Comments are welcome.

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 btrfs.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 4235d54..d7ece5b 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -88,6 +88,11 @@
  * .\"
  * .\" Man page for the "btrfs" tool 
  * .\"
+ * .\" WARNING
+ * .\" WARNING This file is generated automatically. Don't edit, your change
+ * .\" WARNING will be lost. See the file btrfs.c for further information
+ * .\" WARNING 
+ * .\"
  * .SH NAME
  * btrfs \- control a btrfs filesystem
  ****/

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1562190.RBWaYMjKmL
Content-Disposition: inline; filename="send-via-kmail-attach-31164-1320267556-26954.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-31164-1320267556-26954.msg"

diff --git a/btrfs.c b/btrfs.c
index 4235d54..d7ece5b 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -88,6 +88,11 @@
  * .\"
  * .\" Man page for the "btrfs" tool 
  * .\"
+ * .\" WARNING
+ * .\" WARNING This file is generated automatically. Don't edit, your change
+ * .\" WARNING will be lost. See the file btrfs.c for further information
+ * .\" WARNING 
+ * .\"
  * .SH NAME
  * btrfs \- control a btrfs filesystem
  ****/


--nextPart1562190.RBWaYMjKmL--

--nextPart1426448.OjHhO8ukdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOsbTXvwTxYT3FBRIRAlRDAJ994hhbetDg9ksOUhyYHTLSKGZ88gCcD73I
Uvqxoc9IkXEPTaaKiTPiPqo=
=1PSJ
-----END PGP SIGNATURE-----

--nextPart1426448.OjHhO8ukdK--

