From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH][btrfs progs] Update/clean up btrfs help and man page
Date: Mon, 13 Sep 2010 21:23:54 +0200
Message-ID: <201009132124.09118.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2255650.EI7EpL15f5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2255650.EI7EpL15f5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

enclose you can find a patch which improve the help of the btrfs commands a=
nd=20
its man page.
Regarding the help of the btrfs command:
=2D moved the "subvolume set-default" command in the "subvolume" commands g=
roup
=2D removed a wrong new line

Regarding the btrfs command man page:
=2D renaming the command "device balance" in "filesystem balance" (thanks t=
o=20
Andrea Phillipp to highlight that)
=2D adding the entry "subvolume find-new"

Chris, you can pull the patch from the branch "help_cleanup" of the followi=
ng=20
repository.=20

http://cassiopea.homelinux.net/git/btrfs-progs-unstable-all.git

The patch is very simple: only update the man page and move some lines in t=
he=20
help of btrfs command. Comments are welcome.

Regards
G.Baroncelli


diff --git a/btrfs.c b/btrfs.c
index ab5e57f..1816597 100644
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
@@ -89,7 +89,7 @@ static struct Command commands[] =3D {
 	},
 	{ do_df_filesystem, 1,
 	  "filesystem df", "<path>\n"
=2D		"Show space usage information for a mount point\n."
+		"Show space usage information for a mount point."
 	},
 	{ do_balance, 1,
 	  "filesystem balance", "<path>\n"
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..249426c 100644
=2D-- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,6 +15,10 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+.PP
 \fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
@@ -25,8 +29,6 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
=2D\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
=2D.PP
 \fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
@@ -102,6 +104,10 @@ Set the subvolume of the filesystem \fI<path>\fR which=
=20
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
@@ -143,7 +149,7 @@ Show the btrfs filesystem with some additional info. If=
=20
no UUID or label is
 passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP
=20
=2D\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP




=2D-=20
gpg key@ keyserver.linux.it:Goffredo Baroncelli (ghigo) <kreijackATinwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart2255650.EI7EpL15f5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMjnpKvwTxYT3FBRIRAhmxAJ9cnvHQ35Ll+Qckvk1SZMDVDFe05wCfePOJ
gn269403VL0HSKekOQ0I+SA=
=2y+1
-----END PGP SIGNATURE-----

--nextPart2255650.EI7EpL15f5--
