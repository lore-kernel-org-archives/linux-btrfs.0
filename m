From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 2/2] Re: New btrfs command pushed into the btrfs-progs subvol branch - man pages
Date: Thu, 11 Mar 2010 22:44:35 +0100
Message-ID: <201003112244.35551.kreijack@inwind.it>
References: <20100311185421.GM6509@think> <201003112003.18245.kreijack@inwind.it> <20100311190828.GN6509@think>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3555619.mGsJfQ48qF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311190828.GN6509@think>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3555619.mGsJfQ48qF
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Chris,

enclose you can find the man page for the btrfs command, with the new sub-
command (subvolume list, subvolume set-default)..

You can pull from=20

git pull http://cassiopea.homelinux.net/git/btrfs-command.git mlc-subvol

(branch mlc-subvol, commit e59135a27dc1fde6acc4fb198499be2b6cbd9f6f)

$ git diff remotes/origin/subvol | diffstat
 btrfs-list.c   |   15 +++--
 btrfs.c        |   56 +++++++++++++++++-
 btrfs_cmds.c   |   84 +++++++++++++++++-----------
 btrfs_cmds.h   |    1=20
 man/btrfs.8.in |  150 +++++++++++++++++++++++++++++++++++++++++++++[...]
 5 files changed, 283 insertions(+), 43 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
new file mode 100644
index 0000000..26ef982
=2D-- /dev/null
+++ b/man/btrfs.8.in
@@ -0,0 +1,170 @@
+.TH BTRFS 8 "" "btrfs" "btrfs"
+.\"
+.\" Man page written by Goffredo Baroncelli <kreijack@inwind.it> (Feb 2010)
+.\"
+.SH NAME
+btrfs \- control a btrfs filesystem
+.SH SYNOPSIS
+\fBbtrfs\fP \fBsubvolume snapshot\fP\fI <source> [<dest>/]<name>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume list\fP\fI <path>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
+.PP
+\fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\=
fP
+.PP
+\fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
+.PP
+\fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
+.PP
+\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
+.PP
+\fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
+
+.PP
+\fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
+.PP
+.SH DESCRIPTION
+.B btrfs
+is used to control the filesystem and the files and directories stored. It=
 is
+the tool to create or destroy a snapshot or a subvolume for the
+filesystem, to defrag a file or a directory, flush the data to the disk,
+to resize the filesystem, to scan the device.
+
+It is possible to abbreviate the commands unless the commands  are ambiguo=
us.
+For example: it is possible to run
+.I btrfs sub snaps
+instead of
+.I btrfs subvolume snapshot.
+But
+.I btrfs dev s
+is not allowed, because
+.I dev s
+may be interpreted both as
+.I device show
+and as
+.I device scan.
+In this case
+.I btrfs
+returns an error.
+
+If a command is terminated by
+.I --help
+, the relevant help is showed. If the passed command matches more commands,
+the help of all the matched commands are showed. For example
+.I btrfs dev --help
+shows the help of all
+.I device*
+command.
+
+.SH COMMANDS
+.TP
+
+\fBsubvolume snapshot\fR\fI <source> [<dest>/]<name>\fR
+Create a writable snapshot of the subvolume \fI<source>\fR with the name
+\fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
+subvolume, \fBbtrfs\fR returns an error.
+.TP
+
+\fBsubvolume delete\fR\fI <subvolume>\fR
+Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
+subvolume, \fBbtrfs\fR returns an error.
+.TP
+
+\fBsubvolume create\fR\fI [<dest>/]<name>\fR
+Create a subvolume in \fI<dest>\fR (or in the current directory if
+\fI<dest>\fR is omitted).
+.TP
+
+\fBsubvolume list\fR\fI <path>\fR
+List the subvolumes present in the filesystem \fI<path>\fR. For every
+subvolume is showed the subvolume ID (second column),=20
+the ID of the \fItop level\fR=20
+subvolume (fifth column), and the path (seventh column) relative to the
+\fItop level\fR subvolume.
+These <ID> may be used by the \fBsubvolume set-default\fR command, or at
+mount time via the \fIsubvol=3D\fR option.
+.TP
+
+\fBsubvolume set-default\fR\fI <id> <path>\fR
+Set the subvolume of the filesystem \fI<path>\fR which is mounted as=20
+\fIdefault\fR. The subvolume is identified by \fB<id>\fR, which=20
+is returned by the \fBsubvolume list\fR command.
+.TP
+
+\fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fR
+Defragment files and/or directories.
+.TP
+
+\fBdevice scan\fR \fI[<device> [<device>..]]\fR
+Scan devices for a btrfs filesystem. If no devices are passed, \fBbtrfs\fR=
=20
scans
+all the block devices.
+.TP
+
+\fBfilesystem sync\fR\fI <path> \fR
+Force a sync for the filesystem identified by \fI<path>\fR.
+.TP
+
+.\"
+.\" Some wording are extracted by the resize2fs man page
+.\"
+
+\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
+Resize a filesystem identified by \fI<path>\fR.
+The \fI<size>\fR parameter specifies the new size of the filesystem.
+If the prefix \fI+\fR or \fI\-\fR is present the size is increased or=20
decreased
+by the quantity \fI<size>\fR.
+If no units are specified, the unit of the \fI<size>\fR parameter defaults=
 to
+bytes. Optionally, the size parameter may be suffixed by one of the follow=
ing
+the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabyte=
s,
+respectively.
+
+If 'max' is passed, the filesystem will occupy all available space on the
+volume(s).
+
+The \fBresize\fR command \fBdoes not\fR manipulate the size of underlying
+partition.  If you wish to enlarge/reduce a filesystem, you must make sure=
=20
you
+can expand the partition before enlarging the filesystem and shrink the
+partition after reducing the size of the filesystem.
+.TP
+
+\fBfilesystem show\fR [<uuid>|<label>]\fR
+Show the btrfs filesystem with some additional info. If no UUID or label is
+passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+.TP
+
+\fBdevice balance\fR \fI<path>\fR
+Balance the chunks of the filesystem identified by \fI<path>\fR
+across the devices.
+.TP
+
+\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
+Add device(s) to the filesystem identified by \fI<path>\fR.
+.TP
+
+\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
+Remove device(s) from a filesystem identified by \fI<path>\fR.
+.PP
+
+.SH EXIT STATUS
+\fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is return=
ed=20
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




On Thursday 11 March 2010, you (Chris Mason) wrote:
> Thanks for all your work on btrfs!
>=20
> -chris
>=20
> On Thu, Mar 11, 2010 at 08:03:17PM +0100, Goffredo Baroncelli wrote:
> > On Thursday 11 March 2010, Chris Mason wrote:
> > > Hi everyone,
> > >=20
> > > I've pushed Goffredo's new btrfs utility into the subvol branch of the
> > > btrfs-progs repo.  I'm using it as my starting point for the subvol
> > > listing utility as well as my fancy new defrag range ioctl.
> > >=20
> > > Goffredo, the new defrag ioctl takes a bunch of arguments, and I used
> > > getopt inside the command to do it.  The tricky part is that getopt
> > > expects argv[0] to be the command name, so I had to hack things a bit.
> > >=20
> > > Could you please send a patch that changes the commands to include the
> > > command name in argv[0]?  That'll make it easier to be flexible.
> > >=20
> >=20
> > I will start to work=20
> >=20
> > > -chris
> > >=20
> >=20
> >=20
> > --=20
> > gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo)=20
<kreijack@inwind.it>
> > Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart3555619.mGsJfQ48qF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLmWRDvwTxYT3FBRIRAk8QAJ47KCiG8NSxGzsLSGs2Vg3n6p3q3ACcC+Lc
09BgvflMkdNU0PWPfzrqYGY=
=gVdC
-----END PGP SIGNATURE-----

--nextPart3555619.mGsJfQ48qF--
