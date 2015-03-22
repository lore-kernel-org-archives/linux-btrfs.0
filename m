Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37503 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbbCVRiu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Mar 2015 13:38:50 -0400
Date: Sun, 22 Mar 2015 17:38:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: scruffters <scruffters@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs fstrim status (RAID5)
Message-ID: <20150322173849.GG31762@carfax.org.uk>
References: <CAAkAgPhF5GF5tq0Pck-dju-m7qf62LV8FobUHS2z6ibMwwUn2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
In-Reply-To: <CAAkAgPhF5GF5tq0Pck-dju-m7qf62LV8FobUHS2z6ibMwwUn2g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 22, 2015 at 05:30:59PM +0000, scruffters wrote:
> Hello list,
> 
> I wondered if anybody could advise on the status of using fstrim with
> BTRFS. The motivation for me is to finally try using SSD's in a R5
> style configuration with some way of running maintenance overnight to
> maintain performance...
[snip]
> My kernel is 3.2.0-4 (Debian Wheezy).

   Then you shouldn't use btrfs RAID-5 at all, and probably shouldn't
be using btrfs.

   For parity RAID, 3.19 or later is what you should be using, as it
supports recovery and rebuild. You can get those kernels from the
Debian experimental repo. If you're not using parity RAID, then the
last few kernels have been OK, but keeping up with the latest version
is still a reasonably good idea.

   Hugo.

-- 
Hugo Mills             | "You know, the British have always been nice to mad
hugo@... carfax.org.uk | people."
http://carfax.org.uk/  |
PGP: 65E74AC0          |                         Laura Jesson, Brief Encounter

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVDv4pAAoJEFheFHXiqx3kB0oP/RrT9h7inlPE67iUgrebeUFs
zAGy7AkBVkyi71+fQVCXhpwoqLJj4OlDeCy9QK8hR/2mx7FpowSvYXvIBVc4KsJQ
NyRtjANaqZ4mnjw01PzyyOnJ7CPoN1QJvZmVbl4JzvGYOeWI1h/VLQ3DF1TxXGMa
JPpcjFuX416/LhoHuxVRqRspAcAei60c8ZgSw7IJZARetW3paDmvEpUZlvovCXOd
jRyuFTqn8Sm6+De4/cWSnSx6G4gWtEzdxYzCso45Wjjv/HesH28H2mjOTWtEJj2c
yLQDn3gF68mNpI6/foapDQGNFIoF7pbNEFCZ+AgYeHsBgCizaK12BOw2XxNQ9GSr
BYWMoiX23i+d60oIFx1jjq5T9i6yHZSLBWYqSsOW9vcF4HPcSE+L0VppxZSJQIId
w22268T0qtKeV4InJyVnH+bH6YU1UXb/57oApi5gJhYBIbi77OqSoHl5PAOPRf1N
dLS79meXoG6qhINg96QfaZQ0bQA27D8eDAKE4FbQC4JMOoiM6TlweDN2hwR+wQNQ
b0NlMrr56bdpmik/8Ur1pfwKP8qsRLyM4/Otr8htc63FbWpebT1N9UZ7XNmw13Z2
Pn4cbprfVWJZcAMQXmEYGQQDKvE2YDQrmktqSLge1f9S6Yg6xgW4xHFOTX9XPvur
t/2lMmiA9VCfxfSM4aOR
=S0zS
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
