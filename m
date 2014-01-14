Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53986 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaANIZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 03:25:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2zJ1-0007b8-Ot
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 09:25:03 +0100
Received: from ppp-188-174-36-10.dynamic.mnet-online.de ([188.174.36.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 09:25:03 +0100
Received: from tom by ppp-188-174-36-10.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 09:25:03 +0100
To: linux-btrfs@vger.kernel.org
From: Thomas Kuther <tom@kuther.net>
Subject: Re: Issues with 
Date: Tue, 14 Jan 2014 08:23:41 +0000 (UTC)
Message-ID: <loom.20140114T083934-800@post.gmane.org>
References: <20140113002532.3975c806@ws> <52D3C012.9040308@kuther.net> <pan$13b5$4830a55$8e383081$f7bb4fd7@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

[...]
> Normally you'd do a data balance to consolidate data in the data chunks 
> and return the now freed chunks to the unallocated space pool, but you're 
> going to have problems doing that ATM, for two reasons.  The likely 
> easiest to work around is that since all space is allocated and balance 
> works by allocating new chunks and copying data/metadata from the old 
> chunks over, rewriting, defragging and consolidating as it goes, but 
> there's no space left to allocate that new one...
> 
> The usual solution to that is to temporarily btrfs device add another 
> device with a few gigs available, do the rebalance with it providing the 
> necessary new-chunk space, then btrfs device delete, to move the chunks 
> on the temporary-add back to the main device so you can safely remove the 
> temporary-add.  Ordinarily, even a loopback on tmpfs could be used to 
> provide a few gigs, and that should be enough, but of course you can't 
> reboot while the chunks are on that tmpfs-based loopback or you'll lose 
> that data, and the below will likely trigger a live-lock and you'll 
> pretty much HAVE to reboot, so having those chunks on tmpfs probably 
> isn't such a good idea after all.  But a few gig thumbdrive should work, 
> and should keep the data safe over a reboot, so that's probably what I'd 
> recommend ATM.


Thanks again for your input, Duncan.

What I did now was:
a) took another read on the matter first
b) verified the qemu-img'ed backup of the VM is working properly
c) deleted the original vm image and refreshed my system backups

At that point data was still fully allocated.

d) dropped that single system chunk as you suggested previously. 
Interestingly this gave me:

Label: none  uuid: 52bc94ba-b21a-400f-a80d-e75c4cd8a936
        Total devices 1 FS bytes used 43.92GiB
        devid    1 size 119.24GiB used 119.03GiB path /dev/sda2

..some free data chunks.

e) Ran an iteration with balance -dusage=5, -dusage=10, 15, 20, 25.
After 25 it looks like:

Label: none  uuid: 52bc94ba-b21a-400f-a80d-e75c4cd8a936
        Total devices 1 FS bytes used 43.92GiB
        devid    1 size 119.24GiB used 95.02GiB path /dev/sda2


So, your suggestion regarding d) saved me from having to recreate the FS or 
having to add a drive.

Now I need to make sure I get a notice when data gets filled up too much.

Regards,
Tom

