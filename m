Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58674 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751384AbdHVGkv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 02:40:51 -0400
Subject: Re: Btrfs Raid5 issue.
To: Robert LeBlanc <robert@leblancnet.us>, lists@colorremedies.com,
        linux-btrfs@vger.kernel.org
References: <CAANLjFo714ED=kMHZh0fTWc2WhQwkyZ4a7SZtThm9xwPghn1_Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9e3e3576-d4a0-17b0-f95f-8923f6ce89ef@gmx.com>
Date: Tue, 22 Aug 2017 14:40:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAANLjFo714ED=kMHZh0fTWc2WhQwkyZ4a7SZtThm9xwPghn1_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月22日 13:19, Robert LeBlanc wrote:
> Chris and Qu thanks for your help. I was able to restore the data off
> the volume. I only could not read one file that I tried to rsync (a
> MySQl bin log), but it wasn't critical as I had an off-site snapshot
> from that morning and ownclould could resync the files that were
> changed anyway. This turned out much better than the md RAID failure
> that I had a year ago. Much faster recovery thanks to snapshots.
> 
> Is there anything you would like from this damaged filesystem to help
> determine what went wrong and to help make btrfs better? If I don't
> hear back from you in a day, I'll destroy it so that I can add the
> disks into the new btrfs volumes to restore redundancy.
Feel free to destroy the old images.

If nologreplay works, that's good enough.
The problem seems to be extent tree, but it's too hard to locate the 
real problem.

> 
> Bcache wasn't providing the performance I was hoping for, so I'm
> putting the root and roots for my LXC containers on the SSDs (btrfs
> RAID1) and the bulk stuff on the three spindle drives (btrfs RAID1).

Well, I'm more interested in the bcache performance.

I was considering to using my Intel 600P NVMe to cache one 2.5' HGST 1T 
HDD (7200rpm) in my btrfs KVM host (also my daily machine).

Would you please share more details about the performance problem?
(Maybe it's about some btrfs performance problems, not bcache. Btrfs is 
not good at workload like DB or metadata heavy operations)

> For some reason, it seemed that the btrfs RAID5 setup required one of
> the drives, but I thought I had data with RAID5 and metadata with 2
> copies. Was I missing something else that prevented mounting with that
> specific drive? I don't want to get into a situation where one drive
> dies and I can't get to any data.

The direct cause is btrfs fails to replay its log, and it's corrupted 
extent tree causing log replay failed.
And normally such failure will definitely cause problem, so btrfs just 
stop the mount procedure.

In your case, if "nologreplay" is specified, btrfs skips the problem, 
and since you must specify RO for nologrelay, btrfs has nothing to do 
with extent tree at all.
So btrfs can be mounted.

Why extent tree get corrupted is still unknown. If your metadata is also 
RAID5, then write-hole may be the cause.
If your metadata profile is RAID1, then I don't know why this could happen.

So from this point of view, even we fixed btrfs scrub/race problems, 
it's still not good enough to survive a disk removal in real world.

With RAID1 setup, at least we don't need to care about write hole and 
csum will help us to determine which copy is correct, so I think it will 
be much better than RAID56.

If you have spare time, you could try to hot-plug RAID1 devices to 
verify how it works.
But please note that, re-attach plugged device may need to umount the fs 
and re-scan btrfs.

And even you're using 3 devices with RAID1, it's still 2 copies.
So you can lose at most 1 device.

Thanks,
Qu

> 
> Thank you again.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
