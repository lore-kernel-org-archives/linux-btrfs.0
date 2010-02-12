From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 0/2] btrfs: a new tool to manage a btrfs filesystem
Date: Fri, 12 Feb 2010 20:01:09 +0100
Message-ID: <201002122001.09898.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

enclosed in the next two emails you can find two patches which introduc=
e a new program called=20
"btrfs". This program has the ambitious to replace the utilities of the=
 btrfs-prog package, like:
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

Comments are welcome.

BR
Goffredo
---

Example of use:

$ ./btrfs
ERROR:  no command passed
Usage:
        btrfs snapshot|-s <source> [<dest>/]<name>
                Create a writeble snapshot of the subvolume
                <source> with the name <name> in the <dest>
                directory.
        btrfs delete|-D <subvolume>
                Delete the subvolume <subvolume>.
        btrfs create|-S [<dest>/]<name>
                Create a subvolume in <dest> (or the current directory =
if not
                passed.
        btrfs defrag|-d <file>|<dir> [<file>|<dir>...]
                Defragment a file or a directory.
        btrfs fssync|-c <path>
                Force a fs sync on the filesystem <path>
        btrfs resize|-r [+/-]<newsize>[gkm]|max <filesystem>
                Resize the file system. If 'max' is passed, the filesys=
tem
                will occupe all available space on the device.
        btrfs scan|-a [<device> [<device>..]
                Scan all device for or the passed device for a
                btrfs filesystem.
        btrfs show|-l <dev>|<label> [<dev>|<label>...]
                Show the btrfs devices
        btrfs balance|-b <path>
                Balance the chunk across the device
        btrfs add-dev|-A <dev> [<dev>..] <path>
                Add a device to a filesystem
        btrfs rem-dev|-R <dev> [<dev>..] <path>
                Remove a device to a filesystem

        btrfs help|--help|-h
                Show the help.
Btrfs v0.19-5-ge9e04d6-dirty


$ man btrfs | cat
BTRFS(8)                             btrfs                            B=
TRFS(8)



NAME
       btrfs - control a btrfs filesystem

SYNOPSIS
       btrfs  snapshot|-s  <source> [<dest>/]<name>

       btrfs  delete|-D  <subvolume>

       btrfs  create|-S  [<dest>/]<name>

       btrfs  defrag|-d  <file>|<dir> [<file>|<dir>...]

       btrfs  fssync|-c  <path>

       btrfs  resize|-r  [+/-]<size>[gkm]|max <filesystem>

       btrfs  scan|-a  [<device> [<device>..]]

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
       the dato to the disk, to resize a filesystem, to scan the devive=
      =20


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


       create|-S [<dest>/]<name>
              Create  a  subvolume  in  <dest> (or in the current direc=
tory if
              <dest> is not passed).                                   =
      =20


       defrag|-d <file>|<dir> [<file>|<dir>...]
              Defragment files and/or directories.


       scan|-a [<device> [<device>..]]
              Scan devices for a btrfs filesystem. If no devices  are  =
passed,
              btrfs scans all the block devices.                       =
      =20


       fssync|-c <path>
              Force a sync for the filesystem identified by <path>.



       resize|-r [+/-]<size>[gkm]|max <filesystem>
              Resize  a file system indentified by <path>.  The <size> =
parame=E2=80=90
              ter specifies the new size of the filesystem.  If the  pr=
efix  +
              or  - is present the size is increased or decreased by th=
e quan=E2=80=90
              tity <size>.  If no units are specified, the unit of the =
 <size>
              parameter  is  the  byte.  Optionally, the size parameter=
 may be
              suffixed by one of the following  the  units  designators=
:  'K',
              'M', or 'G', kilobytes, megabytes, or gigabytes, respecti=
vely. =20

              If  'max'  is  passed,  the filesystem will occupe all av=
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
              or labels are passed, btrfs scans all the block devices. =
      =20


       balance|-b <path>
              Balance the chunk of the filesystem identified by <path> =
 across
              the devices.                                             =
      =20


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
