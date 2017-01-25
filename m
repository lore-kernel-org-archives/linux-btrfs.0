Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17580 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751137AbdAYEUp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 23:20:45 -0500
Subject: Re: btrfs check lowmem vs original
To: Chris Murphy <chris@colorremedies.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
 <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
 <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com>
Date: Wed, 25 Jan 2017 12:20:39 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At 01/24/2017 05:14 AM, Chris Murphy wrote:
> OK so all of these pass original check, but have problems reported by
> lowmem. Separate notes about each inline.

Thanks for your images!

It really helps a lot.

I tested my patches against these images.
Feel free to test them:
https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes

>
> ~500MiB each, these three are data volumes, first two are raid1, third
> one is single.
> https://drive.google.com/open?id=0B_2Asp8DGjJ9Z3UzWnFKT3A0clU
> https://drive.google.com/open?id=0B_2Asp8DGjJ9V0ROdHNoMW1BVE0
> https://drive.google.com/open?id=0B_2Asp8DGjJ9Zmd1LXl6MU5WeXc

RAID1 ones are not stable for us to check, as it already contains some 
chunk tree error after recovery.
The single one I didn't download, after 324M one encounters some 
btrfs-image recovery problem.

>
> 19MiB, about 15 minutes old, rootfs, OS installation only
> https://drive.google.com/open?id=0B_2Asp8DGjJ9TF9LVkFlcDBzOG8

Passed now.

>
> 55MiB, about 1 month old, rootfs, not much activity
> https://drive.google.com/open?id=0B_2Asp8DGjJ9bkJFc01qcVJxNnM

Passed too.

>
> 324MiB, about 5 months old, used as rootfs, all read-write snapshots
> used as rootfs are forced readonly, a regression previously reported
> without any dev response
> https://drive.google.com/open?id=0B_2Asp8DGjJ9ZmNxdEw1RDBPcTA
> http://www.spinics.net/lists/linux-btrfs/msg61817.html
> https://bugzilla.kernel.org/show_bug.cgi?id=191761

Recovery caused quite a lot of false alert on chunk tree.
Still digging if the remaining errors are valid or not.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


