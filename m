Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46602 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbcFFPGt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 11:06:49 -0400
Date: Mon, 6 Jun 2016 15:06:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Kaho Ng <ngkaho1234@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What is the worst case scenario of splitting an extent-tree's
 node or leaf?
Message-ID: <20160606150647.GJ24492@carfax.org.uk>
References: <CAGeO4WO080utWsqajLKUnR5X1CgA61uZB-hpryoNN-ixq_rhXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcccYpVZDxQ8hzPO"
In-Reply-To: <CAGeO4WO080utWsqajLKUnR5X1CgA61uZB-hpryoNN-ixq_rhXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HcccYpVZDxQ8hzPO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 06, 2016 at 08:17:15PM +0800, Kaho Ng wrote:
> Hi all,
> 
> I have questions on how BTRFS handles the scenario that a split pf
> extent-tree's node/leaf  incurs another splits in the tree's
> node/leaf. Is that scenario bounded? If it is, how could I calculate
> the number that the split starts looping.

   For reference for anyone replying, we've already had this
conversation as far as I could manage it on IRC a few days ago:

http://logs.tvrrug.org.uk/logs/%23btrfs/2016-05-29.html#2016-05-29T10:13:53

   Hugo.

-- 
Hugo Mills             | In one respect at least, the Martians are a happy
hugo@... carfax.org.uk | people: they have no lawyers
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                       John Carter, A Princess of Mars

--HcccYpVZDxQ8hzPO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXVZGHAAoJEFheFHXiqx3kMvgP/0E9ScMEr536geiOrWKJn7cE
YPbDxFHDB+IYR4AxslziWDN6gqS42UOBOtS0K0z/qqDavDyHGIkWcndYyuqINPws
VuDEZKhy8pI84WokPOXLO3G3Yh9oYxTbLyvFtTT/jOxUlE40Rwsfh1EHse8u7LnL
U7wSqU4YokR5azgR3DFZzK93FCCb2AoxIRtUMOMFOO1Jmw1cp6cxdSU7ZgVTOnli
6pUo6qrpLT3oGKh9SAo5o/Eg3tMZfJXKlt8XeHh/quCxng4uvRo+D5Aglq3gEjg2
3IoWNMK/C0WaXsfjxvhBNcF1oZU063xxggffOIg8ozzr5QbC8jU4qY957kYwnhWM
2ZRx+POYHa76yV7X40nKcsk3TG+i9tbHVFDCqcvXX5be54m4oyXpy0sFKQuFVYk/
vZwU5XB0QN/1g8IoOY9AejhOQWspoPNyx7LWKTEZ51gpHsjIU0briKbWDdVkb5fL
XPBdwYZTFJlHHSNgnxDs7VG39d+FnSRwBcm2P6sZAMaG13JkMxVJA3fdIkrMc1XJ
Iq89FbFiAnn0w33+rlnl77R/Zd57pnYA1JTToxEbQvh9mdZfb0qst8YWMYj8nXcp
LHnm8nFUTfIfrDaI9s3zlTxcUn0lR52w0n/VmHnFb5JMtyUjY7Vw+brXugcSRkK8
ZAG+Bw4zQlGwZwuqSYfI
=r5GI
-----END PGP SIGNATURE-----

--HcccYpVZDxQ8hzPO--
