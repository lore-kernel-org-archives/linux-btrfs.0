From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 1/2][BTRFS-PROGS] add the "--force" switch to the mkfs.btrfs command
Date: Tue, 18 Oct 2011 18:45:13 +0200
Message-ID: <7496499.QeRia36pgE@venice>
References: <CAKcLGm8nBmFZOgs4cxAz7qBfyWZne-VX7rhSxA6c0yd4eDTERA@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1717587.C26rEzKsJA"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm8nBmFZOgs4cxAz7qBfyWZne-VX7rhSxA6c0yd4eDTERA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1717587.C26rEzKsJA
Content-Type: multipart/mixed; boundary="nextPart1794490.Txgkrmja1G"
Content-Transfer-Encoding: 7Bit


--nextPart1794490.Txgkrmja1G
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

As requested by Mitch, I resend the patch related to the "--force" option for 
the mkfs.btrfs command.

This patch allow to bypass the check which ensure that you are formatting a 
not mounted partition/disk.
Sometime (eg in a chrooted environment where the /proc filesystem is not 
mounted ) you don't have all the information, and the check fails even if the 
device is not mounted.

Passing the --force|-f flag to the mkfs.btrfs command you bypass this check.

This patch update the mkfs.c program.




On Monday, 17 October, 2011 15:11:15 you wrote:
> Goffredo:
> 
> I was wanting to see if your mkfs.btrfs --force patches could get
> picked up in the Btrfs-progs testing tree that Hugo Mills is trying to
> maintain.
> 
> He was OK with the patches, but was hoping for a 'signed-off-by' and
> more description in the commit comment.
> 
> Could you resend your patches to the list with a 'signed-off-by' and
> some additional description?
> 
> Some suggested text for the comment:
> 
> Certain operating environments (such as a chroot environment) can lead
> to mkfs.btrfs failure while checking devices (particularly when all
> devices are not fully described in /dev).
> 
> The --force option skips device checking, and forces formating on the
> specified target.
> 
> Thanks.
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1794490.Txgkrmja1G
Content-Disposition: inline; filename="0001-Add-the-force-option.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-Add-the-force-option.patch"

>From 037b3d6f01da086dc7d308001289cb79bc08e0bd Mon Sep 17 00:00:00 2001
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Mon, 3 Jan 2011 19:51:46 +0100
Subject: [PATCH 1/2] Add the --force option.

Add the --force option to not check if a device is already mounted.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 mkfs.c |   46 ++++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index e3ced19..be236d0 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -303,6 +303,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10 or single\n");
+	fprintf(stderr, "\t -f --force don't check if a device is already mounted\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
@@ -368,6 +369,7 @@ static struct option long_options[] = {
 	{ "data", 1, NULL, 'd' },
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
+	{ "force", 0, NULL, 'f' },
 	{ 0, 0, 0, 0}
 };
 
@@ -1191,10 +1193,11 @@ int main(int ac, char **av)
 	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
 	char *pretty_buf;
+	int force=0;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VM", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMf", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1240,6 +1243,8 @@ int main(int ac, char **av)
 			case 'r':
 				source_dir = optarg;
 				source_dir_set = 1;
+			case 'f':
+				force=1;
 				break;
 			default:
 				print_usage();
@@ -1263,14 +1268,17 @@ int main(int ac, char **av)
 
 	if (source_dir == 0) {
 		file = av[optind++];
-		ret = check_mounted(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s mount status\n", file);
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is mounted\n", file);
-			exit(1);
+		if(!force){
+			ret = check_mounted(file);
+			if (ret < 0) {
+				fprintf(stderr, 
+				    "error checking %s mount status\n", file);
+				exit(1);
+			}
+			if (ret == 1) {
+				fprintf(stderr, "%s is mounted\n", file);
+				exit(1);
+			}
 		}
 		ac--;
 		fd = open(file, O_RDWR);
@@ -1353,15 +1361,17 @@ int main(int ac, char **av)
 		int old_mixed = mixed;
 
 		file = av[optind++];
-		ret = check_mounted(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s mount status\n",
-				file);
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is mounted\n", file);
-			exit(1);
+		if(!force){
+			ret = check_mounted(file);
+			if (ret < 0) {
+				fprintf(stderr, "error checking %s"
+					" mount status\n",file);
+				exit(1);
+			}
+			if (ret == 1) {
+				fprintf(stderr, "%s is mounted\n", file);
+				exit(1);
+			}
 		}
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
-- 
1.7.7


--nextPart1794490.Txgkrmja1G--

--nextPart1717587.C26rEzKsJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOna0ZvwTxYT3FBRIRAlwzAJ9I2rh1wNT5RIjvowLa6ZnmuPXWvQCfcQo6
gjzfhNwxA4WgtY30GXeiy8o=
=MWm1
-----END PGP SIGNATURE-----

--nextPart1717587.C26rEzKsJA--

