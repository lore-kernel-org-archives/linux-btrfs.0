Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60863 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801AbaEQOZG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 May 2014 10:25:06 -0400
Date: Sat, 17 May 2014 15:24:58 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
Message-ID: <20140517142457.GB2537@carfax.org.uk>
References: <2308735.51F3c4eZQ7@xev>
 <ll7lvd$ulk$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
In-Reply-To: <ll7lvd$ulk$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 17, 2014 at 01:50:52PM +0100, Martin wrote:
> On 16/05/14 04:07, Russell Coker wrote:
> > https://blogs.oracle.com/bill/entry/ditto_blocks_the_amazing_tape
> > 
> > Probably most of you already know about this, but for those of you who haven't 
> > the above describes ZFS "ditto blocks" which is a good feature we need on 
> > BTRFS.  The briefest summary is that on top of the RAID redundancy there...
> [... are additional copies of metadata ...]
> 
> 
> Is that idea not already implemented in effect in btrfs with the way
> that the superblocks are replicated multiple times, ever more times, for
> ever more huge storage devices?

   Superblocks are the smallest part of the metadata. There's a whole
load of metadata that's not in the superblocks that isn't replicated
in this way.

> The one exception is for SSDs whereby there is the excuse that you
> cannot know whether your data is usefully replicated across different
> erase blocks on a single device, and SSDs are not 'that big' anyhow.
> 
> 
> So... Your idea of replicating metadata multiple times in proportion to
> assumed 'importance' or 'extent of impact if lost' is an interesting
> approach. However, is that appropriate and useful considering the real
> world failure mechanisms that are to be guarded against?
> 
> Do you see or measure any real advantage?

   This. How many copies do you actually need? Are there concrete
statistics to show the marginal utility of each additional copy?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- IMPROVE YOUR ORGANISMS!!  -- Subject line of spam email ---     

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3dxOVheFHXiqx3kAQJvpBAAkbgI1G7NLpOhp+hskkilued9cG1CjL8A
HXeklV8d1GFUyvz2z2FsEJcLo2+GKpBcL78v7ZZFspBTwNDT8puOhxT3GZOnaDMZ
+yKMxUolaqm+54/U0ZDeVYBIVt7s2Qtif6/I/clVnhue9XXaj6nYzf0v+o3RBAyq
3Q+OgwUhnmxlHYLQw1TLq/PHT+skJcN/01PHowy8db5FewGd7EYKSCQ9Nw7i2l28
HnTUkG7npKUeIPPHbHAONYR37an086O3VZ+IxVwwnlHZa9j4ElZlSwxd/5UOT6g9
KcFwtlKm0zaO+cYVze/UYD1RCzPMWR5eamToHczloKYnse0CcsxVHaUKfItwUvX+
en4b0CDeu2dx72F9paUg6WgdREZULVCWnRmmMX9rwR2cVbbn/t0pRFz/OeEkIr0F
XcbojOJLFHaMkfTgtDsoeRL2TCAOU4d7BJzOFfzuPO+4OZKyFC370huhfeu7A6yh
BlINFqCXh7Qay/iOV9PhOjJKizb6ngxQWmdpOW45boFrsZalXA6Q3YkTN3N4ca0l
Nihk5AcMzoJR4UPh/UOTRMgqdSEd/Quk/75W/MVAVywM1Cy0mUwhjjKY0RcHT5ZC
lT39NQzN8JhMS2J+yxXQEf8X6rXXoLyzb/wVf5G+DT1ItYCa2kg0/beAS6iFAyFi
REI58vU495g=
=AZUN
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
