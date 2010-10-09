From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH][btrfs progs] Update/clean up btrfs help and man page
Date: Sat, 9 Oct 2010 21:33:25 +0200
Message-ID: <201010092133.32474.kreijack@libero.it>
References: <201009132124.09118.kreijack@libero.it> <4CB07234.1080102@gmail.com> <AANLkTin_Onxqeu2cnj7zCk879hEBTxAe-4eh-i1DvsB9@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1784429.iBMi9edJ2Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: =?iso-8859-1?q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>,
	Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin_Onxqeu2cnj7zCk879hEBTxAe-4eh-i1DvsB9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1784429.iBMi9edJ2Y
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

enclose you can find a patch which improves the help of the btrfs commands,
 updates the INSTALL file  and  the btrfs (command) man page.

Regarding the help of the btrfs command:
=2D moved the "subvolume set-default" command in the "subvolume" commands g=
roup
=2D removed a wrong new line

Regarding the btrfs command man page:
=2D renaming the command "device balance" in "filesystem balance" (thanks t=
o=20
Andrea Phillipp to highlight that)
=2D adding the entry "subvolume find-new"
=2D document the switches of the command "filesystem defrag"
=2D document the <devid> facility of the command "filesystem resize"

Regarding the INSTALL file, which was very old, I removed the reference of =
the=20
old btrfsctl utility and changed the examples using the btrfs command.
I removed the old (and now wrong) statement about the inability to delete a=
=20
subvolume/snapshot

Chris, you can pull the patch from the branch "help_cleanup" of the followi=
ng=20
repository.=20

http://cassiopea.homelinux.net/git/btrfs-progs-unstable-all.git

The patch is very simple: only updates the man page, the INSTALL file and
 moves some lines in the qhelp of btrfs command. Comments are welcome.

Regards
G.Baroncelli

 INSTALL        |   31 ++++++++++++++++++++++---------
 btrfs.c        |   17 +++++++++--------
 man/btrfs.8.in |   36 +++++++++++++++++++++++++++++-------
 3 files changed, 60 insertions(+), 24 deletions(-)



diff --git a/INSTALL b/INSTALL
index 16b45a5..2c9cf1c 100644
=2D-- a/INSTALL
+++ b/INSTALL
@@ -22,23 +22,34 @@ in the e2fsprogs sources, and is usually available as l=
ibuuid or
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
+	btrfs subvolume snapshot /mnt/new_subvol_name \
+		/mnt/snapshot_of_new_subvol
+	btrfs subvolume snapshot /mnt/snapshot_of_new_subvol \
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
@@ -46,3 +57,5 @@ debug-tree: print all of the FS metadata in text form.  E=
xample:
=20
 	debug-tree /dev/sda2 >& big_output_file
=20
+
+
diff --git a/btrfs.c b/btrfs.c
index 46314cf..a607786 100644
=2D-- a/btrfs.c
+++ b/btrfs.c
@@ -61,6 +61,11 @@ static struct Command commands[] =3D {
 	{ do_subvol_list, 1, "subvolume list", "<path>\n"
 		"List the snapshot/subvolume of a filesystem."
 	},
+	{ do_set_default_subvol, 2,
+	  "subvolume set-default", "<id> <path>\n"
+		"Set the subvolume of the filesystem <path> which will be mounted\n"
+		"as default."
+	},
 	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
 		"List the recently modified files in a filesystem."
 	},
@@ -68,19 +73,15 @@ static struct Command commands[] =3D {
 	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size] <file>|<=
dir> [<file>|<dir>...]\n"
 		"Defragment a file or a directory."
 	},
=2D	{ do_set_default_subvol, 2,
=2D	  "subvolume set-default", "<id> <path>\n"
=2D		"Set the subvolume of the filesystem <path> which will be mounted\n"
=2D		"as default."
=2D	},
 	{ do_fssync, 1,
 	  "filesystem sync", "<path>\n"
 		"Force a sync on the filesystem <path>."
 	},
 	{ do_resize, 2,
=2D	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
+	  "filesystem resize", "[<devid>:][+/-]<newsize>[gkm]|max <filesystem>\n"
 		"Resize the file system. If 'max' is passed, the filesystem\n"
=2D		"will occupe all available space on the device."
+		"will occupe all available space on the device. <devid> is\n"
+		"the id of the device which grown or will shrink."
 	},
 	{ do_show_filesystem, 999,
 	  "filesystem show", "[<uuid>|<label>]\n"
@@ -89,7 +90,7 @@ static struct Command commands[] =3D {
 	},
 	{ do_df_filesystem, 1,
 	  "filesystem df", "<path>\n"
=2D		"Show space usage information for a mount point\n."
+		"Show space usage information for a mount point."
 	},
 	{ do_balance, 1,
 	  "filesystem balance", "<path>\n"
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..1997aa8 100644
=2D-- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,18 +15,20 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
=2D\fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fBfilesystem defrag\fP\fI [-vcf] [-s start] [-l len] [-t size=
] <file>|<dir> [<file>|<dir>...]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
=2D\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem=
>\fP
+\fBbtrfs\fP \fBfilesystem resize\fP\fI [<devid>:][+/\-]<size>[gkm]|max <fi=
lesystem>\fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
=2D\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
=2D.PP
 \fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
@@ -102,8 +104,19 @@ Set the subvolume of the filesystem \fI<path>\fR which=
 is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
=20
=2D\fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fR
+\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
+List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
+.TP
+
+\fBfilesystem defragment\fP\fI [-vcf] [-s <start>] [-l <lenght>] [-t <size=
>] <file>|<dir> [<file>|<dir>...]\fR
 Defragment files and/or directories.
+The switch \fB-v\fR turns on the verbose mode.
+The switch \fB-c\fR sets the flag compress on.
+The switch \fB-f\fR turns on the flushing of the data.
+The switch \fB-s\fR sets the beginning of the range to defrag.
+The switch \fB-l\fR sets the length of the range to defrag.
+If the switch \fB-t\fR is passed, any extent bigger than \fB<size>\fR is
+considered already defragged.
 .TP
=20
 \fBdevice scan\fR \fI[<device> [<device>..]]\fR
@@ -119,7 +132,7 @@ Force a sync for the filesystem identified by \fI<path>=
\fR.
 .\" Some wording are extracted by the resize2fs man page
 .\"
=20
=2D\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
+\fBfilesystem resize\fR\fI [<devid>:][+/\-]<size>[gkm]|max <path>\fR
 Resize a filesystem identified by \fI<path>\fR.
 The \fI<size>\fR parameter specifies the new size of the filesystem.
 If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decr=
eased
@@ -136,6 +149,9 @@ The \fBresize\fR command \fBdoes not\fR manipulate the =
size of underlying
 partition.  If you wish to enlarge/reduce a filesystem, you must make sure=
 you
 can expand the partition before enlarging the filesystem and shrink the
 partition after reducing the size of the filesystem.
+
+<devid> is the ID of the device which was enlarged or which will be reduce=
d.
+To know the ID of a device use the command \fBbtrfs filesystem show\fR.
 .TP
=20
 \fBfilesystem show\fR [<uuid>|<label>]\fR
@@ -143,7 +159,7 @@ Show the btrfs filesystem with some additional info. If=
 no UUID or label is
 passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP
=20
=2D\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
@@ -154,6 +170,12 @@ Add device(s) to the filesystem identified by \fI<path=
>\fR.
=20
 \fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
+
+If the devices are used in RAID mode, it is not possible to reduce the=20
+number of the device less than the minimun number (2 devices for RADI1,
+4 devices for RAID10 ...). In this case to replace a failed device, it=20
+is necessary first add a new one.
+=20
 .PP
=20
 .SH EXIT STATUS




On Saturday, 09 October, 2010, J=E9r=F4me Poulin wrote:
> On 13.09.2010 21:23, Goffredo Baroncelli wrote:
> > Hi all,
> >
> > enclose you can find a patch which improve the help of the btrfs
> > commands and its man page. Regarding the help of the btrfs
> > command: - moved the "subvolume set-default" command in the
> > "subvolume" commands group - removed a wrong new line
> >
> > Regarding the btrfs command man page: - renaming the command
> > "device balance" in "filesystem balance" (thanks to Andrea Phillipp
> > to highlight that) - adding the entry "subvolume find-new"
> >
>=20
> Could you also document the defragment switches? At the moment, they
> are only documented in the code, -c to compress, -f to force and -v
> for verbose (even if verbose does not add any output other than the
> version).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1784429.iBMi9edJ2Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMsMOFvwTxYT3FBRIRAnAkAJ4rf/dUShgNdTmDOWRGR/3KLpkkJwCfS1VS
r/YHqDNIHMaFNQl9GGpNlbo=
=FN0C
-----END PGP SIGNATURE-----

--nextPart1784429.iBMi9edJ2Y--
