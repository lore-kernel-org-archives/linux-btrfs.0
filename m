From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Wed, 17 Feb 2010 21:48:29 +0100
Message-ID: <4B7C561D.30808@gmail.com>
References: <201002172102.17816.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002172102.17816.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Cool tool.
Just looking at the help output on the console I found a small typo.

Kind regards,
Andreas Philipp

diff --git a/btrfs.c b/btrfs.c
index cc55599..f3e5d8d 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -633,7 +633,7 @@ static struct Command commands[] =3D {
                "Add a device to a filesystem"
        },
        { -1, "rm-dev", "-R", "<dev> [<dev>..] <path>\n"
-               "Remove a device to a filesystem"
+               "Remove a device from a filesystem"
        },
        /* coming soon
        { 2, "label", "-m", "<label> <path>\n"


On 17.02.2010 21:02, Goffredo Baroncelli wrote:
> Hi all,
>
> enclosed in the next two emails you can find two patches which introd=
uce a new=20
> program called "btrfs". This program has the ambitious to replace the=
=20
> utilities of the btrfs-prog package, like:
> - btrfsctl
> - btrfs-show
> - btrfs-volume
> - btrfs
>
> The goals are:
> - improve the usability of the tools=20
> - add a man page which documents all the commands
> - correct the btrfsctl return codes
>
> I put a lot of attentions in order to avoid regression respect the ol=
d tools.
> A clone of my git repository is available at
>
>         http://cassiopea.homelinux.net/git/btrfs-command.git
>
> On the basis of the feedback of the previous patches I rearranged som=
e "short=20
> command name" (-s, -c ...) in order to avoid collision. I renamed als=
o the=20
> command "create" in "subvolume" (and the relative short command name =
from '-S'=20
> to '-c' :-) ).
>
> Chris, do you think that these patches are mergeable ?
>
> Comments are welcome.
>
> BR
> Goffredo
> ---
>
>  Makefile       |    5
>  btrfs.c        |  775 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>  man/Makefile   |    5
>  man/btrfs.8.in |  122 ++++++++
>  4 files changed, 905 insertions(+), 2 deletions(-)
>
> --
>
> Example of use:
> $ btrfs
> Usage:
>         btrfs snapshot|-s [<dest>/]<name>
>                 Create a writeble snapshot of the subvolume <source> =
with
>                 the name <name> in the <dest> directory.
>         btrfs delete|-D <subvolume>
>                 Delete the subvolume <subvolume>.
>         btrfs subvolume|-c [<dest>/]<name>
>                 Create a subvolume in <dest> (or the current director=
y if
>                 not passed).
>         btrfs defrag|-f <file>|<dir> [<file>|<dir>...]
>                 Defragment a file or a directory.
>         btrfs scan|-n [<device> [<device>..]
>                 Scan all device for or the passed device for a btrfs
>                 filesystem.
>         btrfs fssync|-y <path>
>                 Force a fs sync on the filesystem <path>
>         btrfs resize|-z [+/-]<newsize>[gkm]|max <filesystem>
>                 Resize the file system. If 'max' is passed, the files=
ystem
>                 will occupe all available space on the device.
>         btrfs show|-l [<dev>|<label>...]
>                 Show the btrfs devices
>         btrfs balance|-b <path>
>                 Balance the chunk across the device
>         btrfs add-dev|-A <dev> [<dev>..] <path>
>                 Add a device to a filesystem
>         btrfs rm-dev|-R <dev> [<dev>..] <path>
>                 Remove a device to a filesystem
>
>         btrfs help|--help|-h
>                 Show the help.
>
> Btrfs v0.19-12-g7e4c8e8-dirty
>
>
>
>
> BTRFS(8)                             btrfs                           =
 BTRFS(8)
>
>
>
> NAME
>        btrfs - control a btrfs filesystem
>
> SYNOPSIS
>        btrfs  snapshot|-s  <source> [<dest>/]<name>
>
>        btrfs  delete|-D  <subvolume>
>
>        btrfs  subvolume|-c  [<dest>/]<name>
>
>        btrfs  defrag|-f  <file>|<dir> [<file>|<dir>...]
>
>        btrfs  fssync|-y  <path>
>
>        btrfs  resize|-z  [+/-]<size>[gkm]|max <filesystem>
>
>        btrfs  scan|-n  [<device> [<device>..]]
>
>        btrfs  show|-l  <dev>|<label> [<dev>|<label>...]
>
>        btrfs  balance|-b  <path>
>
>        btrfs  add-dev|-A  <dev> [<dev>..] <path>
>
>        btrfs  rm-dev|-R  <dev> [<dev>..] <path> ]
>
>
>        btrfs  help|--help|-h
>
> DESCRIPTION
>        btrfs  is  used to control the filesystem and the files and di=
rectories
>        stored. It is the tool to create or destroy a new  snapshot  o=
r  a  new
>        subvolume for the filesystem, to defrag a file or a directory,=
 to flush
>        the dato to the disk, to resize the filesystem, to scan the de=
vice.   =20
>
>
> OPTIONS
>        snapshot|-s <source> [<dest>/]<name>
>               Create a writeble snapshot of the subvolume  <source>  =
with  the
>               name  <name>  in the <dest> directory. If <source> is n=
ot a sub=E2=80=90
>               volume, btrfs returns an error.                        =
        =20
>
>
>        delete|-D <subvolume>
>               Delete the subvolume <subvolume>. If <subvolume> is not=
  a  sub=E2=80=90
>               volume, btrfs returns an error.                        =
        =20
>
>
>        subvolume|-c [<dest>/]<name>
>               Create  a  subvolume  in  <dest> (or in the current dir=
ectory if
>               <dest> is not passed).                                 =
        =20
>
>
>        defrag|-f <file>|<dir> [<file>|<dir>...]
>               Defragment files and/or directories.
>
>
>        scan|-n [<device> [<device>..]]
>               Scan devices for a btrfs filesystem. If no devices  are=
  passed,
>               btrfs scans all the block devices.                     =
        =20
>
>
>        fssync|-y <path>
>               Force a sync for the filesystem identified by <path>.
>
>
>
>        resize|-z [+/-]<size>[gkm]|max <filesystem>
>               Resize a file system identified by <path>.  The <size> =
parameter
>               specifies the new size of the filesystem.  If the prefi=
x + or  -
>               is  present  the  size is increased or decreased by the=
 quantity
>               <size>.  If no units are  specified,  the  unit  of  th=
e  <size>
>               parameter  is  the  byte.  Optionally, the size paramet=
er may be
>               suffixed by one of the following  the  units  designato=
rs:  'K',
>               'M', or 'G', kilobytes, megabytes, or gigabytes, respec=
tively. =20
>
>               If  'max'  is  passed,  the filesystem will occupy all =
available
>               space on the volume(s).                                =
        =20
>
>               The resize command does not manipulate the  size  of  u=
nderlying
>               partitions.   If  you  wish  to enlarge/reduce a filesy=
stem, you
>               must make sure you can expand/reduce the size of  the  =
partition
>               also.                                                  =
        =20
>
>
>        show|-l [<dev>|<label>...]
>               Show  the btrfs devices with some additional info. If n=
o devices
>               or labels are passed, btrfs scans all the block devices=
=2E
>
>
>        balance|-b <path>
>               Balance the chunk of the filesystem identified by <path=
>  across
>               the devices.
>
>
>        add-dev|-A  <dev> [<dev>..] <path>
>               Add device(s) to the filesystem identified by <path>.
>
>
>        rm-dev|-R  <dev> [<dev>..] <path>
>               Remove device(s) to the filesystem identified by <path>=
=2E
>
> EXIT STATUS
>        btrf  returns  a zero exist status if it succeeds. Non zero is=
 returned
>        in case of failure.
>
>
> AVAILABILITY
>        btrfs is part of btrfs-progs. Btrfs filesystem is currently un=
der heavy
>        development,  and not suitable for any uses other than benchma=
rking and
>        review.  Please refer to the  btrfs  wiki  http://btrfs.wiki.k=
ernel.org
>        for further details.
>
> SEE ALSO
>        mkfs.btrfs(8)
>
>
>
> btrfs                                                                =
 BTRFS(8)
>
>  =20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
