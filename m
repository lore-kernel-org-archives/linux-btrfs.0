From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [PATCH 2/2] btrfs: a new tool to manage a btrfs filesystem - man
	page
Date: Sat, 13 Feb 2010 12:42:52 +0000
Message-ID: <6278d2221002130442y6cc2be62ybe60dbb62cc71be9@mail.gmail.com>
References: <201002122001.26457.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002122001.26457.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Geffredo,

On Fri, Feb 12, 2010 at 7:01 PM, Goffredo Baroncelli <kreijack@gmail.co=
m> wrote:
> This is the man page of the btrfs command.
>
> diff --git a/man/Makefile b/man/Makefile
> index 4e8893b..4a90b75 100644
> --- a/man/Makefile
> +++ b/man/Makefile
> @@ -7,13 +7,16 @@ mandir =3D $(prefix)/man
> =A0man8dir =3D $(mandir)/man8
>
> =A0MANPAGES =3D mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-imag=
e.8.gz \
> - =A0 =A0 =A0 =A0 =A0btrfs-show.8.gz
> + =A0 =A0 =A0 =A0 =A0btrfs-show.8.gz btrfs.8.gz
>
> =A0all: $(MANPAGES)
>
> =A0mkfs.btrfs.8.gz: mkfs.btrfs.8.in
> =A0 =A0 =A0 =A0$(GZIP) -n -c mkfs.btrfs.8.in > mkfs.btrfs.8.gz
>
> +btrfs.8.gz: btrfs.8.in
> + =A0 =A0 =A0 $(GZIP) -n -c btrfs.8.in > btrfs.8.gz
> +
> =A0btrfsctl.8.gz: btrfsctl.8.in
> =A0 =A0 =A0 =A0$(GZIP) -n -c btrfsctl.8.in > btrfsctl.8.gz
>
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> new file mode 100644
> index 0000000..354faf9
> --- /dev/null
> +++ b/man/btrfs.8.in
> @@ -0,0 +1,122 @@
> +.TH BTRFS 8 "" "btrfs" "btrfs"
> +.\"
> +.\" Man page writte by Goffredo Baroncelli <kreijack@inwind.it> (Feb=
 2010)
> +.\"
> +.SH NAME
> +btrfs \- control a btrfs filesystem
> +.SH SYNOPSIS
> +\fBbtrfs\fP \fB snapshot|\-s \fP\fI <source> [<dest>/]<name>\fP
> +.PP
> +\fBbtrfs\fP \fB delete|\-D \fP\fI <subvolume>\fP
> +.PP
> +\fBbtrfs\fP \fB create|\-S \fP\fI [<dest>/]<name>\fP
> +.PP
> +\fBbtrfs\fP \fB defrag|\-d \fP\fI <file>|<dir> [<file>|<dir>...]\fP
> +.PP
> +\fBbtrfs\fP \fB fssync|\-c \fP\fI <path> \fP
> +.PP
> +\fBbtrfs\fP \fB resize|\-r \fP\fI [+/\-]<size>[gkm]|max <filesystem>=
\fP
> +.PP
> +\fBbtrfs\fP \fB scan|\-a \fP\fI [<device> [<device>..]]\fP
> +.PP
> +\fBbtrfs\fP \fB show|\-l \fP\fI <dev>|<label> [<dev>|<label>...]\fP
> +.PP
> +\fBbtrfs\fP \fB balance|\-b \fP\fI <path> \fP
> +.PP
> +\fBbtrfs\fP \fB add\-dev|\-A \fP\fI <dev> [<dev>..] <path> \fP
> +.PP
> +\fBbtrfs\fP \fB rm\-dev|\-R \fP\fI <dev> [<dev>..] <path> \fP]
> +
> +.PP
> +\fBbtrfs\fP \fB help|\-\-help|\-h \fP\fI\fP
> +.PP
> +.SH DESCRIPTION
> +.B btrfs
> +is used to control the filesystem and the files and directories stor=
ed. It is
> +the tool to create or destroy a new snapshot or a new subvolume for =
the
> +filesystem, to defrag a file or a directory, to flush the dato to th=
e disk,
> +to resize a filesystem, to scan the devive
> +
> +.SH OPTIONS
> +.TP
> +
> +\fBsnapshot|\-s\fR\fI <source> [<dest>/]<name>\fR
> +Create a writeble snapshot of the subvolume \fI<source>\fR with the =
name
> +\fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not=
 a
> +subvolume, \fBbtrfs\fR returns an error.
> +.TP
> +
> +\fBdelete|\-D\fR\fI <subvolume>\fR
> +Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not =
a
> +subvolume, \fBbtrfs\fR returns an error.
> +.TP
> +
> +\fBcreate|\-S\fR\fI [<dest>/]<name>\fR
> +Create a subvolume in \fI<dest>\fR (or in the current directory if
> +\fI<dest>\fR is not passed).
> +.TP
> +
> +\fBdefrag|\-d\fP\fI <file>|<dir> [<file>|<dir>...]\fR
> +Defragment files and/or directories.
> +.TP
> +
> +\fBscan|\-a\fR \fI[<device> [<device>..]]\fR
> +Scan devices for a btrfs filesystem. If no devices are passed, \fBbt=
rfs\fR scans
> +all the block devices.
> +.TP
> +
> +\fBfssync|\-c\fR\fI <path> \fR
> +Force a sync for the filesystem identified by \fI<path>\fR.
> +.TP
> +
> +.\"
> +.\" Some wording are extracted by the resize2fs man page
> +.\"
> +
> +\fBresize|\-r\fR\fI [+/\-]<size>[gkm]|max <filesystem>\fR
> +Resize a file system indentified by \fI<path>\fR.
> +The \fI<size>\fR parameter specifies the new size of the filesystem.
> +If the prefix \fI+\fR or \fI\-\fR is present the size is increased o=
r decreased
> +by the quantity \fI<size>\fR.
> +If no units are specified, the unit of the \fI<size>\fR parameter is=
 the byte.
> +Optionally, the size parameter may be suffixed by one of the followi=
ng the units
> +designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes, r=
espectively.
> +
> +If 'max' is passed, the filesystem will occupe all available space o=
n the
> +volume(s).
> +
> +The \fBresize\fR command \fBdoes not\fR manipulate the size of under=
lying
> +partitions. =A0If you wish to enlarge/reduce a filesystem, you must =
make sure you
> +can expand/reduce the size of the partition also.
> +.TP
> +
> +\fBshow|\-l\fR [<dev>|<label>...]\fR
> +Show the btrfs devices with some additional info. If no devices or l=
abels are
> +passed, \fBbtrfs\fR scans all the block devices.
> +.TP
> +
> +\fBbalance|\-b\fR \fI<path>\fR
> +Balance the chunk of the filesystem identified by \fI<path>\fR
> +across the devices.
> +.TP
> +
> +\fBadd\-dev|\-A \fR\fI <dev> [<dev>..] <path>\fR
> +Add device(s) to the filesystem identified by \fI<path>\fR.
> +.TP
> +
> +\fBrm\-dev|\-R \fR\fI <dev> [<dev>..] <path>\fR
> +Remove device(s) to the filesystem identified by \fI<path>\fR.
> +.PP
> +
> +.SH EXIT STATUS
> +\fBbtrf\fR returns a zero exist status if it succeeds. Non zero is r=
eturned in
> +case of failure.
> +
> +.SH AVAILABILITY
> +.B btrfs
> +is part of btrfs-progs. Btrfs filesystem is currently under heavy de=
velopment,
> +and not suitable for any uses other than benchmarking and review.
> +Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
> +further details.
> +.SH SEE ALSO
> +.BR mkfs.btrfs (8)

Great work. A couple of quick tweaks:

"dato to the disk, to resize a filesystem, to scan the devive"
-> "data to the disk, to resize the filesystem, to scan the device"

"indentified by"
-> "identified by"

"will occupe"
-> "will occupy"

Thanks,
  Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
