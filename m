Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752308AbcLHUPm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 15:15:42 -0500
Subject: Re: out-of-band dedup status?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1481222198.6563.3.camel@scientia.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
Date: Thu, 8 Dec 2016 15:15:38 -0500
MIME-Version: 1.0
In-Reply-To: <1481222198.6563.3.camel@scientia.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s5pAoNKLoqf0B7RhkErskicFLJw9p63gr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s5pAoNKLoqf0B7RhkErskicFLJw9p63gr
Content-Type: multipart/mixed; boundary="vbCvL2WnCUPdXOw6r0tIF9qdXEqC0bS8C";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
 linux-btrfs@vger.kernel.org
Message-ID: <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
Subject: Re: out-of-band dedup status?
References: <1481222198.6563.3.camel@scientia.net>
In-Reply-To: <1481222198.6563.3.camel@scientia.net>

--vbCvL2WnCUPdXOw6r0tIF9qdXEqC0bS8C
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/8/16 1:36 PM, Christoph Anton Mitterer wrote:
> Hey.
>=20
> I just wondered whether out-of-band/"offline" dedup is safe for general=

> use... https://btrfs.wiki.kernel.org/index.php/Status kinda implies so
> (it tells about unspecified performance issues), but this seems again
> already outdated (kernel 4.7)...
> :-(

SUSE supports it in SLE12 using our 3.12 and 4.4 -based kernels.  There
haven't been a lot of changes to the kernel component of it.  It's
pretty simple: check to see if the ranges are identical between two
files and then reflink between them.

> My intention was to use it with duperemove, but AFAIU, the kernel
> itself will anyway do a byte-by-byte comparison before any
> deduplication, so in principle it should be totally safe regardless of
> the stability of the userland tool, right?
> Especially I wouldn't want that "identity" is only assumed because of
> some checksum identity (or collision ;) ).

Yep.  It does a full check in the kernel for precisely that reason.
It's not even enough to do it in userspace because we don't want dedupe
to be race prone.  It's either atomically identical or it's not, and we
don't dedupe if it's not.  If it changes immediately after the ioctl
returns, that's fine -- the cloned range will be CoW'd properly.

> Also, is there anything to take note of when this is used with
> compression and snapshots?

I don't believe so.  IIRC dedupe maps the file to see if it's already
cloned, so it's safe for snapshots (or could relink extents in a
snapshot that diverged and then were restored to their original
contents.  Dedupe works with the uncompressed data, so compression
shouldn't matter here.  I haven't tested it, though.

> What when I use it with incremental send/receive... i.e. I dedupe the
> "master" and then send/receive this to another btrfs... will it work
> (that is will the copy be also deduplicated, with no longer needed
> extents properly being freed)... or at least not cause any corruptions?=


It should.  IIRC send also maps the file (using a different mechanism)
and receive will clone those ranges on the other end.

> Any other things in terms of possible issues, data corruption, etc.
> that one should know when using deduplication?

There shouldn't be.  We haven't had any bug reports at SUSE.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--vbCvL2WnCUPdXOw6r0tIF9qdXEqC0bS8C--

--s5pAoNKLoqf0B7RhkErskicFLJw9p63gr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYSb9rAAoJEB57S2MheeWyQhoP/2BlHxobvMjm8Hjm8tnizuc+
NLN/SeZJrV3o5EQU4HHhHjko9vFkZTgKD/PlNiHYB4DQFVMZ9xw1pn2HcdKPMWzb
glqQKrMmleAI6+8MGe0Oqcx55aYwe8i6EuETAW4JyQlrwY1DSE7DLVrUpx/qIOFZ
aX9CdEnVj30J470TMkBliObVDdx7fx/is8bCTzB2VNiDMaNa3S0lk9ZJ1y/asAf2
orggg2vLCGxR4IDXAnlX1JFoGr8B4VpJrmZcYutxFV4NT2z9yCDkxydJVEolMrDT
eQQdABCJYSXxU9lnBEbAH5EnHX3ST2i0nxO/xPeGy9P0ag9SymZahFahKIRM80dW
0sTawfjhHFGczTozcOChl/IlAzpIwymkoGBgHnS6jrS4Jj4P6Yr7aBdpc7T6t94q
idxHZJiyp6xBn25ieDsEKAK0QqgcMltq3VY7aPYlcyHBA7tEN67jDExhwkSS8vJX
SkgUz32Gt/rx7b0sXqefqdNESbfx6P1+3bX5WkRkTIFtac/TVO2KBHkq7ClLakum
9PJ12FRqQz/rjXDcmmn5SZwRvTOnu7ZptyXXIrGm2ZnNVVl/hdzTBuxQdG3PMeXj
nYXLVavtoFZrZFWRl0HpUnrJwZb8bdEyQRSK+7/LAAZ8z0mb0FqlIqH4qrLDQbwd
uQurzSlzbGJH0EewN1dm
=LoV2
-----END PGP SIGNATURE-----

--s5pAoNKLoqf0B7RhkErskicFLJw9p63gr--
