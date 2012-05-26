Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:56305 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab2EZUxg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 16:53:36 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q4QKrXAe020505
	for <linux-btrfs@vger.kernel.org>; Sat, 26 May 2012 23:53:33 +0300
Received: from smtp-2.hut.fi ([130.233.228.92])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 03486-1195 for <linux-btrfs@vger.kernel.org>;
 Sat, 26 May 2012 23:53:32 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q4QKrVxS020500
	for <linux-btrfs@vger.kernel.org>; Sat, 26 May 2012 23:53:31 +0300
Date: Sat, 26 May 2012 23:53:31 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Fix issues in 'btrfs help' output and manpage
Message-ID: <20120526205331.GB16059@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Fix typos and some grammar errors

* Fix some arguments like <id> -> <subvolid> so they are the same on
  the manpage and 'btrfs help' output

* Add missing commands to manpage

* Change manpage order to conform to 'btrfs help' output, which I
  find the more logical of the two

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 btrfs.c           |    2 +-
 cmds-balance.c    |    8 +--
 cmds-filesystem.c |    2 +-
 cmds-inspect.c    |    4 +-
 cmds-scrub.c      |    8 +--
 cmds-subvolume.c  |    4 +-
 man/btrfs.8.in    |  172 ++++++++++++++++++++++++++++++++-----------------=
----
 7 files changed, 117 insertions(+), 83 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 88238d6..cf16cb8 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -187,7 +187,7 @@ const struct cmd_group btrfs_cmd_group;
=20
 static const char * const cmd_help_usage[] =3D {
 	"btrfs help [--full]",
-	"Dislay help information",
+	"Display help information",
 	"",
 	"--full     display detailed help on every command",
 	NULL
diff --git a/cmds-balance.c b/cmds-balance.c
index 38a7426..7633eae 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -472,7 +472,7 @@ static int cmd_balance_start(int argc, char **argv)
=20
 static const char * const cmd_balance_pause_usage[] =3D {
 	"btrfs [filesystem] balance pause <path>",
-	"Pause running balance",
+	"Pause a running balance operation",
 	NULL
 };
=20
@@ -509,7 +509,7 @@ static int cmd_balance_pause(int argc, char **argv)
=20
 static const char * const cmd_balance_cancel_usage[] =3D {
 	"btrfs [filesystem] balance cancel <path>",
-	"Cancel running or paused balance",
+	"Cancel a running or paused balance operation",
 	NULL
 };
=20
@@ -546,7 +546,7 @@ static int cmd_balance_cancel(int argc, char **argv)
=20
 static const char * const cmd_balance_resume_usage[] =3D {
 	"btrfs [filesystem] balance resume <path>",
-	"Resume interrupted balance",
+	"Resume an interrupted balance operation",
 	NULL
 };
=20
@@ -605,7 +605,7 @@ static int cmd_balance_resume(int argc, char **argv)
=20
 static const char * const cmd_balance_status_usage[] =3D {
 	"btrfs [filesystem] balance status [-v] <path>",
-	"Show status of running or paused balance",
+	"Show status of a running or paused balance operation",
 	"",
 	"-v     be verbose",
 	NULL
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1f53d1c..0aaee54 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -212,7 +212,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_=
devices)
 }
=20
 static const char * const cmd_show_usage[] =3D {
-	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
+	"btrfs filesystem show [--all-devices|<uuid>|<label>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 2f0228f..d80bcf6 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -77,7 +77,7 @@ out:
=20
 static const char * const cmd_inode_resolve_usage[] =3D {
 	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
-	"Get file system paths for the given inode",
+	"Get filesystem paths for the given inode",
 	NULL
 };
=20
@@ -116,7 +116,7 @@ static int cmd_inode_resolve(int argc, char **argv)
=20
 static const char * const cmd_logical_resolve_usage[] =3D {
 	"btrfs inspect-internal logical-resolve [-Pv] <logical> <path>",
-	"Get file system paths for the given logical address",
+	"Get filesystem paths for the given logical address",
 	NULL
 };
=20
diff --git a/cmds-scrub.c b/cmds-scrub.c
index c4503f4..7e5d675 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1479,7 +1479,7 @@ out:
=20
 static const char * const cmd_scrub_start_usage[] =3D {
 	"btrfs scrub start [-Bdqr] <path>|<device>",
-	"Start a new scrub",
+	"Start a new scrub operation",
 	"",
 	"-B     do not background",
 	"-d     stats per device (-B only)",
@@ -1495,7 +1495,7 @@ static int cmd_scrub_start(int argc, char **argv)
=20
 static const char * const cmd_scrub_cancel_usage[] =3D {
 	"btrfs scrub cancel <path>|<device>",
-	"Cancel a running scrub",
+	"Cancel a running scrub operation",
 	NULL
 };
=20
@@ -1551,7 +1551,7 @@ again:
=20
 static const char * const cmd_scrub_resume_usage[] =3D {
 	"btrfs scrub resume [-Bdqr] <path>|<device>",
-	"Resume previously canceled or interrupted scrub",
+	"Resume a previously canceled or interrupted scrub operation",
 	"",
 	"-B     do not background",
 	"-d     stats per device (-B only)",
@@ -1567,7 +1567,7 @@ static int cmd_scrub_resume(int argc, char **argv)
=20
 static const char * const cmd_scrub_status_usage[] =3D {
 	"btrfs scrub status [-dR] <path>|<device>",
-	"Show status of running or finished scrub",
+	"Show status of a running or finished scrub operation",
 	"",
 	"-d     stats per device",
 	"-R     print raw stats",
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 950fa8f..23c72b4 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -394,7 +394,7 @@ static int cmd_snapshot(int argc, char **argv)
 }
=20
 static const char * const cmd_subvol_get_default_usage[] =3D {
-	"btrfs subvolume get-dafault <path>",
+	"btrfs subvolume get-default <path>",
 	"Get the default subvolume of a filesystem",
 	NULL
 };
@@ -432,7 +432,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 }
=20
 static const char * const cmd_subvol_set_default_usage[] =3D {
-	"btrfs subvolume set-dafault <subvolid> <path>",
+	"btrfs subvolume set-default <subvolid> <path>",
 	"Set the default subvolume of a filesystem",
 	NULL
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..83c6208 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -5,40 +5,48 @@
 .SH NAME
 btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
-\fBbtrfs\fP \fBsubvolume snapshot\fP\fI [-r] <source> [<dest>/]<name>\fP
-.PP
-\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume>\fP
-.PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume delete\fP\fI <name>\fP
+.PP
 \fBbtrfs\fP \fBsubvolume list\fP\fI [-p] <path>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
+\fBbtrfs\fP \fBsubvolume snapshot\fP\fI [-r] <source> [<dest>/]<name>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume set-default\fP\fI <subvolid> <path>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <path> <lastgen>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem df\fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>|<label>]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\=
fP
+\fBbtrfs\fP \fBfilesystem defragment\fP\fI [options] <file>|<dir> [<file>|=
<dir>...]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<newsize>[gkm]|max <path>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir=
>...]\fP
+\fBbtrfs\fP \fBfilesystem label\fP\fI <device> [<newlabel>]\fP
 .PP
-\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+\fBbtrfs\fP \fB[filesystem] balance start\fP\fI [options] <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+\fBbtrfs\fP \fB[filesystem] balance pause\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\=
fP
+\fBbtrfs\fP \fB[filesystem] balance cancel\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
+\fBbtrfs\fP \fB[filesystem] balance resume\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
+\fBbtrfs\fP \fB[filesystem] balance status\fP\fI [-v] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
 .PP
+\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device>...]\fP
+.PP
 \fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
@@ -49,19 +57,20 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<pa=
th>\fP
 .PP
-\fBbtrfs\fP \fBinspect-internal logical-resolve\fP
-[-Pv] \fI<logical>\fP \fI<path>\fP
+\fBbtrfs\fP \fBinspect-internal logical-resolve\fP [-Pv] \fI<logical>\fP \=
fI<path>\fP
 .PP
 \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
 .PP
+\fBbtrfs\fP \fBversion\fP\fI\fP
+.PP
 \fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
 .PP
 .SH DESCRIPTION
 .B btrfs
 is used to control the filesystem and the files and directories stored. It=
 is
 the tool to create or destroy a snapshot or a subvolume for the
-filesystem, to defrag a file or a directory, flush the data to the disk,
-to resize the filesystem, to scan the device.
+filesystem, to defragment a file or a directory, flush the data to the dis=
k,
+to resize the filesystem, or to scan devices.
=20
 It is possible to abbreviate the commands unless the commands  are ambiguo=
us.
 For example: it is possible to run
@@ -76,13 +85,10 @@ may be interpreted both as
 .I filesystem show
 and as
 .I filesystem sync.
-In this case
-.I btrfs
-returnsfilesystem sync
 If a command is terminated by
-.I --help
-, the detailed help is showed. If the passed command matches more commands,
-detailed help of all the matched commands is showed. For example
+\fI--help\fP,
+the detailed help is shown. If the passed command matches more commands,
+detailed help of all the matched commands is shown. For example,
 .I btrfs dev --help
 shows the help of all
 .I device*
@@ -91,23 +97,16 @@ commands.
 .SH COMMANDS
 .TP
=20
-\fBsubvolume snapshot\fR\fI [-r] <source> [<dest>/]<name>\fR
-Create a writable/readonly snapshot of the subvolume \fI<source>\fR with t=
he
-name \fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
-subvolume, \fBbtrfs\fR returns an error. If \fI-r\fR is given, the snapshot
-will be readonly.
-.TP
-
-\fBsubvolume delete\fR\fI <subvolume>\fR
-Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
-subvolume, \fBbtrfs\fR returns an error.
-.TP
-
 \fBsubvolume create\fR\fI [<dest>/]<name>\fR
 Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
=20
+\fBsubvolume delete\fR\fI <name>\fR
+Delete the subvolume \fI<name>\fR. If \fI<name>\fR is not a subvolume,
+\fBbtrfs\fR returns an error.
+.TP
+
 \fBsubvolume list\fR\fI [-p] <path>\fR
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
@@ -121,10 +120,11 @@ and top level. The parent's ID may be used at mount t=
ime via the
 \fIsubvolrootid=3D\fR option.
 .TP
=20
-\fBsubvolume set-default\fR\fI <id> <path>\fR
-Set the subvolume of the filesystem \fI<path>\fR which is mounted as=20
-\fIdefault\fR. The subvolume is identified by \fI<id>\fR, which=20
-is returned by the \fBsubvolume list\fR command.
+\fBsubvolume snapshot\fR\fI [-r] <source> [<dest>/]<name>\fR
+Create a writable/read-only snapshot of the subvolume \fI<source>\fR with =
the
+name \fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
+subvolume, \fBbtrfs\fR returns an error. If \fI-r\fR is given, the snapshot
+will be read-only.
 .TP
=20
 \fBsubvolume get-default\fR\fI <path>\fR
@@ -132,12 +132,41 @@ Get the default subvolume of the filesystem \fI<path>=
\fR. The output format
 is similar to \fBsubvolume list\fR command.
 .TP
=20
+\fBsubvolume set-default\fR\fI <subvolid> <path>\fR
+Set the subvolume of the filesystem \fI<path>\fR which is mounted as=20
+\fIdefault\fR. The subvolume is identified by \fI<subvolid>\fR, which=20
+is returned by the \fBsubvolume list\fR command.
+.TP
+
+\fBsubvolume find-new\fR\fI <path> <lastgen>\fR
+List the recently modified files in a filesystem.
+.TP
+
+\fBfilesystem df\fR\fI <path>\fR
+Show space usage information for a mount point.
+.TP
+
+\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
+Show the btrfs filesystem with some additional info. If no \fIUUID\fP or=
=20
+\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
+otherwise the devices list is extracted from the /proc/partitions file.
+.TP
+
+\fBfilesystem sync\fR\fI <path> \fR
+Force a sync for the filesystem identified by \fI<path>\fR.
+.TP
+
 \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] [=
-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
=20
 Defragment file data and/or directory metadata. To defragment all files in=
 a
 directory you have to specify each one on its own or use your shell wildca=
rds.
=20
-The start position and the number of bytes to deframention can be specifie=
d by \fIstart\fR and \fIlen\fR. Any extent bigger than \fIthresh\fR will be=
 considered already defragged. Use 0 to take the kernel default, and use 1 =
to say eveery single extent must be rewritten. You can also turn on compres=
sion in defragment operations.
+The start position and the number of bytes to defragment can be
+specified by \fIstart\fR and \fIlen\fR. Any extent bigger than
+\fIthresh\fR will be considered not fragmented. Use 0 to take the
+kernel default, and use 1 to say every single extent must be
+rewritten. You can also turn on compression in defragment operations.
=20
 \fB-v\fP be verbose
=20
@@ -158,20 +187,16 @@ use it if you use snapshots, have de-duplicated your =
data or made copies with
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
=20
-\fBfilesystem sync\fR\fI <path> \fR
-Force a sync for the filesystem identified by \fI<path>\fR.
-.TP
-
 .\"
 .\" Some wording are extracted by the resize2fs man page
 .\"
=20
-\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
+\fBfilesystem resize\fR\fI [+/\-]<newsize>[gkm]|max <path>\fR
 Resize a filesystem identified by \fI<path>\fR.
-The \fI<size>\fR parameter specifies the new size of the filesystem.
+The \fI<newsize>\fR parameter specifies the new size of the filesystem.
 If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decr=
eased
-by the quantity \fI<size>\fR.
-If no units are specified, the unit of the \fI<size>\fR parameter defaults=
 to
+by the quantity \fI<newsize>\fR.
+If no units are specified, the unit of the \fI<newsize>\fR parameter defau=
lts to
 bytes. Optionally, the size parameter may be suffixed by one of the follow=
ing
 the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabyte=
s,
 respectively.
@@ -185,15 +210,15 @@ can expand the partition before enlarging the filesys=
tem and shrink the
 partition after reducing the size of the filesystem.
 .TP
=20
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
-Show or update the label of a filesystem. \fI<dev>\fR is used to identify =
the
+\fBbtrfs\fP \fBfilesystem label\fP\fI <device> [<newlabel>]\fP
+Show or update the label of a filesystem. \fI<device>\fR is used to identi=
fy the
 filesystem.=20
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
-following costraints exist for a label:
+following constraints exist for a label:
 .IP
-- the maximum allowable lenght shall be less or equal than 256 chars
+- the maximum allowable length is 256 characters
 .IP
-- the label shall not  contain the '/' or '\\' characters.
+- the label shall not contain the '/' or '\\' characters.
=20
 NOTE: Currently there are the following limitations:
 .IP
@@ -202,27 +227,36 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
=20
-\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no \fIUUID\fP or=
=20
-\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
-otherwise the devices list is extracted from the /proc/partitions file.
-.TP
-
-\fBdevice balance\fR \fI<path>\fR
+\fBdevice balance start\fR \fI[options] <path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
=20
-\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice balance pause\fR \fI<path>\fR
+Pause a running balance operation.
+.TP
+
+\fBdevice balance cancel\fR \fI[options] <path>\fR
+Cancel a running or paused balance operation.
+.TP
+
+\fBdevice balance resume\fR \fI <path>\fR
+Resume an interrupted balance operation.
+.TP
+
+\fBdevice balance status\fR \fI[-v] <path>\fR
+Show the status of a running or paused balance operation.
+.TP
+
+\fBdevice add\fR\fI <device> [<device>..] <path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
=20
-\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice delete\fR\fI <device> [<device>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .TP
=20
-\fBdevice scan\fR \fI[--all-devices|<device> [<device>...]\fR
+\fBdevice scan\fR \fI[--all-devices|<device>...]\fR
 If one or more devices are passed, these are scanned for a btrfs filesyste=
m.=20
 If no devices are passed, \fBbtrfs\fR scans all the block devices listed
 in the /proc/partitions file.
@@ -309,14 +343,14 @@ verbose mode. print count of returned paths and all i=
octl() return values
 .RE
=20
 .SH EXIT STATUS
-\fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is return=
ed in
+\fBbtrfs\fR returns a zero exit status if it succeeds. Non-zero is returne=
d in
 case of failure.
=20
 .SH AVAILABILITY
 .B btrfs
-is part of btrfs-progs. Btrfs filesystem is currently under heavy developm=
ent,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
-further details.
+is part of btrfs-progs. The btrfs filesystem is currently under heavy
+development, and not suitable for any use other than benchmarking and
+review. Please refer to the btrfs wiki at http://btrfs.wiki.kernel.org
+for further details.
 .SH SEE ALSO
 .BR mkfs.btrfs (8)
--=20
1.7.10


--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPwULKAAoJEKLT589SE0a0LJMP/igfOIGom7B+mJ27IZ/jXiJt
3AgR5zbCXN8B3y1b4aPEyaeX3yLskqT/VMIvip4OYRe+7n17gWaTlmH50vJb2fVb
/imUOP22UuXnkliaaICP659sHDDeZT4p21k+X45R+01MqTYgOG+vYFA3upieScs8
xyijPXcQo5POkGKyL6xA6KNGP/QwHdDAbA3MSBSeSm57NRKNqbqtkaNkZ4RP4PTQ
HM4sknuv4auLdUHVN/zISf3RtTOzRwBIUhwqpZ34wcjWRaH/7teipiIuxWCimnvf
rHjjBUc1BJyDLfHHl1aGhjfb7whajcREHj+wlAe0xXr+Eo0V4JL/OAKPxMt+4Cj9
x5HGNiFE2axJ7T+9COrer3NadbN8oIcd97bVahcC49auAmOiEBQf8gyn1skM3WjY
EnN+4Colm0UOaMMac9+H6HqwkIpFgoCUVk7iO5m27cOrD8UlYN/6wEbd9GTZEKw8
JvURgakCIuT3SIgODA5fhFq+X4sOISx/jjkksIiH6cKVdCkhD4AEdFmVYcJT4duH
gMFk9VEEBU81Se3ySZxP9Ni4Q2lDiepWfJ6WbCdHG3Uk8JUF6+OASCXlKSapItMA
WTtHHK5B/AMN+fvy6VfGVMXVgLWVcazCwFs5rn6xl43bw6Qxt0Zh6x5JDS3ovaPd
Os1q4cF1/rF4t04CJKG2
=fyZw
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
