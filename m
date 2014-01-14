Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42840 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaANVGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:06:46 -0500
Date: Tue, 14 Jan 2014 21:06:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: george@chinilu.com, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
Message-ID: <20140114210617.GK7221@carfax.org.uk>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com>
 <52CF4D5D.2010709@chinilu.com>
 <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>
 <52D59E28.7010200@chinilu.com>
 <20140115030021.0b001eeb@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LHvWgpbS7VDUdu2f"
In-Reply-To: <20140115030021.0b001eeb@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LHvWgpbS7VDUdu2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 03:00:21AM +0600, Roman Mamedov wrote:
> That said, do not fall into a false sense of security relying on proprietary,
> barely if ever updated after the device has been shipped, and often very
> peculiar-behaving SMART routines inside the black-box HDD firmware as your
> most important data safeguard.
> 
> Of course SMART must be checked and monitored, but don't delude yourself into
> thinking it will always warn you of anything going wrong well in advance of
> failure, or even at all.

   The famous paper from Google a few years back suggested that SMART
was a useful predictor of failure in something like 20% of failures.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--LHvWgpbS7VDUdu2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUtWmyFheFHXiqx3kAQLyug/+KYji25O7YEA614Wh06ihsmR87+BA34ZH
E8xsDboNNTN3O9X5Y4glDXKi5Q3gViBgzD8bEBNBdGabyu+LfDrJQ25ln0puxtjq
mpeC0oR29U1PEW4+oimVUMjL8GjixRKCwIE1H7kEWG1dF+7bqIQ7QKIEcb2wepFb
xL94uZRIeE3VrXGSALSaTTexZxmg02V7lQWXjjZmJe8pr5lK6SJryAAZKqDP9vF2
hRPm9M9kxPCtn8StJ24b07wBYunDZ17UxizrjV2GL8tArjQLHDMnUapw23lCaBgi
Evov1Hkr3KkbbRU3EANig9TZdT3Kiy2AL7wDOMoPU4uu/EjRpzhyDEbX9T/yFoQw
vT1NLDACGWupffogZ9t4Q9idBG1W7teoJpz8qVsqC1pcftKmt09iy+Z+4jgJ/7Md
VTLN3u/sY2A8Lo3H4vPP0lXBEOqwJCmZgVxdvNqdlQXOXDl8dwySZ3UAr/ycrcYQ
/mv7dwFSxgsNvluTiR5SCgDFD2Cfk2S0k567eASuCx2q0bWSo1YQyd20zVEKKDDc
G3xPbiHve/+weJrOH75IVLi0xYfoeKloMyK69ve7eY8CwHVPbnOkx5p61S4kedla
3aBtcecHqPFx5h25rbZou3rYBOMnEwcKyRoVP4zvQwZ5GoshI2c+VNBpolo9JT7R
tNNiktTy7k4=
=mhfR
-----END PGP SIGNATURE-----

--LHvWgpbS7VDUdu2f--
