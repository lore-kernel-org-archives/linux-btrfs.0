Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40462 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755973Ab3HYTNi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 15:13:38 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Help interpreting RAID1 space allocation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$cd80e$ef762822$17e636cb$3a2b1f54@cox.net>
Date: Sun, 25 Aug 2013 13:13:35 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B171C988-1E92-4D04-8744-1B056C089E9E@colorremedies.com>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net> < 093e4c7d21b5e734c86fc4bb1703a69e@lixil.net> < D8D710C1-2FEC-41E1-A139-522F351E0464@colorremedies.com> <pan$cd80e$ef762822$17e636cb$3a2b1f54@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 25, 2013, at 6:12 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> The degraded mount option does indeed simply ALLOW mounting without all 
> devices.  If all devices can be found, btrfs will still integrate them 
> all, regardless of the mount option.

I understand btrfs handling is necessarily different because array assembly vs mounting aren't distinguished as they are with md and hardware raid. An md device won't come up on its own if all members aren't available, you have to tell mdadm to assemble what it can, if successful the array is degraded but not mounted, then you mount the degraded array. So what takes two steps for md raid is a single step with btrfs, and in that context it makes sense intent is indicated with the degraded mount option.

Aside: I think a more conservative approach would be for -o degraded to also imply, by default, ro. Presently specifying -o degraded, I still get a rw mount.

> 
> Looked at in that way, therefore, having the degraded option remain when 
> all devices were found and integrated makes sense.  It's simply denoting 
> the historical fact at that point, that the degraded option was included 
> when mounting, and thus that it WOULD have mounted without all devices, 
> if it couldn't find them all, regardless of whether it found and 
> integrated all devices or not.

As far as I'm aware, nothing else in the mount line works based on history though. If I use -o rw, the line says rw. But if for some reason the kernel finds an inconsistency and drops the filesystem to ro, the mount line immediately says ro, not the rw used when mounting. If I -o remount,rw and the operation is successful, again the mount line reflects this.

But with a btrfs mount, even -o remount doesn't clear degraded once all devices are available. That's confusing.


> And hot-remove won't change the options used to mount, either, so 
> degraded won't (or shouldn't, I don't think it does but didn't actually 
> check that case personally) magically appear in the options due to the 
> hot-remove.

Even btrfs, when it detects certain problems, will change the mount state from rw to ro. There's every reason it could do the same thing when the volume becomes degraded during use. 

If the kernel doesn't export both volume and device state somehow, how does e.g. udisks know the volume is degraded, and which device is the source of the problem, so that the user can be informed in the desktop UI? And also, when the problem is rectified, that the volume is no longer degraded?

> 
>> To me, degraded is an array or volume state, not up to the user to set
>> as an option. So I'd like to know if the option is temporary, to more
>> easily handle a particular problem for now, but the intention is to
>> handle it better (differently) in the future.
> 
> Hopefully the above helped with that.

Yes, I agree it's both a state and a mount option.

>> I think it's a problem if there isn't an write-intent bitmap equivalent
>> for btrfs raid1/raid10, and right now there doesn't seem to be one.
> 
> As I explained I believe btrfs has even better.  It's simply that there's 
> no proper tools available to use it yet…

Understood.



Chris Murphy