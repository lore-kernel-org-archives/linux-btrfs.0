From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] btrfs: a new tool to manage a btrfs filesystem
Date: Sat, 20 Feb 2010 11:48:38 +0100
Message-ID: <201002201148.39264.kreijack@libero.it>
References: <201002192112.17752.kreijack@libero.it> <93cdabd21002191316r7f65a031veb943045dca82c14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002191316r7f65a031veb943045dca82c14@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mike,

Thanks, I implemented all your suggestion except the one related to the=
 resize=20
command.

These patches doesn't address problems related to btrfs itself, and now=
 the=20
interface of the btrfs function is based on the filesystem and not on t=
he=20
device.

But I agree with you that today if a btrfs filesystem relies on more th=
an one=20
device, is not clear how "shrink" the occupation of one specific device=
=20
(remove the device, resize the partition and add the device again ?)=20

I hope to post the new patches (with the implementation of the resize i=
octl=20
call) in this week end.

BR
Goffredo

On Friday 19 February 2010, Mike Fedyk wrote:
> On Fri, Feb 19, 2010 at 12:12 PM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
> > Hi all,
> >
> > on the basis of the suggestion received, I update my btrfs tool.
> >
> > The main changes are:
> > - removed the short form of the command (like '-C')
> > - deployed the "multi level" command (i.e.: btrfs snapshot create)
> > - split the source in three files. This because the new parses are =
quite=20
big
> > (about  295 lines; for example btrfsctl.c are only 239 lines).
> >
> > The "multi level" command parser is quite flexible. They accept the=
 full-
> > length command (btrfs subvolume create) and a contract form (btrfs =
subvol=20
cr).
> > The commands may be arbitrary shortly (even 1 chars) but they have =
to be=20
un-
> > ambiguous. For example
> > - btrfs s s             -> OK (matches 'btrfs subvolume snapshot' o=
nly)
> > - btrfs dev s           -> FAIL (matches both 'btrfs dev show' and
> >                                'btrfs dev scan')
> >
> > The parser highlights which part of the command are ambiguous.
> >
> > This is a RFC because there is no agreement about the name of the c=
ommand.
> > I am proposing the following structure:
> >
> >   btrfs <object> <action>
> >
> > where <object> are:
> > - subvolume (valid action: create, delete, snapshot, list [not=20
implemented])
> > - filesystem (valid action: defrag, sync, resize [not implemented])
> > - device (valid action: add, delete, scan, show, balance)
> >
> > You can find the source at
> >
> >        http://cassiopea.homelinux.net/git/btrfs-command.git
> >
> > (commit 3deec45d18879d60b4032dc1f8895d7b7e1211ec, remember to switc=
h to=20
the
> > "remotes/origin/multi-level-command" branch (I hate git!!!)
> >
> >
> > BR
> > G.Baroncelli
> > ----
> >
> > $ git diff remotes/origin/orig | diffstat
> >  Makefile             |    6
> >  btrfs.c              |   73 ++++++
> >  btrfs_cmds.c         |  587=20
+++++++++++++++++++++++++++++++++++++++++++[...]
> >  btrfs_cmds.h         |   30 ++
> >  btrfs_cmds_parse.c   |  296 +++++++++++++++++++++++++
> >  man/Makefile         |    5
> >  man/btrfs.8.in       |  148 ++++++++++++
> >  13 files changed, 1291 insertions(+), 2 deletions(-)
> >
> > ----
> > $ ./btrfs
> > Usage:
> >        btrfs subvolume snapshot [<dest>/]<name>
> >                Create a writeble snapshot of the subvolume <source>=
 with
> >                the name <name> in the <dest> directory.
> >        btrfs subvolume delete <subvolume>
> >                Delete the subvolume <subvolume>.
> >        btrfs subvolume create [<dest>/]<name>
> >                Create a subvolume in <dest> (or the current directo=
ry if
> >                not passed).
> >        btrfs filesystem defrag <file>|<dir> [<file>|<dir>...]
> >                Defragment a file or a directory.
> >        btrfs device scan [<device> [<device>..]
> >                Scan all device for or the passed device for a btrfs
> >                filesystem.
> >        btrfs filesystem sync <path>
> >                Force a fs sync on the filesystem <path>
> >        btrfs filesystem resize [+/-]<newsize>[gkm]|max <filesystem>
> >                Resize the file system. If 'max' is passed, the file=
system
> >                will occupe all available space on the device.
> >        btrfs device show [<dev>|<label>...]
> >                Show the btrfs devices
> >        btrfs device balance <path>
> >                Balance the chunk across the device
> >        btrfs device add <dev> [<dev>..] <path>
> >                Add a device to a filesystem
> >        btrfs device delete <dev> [<dev>..] <path>
> >                Remove a device from a filesystem
> >
> >        btrfs help|--help|-h
> >                Show the help.
> >
> > Btrfs v0.19-22-g07a97f0-dirty
> >
> > ----
> >
> > $ man man/btrfs.8.in | cat
> > BTRFS(8)                           btrfs                          =20
BTRFS(8)
> >
> >
> >
> > NAME
> >       btrfs - control a btrfs filesystem
> >
> > SYNOPSIS
> >       btrfs subvolume snapshot <source> [<dest>/]<name>
> >
> >       btrfs subvolume delete <subvolume>
> >
> >       btrfs subvolume create [<dest>/]<name>
> >
> >       btrfs filesystem defrag <file>|<dir> [<file>|<dir>...]
> >
> >       btrfs filesystem fssync <path>
> >
> >       btrfs filesystem resize [+/-]<size>[gkm]|max <filesystem>
> >
> >       btrfs device scan [<device> [<device>..]]
> >
> >       btrfs device show <dev>|<label> [<dev>|<label>...]
> >
> >       btrfs device balance <path>
> >
> >       btrfs device add <dev> [<dev>..] <path>
> >
> >       btrfs device delete <dev> [<dev>..] <path> ]
> >
> >
> >       btrfs help|--help|-h
> >
> > DESCRIPTION
> >       btrfs  is  used to control the filesystem and the files and d=
irecto=E2=80=90
> >       ries stored. It is the tool to create or destroy a new snapsh=
ot or a
>=20
> -create or destroy a new snapshot
> +create or destroy a snapshot
>=20
> >       new  subvolume  for the filesystem, to defrag a file or a dir=
ectory,
>=20
> -new  subvolume  for the filesystem, to defrag a file or a directory
> +subvolume for the filesystem, defrag a file or a directory
>=20
> >       to flush the dato to the disk, to resize the filesystem, to s=
can the
> >       device.
>=20
> -to flush the dato to the disk, to resize the filesystem, to scan the
> +flush the data to the disk, resize the filesystem, scan the
>=20
> >
> >       It  is  possible to abbreviate the commands unless the comman=
ds  are
> >       ambiguous.  For example: it is  possible  to  run  btrfs  sub=
  snaps
> >       instead  of  btrfs  subvolume  snapshot.   But  btrfs  dev  s=
 is not
> >       allowed, because dev s may be interpreted both as device show=
 and as
> >       device scan.  In this case btrfs returns an error.
> >
> >       If  a command is terminated by --help , the relevant help is =
showed.
> >       If the passed command matches more commands, the  help  of  a=
ll  the
> >       matched  commands are showed. For example btrfs dev --help sh=
ows the
> >       help of all device* command.
> >
>=20
> Several parts above have more than one space between words, and less
> than two spaces between sentences.
>=20
> >
> > COMMANDS
> >       subvolume snapshot <source> [<dest>/]<name>
> >              Create a writeble snapshot of the subvolume <source> w=
ith the
> >              name  <name>  in  the  <dest> directory. If <source> i=
s not a
> >              subvolume, btrfs returns an error.
> >
>=20
> -Create a writeble snapshot of the subvolume <source> with the
> +Create a writeable snapshot of the subvolume <source> with the
>=20
> >
> >       subvolume delete <subvolume>
> >              Delete the subvolume <subvolume>. If  <subvolume>  is =
 not  a
> >              subvolume, btrfs returns an error.
> >
> >
> >       subvolume create [<dest>/]<name>
> >              Create  a subvolume in <dest> (or in the current direc=
tory if
> >              <dest> is not passed).
> >
> >
> >       filesystem defrag <file>|<dir> [<file>|<dir>...]
> >              Defragment files and/or directories.
> >
>=20
> -filesystem defrag <file>|<dir> [<file>|<dir>...]
> +filesystem defragment <file>|<dir> [<file>|<dir>...]
>=20
> Since the commands can be arbitrarily shortened, might as well spell
> the full command out.
>=20
> >
> >       device scan [<device> [<device>..]]
> >              Scan devices for  a  btrfs  filesystem.  If  no  devic=
es  are
> >              passed, btrfs scans all the block devices.
> >
> >
> >       filesystem fssync <path>
> >              Force a sync for the filesystem identified by <path>.
> >
>=20
> -filesystem fssync <path>
> +filesystem sync <path>
>=20
> You have done away with specifying what it is working on.  I think
> that's best, it just needs good error messages to handle the
> unimplemented cases at the moment.
> I would also rename "fssync" to "sync".
>=20
> >
> >
> >       filesystem resize [+/-]<size>[gkm]|max <filesystem>
>=20
> -filesystem resize [+/-]<size>[gkm]|max <filesystem>
> +filesystem resize [+/-]<size>[gkm]|max <dev>
>=20
> >              Resize a file system identified by <path>.  The <size>=
 param=E2=80=90
>=20
> -Resize a file system identified
> +Resize a filesystem identified
>=20
> >              eter specifies the new size of the filesystem.  If the=
 prefix
> >              +  or  - is present the size is increased or decreased=
 by the
> >              quantity <size>.  If no units are specified, the unit =
of  the
> >              <size> parameter is the byte.  Optionally, the size pa=
rameter
>=20
> -<size> parameter is the byte.
> +<size> parameter defaults to bytes.
>=20
> >              may be suffixed by one of the following  the  units  d=
esigna=E2=80=90
> >              tors:  'K',  'M', or 'G', kilobytes, megabytes, or gig=
abytes,
> >              respectively.
> >
> >              If 'max' is passed, the filesystem will occupy all  av=
ailable
> >              space on the volume(s).
>=20
> -space on the volume(s).
> +space on the block device specified.
>=20
> >
> >              The resize command does not manipulate the size of und=
erlying
> >              partitions.  If you wish to enlarge/reduce a filesyste=
m,  you
> >              must  make  sure you can expand/reduce the size of the=
 parti=E2=80=90
> >              tion also.
> >
>=20
> There are multiple ways to resize a btrfs filesystem.  You can add ad=
d
> or remove devices or shrink or enlarge the devices the filesystem is
> already on.  This operation only works on one block device at a time
> so I think it should be under device instead of filesystem.
>=20
> >
> >       device show [<dev>|<label>...]
> >              Show the btrfs devices  with  some  additional  info. =
 If  no
> >              devices  or  labels  are  passed,  btrfs  scans all th=
e block
> >              devices.
> >
> >
> >       device balance|-b <path>
> >              Balance the chunk of  the  filesystem  identified  by =
 <path>
> >              across the devices.
> >
>=20
> I think this is a bit ambiguous.  While true, it is "balancing the
> filesystem across devices" and "btrfs device balance" is quite
> descriptive, it is working against a path and not a block device for
> its argument.  I think that just tips the scales enough to put it
> under filesystem instead of device.
>=20
> >
> >       device add <dev> [<dev>..] <path>
> >              Add device(s) to the filesystem identified by <path>.
> >
> >
> >       device delete <dev> [<dev>..] <path>
> >              Remove device(s) from a filesystem identified by <path=
>.
> >
> > EXIT STATUS
> >       btrfs  returns  a  zero  exist  status  if  it succeeds. Non =
zero is
> >       returned in case of failure.
> >
> >
> > AVAILABILITY
> >       btrfs is part of btrfs-progs. Btrfs filesystem  is  currently=
  under
> >       heavy  development,  and not suitable for any uses other than=
 bench=E2=80=90
> >       marking   and   review.    Please   refer   to   the   btrfs =
   wiki
> >       http://btrfs.wiki.kernel.org for further details.
> >
> > SEE ALSO
> >       mkfs.btrfs(8)
> >
> >
> >
> > btrfs                                                            =20
 BTRFS(8)
> >
> >
> > --
> > gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo)=20
<kreijackATinwind.it>
> > Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0=
512
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
