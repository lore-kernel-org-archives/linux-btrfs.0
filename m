Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39420 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S933054AbcIUNCL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 09:02:11 -0400
Date: Wed, 21 Sep 2016 09:02:09 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Paul Jones <paul@pauljones.id.au>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs rare silent data corruption with kernel data leak
Message-ID: <20160921130209.GO21290@hungrycats.org>
References: <20160921045556.GN21290@hungrycats.org>
 <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tqN4RWvJTb9VNux/"
In-Reply-To: <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tqN4RWvJTb9VNux/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2016 at 11:14:35AM +0000, Paul Jones wrote:
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> > owner@vger.kernel.org] On Behalf Of Zygo Blaxell
> > Sent: Wednesday, 21 September 2016 2:56 PM
> > To: linux-btrfs@vger.kernel.org
> > Subject: btrfs rare silent data corruption with kernel data leak
> >=20
> > Summary:
> >=20
> > There seem to be two btrfs bugs here: one loses data on writes, and the
> > other leaks data from the kernel to replace it on reads.  It all happen=
s after
> > checksums are verified, so the corruption is entirely silent--no EIO er=
rors,
> > kernel messages, or device event statistics.
> >=20
> > Compressed extents are corrupted with kernel data leak.  Uncompressed
> > extents may not be corrupted, or may be corrupted by deterministically
> > replacing data bytes with zero, or may not be corrupted.  No preconditi=
ons
> > for corruption are known.  Less than one file per hundred thousand seem=
s to
> > be affected.  Only specific parts of any file can be affected.
> > Kernels v4.0..v4.5.7 tested, all have the issue.
>=20
> Funny you should bring this up - I think I just suffered from this, or so=
mething similar.
[...snip...]
> [ 1311.456545] BTRFS warning (device sda1): csum failed ino 44628192 off =
3222405120 csum 2566472073 expected csum 3548745998
> [ 1311.456551] BTRFS warning (device sda1): csum failed ino 44628192 off =
3222470656 csum 2566472073 expected csum 2988893031
>=20
> I'm seeing a lot of checksum 2566472073 - Is that the checksum of blank s=
pace I wonder?

The issue I found occurs after successful checksum validation, and
can affect only the first 4096 bytes of a file.  It produces no kernel
messages and no checksum failures.  If you run 'filefrag -v' on the file,
the corrupted extent *must* have the 'inline' flag; otherwise, it's a
different problem.

You have csum failures, and the affected offsets are way beyond 4096.

Holes are not checksummed in general because they are gaps in the
file offset address space.  Metadata records that describe holes are
checksummed, but when those checksums fail the kernel messages look
different.

I don't recognize the symptoms you are having.  After eliminating
hardware problems and making sure your kernel is up to date, I'd try
changing mount options...

> Here are the details of the filesystem concerned:
[...]
> /dev/sda1 on / type btrfs (rw,noatime,ssd,discard,noacl,space_cache=3Dv2,=
subvolid=3D5,subvol=3D/)
> (compress was enabled previously)

=2E..discard and space_cache=3Dv2 in particular.  Free space tree is a new
feature, and discard has had a few bug fixes over the years.  Both are
non-default options.

Speaking of mount options, 'max_inline=3D0' may prevent the issue I found.


--tqN4RWvJTb9VNux/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfihNEACgkQgfmLGlazG5wr8gCgmhIvid5oWMtxmOmZ4Jbe3DYG
lRsAn1UU55TP6XZM/1vFf7gRJRqyE8io
=RdxB
-----END PGP SIGNATURE-----

--tqN4RWvJTb9VNux/--
