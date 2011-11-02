From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/7] get-default man page
Date: Wed, 02 Nov 2011 22:23:42 +0100
Message-ID: <3488788.FXyDJRn6Dj@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4415292.jTHB4dE5Bi"; micalg="pgp-sha1"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart4415292.jTHB4dE5Bi
Content-Type: multipart/mixed; boundary="nextPart1438634.X0dL9I6nsy"
Content-Transfer-Encoding: 7Bit


--nextPart1438634.X0dL9I6nsy
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Add the man page info for the "btrfs subvolume get-default" command. This command 
was not mentioned in the man page before.

Comments are welcome.


BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>


---
 btrfs_cmds.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 01e08fb..265d2cd 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1810,6 +1810,16 @@ int do_change_label(int nargs, char **argv)
 }
 
 
+/**** man: btrfs subvolume get-default
+ * 
+ * \Bbtrfs\b \Bsubvolume get-default\b\I <path>\i
+ * 
+ * Query which subvolume of the filesystem <path> will be mounted
+ * as default.
+ * 
+ * Get the \Idefault\i subvolume of the filesystem \I<path>\i. 
+ ****/
+
 int do_get_default_subvol(int nargs, char **argv)
 {
 	int fd;

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1438634.X0dL9I6nsy
Content-Disposition: inline; filename="send-via-kmail-attach-14132-1320267561-26993.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-14132-1320267561-26993.msg"

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 01e08fb..265d2cd 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1810,6 +1810,16 @@ int do_change_label(int nargs, char **argv)
 }
 
 
+/**** man: btrfs subvolume get-default
+ * 
+ * \Bbtrfs\b \Bsubvolume get-default\b\I <path>\i
+ * 
+ * Query which subvolume of the filesystem <path> will be mounted
+ * as default.
+ * 
+ * Get the \Idefault\i subvolume of the filesystem \I<path>\i. 
+ ****/
+
 int do_get_default_subvol(int nargs, char **argv)
 {
 	int fd;


--nextPart1438634.X0dL9I6nsy--

--nextPart4415292.jTHB4dE5Bi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOsbTevwTxYT3FBRIRAjyHAJ9uFh5rIitePcaSUd+qTnGULhA2FQCfcGgx
xZ22zEDNXQfe7haQ2aPbvXg=
=uZO1
-----END PGP SIGNATURE-----

--nextPart4415292.jTHB4dE5Bi--

