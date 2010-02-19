From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [RFC] btrfs: a new tool to manage a btrfs filesystem
Date: Fri, 19 Feb 2010 21:12:10 +0100
Message-ID: <201002192112.17752.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart22224074.T7vGTAjSpL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart22224074.T7vGTAjSpL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

on the basis of the suggestion received, I update my btrfs tool.

The main changes are:
=2D removed the short form of the command (like '-C')
=2D deployed the "multi level" command (i.e.: btrfs snapshot create)
=2D split the source in three files. This because the new parses are quite =
big=20
(about  295 lines; for example btrfsctl.c are only 239 lines).

The "multi level" command parser is quite flexible. They accept the full-
length command (btrfs subvolume create) and a contract form (btrfs subvol c=
r).=20
The commands may be arbitrary shortly (even 1 chars) but they have to be un-
ambiguous. For example
=2D btrfs s s 		-> OK (matches 'btrfs subvolume snapshot' only)
=2D btrfs dev s		-> FAIL (matches both 'btrfs dev show' and=20
				'btrfs dev scan')

The parser highlights which part of the command are ambiguous.

This is a RFC because there is no agreement about the name of the command.
I am proposing the following structure:
 =20
   btrfs <object> <action>

where <object> are:=20
=2D subvolume (valid action: create, delete, snapshot, list [not implemente=
d])
=2D filesystem (valid action: defrag, sync, resize [not implemented])
=2D device (valid action: add, delete, scan, show, balance)

You can find the source at=20

	http://cassiopea.homelinux.net/git/btrfs-command.git

(commit 3deec45d18879d60b4032dc1f8895d7b7e1211ec, remember to switch to the=
=20
"remotes/origin/multi-level-command" branch (I hate git!!!)


BR
G.Baroncelli
=2D---

$ git diff remotes/origin/orig | diffstat
 Makefile             |    6
 btrfs.c              |   73 ++++++
 btrfs_cmds.c         |  587 +++++++++++++++++++++++++++++++++++++++++++[..=
=2E]
 btrfs_cmds.h         |   30 ++
 btrfs_cmds_parse.c   |  296 +++++++++++++++++++++++++
 man/Makefile         |    5
 man/btrfs.8.in       |  148 ++++++++++++
 13 files changed, 1291 insertions(+), 2 deletions(-)

=2D---
$ ./btrfs
Usage:
        btrfs subvolume snapshot [<dest>/]<name>
                Create a writeble snapshot of the subvolume <source> with
                the name <name> in the <dest> directory.
        btrfs subvolume delete <subvolume>
                Delete the subvolume <subvolume>.
        btrfs subvolume create [<dest>/]<name>
                Create a subvolume in <dest> (or the current directory if
                not passed).
        btrfs filesystem defrag <file>|<dir> [<file>|<dir>...]
                Defragment a file or a directory.
        btrfs device scan [<device> [<device>..]
                Scan all device for or the passed device for a btrfs
                filesystem.
        btrfs filesystem sync <path>
                Force a fs sync on the filesystem <path>
        btrfs filesystem resize [+/-]<newsize>[gkm]|max <filesystem>
                Resize the file system. If 'max' is passed, the filesystem
                will occupe all available space on the device.
        btrfs device show [<dev>|<label>...]
                Show the btrfs devices
        btrfs device balance <path>
                Balance the chunk across the device
        btrfs device add <dev> [<dev>..] <path>
                Add a device to a filesystem
        btrfs device delete <dev> [<dev>..] <path>
                Remove a device from a filesystem

        btrfs help|--help|-h
                Show the help.

Btrfs v0.19-22-g07a97f0-dirty

=2D---

$ man man/btrfs.8.in | cat                 =20
BTRFS(8)                           btrfs                           BTRFS(8)=
  =20



NAME
       btrfs - control a btrfs filesystem

SYNOPSIS
       btrfs subvolume snapshot <source> [<dest>/]<name>

       btrfs subvolume delete <subvolume>

       btrfs subvolume create [<dest>/]<name>

       btrfs filesystem defrag <file>|<dir> [<file>|<dir>...]

       btrfs filesystem fssync <path>

       btrfs filesystem resize [+/-]<size>[gkm]|max <filesystem>

       btrfs device scan [<device> [<device>..]]

       btrfs device show <dev>|<label> [<dev>|<label>...]

       btrfs device balance <path>

       btrfs device add <dev> [<dev>..] <path>

       btrfs device delete <dev> [<dev>..] <path> ]


       btrfs help|--help|-h

DESCRIPTION
       btrfs  is  used to control the filesystem and the files and directo=
=E2=80=90
       ries stored. It is the tool to create or destroy a new snapshot or a
       new  subvolume  for the filesystem, to defrag a file or a directory,
       to flush the dato to the disk, to resize the filesystem, to scan the
       device.                                                            =
=20

       It  is  possible to abbreviate the commands unless the commands  are
       ambiguous.  For example: it is  possible  to  run  btrfs  sub  snaps
       instead  of  btrfs  subvolume  snapshot.   But  btrfs  dev  s is not
       allowed, because dev s may be interpreted both as device show and as
       device scan.  In this case btrfs returns an error.                 =
=20

       If  a command is terminated by --help , the relevant help is showed.
       If the passed command matches more commands, the  help  of  all  the
       matched  commands are showed. For example btrfs dev --help shows the
       help of all device* command.                                       =
=20


COMMANDS
       subvolume snapshot <source> [<dest>/]<name>
              Create a writeble snapshot of the subvolume <source> with the
              name  <name>  in  the  <dest> directory. If <source> is not a
              subvolume, btrfs returns an error.                          =
=20


       subvolume delete <subvolume>
              Delete the subvolume <subvolume>. If  <subvolume>  is  not  a
              subvolume, btrfs returns an error.                          =
=20


       subvolume create [<dest>/]<name>
              Create  a subvolume in <dest> (or in the current directory if
              <dest> is not passed).                                      =
=20


       filesystem defrag <file>|<dir> [<file>|<dir>...]
              Defragment files and/or directories.    =20


       device scan [<device> [<device>..]]
              Scan devices for  a  btrfs  filesystem.  If  no  devices  are
              passed, btrfs scans all the block devices.                  =
=20


       filesystem fssync <path>
              Force a sync for the filesystem identified by <path>.



       filesystem resize [+/-]<size>[gkm]|max <filesystem>
              Resize a file system identified by <path>.  The <size> param=
=E2=80=90
              eter specifies the new size of the filesystem.  If the prefix
              +  or  - is present the size is increased or decreased by the
              quantity <size>.  If no units are specified, the unit of  the
              <size> parameter is the byte.  Optionally, the size parameter
              may be suffixed by one of the following  the  units  designa=
=E2=80=90
              tors:  'K',  'M', or 'G', kilobytes, megabytes, or gigabytes,
              respectively.                                               =
=20

              If 'max' is passed, the filesystem will occupy all  available
              space on the volume(s).                                     =
=20

              The resize command does not manipulate the size of underlying
              partitions.  If you wish to enlarge/reduce a filesystem,  you
              must  make  sure you can expand/reduce the size of the parti=
=E2=80=90
              tion also.                                                  =
=20


       device show [<dev>|<label>...]
              Show the btrfs devices  with  some  additional  info.  If  no
              devices  or  labels  are  passed,  btrfs  scans all the block
              devices.


       device balance|-b <path>
              Balance the chunk of  the  filesystem  identified  by  <path>
              across the devices.


       device add <dev> [<dev>..] <path>
              Add device(s) to the filesystem identified by <path>.


       device delete <dev> [<dev>..] <path>
              Remove device(s) from a filesystem identified by <path>.

EXIT STATUS
       btrfs  returns  a  zero  exist  status  if  it succeeds. Non zero is
       returned in case of failure.


AVAILABILITY
       btrfs is part of btrfs-progs. Btrfs filesystem  is  currently  under
       heavy  development,  and not suitable for any uses other than bench=
=E2=80=90
       marking   and   review.    Please   refer   to   the   btrfs    wiki
       http://btrfs.wiki.kernel.org for further details.

SEE ALSO
       mkfs.btrfs(8)



btrfs                                                              BTRFS(8)


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart22224074.T7vGTAjSpL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLfvCavwTxYT3FBRIRAgMEAJ9+0dh+nLO/UEr17F6QaPLJdFTnfQCfRAmj
ZTdYCHG2hL4rzu9Ctq1F4O0=
=r5FO
-----END PGP SIGNATURE-----

--nextPart22224074.T7vGTAjSpL--
