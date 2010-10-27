From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [RFC PATCH] Deprecate btrfsctl, btrfs-show, btrfs-vol
Date: Wed, 27 Oct 2010 20:49:26 +0200
Message-ID: <201010272049.40904.kreijack@libero.it>
References: <22986774.2784821287748969875.JavaMail.defaultUser@defaultHost> <201010261932.15023.kreijack@libero.it> <20101026195357.GH13254@think>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1316851.Mdea0sT4DR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Chris Mason <chris.mason@oracle.com>,
	David Nicol <davidnicol@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101026195357.GH13254@think>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1316851.Mdea0sT4DR
Content-Type: Text/Plain;
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

What I am asking here is a comment about the WARNINGs and suggestions about=
=20
the policy to adopt in deprecating these programs.
My suggestions are:
=2D put a warning in the documentation and in the program (see below)
=2D "freeze" the programs avoiding to add new functionality to the=20
  "old utilities".=20
=2D after six month remove the old utilities programs from the btrfs-progs=
=20
  package

The aim is to support the old systems but discourage to use the old tools.

If btrfs would show regression respect the old tools, I am happy to know an=
d=20
I will work to solve the issues.

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
ree id] or the=20
directory


Below the patch, but it is possible to pull the changes from:

 	http://cassiopea.homelinux.net/git/btrfs-progs-unstable-all.git

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
 6 files changed, 26 insertions(+)


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
index c2d4488..558b484 100644
=2D-- a/man/btrfsctl.8.in
+++ b/man/btrfsctl.8.in
@@ -10,6 +10,9 @@ btrfsctl \- control a btrfs filesystem
 [ \fB \-A\fP\fI device\fP ]
 [ \fB \-a\fP ]
 [ \fB \-c\fP ]
+.SH NOTE
+.B btrfs-show
+is deprecated. Please consider to switch to the btrfs utility.
 .SH DESCRIPTION
 .B btrfsctl
 is used to control the filesystem and the files and directories stored. It=
 is the tool to=20
create a new snapshot for the filesystem.


On Tuesday, 26 October, 2010, Chris Mason wrote:
> On Tue, Oct 26, 2010 at 07:32:14PM +0200, Goffredo Baroncelli wrote:
> >=20
> > The package btrfs-tools needs a lot of care:
> > - the INSTALL file still reports that is not possible to remove a subvo=
lume
> > - a lot of program are not documented (what is the meaning of btrfs-zer=
o-log=20
> > ?)
> > - "btrfs dev scan" and "btrfs -a" try to read CDROM and Floppy looking =
for a=20
> > btrfs filesystem: only waste of time
> > - [...]
> >=20
> > I think that is better to improve the btrfs-progs and not to update btr=
fsctl.
>=20
> I'd agree, the btrfsctl command is more than a little awkward, and the
> btrfs command is pretty much better in every way.
>=20
> -chris
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1316851.Mdea0sT4DR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMyHQ3vwTxYT3FBRIRAuMSAJ0SG0Heic52hwCWNlVE2ZRD0a2RZQCfYIcm
TWKwYbMieGnHf6nDKz5O0h8=
=d0DH
-----END PGP SIGNATURE-----

--nextPart1316851.Mdea0sT4DR--
