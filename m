Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33542 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759822AbdEOIQJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 04:16:09 -0400
Date: Mon, 15 May 2017 08:14:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
Message-ID: <20170515081455.GM9701@carfax.org.uk>
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
 <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
 <20170514201508.bd3dshfymqt4swpb@merlins.org>
 <20170514212111.GL9701@carfax.org.uk>
 <20170514231652.sdpaci7e4oxs5gc3@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1rguoi8KZGYj2k4L"
In-Reply-To: <20170514231652.sdpaci7e4oxs5gc3@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1rguoi8KZGYj2k4L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 14, 2017 at 04:16:52PM -0700, Marc MERLIN wrote:
> On Sun, May 14, 2017 at 09:21:11PM +0000, Hugo Mills wrote:
> > > 2) balance -musage=0
> > > 3) balance -musage=20
> > 
> >    In most cases, this is going to make ENOSPC problems worse, not
> > better. The reason for doign this kind of balance is to recover unused
> > space and allow it to be reallocated. The typical behaviour is that
> > data gets overallocated, and it's metadata which runs out. So, the
> > last thing you want to be doing is reducing the metadata allocation,
> > because that's the scarce resource.
> > 
> >    Also, I'd usually recommend using limit=n, where n is approximately
> > the amount of data overallcation (allocated space less used
> > space). It's much more controllable than usage.
> 
> 
> Thanks for that.
> So, would you just remove the balance -musage=20 altogether?

   Yes.

> As for limit= I'm not sure if it would be helpful since I run this
> nightly. Anything that doesn't get done tonight due to limit, would be
> done tomorrow?

   I'm suggesting limit= on its own. It's a fixed amount of work
compared to usage=, which may not do anything at all. For example,
it's perfectly possible to have a filesystem which is, say, 30% full,
and yet is still fully-allocated filesystem with more than 20% of
every chunk used. In that case your usage= wouldn't balance anything,
and you'd still be left in the situation of risking ENOSPC from
running out of metadata.

   All you need to do is ensure that you have enough unallocated space
for the metadata to expand into if it needs to. That's the ultimate
goal of all this.

   If you have SSDs, it may also be beneficial to use nossd as a mount
option, because that seems to have some pathology in overallocating
chunks in normal usage. Hans investigated this in detail a month or
two ago.

   Hugo.

-- 
Hugo Mills             | "You know, the British have always been nice to mad
hugo@... carfax.org.uk | people."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                         Laura Jesson, Brief Encounter

--1rguoi8KZGYj2k4L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZGWN/AAoJEFheFHXiqx3kknMP/2BG1b72j5R+3otk/snmOd+/
2dmS9b6cDf3h6Tvuc2yAbBix8asTJsG/ZfNMrv1ciZ/rQ3f1nrneubGjAU4kpX4Z
3mNiGT9C4I0T3SKJnzyiRD5ir9yKBqvdYtQS3mei23a9mLuBmGBV25jqmXR/HGHw
Swx6VoTGrh7kyY8ZPZYF6cVBlIuxX1zNQK29iyXWjLOPrY6FZt58l6pTHnE4q3hf
UiXO5ScYTX3GkvDSDCIjIiSI1apmwmLb4hLCBR/ACbNZA1HY/jLS2HWQgCfALBH3
mRLroDpWm19ubCFHltVZmdbgKuIefguPFuwEjUKYfUhlZOP07tu0bwtDW/AHnHoc
N1GYFLUX6pbPJCZiVLL1F/tY7xPDMbV99Bs8WAVhOfaplvkZ+6CEJXlOTMDRZIx8
z4S59lACHzY4i36EIId9QGcRuSvTHUXSqC9nwEI7o73mnC+c0DuoosMeZEryiPOc
gk/3/vh0fdY7LEbXSKFxPnrbFeQamnD0ATt2Oiui/wLGC6A9J6GCTUITcn5YkBJ1
pkUslnwEVZ8Q5CiE8/V6Xr+L7PtE8OsoA2Moaiue9BaLuiqv820ytv3xUQkVNDIw
ysSpqqSbQWUaI6L0OZCNm/m1ulo03rGtmBOPqpnuOup9UlbNbNCYwDITpsyp9X9p
2Loh2caJ/K/s/5pUugw2
=uRsK
-----END PGP SIGNATURE-----

--1rguoi8KZGYj2k4L--
