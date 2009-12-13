From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH] Improve the btrfsctl help
Date: Sun, 13 Dec 2009 19:50:03 +0100
Message-ID: <200912131950.09622.kreijack@libero.it>
References: <200912121639.41192.kreijack@libero.it> <9bd6b5360912130005m2bf7993ar7df5244945504534@mail.gmail.com> <200912131239.06192.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2278625.UAgWotkoax";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912131239.06192.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2278625.UAgWotkoax
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi all,

another update:
=2D improved the help=20
=2D better check of the number of the parameter
=2D added useful info about the '-r' command
=2D update the man page also

comments are welcome.

BR
Goffredo


=2D-
diff --git a/btrfsctl.c b/btrfsctl.c
index 66c4e89..dd0de48 100644
=2D-- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -45,17 +45,21 @@ static inline int ioctl(int fd, int define, void *arg) =
{ return 0; }
=20
 static void print_usage(void)
 {
=2D	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
=2D	printf("                [-r size] [-A device] [-a] [-c] [-D dir .]\n");
=2D	printf("\t-d filename: defragments one file\n");
=2D	printf("\t-d directory: defragments the entire Btree\n");
=2D	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
=2D	printf("\t-S subvol_name dir: creates a new subvolume\n");
=2D	printf("\t-r [+-]size[gkm]: resize the FS by size amount\n");
=2D	printf("\t-A device: scans the device file for a Btrfs filesystem\n");
=2D	printf("\t-a: scans all devices for Btrfs filesystems\n");
=2D	printf("\t-c: forces a single FS sync\n");
=2D	printf("\t-D: delete snapshot\n");
+	printf("usage: btrfsctl [-d file|directory] [-s snap_name subvol]\n");
+	printf("                [-S vol_name directory] [-a] [-r size tree]\n");
+	printf("                [-A device] [-c tree] [-D name directory]\n");
+	printf("\t-d filename: defragments one file.\n");
+	printf("\t-d directory: defragments the entire Btree.\n");
+	printf("\t-s snap_name subvol: creates a new snapshot of subvol.\n");
+	printf("\t-S subvol_name directory: creates a new subvolume in directory.=
\n");
+	printf("\t-a: scans all devices for Btrfs filesystems.\n");
+	printf("\t-r [revid:][+-]size[kmg] tree\n");
+	printf("\t               resize the FS by size amount (pass 'max'\n");
+	printf("\t               to resize up to device size).'revid' is\n");
+	printf("\t               the device-id to resize: default is 1.\n");
+	printf("\t-A device: scans the device file for a Btrfs filesystem.\n");
+	printf("\t-c tree: forces a single FS sync.\n");
+	printf("\t-D name directory: delete a snapshot or subvolume in directory.=
\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -110,7 +114,7 @@ int main(int ac, char **av)
 	for (i =3D 1; i < ac; i++) {
 		if (strcmp(av[i], "-s") =3D=3D 0) {
 			if (i + 1 >=3D ac - 1) {
=2D				fprintf(stderr, "-s requires an arg");
+				fprintf(stderr, "-s requires two args\n");
 				print_usage();
 			}
 			fullpath =3D av[i + 1];
@@ -137,14 +141,14 @@ int main(int ac, char **av)
 			command =3D BTRFS_IOC_SNAP_CREATE;
 		} else if (strcmp(av[i], "-S") =3D=3D 0) {
 			if (i + 1 >=3D ac - 1) {
=2D				fprintf(stderr, "-S requires an arg");
+				fprintf(stderr, "-S requires two args\n");
 				print_usage();
 			}
 			name =3D av[i + 1];
 			len =3D strlen(name);
 			if (len =3D=3D 0 || len >=3D BTRFS_VOL_NAME_MAX) {
 				fprintf(stderr,
=2D				     "snapshot name zero length or too long\n");
+				     "volume name zero length or too long\n");
 				exit(1);
 			}
 			if (strchr(name, '/')) {
@@ -160,15 +164,16 @@ int main(int ac, char **av)
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
 			name =3D av[i + 1];
 			len =3D strlen(name);
 			if (len =3D=3D 0 || len >=3D BTRFS_VOL_NAME_MAX) {
=2D				fprintf(stderr, "-D size too long\n");
+				fprintf(stderr,
+				      "volume name zero length or too long\n");
 				exit(1);
 			}
 		} else if (strcmp(av[i], "-A") =3D=3D 0) {
@@ -178,18 +183,23 @@ int main(int ac, char **av)
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
 			len =3D strlen(name);
 			if (len =3D=3D 0 || len >=3D BTRFS_VOL_NAME_MAX) {
=2D				fprintf(stderr, "-r size too long\n");
+				fprintf(stderr,
+				     "-r argument zero length or too long\n");
 				exit(1);
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
diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
index c2d4488..b645429 100644
=2D-- a/man/btrfsctl.8.in
+++ b/man/btrfsctl.8.in
@@ -4,12 +4,13 @@ btrfsctl \- control a btrfs filesystem
 .SH SYNOPSIS
 .B btrfsctl
 [ \fB\-d\fP\fI file|directory \fP ]
=2D[ \fB\-s\fP\fI snapshot-name directory\fP ]
+[ \fB\-s\fP\fI snapshot-name subvolume\fP ]
 [ \fB \-S\fP\fI subvolume-name directory\fP ]
=2D[ \fB \-r\fP\fI [+-]size\fP ]
+[ \fB \-r\fP\fI [devid:][+-]size[kmg]\fP tree]
 [ \fB \-A\fP\fI device\fP ]
 [ \fB \-a\fP ]
=2D[ \fB \-c\fP ]
+[ \fB \-c\fP tree]
+[ \fB \-D\fP\fI subvolume-name directory\fP ]
 .SH DESCRIPTION
 .B btrfsctl
 is used to control the filesystem and the files and directories stored. It=
 is the tool to=20
create a new snapshot for the filesystem.
@@ -18,14 +19,21 @@ is used to control the filesystem and the files and dir=
ectories stored.=20
It is th
 \fB\-d\fR \fIfile|directory\fR
 Defragment a file or a directory. If the argument is a directory, the enti=
re b-tree under=20
the directory is defragged.
 .TP
=2D\fB\-s\fR \fIsnapshot-name directory\fR
=2DCreates a new \fIsnapshot\fP of the \fIdirectory\fP specified.
+\fB\-s\fR \fIsnapshot-name subvolume\fR
+Creates a new \fIsnapshot\fP of the \fIsubvolume\fP specified. In the
+\fIsnapshot-name\fP may be specify the path where the snapshot will be pla=
ced.
+\fIsubvolume\fP may be specified with any file or directory of the subvolu=
me.
 .TP
 \fB\-S\fR \fIsubvolume-name directory\fR
=2DCreates a new subvolume.
+Creates a new \fIsubvolume\fP in the \fIdirectory\fP specified.
 .TP
=2D\fB\-r\fR \fI[+|-]size\fR
=2DResizes the filesystem with the \fIsize\fP specified. If the value is pr=
eceded with a=20
signed symbol, the filesystem is resized with respect to the current filesy=
stem size.=20
\fIsize\fP can be suffixed by k,m or g to represent kilobytes, megabytes, o=
r gigabytes=20
respectively.
+\fB\-r\fR \fI[devid:][+|-]size[kmg] tree\fR
+Resizes the filesystem with the \fIsize\fP specified. If the value is prec=
eded
+with a signed symbol, the filesystem is resized with respect to the current
+filesystem size. \fIsize\fP can be suffixed by k,m or g to represent kilob=
ytes,
+megabytes, or gigabytes respectively. For a multi-device filesystem the
+\fIdevid\fP parameter specify which device has to be resize (default 1).
+\fItree\fP may be any element of the filesystem involved.
 .TP
 \fB\-A\fR \fIdevice\fR
 Scans the \fIdevice\fR for btrfs filesystem.
@@ -33,8 +41,12 @@ Scans the \fIdevice\fR for btrfs filesystem.
 \fB\-a\fR
 Scans all devices present in the system for btrfs filesystem.
 .TP
=2D\fB\-c\fR
=2DForces a filesystem sync.
+\fB\-c\fR \fItree\fR
+Forces a filesystem sync. \fItree\fP may be any element of the filesystem
+involved.
+.TP
+\fB\-D\fR \fIsubvolume-name directory\fR
+Delete a subvolume in the directory specified.
 .SH AVAILABILITY
 .B btrfsctl
 is part of btrfs-progs. Btrfs is currently under heavy development,

=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart2278625.UAgWotkoax
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLJTdbvwTxYT3FBRIRAl6MAJ9WdxKGG2YPvOS1wbchgGCB27YfpQCfZNl0
oDFHbMnpX755JIZRbs9jgv4=
=N9lh
-----END PGP SIGNATURE-----

--nextPart2278625.UAgWotkoax--
