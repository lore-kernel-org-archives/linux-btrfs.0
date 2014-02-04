Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45301 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaBDQc6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2014 11:32:58 -0500
Date: Tue, 4 Feb 2014 16:32:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash with a corrupted(?) filesystem
Message-ID: <20140204163235.GC6490@carfax.org.uk>
References: <20140204222310.65c4a468@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
In-Reply-To: <20140204222310.65c4a468@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 10:23:10PM +0600, Roman Mamedov wrote:
> Hello,
> 
> My server had a period of instability (PSU-related issues), some lockups,
> some strange crashes, and some files became corrupted, and perhaps parts of
> a filesystem too. One BTRFS partition now fails with the following errors.
> 
> On an attempt to make a snapshot:
> 
> [   48.035664] btrfs: corrupt leaf, bad key order: block=193529446400,root=1, slot=9
[snip]

   Bad key order is pretty much always down to hardware corrupting
data at some point -- which would go well with your list of hardware
problems above.

> Currently I have it mounted read-only, and all data seems to be accessible.
> Short of copying everything away and recreating the FS, how can I bring it to
> a working order. Is btrfsck a good option here?

   The first investigation to do would be to look at the block in
question and see if it's got an obvious problem with it. If you post
the output of "btrfs-debug-tree -b 193529446400 /dev/whatever", we can
take a look at the indexing.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- You're never alone with a rubber duck... ---             

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvEWI1heFHXiqx3kAQIBeQ/+LWOG5aavggpuvdpIgcodD/muC3AK3oby
HOmr8hv0P7DSARpVGdb8gBEYnr/fIBryNGb7uQuGNuxTo7aaoAxAPxpgIWvnFPRr
WjHU/dzBlMKmWKyRMa/N1W0Jz5Bm4l9CD4eb/yweIXqeSQvMGk+ps2mT2/jPtib+
t+n87OXgixsS7lJkPWSUhYh4vzczrCmuZm7YglA2A27ig1veGXzhfj95HVxiG9n2
DnGeZAm1J1w7LR4Z+KwuDwCr+Dhlap3gU6VoFvmtR/WEt1NNrozy5ceIom31DZH0
BDBA15+8o4g0UyHCbBUw03aKJgUQyrHDYz1p40aQjclYpsZQqYWqW3fpd/fxqHsQ
Ht3AKx3YGlfy1BY+05zzFwMGIgpOMzqAjXsibx1S9Jp1WVEPWoB/It4JTqs7MNh8
C0VGmgFeA7T+aZtj58C8x+O5OYh7i2IsGDPa7SRTQx1Rz+3zpnbHC6iGZPJ85Vw5
Z5yF5FWFjvvNyR5i3zo7oSOqxSGbWC4ItEQF+Y/JdNSB6Ib4G/oRvdpzsnecJKb1
zFjv4JtBVYZv+7jUqilTCUxWnokUG5EY2wzRCUA44GzI1oKfmxVMAcO/k2/20L2h
RE9a+73Ei4h37S+2RUsh0vpVhWuvn3oYwBBeBOstQD6XmPiI/XflHm6ToEeMgs+y
Aqqc5WPcNxU=
=wea+
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
