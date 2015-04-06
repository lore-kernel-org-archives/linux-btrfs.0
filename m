Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33333 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbDFKNq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 06:13:46 -0400
Date: Mon, 6 Apr 2015 10:13:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Pavel Volkov <sailor@lists.xtsubasa.org>
Cc: Russell Coker <russell@coker.com.au>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Btrfs hangs 3.19-10
Message-ID: <20150406101338.GF13864@carfax.org.uk>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
 <20150404130047.GC13864@carfax.org.uk>
 <pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
 <201504050330.47299.russell@coker.com.au>
 <20150405100417.GE13864@carfax.org.uk>
 <2f6a9ac9-0684-4b9a-982e-031286be398e@lists.xtsubasa.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
In-Reply-To: <2f6a9ac9-0684-4b9a-982e-031286be398e@lists.xtsubasa.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2015 at 10:40:03AM +0300, Pavel Volkov wrote:
> On Sunday, April 5, 2015 1:04:17 PM MSK, Hugo Mills wrote:
> >   That's these, I think:
> >
> >#define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
> >#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF    (1ULL << 6)
> >
> >so it's definitely -O^extref. I don't see where big_metadata comes
> >from, though. That's not a -O option. Try with -O^extref and see where
> >that gets you. (Also, don't mount the FS on a newer kernel -- it may
> >be setting big metadata automatically, although it probably shouldn't
> >do).
> 
> By the way, is there any way to see which options are enabled on a
> local filesystem without having to try mounting it with old kernel
> and checking dmesg?

   btrfs-show-super is the tool for that.

   Hugo.

-- 
Hugo Mills             | Great oxymorons of the world, no. 4:
hugo@... carfax.org.uk | Future Perfect
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVIlxRAAoJEFheFHXiqx3ksUwP/iK8/vOlzmLb2z3Vb2/SpyVe
BmYw82r6CY4iPqcQPFE2uDUnCaOWZ4PE00MsOKcx6Spfa8sSIDdHw0ZBEidiYRBT
NiLqj62n58Z96UNYynDnfA9eI+CuAP9aOGc9nXWv7gi6gDjT0P7LBTQd1r7TJjEa
pbeWJAiMrO1q4hl3Q99SjnetXWIhXefEYQHpBeo17ISBVdTIMBxM/oBjS5FX+n3f
caXePG18MDaUVFD4rLCjFT76cPBp/pwpyjfMJKCHS5HaYn2IKTS7I5/hXTDcr0qB
0dftoK/2DECw0EGNZVLv7+dd24COqGqJIiRNddTT5pZkxkBA9HWW7c0b8mzSXh9u
TqxGiYVVrKxxTogyV/5fJz0zCsmDYYq1Y4Y7zuEC/Vf9fOeRLtziJ0c13YFQqYUB
86hJLvbT6wMU9JS3acZWHTVYdISkkaDXrxryeOwCFBGAS7j0n1PKygKvI783kCpi
YdtSy2Srs/SY9IX0vssTlOixaVPH7cYNsCKn4dfLyK+431mCqYbq4VV0ScFIEInD
isRF82JLnIFMARJqYoF/1NA3fU0BDkrl4nUlEXop0UiEZudRAGRavsCfnWkMYvfR
sQpR/wVnZS69I4mb8/g8H9yVOTsByt1z/hc8Iy3mhBGKFGX45o/f4fVWURTv3GDy
2y5ecXznPpekKzLq2wxg
=n9Nv
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
