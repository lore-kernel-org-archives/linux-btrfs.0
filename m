Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58462 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaLRIlh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 03:41:37 -0500
Date: Thu, 18 Dec 2014 08:41:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        David Sterba <dave@jikos.cz>
Subject: Terminology (was Re: [PATCH 6/7] Print the summary)
Message-ID: <20141218084131.GA25267@carfax.org.uk>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
 <1418673780-22000-7-git-send-email-kreijack@inwind.it>
 <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
 <548FAB3A.7060009@pobox.com>
 <20141216090540.GK1442@carfax.org.uk>
 <549269CB.3010806@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
In-Reply-To: <549269CB.3010806@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2014 at 09:44:43PM -0800, Robert White wrote:
> On 12/16/2014 01:05 AM, Hugo Mills wrote:
> >On Mon, Dec 15, 2014 at 07:47:06PM -0800, Robert White wrote:
> >>I prefer "slice", not that I am totally happy with that word either.
> >>But by the time you get through loopback devices, memory map
> >>devices, the "device files" that represent parts of "partitioned"
> >>devices, logical "volumes", and god only knows what future
> >>"thingies" we will end up dealing with... I like the terms that
> >>remove false hints.
> >
> >    All this agreed, but "slice" will be largely viewed as a neologism
> >by anyone who hasn't used (IIRC) BSD or Solaris. On the other hand,
> >for all their other flaws, "device" is much better than "disk" here,
> >as you could he talking about a partition, a flash memory card (which
> >many people don't view as "disks"), or a network block device. You
> >could refer to a "block device" to clarify, because that's really what
> >we're talking about here, but it could get a bit cumbersome.
> 
> That's part of why I'm not perfectly happy with slice either.
> 
> But just last week I was trying to explain the whole thing of being
> out of raw space to allocate storage extents compared to being out
> of managed space to allocate file, um, extents...
> 
> And I'm currently going around in circles over whole "when is a
> sector free" as far as /bin/df is concerned...
> 
> 
> we've got devices as we view them which are parts of devices as the ...
> 
> We've got storage extents and we are dealing with people who are
> used to seeing "extent" used as the name of contiguously stored
> sections of files, but our extents store segments of the devices.

   "...our extents store segments of the devices" _as well_, and that
term doesn't tend to leak out into public discussions. They're also
arked with a different record type in the extent tree, IIRC.

> We've also got those two-disk raid-5(s) which we've established are
> mathematically correct, but which will trip up everyone that is used
> to the three-or-more rule.

   I don't buy this one. You're the first person who's complained
about the use of the parity RAID names. However, we've had plenty of
people complaining about the RAID-1 term.

   As I said at the time, maybe we need to revisit the RAID vocabulary
completely and move to a more flexible terminology.

   David -- would you accept the cNsMpP patches if I revisted them?

> Then using the variable bytenr instead of byte_number (when all the
> rest of the variables are spelled out) and I'm not sure if thats in
> the logical view or the physical layout view, or both.

   Everything is in the logical view, unless you're looking at the
chunk tree, which does that mapping.

> In short (too late) there is a huge lexicon problem to newcomers
> here because of noun-overloading (in the programmatic sense).

   The extents and bytenr concerns don't leak out into the public
(user) arena. RAID is a known problem with a proposed solution. I
don't see this as being *huge* -- not in the same way that space
reporting to users is huge.

   Hugo.

-- 
Hugo Mills             | Always be sincere, whether you mean it or not.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |                                      Flanders & Swann
PGP: 65E74AC0          |                                The Reluctant Cannibal

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUkpM6AAoJEFheFHXiqx3kK1EQAK3U/rKpt+q44Kdm1dtYhH9s
wOsyyYbRXZJozt/H4xDZi6f9zYcC1YEijgGyLd+os+oOQ6vWkkFiBGU0+3i2GtfP
CQz8JEOTL39gFlG3yT6XAx9gqpzBSEUiDcxxZu9Qd+5pqIn7DwGITG8/bC0FKTNQ
f11s/m2ifVl4YuEl/60ZhvrnqIv7QTt/0lq0AKrDVdLllMbgV/pkuf+YlHg4lnqo
4LcuXHE5h1UvkiRbpM2HAfW/Y093eTH0UxStXT+CvkD2qbxcEoQuBZrk12bvmzTV
JPsnW7ytIq9/kFU5v5yqXhQxAR4PbKXNnf7BXm8JFO3KxVf2Gv0xvg7NlyBrizIm
WI+U66ovo62ff/aPai+f8JTVzKuceZEWGR/jZDVY0kgjQYkDRLKsZ9IWFhqlGvkf
MvFaXzbStPpeRN2M0bc/p+/u9gKbIS5up93hwBQ+9Lf/0GpSe2f4WViFr9NgQJg5
WpGnHDUEIe8CoMS/09WapN7SwaS9LRdRkVbK+4BYB2bRjWNo9vwjUhZPjodthXmk
YQQ0zAVTDPOAeh2VOaNBGgQSz2IzSnkOMUbDdehC9NuuUSKhypbKJreeaZv03+en
IXKL8k/NhUBTKEgTdXMP3wooB2njDEXsEIGjXKcnwdasIFgMWItvcaoNsnFlIPP0
ohtpaUYPdi9S1vIZhNcM
=9p0x
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
