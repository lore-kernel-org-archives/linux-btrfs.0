Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34154 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbaLBBuh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 20:50:37 -0500
Message-ID: <1417485029.4310.22.camel@gentoo.org>
Subject: Re: btrfs stuck with lot's of files
From: Peter Volkov <pva@gentoo.org>
To: Robert White <rwhite@pobox.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 02 Dec 2014 04:50:29 +0300
In-Reply-To: <547CB7D0.4040800@pobox.com>
References: <1417434411.20237.1.camel@gentoo.org>
	 <547CB7D0.4040800@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

В Пн, 01/12/2014 в 10:47 -0800, Robert White пишет:
> On 12/01/2014 03:46 AM, Peter Volkov wrote:
>  > (stuff about getting hung up trying to write to one drive)
> 
> That drive (/dev/sdn) is probably starting to fail.
> (about failed drive)

Thank you Robert for the answer. It is not likely that drive fails here.
Similar condition (write to a single drive) happens with other drives
i.e. such write pattern may happen with any drive.

After looking at what happens longer I see the following. During stuck
single processor core is busy 100% of CPU in kernel space (some kworker
is taking 100% CPU). Ftrace reveals that
btrfs_async_reclaim_metadata_space is most frequently called function.
So it looks like btrfs is doing some operation with metadata and until
it finishes that everything is stuck (practically no writes happens on
disk). So I'm looking for suggestion on how to cope with this process.

> >   # btrfs filesystem df /store/
> > Data, single: total=11.92TiB, used=10.86TiB
> 
> Reguardless of the above...
> 
> You have a terabyte of unused but allocated data storage. You probably 
> need to balance your system to un-jamb that. That's a lot of space that 
> is unavailable to the metadata (etc).

Well, I'm afraid that balance will put fs into even longer "stuck".

> ASIDE: Having your metadata set to RAID1 (as opposed to the default of 
> DUP) seems a little iffy since your data is still set to DUP.

That's true. But why data is duplicated? During btrfs volume creation
I've set explicitly -d data single.

> FUTHER ASIDE: raid1 metadata and raid5 data might be good for you given 
> 22 volumes and 10% empty empty space it would only cost you half of your 
> existing empty space. If you don't RAID your data, there is no real 
> point to putting your metadata in RAID.

Is raid5 ready for use? As I read post[1] mentioned on[2] it is still
some way to make it stable.

[1]
http://marc.merlins.org/perso/btrfs/post_2014-03-23_Btrfs-Raid5-Status.html
[2] https://btrfs.wiki.kernel.org/index.php/RAID56

--
Peter.

