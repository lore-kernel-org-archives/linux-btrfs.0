Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34974 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaL2TEB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 14:04:01 -0500
Date: Mon, 29 Dec 2014 19:04:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "sys.syphus" <syssyphus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: I need to P. are we almost there yet?
Message-ID: <20141229190400.GA26040@carfax.org.uk>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
 <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
In-Reply-To: <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 01:00:05PM -0600, sys.syphus wrote:
> oh, and sorry to bump myself. but is raid10 *ever* more redundant in
> btrfs-speak than raid1? I currently use raid1 but i know in mdadm
> speak raid10 means you can lose 2 drives assuming they aren't the
> "wrong ones", is it safe to say with btrfs / raid 10 you can only lose
> one no matter what?

   I think that with an even number of identical-sized devices, you
get the same "guarantees" (well, behaviour) as you would with
traditional RAID-10.

   I may be wrong about that -- do test before relying on it. The FS
probably won't like losing two devices, though, even if the remaining
data is actually enough to reconstruct the FS.

   Hugo.

-- 
Hugo Mills             | I can resist everything except temptation
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUoaWfAAoJEFheFHXiqx3kxycQAJv5PXMmQ+riJiei3qkhJu+I
YTEWDJ3CAW+R42uDCM2IaO5X0E1t0j7XP9dAM9DWt/6wDBrn/bFLZv0SA38gmVG+
tc5a9y1c03iCdTdusye8bIuyUT1Ypbv2EcnHvOj9MB1IHouA/JbHLHsnkybFjE4S
wSsU7ytm2at+4dd5sMs1pZN2j0e0ep7dS3T3wDubeilcEbUFiBrhpzwIt7Ak+AMH
jmb9Lzit+6+ScrCx945mxdBoLLPt3xu6AA1Kdu7ZFuMwkvAVCKitC1CCYqmu56tV
+fkyr+qth8taNEFtQcczgXAa7DPC+o1629fyphP7LBIBHE/tdWPQTUrH9CQKk6AQ
+I4QipZHLv6KAeihIv0FHYn78C4oOZM1k9VUGrA4LKuMiD3U5RUNB/oC7dPllTSC
kCNyzQCvHIrU6k1TY4OPMSbDPZOF0Gh6RVn1an9zCVK3YDHalLdclWBdlHtFhoiL
LBTiHt5z5uNWDgSzthEwFtaFml/lqQFsZ8bxd7NQrOFjyEga8tJZp9mdCvLlp9HM
Hd9Pr2eJBMmAB2eModaPO5AS2BfBb44chynyeus7IrhSrEmhBW94EBABan8OKFOU
kvYJYl4DJDVhKQHyQGPBu+KSZIj2iQVPy71UwmZuTmexLt8dcUUGNFS3donY4Id7
PlkHfW2i3GlSrtb/oTEi
=57Iw
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
