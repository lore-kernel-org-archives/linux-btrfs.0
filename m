From: Chris Samuel <chris@csamuel.org>
Subject: Re: immutable (WORM) file system
Date: Tue, 13 Mar 2012 11:17:16 +1100
Message-ID: <201203131117.16977.chris@csamuel.org>
References: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com> <20120312234039.GA13695@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1530102.d6UsoEaGh4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120312234039.GA13695@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1530102.d6UsoEaGh4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 13 March 2012 10:40:39 David Sterba wrote:

> (I just know that the flag is there and is related to the question,
> haven't tested it myself and do not know what was the original
> intention.)

Not sure it helps, but the commits for these were:

commit fdebe2bd70047e057827cba85ba31b2545e31900
Author: Yan <yanzheng@21cn.com>
Date:   Mon Jan 14 13:26:08 2008 -0500

    Btrfs: Add readonly inode flag
   =20
    This patch adds readonly inode flag support.  A file with this flag
    can't be modified, but can be deleted.
   =20
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

and..

commit cb6db4e57632ba8589cc2f9fe1d0aa9116b87ab8
Author: Jeff Mahoney <jeffm@suse.de>
Date:   Mon Aug 15 17:27:21 2011 +0000
Author: Jeff Mahoney <jeffm@suse.de>
Date:   Mon Aug 15 17:27:21 2011 +0000

    btrfs: btrfs_permission's RO check shouldn't apply to device nodes
   =20
    This patch tightens the read-only access checks in btrfs_permission to
     match the constraints in inode_permission. Currently, even though the
     device node itself will be unmodified, read-write access to device nod=
es
     is denied to when the device node resides on a read-only subvolume or a
     is a file that has been marked read-only by the btrfs conversion utili=
ty.
   =20
     With this patch applied, the check only affects regular files,
     directories, and symlinks. It also restructures the code a bit so that
     we don't duplicate the MAY_WRITE check for both tests.
   =20
    Signed-off-by: Jeff Mahoney <jeffm@suse.com>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1530102.d6UsoEaGh4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT16SDI1yjaOTJg85AQJ8lQf+Jl8maKEyvO9/BZeuPRNsWj6xV+LQ/Vie
7slzZMwskDg28ZOt2ZpERumJ7zum6YqEkGdp8iR5zNaUWuLu36/s2sk51tUcafsU
7GLgH0/0CEqnfi3MinbY9URS/+N7sDX1eOovPQh6eRk2hZ40Uhft3SKOY3sfdSKP
LRzykHDRUCRmEXchR5mVY+HjCfa3R97JB8NKVr/Ov2RCbL2Y5xMgUlWZTwlMOfny
SFreM2SFzrKRHnxdtADn50g2qv3ri4nfJ6Qalq8pWc+TooSc3pMie9cXoIeQwWso
lgMpqA+Hku2OMzds2BDCSd/DH36HTPvn1ZNFeNiPnWnvb/qcsxIoQQ==
=hlNy
-----END PGP SIGNATURE-----

--nextPart1530102.d6UsoEaGh4--
