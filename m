From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BTRFS-PROGS][PATCH 5/7] btrfs filesystem restriper man page added
Date: Wed, 02 Nov 2011 22:23:19 +0100
Message-ID: <1803378.QLkab4k852@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1388245.FxYhrWq4Gh"; micalg="pgp-sha1"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1388245.FxYhrWq4Gh
Content-Type: multipart/mixed; boundary="nextPart1393987.xfPBu2uBcG"
Content-Transfer-Encoding: 7Bit


--nextPart1393987.xfPBu2uBcG
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Added "btrfs filesystem restriper *" commands to the man page

Ilya,
could you be so kindly to take care of these info for the man page 
from now onwards ?

After merging this patch you can see this text in the man page doing:

make man/btrfs.8.in
man man/btrfs.8.in

Don't hesitate to contact me for further information.

Comments are welcome.

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 btrfs_cmds.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 265d2cd..967917e 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1359,9 +1359,40 @@ static struct option restripe_longopts[] = {
 	{ 0, 0, 0, 0}
 };
 
-/*
- * [-d [filters]] [-m [filters]] [-s [filters]] [-vf]
- */
+/**** man: btrfs filesystem restripe start
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe start\b [-d [filters]] [-m [filters]] [-s [filters]] [-vf] \I<path>\i
+ * 
+ * Start restriper.
+ * 
+ * Start restriper.
+ * 
+ * \B-d\b	\Idata\i.
+ * 
+ * \B-m\b	\Imetadata\i.
+ * 
+ * \B-s\b	\Isystem\i.
+ * 
+ * \B-f\b	force.
+ * 
+ * \B-v\b	verbose.
+ * 
+ * \Ifilters\i may be a comma separated list of the following item
+ * 
+ * \Bprofile\b=raid0|raid1|raid10|single|dup ( multiple profiles allowed)
+ * 
+ * \Busage\b=<nnn>
+ * 
+ * \Bdevid\b=<nnn>
+ * 
+ * \Bconvert\b=raid0|raid1|radi10|single|dup (only one profile alloweda)
+ * 
+ * \Bvrange\b=[start]..[stop]
+ * 
+ * \Bdrange\b=[start]..[stop]
+ * 
+ ****/
+
 int do_restripe(int ac, char **av)
 {
 	int fd;
@@ -1478,6 +1509,16 @@ int do_restripe(int ac, char **av)
 	return 0;
 }
 
+/**** man: btrfs filesystem restripe cancel
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe cancel\b \I<path>\i
+ * 
+ * Cancel restriper.
+ * 
+ * Cancel restriper.
+ * 
+ ****/
+
 int do_restripe_cancel(int ac, char **av)
 {
 	int fd;
@@ -1504,6 +1545,16 @@ int do_restripe_cancel(int ac, char **av)
 	return 0;
 }
 
+/**** man: btrfs filesystem restripe pause
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe pause\b \I<path>\i
+ * 
+ * Pause restriper.
+ * 
+ * Pause restriper.
+ * 
+ ****/
+
 int do_restripe_pause(int ac, char **av)
 {
 	int fd;
@@ -1530,6 +1581,16 @@ int do_restripe_pause(int ac, char **av)
 	return 0;
 }
 
+/**** man: btrfs filesystem restripe resume
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe resume\b \I<path>\i
+ * 
+ * Resume interrupted restripe operation.
+ * 
+ * Resume interrupted restripe operation.
+ * 
+ ****/
+
 int do_restripe_resume(int ac, char **av)
 {
 	int fd;
@@ -1571,6 +1632,18 @@ static struct option restripe_progress_longopts[] = {
 	{ 0, 0, 0, 0}
 };
 
+/**** man: btrfs filesystem restripe status  
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe status\b [-v] \I<path>\i
+ * 
+ * Show status of running or paused restripe operation.
+ * 
+ * Show status of running or paused restripe operation.
+ *
+ * \B-v\b	verbose.
+ * 
+ ****/
+
 int do_restripe_progress(int ac, char **av)
 {
 	int fd;

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1393987.xfPBu2uBcG
Content-Disposition: inline; filename="send-via-kmail-attach-26955-1320267567-27032.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-26955-1320267567-27032.msg"

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 265d2cd..967917e 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1359,9 +1359,40 @@ static struct option restripe_longopts[] = {
 	{ 0, 0, 0, 0}
 };
 
-/*
- * [-d [filters]] [-m [filters]] [-s [filters]] [-vf]
- */
+/**** man: btrfs filesystem restripe start
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe start\b [-d [filters]] [-m [filters]] [-s [filters]] [-vf] \I<path>\i
+ * 
+ * Start restriper.
+ * 
+ * Start restriper.
+ * 
+ * \B-d\b	\Idata\i.
+ * 
+ * \B-m\b	\Imetadata\i.
+ * 
+ * \B-s\b	\Isystem\i.
+ * 
+ * \B-f\b	force.
+ * 
+ * \B-v\b	verbose.
+ * 
+ * \Ifilters\i may be a comma separated list of the following item
+ * 
+ * \Bprofile\b=raid0|raid1|raid10|single|dup ( multiple profiles allowed)
+ * 
+ * \Busage\b=<nnn>
+ * 
+ * \Bdevid\b=<nnn>
+ * 
+ * \Bconvert\b=raid0|raid1|radi10|single|dup (only one profile alloweda)
+ * 
+ * \Bvrange\b=[start]..[stop]
+ * 
+ * \Bdrange\b=[start]..[stop]
+ * 
+ ****/
+
 int do_restripe(int ac, char **av)
 {
 	int fd;
@@ -1478,6 +1509,16 @@ int do_restripe(int ac, char **av)
 	return 0;
 }
 
+/**** man: btrfs filesystem restripe cancel
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe cancel\b \I<path>\i
+ * 
+ * Cancel restriper.
+ * 
+ * Cancel restriper.
+ * 
+ ****/
+
 int do_restripe_cancel(int ac, char **av)
 {
 	int fd;
@@ -1504,6 +1545,16 @@ int do_restripe_cancel(int ac, char **av)
 	return 0;
 }
 
+/**** man: btrfs filesystem restripe pause
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe pause\b \I<path>\i
+ * 
+ * Pause restriper.
+ * 
+ * Pause restriper.
+ * 
+ ****/
+
 int do_restripe_pause(int ac, char **av)
 {
 	int fd;
@@ -1530,6 +1581,16 @@ int do_restripe_pause(int ac, char **av)
 	return 0;
 }
 
+/**** man: btrfs filesystem restripe resume
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe resume\b \I<path>\i
+ * 
+ * Resume interrupted restripe operation.
+ * 
+ * Resume interrupted restripe operation.
+ * 
+ ****/
+
 int do_restripe_resume(int ac, char **av)
 {
 	int fd;
@@ -1571,6 +1632,18 @@ static struct option restripe_progress_longopts[] = {
 	{ 0, 0, 0, 0}
 };
 
+/**** man: btrfs filesystem restripe status  
+ * 
+ * \Bbtrfs\b \Bfilesystem restripe status\b [-v] \I<path>\i
+ * 
+ * Show status of running or paused restripe operation.
+ * 
+ * Show status of running or paused restripe operation.
+ *
+ * \B-v\b	verbose.
+ * 
+ ****/
+
 int do_restripe_progress(int ac, char **av)
 {
 	int fd;


--nextPart1393987.xfPBu2uBcG--

--nextPart1388245.FxYhrWq4Gh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOsbTHvwTxYT3FBRIRAgj1AJ0RB97ZkFEldC8iVQIomgO5QvCXTACfceVU
srJRth8EeIuzJmHqLDxjOaE=
=p9Ll
-----END PGP SIGNATURE-----

--nextPart1388245.FxYhrWq4Gh--

