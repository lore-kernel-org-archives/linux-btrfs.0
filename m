From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH][TRIVIAL] Improve the btrfsctl help
Date: Sat, 12 Dec 2009 16:39:27 +0100
Message-ID: <200912121639.41192.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart42024413.F97EOSMJeF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart42024413.F97EOSMJeF
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

I found the help of the btrfctl command very poor. I rewrite some help=20
messages and correct (or added when needed) the check of the number of=20
parameter.

Please apply.


* Improve/correct the check of the arguments number
* Revise the command help
=2D--
 btrfsctl.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 66c4e89..0e5ce79 100644
=2D-- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -45,17 +45,18 @@ static inline int ioctl(int fd, int define, void *arg) =
{=20
return 0; }
=20
 static void print_usage(void)
 {
=2D	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
=2D	printf("                [-r size] [-A device] [-a] [-c] [-D dir .]\n");
+	printf("usage: btrfsctl [-d file|dir] [-s snap_name subvol]\n");
+	printf("                [-S vol_name dir] [-a] [-r size subvol]\n");
+	printf("                [-A device] [-c subvol] [-D name subvol]\n");
 	printf("\t-d filename: defragments one file\n");
 	printf("\t-d directory: defragments the entire Btree\n");
=2D	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
=2D	printf("\t-S subvol_name dir: creates a new subvolume\n");
=2D	printf("\t-r [+-]size[gkm]: resize the FS by size amount\n");
=2D	printf("\t-A device: scans the device file for a Btrfs filesystem\n");
+	printf("\t-s snap_name subvol: creates a new snapshot of subvol\n");
+	printf("\t-S subvol_name dir: creates a new subvolume in dir\n");
 	printf("\t-a: scans all devices for Btrfs filesystems\n");
=2D	printf("\t-c: forces a single FS sync\n");
=2D	printf("\t-D: delete snapshot\n");
+	printf("\t-r [+-]size[gkm] subvol: resize the FS by size amount\n");
+	printf("\t-A device: scans the device file for a Btrfs filesystem\n");
+	printf("\t-c subvol: forces a single FS sync\n");
+	printf("\t-D name dir: delete a snapshot or subvolume of dir\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -110,7 +111,7 @@ int main(int ac, char **av)
 	for (i =3D 1; i < ac; i++) {
 		if (strcmp(av[i], "-s") =3D=3D 0) {
 			if (i + 1 >=3D ac - 1) {
=2D				fprintf(stderr, "-s requires an arg");
+				fprintf(stderr, "-s requires two args\n");
 				print_usage();
 			}
 			fullpath =3D av[i + 1];
@@ -137,7 +138,7 @@ int main(int ac, char **av)
 			command =3D BTRFS_IOC_SNAP_CREATE;
 		} else if (strcmp(av[i], "-S") =3D=3D 0) {
 			if (i + 1 >=3D ac - 1) {
=2D				fprintf(stderr, "-S requires an arg");
+				fprintf(stderr, "-S requires two args\n");
 				print_usage();
 			}
 			name =3D av[i + 1];
@@ -160,8 +161,8 @@ int main(int ac, char **av)
 			}
 			command =3D BTRFS_IOC_DEFRAG;
 		} else if (strcmp(av[i], "-D") =3D=3D 0) {
=2D			if (i >=3D ac - 1) {
=2D				fprintf(stderr, "-D requires an arg\n");
+			if (i + 1 >=3D ac - 1) {
+				fprintf(stderr, "-D requires two args\n");
 				print_usage();
 			}
 			command =3D BTRFS_IOC_SNAP_DESTROY;
@@ -178,8 +179,8 @@ int main(int ac, char **av)
 			}
 			command =3D BTRFS_IOC_SCAN_DEV;
 		} else if (strcmp(av[i], "-r") =3D=3D 0) {
=2D			if (i >=3D ac - 1) {
=2D				fprintf(stderr, "-r requires an arg\n");
+			if (i+1 >=3D ac - 1) {
+				fprintf(stderr, "-r requires two args\n");
 				print_usage();
 			}
 			name =3D av[i + 1];
@@ -190,6 +191,10 @@ int main(int ac, char **av)
 			}
 			command =3D BTRFS_IOC_RESIZE;
 		} else if (strcmp(av[i], "-c") =3D=3D 0) {
+			if (i >=3D ac - 1) {
+				fprintf(stderr, "-c requires an arg\n");
+				print_usage();
+			}
 			command =3D BTRFS_IOC_SYNC;
 		}
 	}
=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart42024413.F97EOSMJeF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLI7kvvwTxYT3FBRIRAuGGAJ94KXpoSgorGGdrudGJopidkrzVPQCeLRRj
hG5HqIVoK+Cxjwq3LNtSEUE=
=qsEm
-----END PGP SIGNATURE-----

--nextPart42024413.F97EOSMJeF--
