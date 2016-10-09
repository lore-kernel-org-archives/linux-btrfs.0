Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39260 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750900AbcJIELp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 00:11:45 -0400
Date: Sun, 9 Oct 2016 00:11:22 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>
Subject: Re: btrfs rare silent data corruption with kernel data leak (updated
 with some bisection results)
Message-ID: <20161009041122.GV21290@hungrycats.org>
References: <20160921045556.GN21290@hungrycats.org>
 <20161008061008.GT21290@hungrycats.org>
 <20161008070200.GU21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CSNFvL6ilyiKL/Hs"
In-Reply-To: <20161008070200.GU21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CSNFvL6ilyiKL/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 08, 2016 at 03:02:00AM -0400, Zygo Blaxell wrote:
> On Sat, Oct 08, 2016 at 02:10:08AM -0400, Zygo Blaxell wrote:
> [...]
> > The "write half" of the bug seems to appear first somewhere between v3.8
> > and v3.9.  I have not been able to reproduce it with v3.8.13, v3.7.10, =
or
> > v3.6.11.  I can reproduce it in v3.9.11, v3.12.64, and v3.18.13..v4.7.5.
>=20
> After six more iterations of the 'repro' script, I can reproduce "write
> half" on 3.8.13.
>=20
> Bisection is hard.  Bisecting ancient bugs even more so.

I increased the number of iterations of the 'repro' script to 100,
although in practice no more than 20 are required.  With this test
case, I can find the bug in kernels as early as v3.5.7.  v3.0..v3.4 crash
before they complete one run of the 'repro' script.  Earlier kernels
don't work with the userspace on my testing machine, and going back more
than four years is not worth the effort IMHO.

At the other end of the timeline, I also reproduced this bug on 4.8.1.


--CSNFvL6ilyiKL/Hs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf5w2oACgkQgfmLGlazG5xzeQCfRreGUInUlM1IcFJZJ5ShxiLY
EhEAn30i1mFsvB7YRTcwTxMnEf+V6Av6
=aqaB
-----END PGP SIGNATURE-----

--CSNFvL6ilyiKL/Hs--
