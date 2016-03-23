Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53789 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbcCWW2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 18:28:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1airGd-0002Wo-Ib
	for linux-btrfs@vger.kernel.org; Wed, 23 Mar 2016 23:28:43 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 23:28:43 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 23:28:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID-1 refuses to balance large drive
Date: Wed, 23 Mar 2016 22:28:36 +0000 (UTC)
Message-ID: <pan$69a55$49062856$48449733$884dd726@cox.net>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 23 Mar 2016 12:34:10 -0600 as excerpted:

> On Wed, Mar 23, 2016 at 10:51 AM, Brad Templeton <bradtem@gmail.com>
> wrote:
>> Thanks for assist.  To reiterate what I said in private:
>>
>> a) I am fairly sure I swapped drives by adding the 6TB drive and then
>> removing the 2TB drive, which would not have made the 6TB think it was
>> only 2TB.    The btrfs statistics commands have shown from the
>> beginning the size of the device as 6TB, and that after the remove, it
>> haad 4TB unallocated.
> 
> I agree this seems to be consistent with what's been reported.

Chris, and Hugo too as the one with the most experience with this, on IRC 
and privately as well as on-list.

Is this possibly another instance of that persistent mystery bug where 
btrfs pretty much refuses to allocate new chunks despite there being all 
sorts of room for it to do so, that seems just rare enough that without 
any known method of replication, keeps getting backburnered by more 
urgent-issues when devs try to properly investigate and trace it down, 
while being persistent over many kernels now and just common enough, with 
just enough common characteristics among those affected, to be considered 
a single, now recognized, bug?

If it's the same bug here, it seems to be affecting only the new 6 TB 
device, not the older and smaller devices, but I'm not sure if it has 
manifested in that sort of device-exclusive form before, or not, and that 
along with the facts that there's no fix known and that Hugo seems to be 
the only one with enough experience with the bug to actually reasonably 
authoritatively consider it the same bug, has me reluctant to actually 
label it as such here.

But I can certainly ask the question, and I've not yet seen it suggested 
as the ultimate bug we're facing thin this thread yet, so...


If Hugo (or Chris if he's seen enough more instances of this bug recently 
to reasonably reliably say) doesn't post something more authoritative...

If this is indeed /that/ bug, then most efforts to fix it, won't directly 
fix it at all.  Rebalancing to single, and then back to raid1, /might/ 
eliminate it... or not, I simply don't have enough experience 
troubleshooting this bug to know if others tried that and their results 
or not (tho I'd guess Hugo would have suggested that, where people 
weren't dealing with a single-device-only, anyway, and might know the 
results).

The one known way to eliminate the bug is to back everything up, blow 
away the filesystem and recreate it.  Tho AFAIK, in one instance at 
least, the new btrfs ended up having the same bug.  But I believe for 
most, it does get rid of it.  Luckily in the OP's case, the filesystem 
has evolved over time, so chances are that the bug won't appear on the 
new btrfs, created from the start with all the devices intended for it 
currently.  It /might/ reappear with time, but I'd hope it'd only appear 
sometime later, after another device upgrade or two, at least.

Of course, that's assuming it's either this bug, or another one that's 
fixed by starting over with newly created filesystem with all currently 
intended devices included in the mkfs.btrfs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

