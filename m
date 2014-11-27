Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40698 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751403AbaK0PRV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 10:17:21 -0500
Date: Thu, 27 Nov 2014 10:17:20 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balance and RAID-1
Message-ID: <20141127151720.GW17395@hungrycats.org>
References: <201411280137.51086.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CSNFvL6ilyiKL/Hs"
In-Reply-To: <201411280137.51086.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CSNFvL6ilyiKL/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 01:37:50AM +1100, Russell Coker wrote:
> I had a RAID-1 filesystem with 2*3TB disks and 330G of disk space free=20
> according to df -h.  I replaced a 3TB disk with a 4TB disk and df reporte=
d no=20
> change in the free space (as expected).

Did you btrfs resize that 4TB disk?  If not, btrfs still thinks the 4TB
disk is a 3TB disk, and the rest follows from that.

> I added a 1TB disk to the filesystem and there was still no change!  I=20
> expected that adding a 1TB disk would give 3TB+1TB on one side and 4TB on=
 the=20
> other so I would instantly get an extra 1TB of free space according to df=
 -h.
>=20
> 1072 out of about 2734 chunks balanced (1073 considered),  61% left
>=20
> I ran btrfs balance for just over a day and a btrfs balance status report=
ed=20
> the above.  But it still only showed 860G free according to df -h.  I've=
=20
> cancelled the balance because 860G of free space is enough for the moment=
 and=20
> I don't want that server running slowly and making noise any more.
>=20
> I think that the allocation of disk space needs to be improved.  If I add=
ed a=20
> 1TB disk to a pair of 3TB disks then it would be quite reasonably for som=
e=20
> serious reallocation to be required to make use of the extra space.  But =
when=20
> I added a 1TB disk to an array that had a 3TB and a 4TB then it should be=
 able=20
> to make use of the space quite easily.
>=20
> --=20
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--CSNFvL6ilyiKL/Hs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR3QIAACgkQgfmLGlazG5yTPACg3KKXKAeyuHj8dmi+LXKkXdVY
5OYAmQHAV6W53LKx02tpPvIQrRnRpROm
=ns6L
-----END PGP SIGNATURE-----

--CSNFvL6ilyiKL/Hs--
