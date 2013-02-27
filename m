Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18382 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab3B0BaE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 20:30:04 -0500
Date: Wed, 27 Feb 2013 09:28:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Fredrik Tolf <fredrik@dolda2000.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Changing allocation mode
Message-ID: <20130227012832.GB7028@liubo>
Reply-To: bo.li.liu@oracle.com
References: <alpine.DEB.2.02.1302230138220.8295@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1302230138220.8295@shack.dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 23, 2013 at 01:46:03AM +0100, Fredrik Tolf wrote:
> Dear list,
> 
> I'm still in the process of transferring all the data I have to the
> btrfs filesystem I have had your help in debugging in a previous
> thread, and I have a slight question, if you will humour me.
> 
> I have the data I want to transfer on an old ReiserFS partition,
> consisting of 2 mdraid mirrors, one of which consists of two 1.5 TB
> disks, and the other of two 3 TB disks. The btrfs I'm copying the
> data to consists of two 3 TB disks only that I have put in RAID-1
> mode, and the data on the old filesystem is only slightly larger
> than 3 TB. I am now at the point where I have transferred just under
> 3 TB.
> 
> If I were transferring the data to a new filesystem on mdraid, the
> procedure I would use for that last portion of the data would be to
> remove one disk only from either of the old mdraid mirror arrays
> (putting that array in degraded mode), and then create a new mirror
> in degraded mode with only that disk, add that mirror to the new
> filesystem, expand it, copy the last data, and then delete the old
> mirrors, moving the rest of the disks to the new filesystem.

That sounds like using seed device, although seed disk is designed for another
different purpose.

thanks,
liubo

> 
> Is there a way to mirror this procedure in btrfs? I'm not yet quite
> so familiar with all btrfs concepts that I know quite what I'm
> talking about, but I'm guessing that what I want to do is to merely
> temporarily set the allocator to allocate new btrfs on a single disk
> only, and then add a single disk to the filesystem. And then copy
> the rest of the data, abandon the old filesystem and add another
> disk and rebalance those singly-allocated extents to RAID-1 mode.
> 
> Have I described a conceptionable idea in saying so? And if so, how
> does one actually do that? I don't know if I'm just blind, but I
> haven't found any btrfs command to change the allocation algorithm
> without having to rebalance the existing data, which seems a bit
> unnecessary in this case.
> 
> Thanks for any help you can offer!
> 
> --
> 
> Fredrik Tolf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
