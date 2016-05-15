Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36163 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbcEOXFi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 19:05:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b256M-0004o8-Lb
	for linux-btrfs@vger.kernel.org; Mon, 16 May 2016 01:05:34 +0200
Received: from ip5f5ae06c.dynamic.kabel-deutschland.de ([95.90.224.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 01:05:34 +0200
Received: from hurikhan77 by ip5f5ae06c.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 01:05:34 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Hot data tracking / hybrid storage
Date: Mon, 16 May 2016 01:05:24 +0200
Message-ID: <20160516010524.7e208f96@jupiter.sol.kaishome.de>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 15 May 2016 21:11:11 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Ferry Toth posted on Sun, 15 May 2016 12:12:09 +0000 as excerpted:
> 
> > Is there anything going on in this area?
> > 
> > We have btrfs in RAID10 using 4 HDD's for many years now with a
> > rotating scheme of snapshots for easy backup. <10% files (bytes)
> > change between oldest snapshot and the current state.
> > 
> > However, the filesystem seems to become very slow, probably due to
> > the RAID10 and the snapshots.
> > 
> > It would be fantastic if we could just add 4 SSD's to the pool and
> > btrfs would just magically prefer to put often accessed files there
> > and move older or less popular files to the HDD's.
> > 
> > In my simple mind this can not be done easily using bcache as that
> > would require completely rebuilding the file system on top of
> > bcache (can not just add a few SSD's to the pool), while
> > implementing a cache inside btrfs is probably a complex thing with
> > lots of overhead.
> > 
> > Simply telling the allocator to prefer new files to go to the ssd
> > and move away unpopular stuff to hdd during balance should do the
> > trick, or am I wrong?
> > 
> > Are none of the big users looking into this?  
> 
> Hot data tracking remains on the list of requested features, but at
> this point there's far more features on that list than developers
> working on them, so unless it's a developer's (or their
> employer/sponsor's) high priority, it's unlikely to see the light of
> day for some time, years, yet.
> 
> And given the availability of two hybrid solutions in the form of
> bcache and a device-mapper solution (the name of which I can't recall
> ATM), priority for a btrfs-builtin solution isn't going to be as high
> as it might be otherwise, so...
> 
> 
> The good news for the dmapper solution is that AFAIK, it doesn't
> require reformatting like bcache does.
> 
> The bad news for it is that while we have list regulars using btrfs
> on bcache so it's a (relatively) well known and tested solution,
> we're lacking any regulars known to be using btrfs on the dmapper
> solution. Additionally, some posters looking at the dmapper choice
> have reported that it's not as mature as bcache and not really ready
> for use with btrfs, which is itself still stabilizing and maturing,
> and they weren't ready to deal with the complexities and reliability
> issues of two still stabilizing and maturing subsystems one on top of
> the other.
> 
> Of course, that does give you the opportunity of being that list
> regular using btrfs on top of that dmapper solution, should you be
> willing to undertake that task. =:^)
> 
> 
> Meanwhile, you did mention backups, and of course as btrfs /is/ still 
> maturing, use without backups (and snapshots aren't backups) ready if 
> needed is highly discouraged in any case, so you do have the option
> of simply blowing away the existing filesystem and either redoing it
> as-is, which will likely speed it up dramatically, for a few more
> years, or throwing in those ssds and redoing it with bcache.
> 
> It's also worth noting that if you can add 4 ssds to the existing
> set, you obviously have the hookups available for four more devices,
> and with hdds cheap as they are compared to ssds, if necessary you
> should be able to throw four more hdds in there, formatting them with
> bcache or not first as desired, and creating a new btrfs on them,
> then copying everything over.  After that you could yank the old ones
> for use as spares or whatever, and replace them with ssds, which
> could be setup with bcache as well and then activated.  Given the
> cost of a single ssd, the total cost of four of them plus four hdds
> should still be below the cost of five ssds, and you're still not
> using more than the 8 total hookups you had already mentioned, so it
> should be quite reasonable to do it that way.

You can go there with only one additional HDD as temporary storage.
Just connect it, format as bcache, then do a "btrfs dev replace". Now
wipe that "free" HDD (use wipefs), format as bcache, then... well, you
get the point. At the last step, remove the remaining HDD. Now add your
SSDs, format as caching device, and attach each individual HDD backing
bcache to each SSD caching bcache.

Devices don't need to be formatted and created at the same time. I'd
also recommend to add all SSDs only in the last step to not wear them
early with writes during device replacement.

If you want, you can add one additional step to get the temporary hard
disk back. But why not simply replace the oldest hard disk with the
newest. Take a look at smartctl to see which is the best candidate.

I went a similar route but without one extra HDD. I had three HDDs in
mraid1/draid0 and enough spare space. I just removed one HDD, prepared
it for bcache, then added it back and removed the next.


-- 
Regards,
Kai

Replies to list-only preferred.

