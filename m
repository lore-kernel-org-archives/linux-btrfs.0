Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaLOSrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 13:47:06 -0500
Date: Mon, 15 Dec 2014 19:47:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141215184702.GU27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <1416859665.3019.6@mail.thefacebook.com>
 <20141125164717.GK26471@twin.jikos.cz>
 <5475D7F3.4040408@swiftspirit.co.za>
 <5475DC9A.3060003@gmail.com>
 <20141201183729.GM12140@twin.jikos.cz>
 <547CD129.2030007@gmail.com>
 <CAJBj3vfr+awjY1iztH-wcy9PSzsCa2cYsDhmRz2cV-O=SFifHw@mail.gmail.com>
 <m5it8o$8gf$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <m5it8o$8gf$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 01, 2014 at 03:23:03PM -0800, Alex Elsayed wrote:
> > I have not seen any evidence that combining hashes like that actually
> > reduces the chances of collision, but if we assume it does, then
> > again, the non-crypto hashes would be faster. For example, 128-bit
> > Spooky2 combined with 128-bit CityHash would produce a 256-bit hash
> > and would be faster than MD5 + whatever.
> 
> It has no real benefit, but _why_ depends on what your model is.
> 
> There's a saying that engineers worry about stochastic failure; security 
> professionals have to worry about malicious failure.
> 
> If your only concern is stochastic failure (random bitflips, etc), then the 
> chances of collision with 128-bit CityHash or MurmurHash or SipHash or what-
> have-you are already so small that every single component in your laptop 
> dying simultaneously is more likely. Adding another hash is thus just a 
> waste of cycles.

So as far as speed is preferred over strength, it does not matter much
which algorithm we choose and combining more together does not bring a
significant benefit. Crc32 is weak but has served well over the years,
the improvement to anything 128bit-based should be obvious.

> If your concern is malicious failure (in-band deduplication attack or 
> similar, ignoring for now that btrfs actually compares the extent data as 
> well IIRC), then it's well-known in the cryptographic community that the 
> concatenation of multiple hashes is as strong as the strongest hash, _but no 
> stronger_ [1].

In-band dedup uses sha anyway, the block checksums are only used for
verification.

> Since the strongest cipher in the above list is either a non-cryptographic 
> hash or MD5, which is known-weak to the point of there being numerous toy 
> programs finding collisions for arbitrary data, it would not be worth much.
> 
> The only place this might be of use is if you used N strong/unbroken hashes, 
> in order to hedge against up to N-1 of them being broken. However, the gain 
> of that is (again) infinetismal, and the performance cost quite large 
> indeed.

Thanks for you valuable input!
