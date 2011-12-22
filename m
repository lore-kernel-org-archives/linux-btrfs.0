From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 22 Dec 2011 23:24:13 +1100
Message-ID: <201112222324.16871.chris@csamuel.org>
References: <cover.1301542804.git.larry@elder-gods.org> <20110401133405.GA17956@infradead.org> <1301665083-sup-3969@think>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1730742.9R2iUhXshG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301665083-sup-3969@think>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1730742.9R2iUhXshG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Christoph,

On Sat, 2 Apr 2011 12:40:11 AM Chris Mason wrote:

> Excerpts from Christoph Hellwig's message of 2011-04-01 09:34:05=20
=2D0400:
>
> > I don't think it's a good idea to introduce any user visible
> > operations over subvolume boundaries.  Currently we don't have
> > any operations over mount boundaries, which is pretty
> > fumdamental to the unix filesystem semantics.  If you want to
> > change this please come up with a clear description of the
> > semantics and post it to linux-fsdevel for discussion.  That of
> > course requires a clear description of the btrfs subvolumes,
> > which is still completely missing.
>=20
> The subvolume is just a directory tree that can be snapshotted, and
> has it's own private inode number space.
>=20
> reflink across subvolumes is no different from copying a file from
> one subvolume to another at the VFS level.  The src and
> destination are different files and different inodes, they just
> happen to share data extents.

Were Chris Mason's points above enough to sway your opposition to this=20
functionality/patch?

There is demand for the ability to move data between subvolumes=20
without needing to copy the extents themselves, it's cropped up again=20
on the list in recent days.

It seems a little hard (and counterintuitive) to enforce a wasteful=20
use of resources to copy data between different parts of the same=20
filesystem which happen to be a on a different subvolume when it's=20
permitted & functional to the same filesystem on the same subvolume.

I don't dispute the comment about documentation on subvolumes though,=20
there is a short discussion of them on the btrfs wiki in the sysadmins=20
guide, but not really a lot of detail. :-)

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1730742.9R2iUhXshG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATvMhbo1yjaOTJg85AQJSKAf/ZmfVxDTvKSrDLa9r2p5gxH9yvHLES3Xz
/4xcwV1UGxrQyUZZHa7q9egSx9XdeYZ+20itNSx7DYKYRrbKk1jRKmGPQ9vEJhdK
Yv/kgEn86ChOye4Rw6d3Y4e3X9PaSGbScXxDb8FvEzVGim8QmLS0iEhNUdlYl+8B
bvgGQijpKm3M0Se7/dYafhCYPyHCE92viBM48UrnFHyP3g5himHu0Un1yY7HQxFa
YMfrmssQPzVzflkYTKPysN8giVUlEyNFJx5X/GYrQgSz7P7zyOJFAEsP0U3ALxJk
tuTIyNDNEGrnWd6RTk5JuTWUJLTUyNoFCRuL1Hmk+Ue8grT7U7aWOg==
=cXxR
-----END PGP SIGNATURE-----

--nextPart1730742.9R2iUhXshG--
