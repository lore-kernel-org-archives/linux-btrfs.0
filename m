From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BTRFS-PROG][PATCH 7/7] Test for man page
Date: Wed, 02 Nov 2011 22:23:49 +0100
Message-ID: <2290721.F2lPLrcd0v@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7515924.2TamNO1CnH"; micalg="pgp-sha1"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart7515924.2TamNO1CnH
Content-Type: multipart/mixed; boundary="nextPart2477584.Uc7YqM3156"
Content-Transfer-Encoding: 7Bit


--nextPart2477584.Uc7YqM3156
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

This test checks that the man page cites all the btrfs commands

Comments are welcome.

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 test/003s.sh |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100755 test/003s.sh

diff --git a/test/003s.sh b/test/003s.sh
new file mode 100755
index 0000000..b47bfb8
--- /dev/null
+++ b/test/003s.sh
@@ -0,0 +1,40 @@
+#!/bin/bash
+
+. test/functions.sh
+
+# to avoid an unneeded losetup execution
+BTRFS_TESTS_VOLUMES=""
+
+announce manpage
+catchclean
+
+cmds="$( ./btrfs | grep "^$(echo -ne \\t)btrfs" | grep -v help | 
+		while read line; do
+			set $line
+			# restripe commands have 4 verbs, 
+			# the other commands have 3 only verbs
+			if [ "x$3" = "xrestripe" ]; then
+				echo "$1,$2,$3,$4"
+			else
+				echo "$1,$2,$3"
+			fi
+		done
+
+)"
+
+function check_command(){
+	tot="$(man man/btrfs.8.in | grep -E "$1" | wc -l )"
+	[ "$tot" -ge 2 ]
+}
+
+for cmd in $cmds; do
+
+	recmd="$( echo $cmd | sed -e "s/,/[[:space:]]+/g" )"
+	vcmd="$( echo $cmd | sed -e "s/,/ /g" )"
+	
+	catch check_command "$recmd" || \
+		fail Command "'$vcmd'" not present in man page
+
+done
+
+summarise

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart2477584.Uc7YqM3156
Content-Disposition: inline; filename="send-via-kmail-attach-12137-1320267578-27114.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-12137-1320267578-27114.msg"

diff --git a/test/003s.sh b/test/003s.sh
new file mode 100755
index 0000000..b47bfb8
--- /dev/null
+++ b/test/003s.sh
@@ -0,0 +1,40 @@
+#!/bin/bash
+
+. test/functions.sh
+
+# to avoid an unneeded losetup execution
+BTRFS_TESTS_VOLUMES=""
+
+announce manpage
+catchclean
+
+cmds="$( ./btrfs | grep "^$(echo -ne \\t)btrfs" | grep -v help | 
+		while read line; do
+			set $line
+			# restripe commands have 4 verbs, 
+			# the other commands have 3 only verbs
+			if [ "x$3" = "xrestripe" ]; then
+				echo "$1,$2,$3,$4"
+			else
+				echo "$1,$2,$3"
+			fi
+		done
+
+)"
+
+function check_command(){
+	tot="$(man man/btrfs.8.in | grep -E "$1" | wc -l )"
+	[ "$tot" -ge 2 ]
+}
+
+for cmd in $cmds; do
+
+	recmd="$( echo $cmd | sed -e "s/,/[[:space:]]+/g" )"
+	vcmd="$( echo $cmd | sed -e "s/,/ /g" )"
+	
+	catch check_command "$recmd" || \
+		fail Command "'$vcmd'" not present in man page
+
+done
+
+summarise


--nextPart2477584.Uc7YqM3156--

--nextPart7515924.2TamNO1CnH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOsbTlvwTxYT3FBRIRAuqcAJ95OwUXYoEeKeKTAf1c/dhgZZshDACcDFkU
6FCRMBUiasI7wzE3qSqHETc=
=nZTP
-----END PGP SIGNATURE-----

--nextPart7515924.2TamNO1CnH--

