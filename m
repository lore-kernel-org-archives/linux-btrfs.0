Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kim.monte-stello.com ([91.121.114.170]:52729 "EHLO
	kim.monte-stello.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3CKV1T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 17:27:19 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by kim.monte-stello.com (Postfix) with ESMTP id 3C4E22D4D5
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 21:17:22 +0000 (GMT)
Received: from kim.monte-stello.com ([127.0.0.1])
	by localhost (kim.monte-stello.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id IYxq3uqsly4S for <linux-btrfs@vger.kernel.org>;
	Mon, 11 Mar 2013 21:17:21 +0000 (GMT)
Date: Mon, 11 Mar 2013 21:17:17 +0000
From: Antoine Sirinelli <antoine@monte-stello.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Add a rule to build a static mkfs.btrfs
Message-ID: <20130311211714.GA8494@kabis>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Static mkfs.btrfs can be used to "bootstrap" a system from a live CD
which does not provide mkfs.btrfs.

The executable produced is named mkfs.btrfs.static and built by invoking
the "static" make rule.

Signed-off-by: Antoine Sirinelli <antoine@monte-stello.com>
---
 Makefile |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index bea8ae9..e986e51 100644
--- a/Makefile
+++ b/Makefile
@@ -72,7 +72,7 @@ all: version.h $(progs) manpages
 # NOTE: For static compiles, you need to have all the required libs
 # 	static equivalent available
 #
-static: version.h btrfs.static
+static: version.h btrfs.static mkfs.btrfs.static
=20
 version.h:
 	$(Q)bash version.sh
@@ -116,6 +116,11 @@ mkfs.btrfs: $(objects) mkfs.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -l=
blkid
=20
+mkfs.btrfs.static: $(static_objects) mkfs.static.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o mkfs.btrfs.static mkfs.static.o \
+		$(static_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
+
 btrfs-debug-tree: $(objects) debug-tree.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS=
) $(LIBS)
@@ -178,7 +183,7 @@ clean :
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-se=
lect-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test b=
trfs.static btrfsck \
-	      version.h
+	      version.h mkfs.btrfs.static
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
=20
 install: $(progs) install-man
--=20
1.7.10.4


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPknTAAoJEBffEMtnGaT5PYAP/iH9tVLmUjJR0VEqrdU+NTic
qGu/AbHhwEZk2Ns6JqjM+YsymtM2J7+R1aB9mlHlvc5XU0fFY+I91v7cbFMslnYC
wyIQrPINJ423+HxQ32u7yrvFQeDFJo5e82ORJwKpd0lKzNw9OttWYO1USTkQNSps
jk/6OOXWpk2kkbsCLQkTbBg5+i+650XSDDONVGLAVGUdeDduOKVWD9MUztYcVSBo
KN1oH+2HTZiYU+aOA1bT7kG46h5mIKdEK7JMUVpnQHJbSUn80ovgIAkIb4BDOUv1
lgLcHRa1Ct4XHCqjpWbGuc1OUBpVChl7JJSaCRd1fRX4Pak2vhERr4+BCazqTxRD
VYJ4V84v4GjJn1eQkTVxVvGxhp25GUm9///kl/E0UcoNKe+3dzhhzst5Ry+cOZTr
blKyVsZdJZ4m7AOM1eq2Um95UQwCwG3xdUJQee6nora8ptXmzcxl+2E7phwaGUvI
jOqrgJVj4CP76OwTnVhFiVrubutSAKnsC0dp9FrREa0Eldtj+At6zMt0b+O3UbQw
A8eOJLWoO7glqB7dPH4X28/LGJ8b9qkDnNJAxzGetjjgx9ojipqE7TKGyh9Xu4E8
8jxa+Wo8a2ijWOSEYW271NLANSdqSvfFnsUHB/87TfcAzPQCEaydlOpHqiDT0GMR
p56i/+FUGBLiqK36CdOl
=nNDv
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
