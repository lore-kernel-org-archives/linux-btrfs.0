Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38351 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab3A3KtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 05:49:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U0VEa-0005Yd-4Q
	for linux-btrfs@vger.kernel.org; Wed, 30 Jan 2013 11:49:40 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 11:49:40 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 11:49:40 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: RAID 0 across SSD and HDD
Date: Wed, 30 Jan 2013 02:49:09 -0800
Message-ID: <keatr3$65q$1@ger.gmane.org>
References: <keap27$oqb$1@ger.gmane.org> <20130130100201.GN16285@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130130100201.GN16285@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 30/01/13 02:02, Hugo Mills wrote:
> On Wed, Jan 30, 2013 at 01:27:37AM -0800, Roger Binns wrote:
>> In my specific case I have a 250GB SSD and a 500GB HDD, and about
>> 250GB of files (constantly growing).  One message I saw said that new
>> blocks are allocated on the device with the most free space which
>> implies the SSD would be virtually unused in my case, except for
>> metadata which would only be used half the time.
> 
> That would be the case with "single" mode, not with RAID-0.

Ah, I hadn't realised there was a major difference.

> With RAID-0, you'd get data striped equally across all (in this case,
> both) the devices, up to the size of the second-largest one, at which
> point it'll stop allocating space.

By "stop allocating space" I assume you mean it will return out of space
errors, even though there is technically 250GB of unused space.  I presume
there is no way to say that RAID-0 should be used where possible and then
fallback to "single" for the remaining space.

It looks like my choices are:

* RAID 0 and getting 500GB of usable space, with performance 50% of the
accesses at HDD levels and 50% at SSD levels

* Single and getting 750GB of usable space with performance and usage
mostly on the HDD

> We don't have any kind of hot-data management yet, but it's on the list
> of things we'd like to have at some point.

I'm happy to wait till it is available.  btrfs has been beneficial to me
in so many other respects (eg checksums, compression, online everything,
not having to deal with LVM and friends).  I was just hoping that joining
an SSD and HDD would be somewhat worthwhile now even if it isn't close to
what hot data will deliver in the future.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlEI+qUACgkQmOOfHg372QT/pwCfd0UiGGlQpIjCBtCpysPZtGEs
wEQAoNVIzFIkPp/EzHTDDaD9RD178dkB
=VUqP
-----END PGP SIGNATURE-----

