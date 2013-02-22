Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42945 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab3BVRQI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 12:16:08 -0500
Date: Fri, 22 Feb 2013 17:16:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Mike Power <dodtsair@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: copy on write misconception
Message-ID: <20130222171604.GI14283@carfax.org.uk>
References: <5127A6C0.6080104@alumni.calpoly.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9s922KAXlWjPfK/Q"
In-Reply-To: <5127A6C0.6080104@alumni.calpoly.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9s922KAXlWjPfK/Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 22, 2013 at 09:11:28AM -0800, Mike Power wrote:
> I think I have a misconception of what copy on write in btrfs means
> for individual files.
> 
> I had originally thought that I could create a large file:
> time dd if=/dev/zero of=10G bs=1G count=10
> 10+0 records in
> 10+0 records out
> 10737418240 bytes (11 GB) copied, 100.071 s, 107 MB/s
> 
> real    1m41.082s
> user    0m0.000s
> sys    0m7.792s
> 
> Then if I copied this file no blocks would be copied until they are
> written.  Hence the two files would use the same blocks underneath.
> But specifically that copy would be fast.  Since it would only need
> to write some metadata.  But when I copy the file:
> time cp 10G 10G2
> 
> real    3m38.790s
> user    0m0.124s
> sys    0m10.709s
> 
> Oddly enough it actually takes longer then the initial file
> creation.  So I am guessing that the long duration copy of the file
> is expected and that is not one of the virtues of btrfs copy on
> write.  Does that sound right?

   You probably want cp --reflink=always, which makes a CoW copy of
the file's metadata only. The resulting files have the semantics of
two different files, but share their blocks until a part of one of
them is modified (at which point, the modified blocks are no longer
shared).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I don't like the look of it,  I tell you." "Well, stop ---     
                          looking at it, then."                          

--9s922KAXlWjPfK/Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSen1L9z9OVl50rAAQI72w/9Gk/bOXGyJtv69IufzyRFbaRxT2Kcm51/
yEQQAxppAClNcarZDnjytoPjP2zXg9uHYMC/QON2Ri4moOGLBAn7L5RYsBvzfa+B
5N6S+cSDcs3e04UosqyDGakH8Z5CBX0+nfXimmnCOP+0UqiT9iaoQbDSXSFYGgJ8
/cSnHCNn197YV9MJD6VZpZgnvhKC+EoZvP4jT87Bvgl13rBgewNkhT7x4AnJJ1F9
hXesj1akhGNT2hoQTDgZ+dHvKC8INMHalXr9uWwlXCcfqAJCKC+iGx2MN3HYYVuv
2cvQWZpYRi5SAWKWAR8glx52CLn9CxSBbURPMXU/gmhk9XOFLmUb/O4UceRmJvsE
wp8/Us4k7tS7IcrroHyIavkkyffocPht3YkdyviaVGkxgrY/7vu6k4t8mxMEnfKA
mx4WBg7t/eC2MFnTiO1murhD7BaUE4N8MW+H0LoOEPO9410D/C+I5RjG5ftypicR
yPlj6RvATJZ4tgWK1T5yn/KScB8lx7qb3iuHTK1Q1Rykx5yIn7zdej9B/NlL6yDC
RHrSGSlpH/25pzoVLlKgYg6WxW4YcKUBsIgjG4ka65+0fl+xG/7u4UeLHsMSDTyM
jBoTDsQbTYfGwVFs3roe5EdIc3NuYOEgbI8o5F3WZwK7rgCVhxP+Q4heXoYWdY3D
3NN5NaFChRQ=
=g2ii
-----END PGP SIGNATURE-----

--9s922KAXlWjPfK/Q--
