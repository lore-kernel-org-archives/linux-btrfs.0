From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 3/5][REPOST][BTRFS-PROGS] Deprecate btrfsctl, btrfs-show, btrfs-vol
Date: Sun, 5 Dec 2010 18:47:36 +0100
Message-ID: <201012051847.36807.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3401258.i9il53RRkb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: linux-btrfs@vger.kernel.org, David Nicol <davidnicol@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3401258.i9il53RRkb
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

the patch below deprecates the following programs

* btrfsctl
* btrfs-vol
* btrfs-show

the reason is simple, these programs are superseded by the btrfs utility,
both in terms of documentation, usability and bug. The goal is to avoid=20
to duplicate codes and avoid update two programs.

The patch adds a warning in the man pages, in the INSTALL file and in the=20
programs.

$ ./btrfsctl=20
**
** WARNING: this program is considered deprecated
** Please consider to switch to the btrfs utility
**
no valid commands given
usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]
                [-r size] [-A device] [-a] [-c] [-D dir .]
        -d filename: defragments one file
        -d directory: defragments the entire Btree
        -s snap_name dir: creates a new snapshot of dir
        -S subvol_name dir: creates a new subvolume
        -r [+-]size[gkm]: resize the FS by size amount
        -A device: scans the device file for a Btrfs filesystem
        -a: scans all devices for Btrfs filesystems
        -c: forces a single FS sync
        -D: delete snapshot
        -m [tree id] directory: set the default mounted subvolume to the [t=
ree=20
id] or the=20
directory


Below the patch, but it is possible to pull the changes from:

 	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

branch

	btrfs-deprecated

Comments are welcome.

G.Baroncelli

 INSTALL             |    5 +++++
 btrfs-show.c        |    5 +++++
 btrfs-vol.c         |    5 +++++
 btrfsctl.c          |    5 +++++
 man/btrfs-show.8.in |    3 +++
 man/btrfsctl.8.in   |    3 +++
 6 files changed, 26 insertions(+), 0 deletions(-)



diff --git a/INSTALL b/INSTALL
index 16b45a5..cbde78f 100644
=2D-- a/INSTALL
+++ b/INSTALL
@@ -24,10 +24,15 @@ e2fsprogs-devel from various distros.
 Building the utilities is just make ; make install.  The programs go
 into /usr/local/bin.  The commands available are:
=20
+btrfs: control program to manage the filesystem.
+
 mkfs.btrfs: create a filesystem
=20
 btrfsctl: control program to create snapshots and subvolumes:
=20
+	NOTE: this utility is deprecated. Please consider to switch
+	to the btrfs utility (see above)
+
 	mount /dev/sda2 /mnt
 	btrfsctl -s new_subvol_name /mnt
 	btrfsctl -s snapshot_of_default /mnt/default
diff --git a/btrfs-show.c b/btrfs-show.c
index c49626c..8210fd2 100644
=2D-- a/btrfs-show.c
+++ b/btrfs-show.c
@@ -117,6 +117,11 @@ int main(int ac, char **av)
 	int ret;
 	int option_index =3D 0;
=20
+	printf( "**\n"
+		"** WARNING: this program is considered deprecated\n"
+		"** Please consider to switch to the btrfs utility\n"
+		"**\n");
+
 	while(1) {
 		int c;
 		c =3D getopt_long(ac, av, "", long_options,
diff --git a/btrfs-vol.c b/btrfs-vol.c
index 4ed799d..fe6f240 100644
=2D-- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -78,6 +78,11 @@ int main(int ac, char **av)
 	struct btrfs_ioctl_vol_args args;
 	u64 dev_block_count =3D 0;
=20
+	printf( "**\n"
+		"** WARNING: this program is considered deprecated\n"
+		"** Please consider to switch to the btrfs utility\n"
+		"**\n");
+
 	while(1) {
 		int c;
 		c =3D getopt_long(ac, av, "a:br:", long_options,
diff --git a/btrfsctl.c b/btrfsctl.c
index 92bdf39..d20c96a 100644
=2D-- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -107,6 +107,11 @@ int main(int ac, char **av)
 	char *fullpath;
 	u64 objectid =3D 0;
=20
+	printf( "**\n"
+		"** WARNING: this program is considered deprecated\n"
+		"** Please consider to switch to the btrfs utility\n"
+		"**\n");
+=09
 	if (ac =3D=3D 2 && strcmp(av[1], "-a") =3D=3D 0) {
 		fprintf(stderr, "Scanning for Btrfs filesystems\n");
 		btrfs_scan_one_dir("/dev", 1);
diff --git a/man/btrfs-show.8.in b/man/btrfs-show.8.in
index dd0b147..cb98b68 100644
=2D-- a/man/btrfs-show.8.in
+++ b/man/btrfs-show.8.in
@@ -3,6 +3,9 @@
 btrfs-show \- scan the /dev directory for btrfs partitions and print resul=
ts.
 .SH SYNOPSIS
 .B btrfs-show
+.SH NOTE
+.B btrfs-show
+is deprecated. Please consider to switch to the btrfs utility.=09
 .SH DESCRIPTION
 .B btrfs-show
 is used to scan the /dev directory for btrfs partitions and display brief
diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
index c2d4488..8705fa6 100644
=2D-- a/man/btrfsctl.8.in
+++ b/man/btrfsctl.8.in
@@ -10,6 +10,9 @@ btrfsctl \- control a btrfs filesystem
 [ \fB \-A\fP\fI device\fP ]
 [ \fB \-a\fP ]
 [ \fB \-c\fP ]
+.SH NOTE
+B btrfsctl
+is deprecated. Please consider to switch to the btrfs utility.
 .SH DESCRIPTION
 .B btrfsctl
 is used to control the filesystem and the files and directories stored. It=
 is=20
the tool to create a new snapshot for the filesystem.



=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart3401258.i9il53RRkb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBM+9A4vwTxYT3FBRIRAuNhAJ9d0Gn+9lCncIWCo0PM1X4MPYE5/ACggVyn
CIHabxrYyi8mhFyrwf5EFbc=
=Yrta
-----END PGP SIGNATURE-----

--nextPart3401258.i9il53RRkb--
