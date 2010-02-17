From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Wed, 17 Feb 2010 21:02:17 +0100
Message-ID: <201002172102.17816.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>, Mike Fedyk <mfedyk@mikefedyk.com>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

enclosed in the next two emails you can find two patches which introduc=
e a new=20
program called "btrfs". This program has the ambitious to replace the=20
utilities of the btrfs-prog package, like:
- btrfsctl
- btrfs-show
- btrfs-volume
- btrfs

The goals are:
- improve the usability of the tools=20
- add a man page which documents all the commands
- correct the btrfsctl return codes

I put a lot of attentions in order to avoid regression respect the old =
tools.
A clone of my git repository is available at

        http://cassiopea.homelinux.net/git/btrfs-command.git

On the basis of the feedback of the previous patches I rearranged some =
"short=20
command name" (-s, -c ...) in order to avoid collision. I renamed also =
the=20
command "create" in "subvolume" (and the relative short command name fr=
om '-S'=20
to '-c' :-) ).

Chris, do you think that these patches are mergeable ?

Comments are welcome.

BR
Goffredo
---

 Makefile       |    5
 btrfs.c        |  775 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++++
 man/Makefile   |    5
 man/btrfs.8.in |  122 ++++++++
 4 files changed, 905 insertions(+), 2 deletions(-)

--

Example of use:
$ btrfs
Usage:
        btrfs snapshot|-s [<dest>/]<name>
                Create a writeble snapshot of the subvolume <source> wi=
th
                the name <name> in the <dest> directory.
        btrfs delete|-D <subvolume>
                Delete the subvolume <subvolume>.
        btrfs subvolume|-c [<dest>/]<name>
                Create a subvolume in <dest> (or the current directory =
if
                not passed).
        btrfs defrag|-f <file>|<dir> [<file>|<dir>...]
                Defragment a file or a directory.
        btrfs scan|-n [<device> [<device>..]
                Scan all device for or the passed device for a btrfs
                filesystem.
        btrfs fssync|-y <path>
                Force a fs sync on the filesystem <path>
        btrfs resize|-z [+/-]<newsize>[gkm]|max <filesystem>
                Resize the file system. If 'max' is passed, the filesys=
tem
                will occupe all available space on the device.
        btrfs show|-l [<dev>|<label>...]
                Show the btrfs devices
        btrfs balance|-b <path>
                Balance the chunk across the device
        btrfs add-dev|-A <dev> [<dev>..] <path>
                Add a device to a filesystem
        btrfs rm-dev|-R <dev> [<dev>..] <path>
                Remove a device to a filesystem

        btrfs help|--help|-h
                Show the help.

Btrfs v0.19-12-g7e4c8e8-dirty




BTRFS(8)                             btrfs                            B=
TRFS(8)



NAME
       btrfs - control a btrfs filesystem

SYNOPSIS
       btrfs  snapshot|-s  <source> [<dest>/]<name>

       btrfs  delete|-D  <subvolume>

       btrfs  subvolume|-c  [<dest>/]<name>

       btrfs  defrag|-f  <file>|<dir> [<file>|<dir>...]

       btrfs  fssync|-y  <path>

       btrfs  resize|-z  [+/-]<size>[gkm]|max <filesystem>

       btrfs  scan|-n  [<device> [<device>..]]

       btrfs  show|-l  <dev>|<label> [<dev>|<label>...]

       btrfs  balance|-b  <path>

       btrfs  add-dev|-A  <dev> [<dev>..] <path>

       btrfs  rm-dev|-R  <dev> [<dev>..] <path> ]


       btrfs  help|--help|-h

DESCRIPTION
       btrfs  is  used to control the filesystem and the files and dire=
ctories
       stored. It is the tool to create or destroy a new  snapshot  or =
 a  new
       subvolume for the filesystem, to defrag a file or a directory, t=
o flush
       the dato to the disk, to resize the filesystem, to scan the devi=
ce.   =20


OPTIONS
       snapshot|-s <source> [<dest>/]<name>
              Create a writeble snapshot of the subvolume  <source>  wi=
th  the
              name  <name>  in the <dest> directory. If <source> is not=
 a sub=E2=80=90
              volume, btrfs returns an error.                          =
      =20


       delete|-D <subvolume>
              Delete the subvolume <subvolume>. If <subvolume> is not  =
a  sub=E2=80=90
              volume, btrfs returns an error.                          =
      =20


       subvolume|-c [<dest>/]<name>
              Create  a  subvolume  in  <dest> (or in the current direc=
tory if
              <dest> is not passed).                                   =
      =20


       defrag|-f <file>|<dir> [<file>|<dir>...]
              Defragment files and/or directories.


       scan|-n [<device> [<device>..]]
              Scan devices for a btrfs filesystem. If no devices  are  =
passed,
              btrfs scans all the block devices.                       =
      =20


       fssync|-y <path>
              Force a sync for the filesystem identified by <path>.



       resize|-z [+/-]<size>[gkm]|max <filesystem>
              Resize a file system identified by <path>.  The <size> pa=
rameter
              specifies the new size of the filesystem.  If the prefix =
+ or  -
              is  present  the  size is increased or decreased by the q=
uantity
              <size>.  If no units are  specified,  the  unit  of  the =
 <size>
              parameter  is  the  byte.  Optionally, the size parameter=
 may be
              suffixed by one of the following  the  units  designators=
:  'K',
              'M', or 'G', kilobytes, megabytes, or gigabytes, respecti=
vely. =20

              If  'max'  is  passed,  the filesystem will occupy all av=
ailable
              space on the volume(s).                                  =
      =20

              The resize command does not manipulate the  size  of  und=
erlying
              partitions.   If  you  wish  to enlarge/reduce a filesyst=
em, you
              must make sure you can expand/reduce the size of  the  pa=
rtition
              also.                                                    =
      =20


       show|-l [<dev>|<label>...]
              Show  the btrfs devices with some additional info. If no =
devices
              or labels are passed, btrfs scans all the block devices.


       balance|-b <path>
              Balance the chunk of the filesystem identified by <path> =
 across
              the devices.


       add-dev|-A  <dev> [<dev>..] <path>
              Add device(s) to the filesystem identified by <path>.


       rm-dev|-R  <dev> [<dev>..] <path>
              Remove device(s) to the filesystem identified by <path>.

EXIT STATUS
       btrf  returns  a zero exist status if it succeeds. Non zero is r=
eturned
       in case of failure.


AVAILABILITY
       btrfs is part of btrfs-progs. Btrfs filesystem is currently unde=
r heavy
       development,  and not suitable for any uses other than benchmark=
ing and
       review.  Please refer to the  btrfs  wiki  http://btrfs.wiki.ker=
nel.org
       for further details.

SEE ALSO
       mkfs.btrfs(8)



btrfs                                                                 B=
TRFS(8)

--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinw=
ind.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
