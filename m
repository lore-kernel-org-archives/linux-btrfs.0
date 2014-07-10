Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52636 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGJVU5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 17:20:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X5Llw-0008BL-6t
	for linux-btrfs@vger.kernel.org; Thu, 10 Jul 2014 23:20:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 23:20:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 23:20:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: File server structure suggestion
Date: Thu, 10 Jul 2014 21:20:44 +0000 (UTC)
Message-ID: <pan$3fa75$98459e65$9560b016$e99b83a7@cox.net>
References: <CAGTBuzTWV2jVqy4uScevHbMi-kp4_TRdeR21ZoA3-yOtCXPA=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrew Flerchinger posted on Thu, 10 Jul 2014 10:41:02 -0400 as excerpted:

> Enter btrfs. Unfortunately, it's newer than ZFS and isn't as robust, but
> it does support online capacity expansion, and the on disk format is
> expect to be stable. It has data checksums and COW, which are the
> primary things I'm after. RAID10 seems pretty stable, but RAID56 isn't.
> 
> So I'm looking for a suggestion. My end goal is RAID6 and expand it a
> drive at a time as needed. For right now, I can either:
> 
> 1) Run RAID6, but be aware of its limitations. I can manually remove and
> add drives in separate steps if needed. Keep the server on a UPS to
> limit unexpected shutdowns and any corruption there. The whole array
> can't be scrubbed, but if there is a chechsum problem when reading
> individual data, will that still be corrected and/or logged? This will
> be a temporary situation, as over time, more features will be built out,
> and the existing file system will be better supported.
> 
> 2) Run RAID10, and convert the file system to RAID6 later once it is
> stable. Since RAID10 is far more stable and feature complete than RAID56
> right now, all features will work okay, I'm just buying more
> drives/running at lower capacity for the moment. If I have to grow the
> array, I'd have to buy two drives. In the future, once RAID6 is better
> supported, I can convert in-place to RAID6.

I'd personally consider btrfs raid5/6 to be in practice a slow and lower 
capacity raid0, at this point, except that you'll get raid5/6 for "free" 
when that's fully supported, since it has been doing the writing for that 
all along, it just couldn't properly restore.  IOW, I wouldn't consider 
it trustworthy at all against loss of a device, which based on your 
suggestion, isn't appropriate for your usage.

That leaves either raid10 or raid1.  It's worth noting that btrfs raid1 
is at this point paired mirrors only, so no matter how many devices, you 
still have exactly two mirrors of all (meta)data.  N-way-mirroring is 
planned for after raid5/6 completion.  Which could put raid1 in the 
running for you, and as the simplest redundant raid, it might be easier 
to convert to raid5/6 later.

Then there's raid10, which takes more drives and is faster, but is still 
limited to two mirrors.  But while I haven't actually used raid10 myself, 
I do /not/ believe it's limited to pair-at-a-time additions.  I believe 
it'll take, for instance five devices, just fine, staggering chunk 
allocation as necessary to fill all at about the same rate.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

