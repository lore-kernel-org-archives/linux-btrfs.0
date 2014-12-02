Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36266 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932303AbaLBRAN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 12:00:13 -0500
Date: Tue, 2 Dec 2014 12:00:11 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Thin metadata and nohole options recommended?
Message-ID: <20141202170011.GB17395@hungrycats.org>
References: <CAH-HCWUaUnbarSdBd4+QGFuscNtVG6wNxQEfRqrJwN2YVC0+fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="72pTQ1Q5L511SwPT"
In-Reply-To: <CAH-HCWUaUnbarSdBd4+QGFuscNtVG6wNxQEfRqrJwN2YVC0+fA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--72pTQ1Q5L511SwPT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 08:38:15PM +0530, Shriramana Sharma wrote:
> From what I'm reading, thin metadata and nohole options were
> introduced to make the FS more efficient. Does this mean that for
> someone about to do mkfs.btrfs, it is actively recommended to use
> these options?

If you're using older kernels, I'd avoid those options.  I'd still avoid
those options with current kernels unless you're intentionally looking
for bugs.

> Another pertinent question -- why aren't they default then?

It has been one month since the last skinny-metadata fix (fixing a bug
that was as old as the skinny-metadata feature itself) in 3.18-rc3.

It has been two months since the last no-holes fix in 3.17.2.

IMHO if an optional filesystem feature has had a significant bug fixed
in the last six months, it probably shouldn't be enabled by default.  ;)

Skinny-metadata can be enabled after mkfs, though my benchmark results
so far are mixed about whether the theoretical performance benefit
practically materializes.  No-holes is mostly useless unless you are a
fan of huge sparse files.

--72pTQ1Q5L511SwPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR98BsACgkQgfmLGlazG5y5UQCghHtv2NCDiIuRRCCd2iffMLyq
O5YAoKu+l8miyHQI97f6O1xlH1xPrn6f
=I9TZ
-----END PGP SIGNATURE-----

--72pTQ1Q5L511SwPT--
