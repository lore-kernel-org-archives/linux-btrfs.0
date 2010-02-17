From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 2/2 V2] btrfs, a new tool to manage a btrfs filesystem; man page
Date: Wed, 17 Feb 2010 21:02:35 +0100
Message-ID: <201002172102.35886.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2072150.JBbG5U66Xo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Daniel J Blueman <daniel.blueman@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2072150.JBbG5U66Xo
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This is the source code of the man page of btrfs.
The main changes from my previous patch are:
=2D Rearranged the short command in order to avoid conflicts
=2D Renamed the 'create' verb is 'subvolume'

Thanks to Daniel for some tweaks on the syntax

BR
G.Baroncelli

diff --git a/man/Makefile b/man/Makefile
index 4e8893b..4a90b75 100644
=2D-- a/man/Makefile
+++ b/man/Makefile
@@ -7,13 +7,16 @@ mandir =3D $(prefix)/man
 man8dir =3D $(mandir)/man8
=20
 MANPAGES =3D mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz \
=2D	   btrfs-show.8.gz
+	   btrfs-show.8.gz btrfs.8.gz
=20
 all: $(MANPAGES)
=20
 mkfs.btrfs.8.gz: mkfs.btrfs.8.in
 	$(GZIP) -n -c mkfs.btrfs.8.in > mkfs.btrfs.8.gz
=20
+btrfs.8.gz: btrfs.8.in
+	$(GZIP) -n -c btrfs.8.in > btrfs.8.gz
+
 btrfsctl.8.gz: btrfsctl.8.in
 	$(GZIP) -n -c btrfsctl.8.in > btrfsctl.8.gz
=20
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
new file mode 100644
index 0000000..31d3850
=2D-- /dev/null
+++ b/man/btrfs.8.in
@@ -0,0 +1,122 @@
+.TH BTRFS 8 "" "btrfs" "btrfs"
+.\"
+.\" Man page written by Goffredo Baroncelli <kreijack@inwind.it> (Feb 2010)
+.\"
+.SH NAME
+btrfs \- control a btrfs filesystem
+.SH SYNOPSIS
+\fBbtrfs\fP \fB snapshot|\-s \fP\fI <source> [<dest>/]<name>\fP
+.PP
+\fBbtrfs\fP \fB delete|\-D \fP\fI <subvolume>\fP
+.PP
+\fBbtrfs\fP \fB subvolume|\-c \fP\fI [<dest>/]<name>\fP
+.PP
+\fBbtrfs\fP \fB defrag|\-f \fP\fI <file>|<dir> [<file>|<dir>...]\fP
+.PP
+\fBbtrfs\fP \fB fssync|\-y \fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fB resize|\-z \fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
+.PP
+\fBbtrfs\fP \fB scan|\-n \fP\fI [<device> [<device>..]]\fP
+.PP
+\fBbtrfs\fP \fB show|\-l \fP\fI <dev>|<label> [<dev>|<label>...]\fP
+.PP
+\fBbtrfs\fP \fB balance|\-b \fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fB add\-dev|\-A \fP\fI <dev> [<dev>..] <path> \fP
+.PP
+\fBbtrfs\fP \fB rm\-dev|\-R \fP\fI <dev> [<dev>..] <path> \fP]
+
+.PP
+\fBbtrfs\fP \fB help|\-\-help|\-h \fP\fI\fP
+.PP
+.SH DESCRIPTION
+.B btrfs
+is used to control the filesystem and the files and directories stored. It=
 is
+the tool to create or destroy a new snapshot or a new subvolume for the
+filesystem, to defrag a file or a directory, to flush the dato to the disk,
+to resize the filesystem, to scan the device.
+
+.SH OPTIONS
+.TP
+
+\fBsnapshot|\-s\fR\fI <source> [<dest>/]<name>\fR
+Create a writeble snapshot of the subvolume \fI<source>\fR with the name
+\fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
+subvolume, \fBbtrfs\fR returns an error.
+.TP
+
+\fBdelete|\-D\fR\fI <subvolume>\fR
+Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
+subvolume, \fBbtrfs\fR returns an error.
+.TP
+
+\fBsubvolume|\-c\fR\fI [<dest>/]<name>\fR
+Create a subvolume in \fI<dest>\fR (or in the current directory if
+\fI<dest>\fR is not passed).
+.TP
+
+\fBdefrag|\-f\fP\fI <file>|<dir> [<file>|<dir>...]\fR
+Defragment files and/or directories.
+.TP
+
+\fBscan|\-n\fR \fI[<device> [<device>..]]\fR
+Scan devices for a btrfs filesystem. If no devices are passed, \fBbtrfs\fR=
=20
scans
+all the block devices.
+.TP
+
+\fBfssync|\-y\fR\fI <path> \fR
+Force a sync for the filesystem identified by \fI<path>\fR.
+.TP
+
+.\"
+.\" Some wording are extracted by the resize2fs man page
+.\"
+
+\fBresize|\-z\fR\fI [+/\-]<size>[gkm]|max <filesystem>\fR
+Resize a file system identified by \fI<path>\fR.
+The \fI<size>\fR parameter specifies the new size of the filesystem.
+If the prefix \fI+\fR or \fI\-\fR is present the size is increased or=20
decreased
+by the quantity \fI<size>\fR.
+If no units are specified, the unit of the \fI<size>\fR parameter is the=20
byte.
+Optionally, the size parameter may be suffixed by one of the following the=
=20
units
+designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,=20
respectively.
+
+If 'max' is passed, the filesystem will occupy all available space on the
+volume(s).
+
+The \fBresize\fR command \fBdoes not\fR manipulate the size of underlying
+partitions.  If you wish to enlarge/reduce a filesystem, you must make sur=
e=20
you
+can expand/reduce the size of the partition also.
+.TP
+
+\fBshow|\-l\fR [<dev>|<label>...]\fR
+Show the btrfs devices with some additional info. If no devices or labels =
are
+passed, \fBbtrfs\fR scans all the block devices.
+.TP
+
+\fBbalance|\-b\fR \fI<path>\fR
+Balance the chunk of the filesystem identified by \fI<path>\fR
+across the devices.
+.TP
+
+\fBadd\-dev|\-A \fR\fI <dev> [<dev>..] <path>\fR
+Add device(s) to the filesystem identified by \fI<path>\fR.
+.TP
+
+\fBrm\-dev|\-R \fR\fI <dev> [<dev>..] <path>\fR
+Remove device(s) to the filesystem identified by \fI<path>\fR.
+.PP
+
+.SH EXIT STATUS
+\fBbtrf\fR returns a zero exist status if it succeeds. Non zero is returne=
d=20
in
+case of failure.
+
+.SH AVAILABILITY
+.B btrfs
+is part of btrfs-progs. Btrfs filesystem is currently under heavy=20
development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart2072150.JBbG5U66Xo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLfEtbvwTxYT3FBRIRAtgfAJ9jamdj0kU8m/6HjbIysM60EKdnogCfcuOF
fH7vqTdLhDcQYZRNmaVgWSU=
=7n3J
-----END PGP SIGNATURE-----

--nextPart2072150.JBbG5U66Xo--
