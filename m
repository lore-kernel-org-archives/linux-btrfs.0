From: Goffredo Baroncelli <kreijack@alice.it>
Subject: Man page for mkfs.btrfs
Date: Mon, 25 Aug 2008 19:12:47 +0200
Message-ID: <200808251913.03613.kreijack@alice.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2652891.b3XMMfJN8f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2652891.b3XMMfJN8f
Content-Type: multipart/mixed;
  boundary="Boundary-01=_QgusIp6YfvE1Jgq"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_QgusIp6YfvE1Jgq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi all,

enclose you can find a proposal for a man page of the mkfs.btrfs. If you th=
ink=20
that it is usefoul I will improve it on the basis of your suggestions.
As side note, I suggest also to update the help message of the mkfs.btrf he=
lp:
"-n --nodesize size of btree leaves" should be "-n --nodesize size of btree=
=20
nodes".

BR
Goffredo


$ ./mkfs.btrfs
usage: mkfs.btrfs [options] dev [ dev ... ]
options:
         -b --byte-count total number of bytes in the FS
         -l --leafsize size of btree leaves
         -n --nodesize size of btree leaves
         -s --sectorsize min block allocation
Btrfs v0.16+da35ab2b0b54


BR
Goffredo


$ man -Tutf8 ./mkfs.btrfs.8
MKFS.BTRFS(8)                                                    MKFS.BTRFS=
(8)



NAME
       mkfs.btrfs - create a btrfs file system

SYNOPSIS
       mkfs.btrfs  [ -A|--alloc-start=3Dstart-alloc ] [ -d|--data=3Ddata-pr=
ofile ]
       [  -l|--leafsize=3Dbtree-leaves-size  ]  [  -L|--label=3Dvolume-labe=
l  ]  [
       -m|--metadatametadata-profile ] [ -n|--nodesize=3Dnode-size ] [ -s|-=
=2Dsec=E2=80=90
       torsize=3Dsector-size ]  [  -b|--byte-count=3Dfilesystem-size  ]  de=
vice  [
       device...  ]

DESCRIPTION
       mkfs.btrfs is used to create a btrfs file system on a device (usuall=
y a
       disk partition).  device is  the  special  file  corresponding  to  =
the
       device (e.g /dev/hdXX).

OPTIONS
       -A, --alloc-start=3Dstart-alloc
              TBD.

       -d, --data=3Ddata-profile
              mkfs.btrfs will accept more than one device on the command li=
ne.
              This option controls the raid  configuration  for  data.   Va=
lid
              choices  are raid0, raid1, raid10 and single.  Single means t=
hat
              no duplication of metadata is done, which may  be  desired  w=
hen
              using hardware raid.  Raid10 requires at least 4 devices.


       -l, --leafsize=3Dbtree-leaves-size
              Size  of btree leaves.  A size suffix of K or k for kilobytes=
, M
              or m for megabytes, G or g for gigabytes  is  optional.  Defa=
ult
              unit is byte.

       -L, --label=3Dvolume-name
              Sets  the  volume  name  (label) of the file system.  The vol=
ume
              name can be up to 256 characters long. The  characters  =E2=
=80=99\=E2=80=99  and
              =E2=80=99/=E2=80=99 aren=E2=80=99t valid.  The default is no =
label.

       -m, --metadata=3Dmetadata-profile
              mkfs.btrfs will accept more than one device on the command li=
ne.
              This option controls the raid configuration for metadata.  Va=
lid
              choices  are raid0, raid1, raid10 and single.  Single means t=
hat
              no duplication of metadata is done, which may  be  desired  w=
hen
              using hardware raid.  Raid10 requires at least 4 devices.

       -n, --nodesize=3Dbtree-nodes-size
              Size  of  btree nodes.  A size suffix of K or k for kilobytes=
, M
              or m for megabytes, G or g for gigabytes  is  optional.  Defa=
ult
              unit is byte.

       -s, --sectorsize=3Dsector-size
              Size of the sector.  A size suffix of K or k for kilobytes, M=
 or
              m for megabytes, G or g for gigabytes is optional. Default  u=
nit
              is byte.

       -b, --byte-contfilesystem-size
              Size  of the filesystem.  A size suffix of K or k for kilobyt=
es,
              M or m for megabytes, G or g for gigabytes is optional.  Defa=
ult
              unit is byte.

BUGS
       May be.

AUTHOR
       Chris Mason <chris.mason <at> oracle.com>

SEE ALSO
       btrfsctl(8), btrfsck(8), btrf-show(8), btrf-vol(8), mkfs(8)



Version 0.1                       20 Aug 2008                    MKFS.BTRFS=
(8)




=2D-=20
gpg key Goffredo Baroncelli (ghigo) <kreijack_AT_inwind_DOT_it>
Key fingerprint =3D CE3C 7E01 6782 30A3 5B87  87C0 BB86 505C 6B2A CFF9

--Boundary-01=_QgusIp6YfvE1Jgq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*=

diff -r da35ab2b0b54 mkfs.btrfs.8
--- /dev/null   Thu Jan 01 00:00:00 1970 +0000
+++ b/mkfs.btrfs.8      Mon Aug 25 18:59:21 2008 +0200
@@ -0,0 +1,111 @@
+.\" -*- nroff -*-
+.TH MKFS.BTRFS 8 "20 Aug 2008" "Version 0.1"
+.SH NAME
+.B mkfs.btrfs
+\- create a btrfs file system
+.SH SYNOPSIS
+.B mkfs.btrfs
+[
+.BI \-A|--alloc-start= "start-alloc"
+]
+[
+.BI \-d|--data= "data-profile"
+]
+[
+.BI \-l|--leafsize= "btree-leaves-size"
+]
+[
+.BI \-L|--label= "volume-label"
+]
+[
+.BI \-m|--metadata "metadata-profile"
+]
+[
+.BI \-n|--nodesize= "node-size"
+]
+[
+.BI \-s|--sectorsize= "sector-size"
+]
+[
+.BI \-b|--byte-count= "filesystem-size"
+]
+.I device
+[
+.I device...
+]
+.SH DESCRIPTION
+.B mkfs.btrfs
+is used to create a btrfs file system on a device (usually
+a disk partition).
+.I device
+is the special file corresponding to the device (e.g /dev/hdXX).
+.SH OPTIONS
+.TP
+.BI \-A,\ --alloc-start= "start-alloc "
+TBD.
+.TP
+.BI \-d,\ --data= "data-profile"
+.B mkfs.btrfs
+will accept more than one device on the command line.
+This option controls the raid configuration for data.
+Valid choices are
+.B raid0,
+.B raid1,
+.B raid10
+and
+.B single.
+Single means that no duplication of metadata is done, which may be
+desired when using hardware raid.
+.B Raid10
+requires at least 4 devices.
+
+.TP
+.BI \-l,\ --leafsize= "btree-leaves-size"
+Size of btree leaves.
+A size suffix of K or k for kilobytes, M or m for megabytes, G or g for
+gigabytes is optional. Default unit is byte.
+.TP
+.BI \-L,\ --label= "volume-name"
+Sets the volume name (label) of the file system.  The volume name can
+be up to 256 characters long. The characters '\\' and '/' aren't valid.
+The default is no label.
+.TP
+.BI \-m,\ --metadata= "metadata-profile"
+.B mkfs.btrfs
+will accept more than one device on the command line.
+This option controls the raid configuration for metadata.
+Valid choices are
+.B raid0,
+.B raid1,
+.B raid10
+and
+.B single.
+Single means that no duplication of metadata is done, which may be
+desired when using hardware raid.
+.B Raid10
+requires at least 4 devices.
+.TP
+.BI \-n,\ --nodesize= "btree-nodes-size"
+Size of btree nodes.
+A size suffix of K or k for kilobytes, M or m for megabytes, G or g for
+gigabytes is optional. Default unit is byte.
+.TP
+.BI \-s,\ --sectorsize= "sector-size"
+Size of the sector.
+A size suffix of K or k for kilobytes, M or m for megabytes, G or g for
+gigabytes is optional. Default unit is byte.
+.TP
+.BI \-b,\ --byte-cont "filesystem-size"
+Size of the filesystem.
+A size suffix of K or k for kilobytes, M or m for megabytes, G or g for
+gigabytes is optional. Default unit is byte.
+.SH BUGS
+May be.
+.SH AUTHOR
+Chris Mason <chris.mason <at> oracle.com>
+.SH SEE ALSO
+.BR btrfsctl (8),
+.BR btrfsck (8),
+.BR btrf-show (8),
+.BR btrf-vol (8),
+.BR mkfs (8)

--Boundary-01=_QgusIp6YfvE1Jgq--

--nextPart2652891.b3XMMfJN8f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIsugfu4ZQXGsqz/kRAsAPAJ4m7QxCpYS4YAYuMtEsVJnu9Z3gRwCgqlro
rOjel8mGxpua6O3qkEiUUaE=
=jNUp
-----END PGP SIGNATURE-----

--nextPart2652891.b3XMMfJN8f--
