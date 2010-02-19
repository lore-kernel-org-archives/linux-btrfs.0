From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [RFC] btrfs: a new tool to manage a btrfs filesystem
Date: Fri, 19 Feb 2010 13:16:24 -0800
Message-ID: <93cdabd21002191316r7f65a031veb943045dca82c14@mail.gmail.com>
References: <201002192112.17752.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002192112.17752.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 19, 2010 at 12:12 PM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> Hi all,
>
> on the basis of the suggestion received, I update my btrfs tool.
>
> The main changes are:
> - removed the short form of the command (like '-C')
> - deployed the "multi level" command (i.e.: btrfs snapshot create)
> - split the source in three files. This because the new parses are qu=
ite big
> (about =C2=A0295 lines; for example btrfsctl.c are only 239 lines).
>
> The "multi level" command parser is quite flexible. They accept the f=
ull-
> length command (btrfs subvolume create) and a contract form (btrfs su=
bvol cr).
> The commands may be arbitrary shortly (even 1 chars) but they have to=
 be un-
> ambiguous. For example
> - btrfs s s =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> OK (matches =
'btrfs subvolume snapshot' only)
> - btrfs dev s =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -> FAIL (matches bot=
h 'btrfs dev show' and
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0'btrfs dev scan')
>
> The parser highlights which part of the command are ambiguous.
>
> This is a RFC because there is no agreement about the name of the com=
mand.
> I am proposing the following structure:
>
> =C2=A0 btrfs <object> <action>
>
> where <object> are:
> - subvolume (valid action: create, delete, snapshot, list [not implem=
ented])
> - filesystem (valid action: defrag, sync, resize [not implemented])
> - device (valid action: add, delete, scan, show, balance)
>
> You can find the source at
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0http://cassiopea.homelinux.net/git/btrfs-c=
ommand.git
>
> (commit 3deec45d18879d60b4032dc1f8895d7b7e1211ec, remember to switch =
to the
> "remotes/origin/multi-level-command" branch (I hate git!!!)
>
>
> BR
> G.Baroncelli
> ----
>
> $ git diff remotes/origin/orig | diffstat
> =C2=A0Makefile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=
=A06
> =C2=A0btrfs.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0=
 73 ++++++
> =C2=A0btrfs_cmds.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0587 ++++++++++=
+++++++++++++++++++++++++++++++++[...]
> =C2=A0btrfs_cmds.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 30 ++
> =C2=A0btrfs_cmds_parse.c =C2=A0 | =C2=A0296 +++++++++++++++++++++++++
> =C2=A0man/Makefile =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A05
> =C2=A0man/btrfs.8.in =C2=A0 =C2=A0 =C2=A0 | =C2=A0148 ++++++++++++
> =C2=A013 files changed, 1291 insertions(+), 2 deletions(-)
>
> ----
> $ ./btrfs
> Usage:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs subvolume snapshot [<dest>/]<name>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create a write=
ble snapshot of the subvolume <source> with
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the name <name=
> in the <dest> directory.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs subvolume delete <subvolume>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Delete the sub=
volume <subvolume>.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs subvolume create [<dest>/]<name>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create a subvo=
lume in <dest> (or the current directory if
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0not passed).
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs filesystem defrag <file>|<dir> [<fil=
e>|<dir>...]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Defragment a f=
ile or a directory.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs device scan [<device> [<device>..]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Scan all devic=
e for or the passed device for a btrfs
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0filesystem.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs filesystem sync <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Force a fs syn=
c on the filesystem <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs filesystem resize [+/-]<newsize>[gkm=
]|max <filesystem>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Resize the fil=
e system. If 'max' is passed, the filesystem
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0will occupe al=
l available space on the device.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs device show [<dev>|<label>...]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Show the btrfs=
 devices
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs device balance <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Balance the ch=
unk across the device
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs device add <dev> [<dev>..] <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Add a device t=
o a filesystem
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs device delete <dev> [<dev>..] <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remove a devic=
e from a filesystem
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs help|--help|-h
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Show the help.
>
> Btrfs v0.19-22-g07a97f0-dirty
>
> ----
>
> $ man man/btrfs.8.in | cat
> BTRFS(8) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BTRFS(8)
>
>
>
> NAME
> =C2=A0 =C2=A0 =C2=A0 btrfs - control a btrfs filesystem
>
> SYNOPSIS
> =C2=A0 =C2=A0 =C2=A0 btrfs subvolume snapshot <source> [<dest>/]<name=
>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs subvolume delete <subvolume>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs subvolume create [<dest>/]<name>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs filesystem defrag <file>|<dir> [<file>|<di=
r>...]
>
> =C2=A0 =C2=A0 =C2=A0 btrfs filesystem fssync <path>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs filesystem resize [+/-]<size>[gkm]|max <fi=
lesystem>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs device scan [<device> [<device>..]]
>
> =C2=A0 =C2=A0 =C2=A0 btrfs device show <dev>|<label> [<dev>|<label>..=
=2E]
>
> =C2=A0 =C2=A0 =C2=A0 btrfs device balance <path>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs device add <dev> [<dev>..] <path>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs device delete <dev> [<dev>..] <path> ]
>
>
> =C2=A0 =C2=A0 =C2=A0 btrfs help|--help|-h
>
> DESCRIPTION
> =C2=A0 =C2=A0 =C2=A0 btrfs =C2=A0is =C2=A0used to control the filesys=
tem and the files and directo=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 ries stored. It is the tool to create or destroy=
 a new snapshot or a

-create or destroy a new snapshot
+create or destroy a snapshot

> =C2=A0 =C2=A0 =C2=A0 new =C2=A0subvolume =C2=A0for the filesystem, to=
 defrag a file or a directory,

-new  subvolume  for the filesystem, to defrag a file or a directory
+subvolume for the filesystem, defrag a file or a directory

> =C2=A0 =C2=A0 =C2=A0 to flush the dato to the disk, to resize the fil=
esystem, to scan the
> =C2=A0 =C2=A0 =C2=A0 device.

-to flush the dato to the disk, to resize the filesystem, to scan the
+flush the data to the disk, resize the filesystem, scan the

>
> =C2=A0 =C2=A0 =C2=A0 It =C2=A0is =C2=A0possible to abbreviate the com=
mands unless the commands =C2=A0are
> =C2=A0 =C2=A0 =C2=A0 ambiguous. =C2=A0For example: it is =C2=A0possib=
le =C2=A0to =C2=A0run =C2=A0btrfs =C2=A0sub =C2=A0snaps
> =C2=A0 =C2=A0 =C2=A0 instead =C2=A0of =C2=A0btrfs =C2=A0subvolume =C2=
=A0snapshot. =C2=A0 But =C2=A0btrfs =C2=A0dev =C2=A0s is not
> =C2=A0 =C2=A0 =C2=A0 allowed, because dev s may be interpreted both a=
s device show and as
> =C2=A0 =C2=A0 =C2=A0 device scan. =C2=A0In this case btrfs returns an=
 error.
>
> =C2=A0 =C2=A0 =C2=A0 If =C2=A0a command is terminated by --help , the=
 relevant help is showed.
> =C2=A0 =C2=A0 =C2=A0 If the passed command matches more commands, the=
 =C2=A0help =C2=A0of =C2=A0all =C2=A0the
> =C2=A0 =C2=A0 =C2=A0 matched =C2=A0commands are showed. For example b=
trfs dev --help shows the
> =C2=A0 =C2=A0 =C2=A0 help of all device* command.
>

Several parts above have more than one space between words, and less
than two spaces between sentences.

>
> COMMANDS
> =C2=A0 =C2=A0 =C2=A0 subvolume snapshot <source> [<dest>/]<name>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create a writeble sna=
pshot of the subvolume <source> with the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name =C2=A0<name> =C2=
=A0in =C2=A0the =C2=A0<dest> directory. If <source> is not a
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0subvolume, btrfs retu=
rns an error.
>

-Create a writeble snapshot of the subvolume <source> with the
+Create a writeable snapshot of the subvolume <source> with the

>
> =C2=A0 =C2=A0 =C2=A0 subvolume delete <subvolume>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Delete the subvolume =
<subvolume>. If =C2=A0<subvolume> =C2=A0is =C2=A0not =C2=A0a
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0subvolume, btrfs retu=
rns an error.
>
>
> =C2=A0 =C2=A0 =C2=A0 subvolume create [<dest>/]<name>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create =C2=A0a subvol=
ume in <dest> (or in the current directory if
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<dest> is not passed)=
=2E
>
>
> =C2=A0 =C2=A0 =C2=A0 filesystem defrag <file>|<dir> [<file>|<dir>...]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Defragment files and/=
or directories.
>

-filesystem defrag <file>|<dir> [<file>|<dir>...]
+filesystem defragment <file>|<dir> [<file>|<dir>...]

Since the commands can be arbitrarily shortened, might as well spell
the full command out.

>
> =C2=A0 =C2=A0 =C2=A0 device scan [<device> [<device>..]]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Scan devices for =C2=A0=
a =C2=A0btrfs =C2=A0filesystem. =C2=A0If =C2=A0no =C2=A0devices =C2=A0a=
re
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0passed, btrfs scans a=
ll the block devices.
>
>
> =C2=A0 =C2=A0 =C2=A0 filesystem fssync <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Force a sync for the =
filesystem identified by <path>.
>

-filesystem fssync <path>
+filesystem sync <path>

You have done away with specifying what it is working on.  I think
that's best, it just needs good error messages to handle the
unimplemented cases at the moment.
I would also rename "fssync" to "sync".

>
>
> =C2=A0 =C2=A0 =C2=A0 filesystem resize [+/-]<size>[gkm]|max <filesyst=
em>

-filesystem resize [+/-]<size>[gkm]|max <filesystem>
+filesystem resize [+/-]<size>[gkm]|max <dev>

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Resize a file system =
identified by <path>. =C2=A0The <size> param=E2=80=90

-Resize a file system identified
+Resize a filesystem identified

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0eter specifies the ne=
w size of the filesystem. =C2=A0If the prefix
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+ =C2=A0or =C2=A0- is=
 present the size is increased or decreased by the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0quantity <size>. =C2=A0=
If no units are specified, the unit of =C2=A0the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<size> parameter is t=
he byte. =C2=A0Optionally, the size parameter

-<size> parameter is the byte.
+<size> parameter defaults to bytes.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0may be suffixed by on=
e of the following =C2=A0the =C2=A0units =C2=A0designa=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tors: =C2=A0'K', =C2=A0=
'M', or 'G', kilobytes, megabytes, or gigabytes,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0respectively.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If 'max' is passed, t=
he filesystem will occupy all =C2=A0available
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0space on the volume(s=
).

-space on the volume(s).
+space on the block device specified.

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The resize command do=
es not manipulate the size of underlying
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partitions. =C2=A0If =
you wish to enlarge/reduce a filesystem, =C2=A0you
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0must =C2=A0make =C2=A0=
sure you can expand/reduce the size of the parti=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tion also.
>

There are multiple ways to resize a btrfs filesystem.  You can add add
or remove devices or shrink or enlarge the devices the filesystem is
already on.  This operation only works on one block device at a time
so I think it should be under device instead of filesystem.

>
> =C2=A0 =C2=A0 =C2=A0 device show [<dev>|<label>...]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Show the btrfs device=
s =C2=A0with =C2=A0some =C2=A0additional =C2=A0info. =C2=A0If =C2=A0no
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0devices =C2=A0or =C2=A0=
labels =C2=A0are =C2=A0passed, =C2=A0btrfs =C2=A0scans all the block
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0devices.
>
>
> =C2=A0 =C2=A0 =C2=A0 device balance|-b <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Balance the chunk of =
=C2=A0the =C2=A0filesystem =C2=A0identified =C2=A0by =C2=A0<path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0across the devices.
>

I think this is a bit ambiguous.  While true, it is "balancing the
filesystem across devices" and "btrfs device balance" is quite
descriptive, it is working against a path and not a block device for
its argument.  I think that just tips the scales enough to put it
under filesystem instead of device.

>
> =C2=A0 =C2=A0 =C2=A0 device add <dev> [<dev>..] <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Add device(s) to the =
filesystem identified by <path>.
>
>
> =C2=A0 =C2=A0 =C2=A0 device delete <dev> [<dev>..] <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remove device(s) from=
 a filesystem identified by <path>.
>
> EXIT STATUS
> =C2=A0 =C2=A0 =C2=A0 btrfs =C2=A0returns =C2=A0a =C2=A0zero =C2=A0exi=
st =C2=A0status =C2=A0if =C2=A0it succeeds. Non zero is
> =C2=A0 =C2=A0 =C2=A0 returned in case of failure.
>
>
> AVAILABILITY
> =C2=A0 =C2=A0 =C2=A0 btrfs is part of btrfs-progs. Btrfs filesystem =C2=
=A0is =C2=A0currently =C2=A0under
> =C2=A0 =C2=A0 =C2=A0 heavy =C2=A0development, =C2=A0and not suitable =
for any uses other than bench=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 marking =C2=A0 and =C2=A0 review. =C2=A0 =C2=A0P=
lease =C2=A0 refer =C2=A0 to =C2=A0 the =C2=A0 btrfs =C2=A0 =C2=A0wiki
> =C2=A0 =C2=A0 =C2=A0 http://btrfs.wiki.kernel.org for further details=
=2E
>
> SEE ALSO
> =C2=A0 =C2=A0 =C2=A0 mkfs.btrfs(8)
>
>
>
> btrfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0BTRFS(8)
>
>
> --
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATi=
nwind.it>
> Key fingerprint =3D 4769 7E51 5293 D36C 814E =C2=A0C054 BF04 F161 3DC=
5 0512
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
