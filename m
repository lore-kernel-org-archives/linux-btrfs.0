From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 1/5][REPOST][BTRFS-PROGS] Update/clean up btrfs help and man page V2
Date: Sun, 5 Dec 2010 18:47:45 +0100
Message-ID: <201012051847.45520.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1465095.aAIM7pfx1D";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: =?iso-8859-1?q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>,
	Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1465095.aAIM7pfx1D
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

enclose you can find a patch which improves the help of the btrfs commands,
 updates the INSTALL file  and  the btrfs (command) man page.

Regarding the help of the btrfs command:
=2D moved the "subvolume set-default" command in the "subvolume" commands g=
roup
=2D removed a wrong new line
=2D small tweak on the basis of Andreas suggestion

Regarding the btrfs command man page:
=2D renaming the command "device balance" in "filesystem balance" (thanks t=
o=20
Andreas Phillipp to highlight that)
=2D adding the entry "subvolume find-new"
=2D document the switches of the command "filesystem defrag"
=2D document the <devid> facility of the command "filesystem resize"
=2D small tweak on the basis of Andreas suggestion

Regarding the INSTALL file, which was very old, I removed the reference of =
the=20
old btrfsctl utility and changed the examples using the btrfs command.
I removed the old (and now wrong) statement about the inability to delete a=
=20
subvolume/snapshot

Chris, you can pull the patch from the branch "help_cleanup" of the followi=
ng=20
repository.=20

http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

(or you can browse the changes at
http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git/?p=3Dbtrfs-
progs-unstable-all.git;a=3Dsummary)

The patch is very simple: only updates the man page, the INSTALL file and
 moves/updates some lines in the help of btrfs command. Comments are welcom=
e.

Regards
G.Baroncelli

 INSTALL        |   29 ++++++++++++++++++++---------
 btrfs.c        |   24 ++++++++++++------------
 man/btrfs.8.in |   45 +++++++++++++++++++++++++--------------------
 3 files changed, 57 insertions(+), 41 deletions(-)


diff --git a/INSTALL b/INSTALL
index 16b45a5..3840148 100644
=2D-- a/INSTALL
+++ b/INSTALL
@@ -22,23 +22,32 @@ in the e2fsprogs sources, and is usually available as=20
libuuid or
 e2fsprogs-devel from various distros.
=20
 Building the utilities is just make ; make install.  The programs go
=2Dinto /usr/local/bin.  The commands available are:
+into /usr/local/bin.  The mains commands available are:
=20
 mkfs.btrfs: create a filesystem
=20
=2Dbtrfsctl: control program to create snapshots and subvolumes:
=2D
+btrfs: control program to create snapshots and subvolumes:
+	# mount a btrfs filesystem
 	mount /dev/sda2 /mnt
=2D	btrfsctl -s new_subvol_name /mnt
=2D	btrfsctl -s snapshot_of_default /mnt/default
=2D	btrfsctl -s snapshot_of_new_subvol /mnt/new_subvol_name
=2D	btrfsctl -s snapshot_of_a_snapshot /mnt/snapshot_of_new_subvol
+
+	# create a subvolume
+	btrfs subvolume create /mnt/new_subvol_name
+
+	# snapshot of a subvolume
+	btrfs subvolume snapshot /mnt/default /mnt/snapshot_of_default=20
+	btrfs subvolume snapshot /mnt/snapshot_of_default \
+		/mnt/snapshot_of_a_snapshot
+
+	# list of the subvolumes
 	ls /mnt
 	default snapshot_of_a_snapshot snapshot_of_new_subvol
 	new_subvol_name snapshot_of_default
=20
=2D	Snapshots and subvolumes cannot be deleted right now, but you can
=2D	rm -rf all the files and directories inside them.
+	# removal of a subvolume or a snapshot
+	btrfs subvolume delete /mn/snapshot_of_a_snapshot
+
+	# look a the btrfs man page for further information
+	man btrfs
=20
 btrfsck: do a limited check of the FS extent trees.</li>
=20
@@ -46,3 +55,5 @@ debug-tree: print all of the FS metadata in text form. =20
Example:
=20
 	debug-tree /dev/sda2 >& big_output_file
=20
+
+
diff --git a/btrfs.c b/btrfs.c
index 46314cf..8b3716a 100644
=2D-- a/btrfs.c
+++ b/btrfs.c
@@ -61,6 +61,11 @@ static struct Command commands[] =3D {
 	{ do_subvol_list, 1, "subvolume list", "<path>\n"
 		"List the snapshot/subvolume of a filesystem."
 	},
+	{ do_set_default_subvol, 2,
+	  "subvolume set-default", "<id> <path>\n"
+		"Set the subvolume of the filesystem <path> which will be=20
mounted\n"
+		"as default."
+	},
 	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
 		"List the recently modified files in a filesystem."
 	},
@@ -68,11 +73,6 @@ static struct Command commands[] =3D {
 	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size]=20
<file>|<dir> [<file>|<dir>...]\n"
 		"Defragment a file or a directory."
 	},
=2D	{ do_set_default_subvol, 2,
=2D	  "subvolume set-default", "<id> <path>\n"
=2D		"Set the subvolume of the filesystem <path> which will be=20
mounted\n"
=2D		"as default."
=2D	},
 	{ do_fssync, 1,
 	  "filesystem sync", "<path>\n"
 		"Force a sync on the filesystem <path>."
@@ -83,29 +83,29 @@ static struct Command commands[] =3D {
 		"will occupe all available space on the device."
 	},
 	{ do_show_filesystem, 999,
=2D	  "filesystem show", "[<uuid>|<label>]\n"
=2D		"Show the info of a btrfs filesystem. If no <uuid> or=20
<label>\n"
+	  "filesystem show", "[<device>|<uuid>|<label>]\n"
+		"Show the info of a btrfs filesystem. If no argument\n"
 		"is passed, info of all the btrfs filesystem are shown."
 	},
 	{ do_df_filesystem, 1,
 	  "filesystem df", "<path>\n"
=2D		"Show space usage information for a mount point\n."
+		"Show space usage information for a mount point."
 	},
 	{ do_balance, 1,
 	  "filesystem balance", "<path>\n"
 		"Balance the chunks across the device."
 	},
=2D	{ do_scan,
=2D	  999, "device scan", "[<device> [<device>..]\n"
+	{ do_scan, 999,=20
+	  "device scan", "[<device>...]\n"
 		"Scan all device for or the passed device for a btrfs\n"
 		"filesystem."
 	},
 	{ do_add_volume, -2,
=2D	  "device add", "<dev> [<dev>..] <path>\n"
+	  "device add", "<device> [<device>...] <path>\n"
 		"Add a device to a filesystem."
 	},
 	{ do_remove_volume, -2,
=2D	  "device delete", "<dev> [<dev>..] <path>\n"
+	  "device delete", "<device> [<device>...] <path>\n"
 		"Remove a device from a filesystem."
 	},
 	/* coming soon
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..5ec1a8d 100644
=2D-- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,21 +15,23 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
=2D\fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\=
fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\=
fP
 .PP
=2D\fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
=2D.PP
=2D\fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
+\fBbtrfs\fP \fBdevice scan\fP\fI [<device>...]\fP
 .PP
=2D\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
+\fBbtrfs\fP \fBdevice show\fP\fI [<device>|<uuid>|<label>]\fP
 .PP
=2D\fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
+\fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
=2D\fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
+\fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP]
=20
 .PP
 \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
@@ -47,17 +49,16 @@ For example: it is possible to run
 instead of
 .I btrfs subvolume snapshot.
 But
=2D.I btrfs dev s
+.I btrfs file s
 is not allowed, because
=2D.I dev s
+.I file s
 may be interpreted both as
=2D.I device show
+.I filesystem show
 and as
=2D.I device scan.
+.I filesystem sync.
 In this case
 .I btrfs
=2Dreturns an error.
=2D
+returnsfilesystem sync
 If a command is terminated by
 .I --help
 , the relevant help is showed. If the passed command matches more commands,
@@ -102,11 +103,15 @@ Set the subvolume of the filesystem \fI<path>\fR whic=
h=20
is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
=20
+\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
+List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
+.TP
+
 \fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fR
 Defragment files and/or directories.
 .TP
=20
=2D\fBdevice scan\fR \fI[<device> [<device>..]]\fR
+\fBdevice scan\fR \fI[<device>...]\fR
 Scan devices for a btrfs filesystem. If no devices are passed, \fBbtrfs\fR=
=20
scans
 all the block devices.
 .TP
@@ -138,21 +143,21 @@ can expand the partition before enlarging the filesys=
tem=20
and shrink the
 partition after reducing the size of the filesystem.
 .TP
=20
=2D\fBfilesystem show\fR [<uuid>|<label>]\fR
=2DShow the btrfs filesystem with some additional info. If no UUID or label=
 is
=2Dpassed, \fBbtrfs\fR show info of all the btrfs filesystem.
+\fBfilesystem show\fR [<device>|<uuid>|<label>]\fR
+Show the btrfs filesystem with some additional info. If no argument is
+passed, \fBbtrfs\fR shows info of all the btrfs filesystems.
 .TP
=20
=2D\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
=20
=2D\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice add\fR\fI <device> [<device>...] <path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
=20
=2D\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice delete\fR\fI <device> [<device>...] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .PP
=20



=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1465095.aAIM7pfx1D
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBM+9BBvwTxYT3FBRIRAlEcAJ90huPqWryDbcO1cVIFtOC85Irf1ACfdCSa
ozqO2wNTa9FfeUrzlYPKlrU=
=Cd17
-----END PGP SIGNATURE-----

--nextPart1465095.aAIM7pfx1D--
