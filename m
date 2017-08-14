Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752247AbdHNIBL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 04:01:11 -0400
Subject: Re: how to benchmark schedulers
To: "Janos Toth F." <toth.f.janos@gmail.com>,
        Bernhard Landauer <oberon@manjaro.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b5d1a891-efc0-e49e-ff91-4409c26491d2@manjaro.org>
 <751f296a-d26c-83a9-d105-e85f73fdcd06@manjaro.org>
 <CANznX5FDMU5z4bJEpBeF+WmknhHWpQNbSaa8okbJAZhKz71y5Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3d0c11f4-65a5-8425-e989-9e4cce3b896e@gmx.com>
Date: Mon, 14 Aug 2017 16:01:05 +0800
MIME-Version: 1.0
In-Reply-To: <CANznX5FDMU5z4bJEpBeF+WmknhHWpQNbSaa8okbJAZhKz71y5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月08日 21:19, Janos Toth F. wrote:
> I think you should consider using Linux 4.12 which has bfq (bfq-mq)
> for blk-mq. So, you don't need out-of-tree BFQ patches if you switch
> to blk-mq (but now you are free to do so even if you have HDDs or SSDs
> which benefit from software schedulers since you have some multi-queue
> schedulers for them). Just make sure to enable blk-mq (has to be a
> boot parameter or build-time choice) in order to gain access to
> bfq-mq. And remember that bfq-mq has to be activated manually (the
> build-time choice for a default scheduler is not valid for multi-queue
> schedulers, you will default to "none" which is effectively the new
> "no-op").
> Note: there is only one BFQ in 4.12 and it's bfq-mq which runs under
> the name of simply BFQ (not bfq-mq, I only used that name to make it
> clear that BFQ in 4.12 is a multi-queue version of BFQ).
> 
> I always wondered if Btrfs makes any use of FUA if it's enabled for
> compatible SATA devices (it's disabled by default because there are
> some drives with faulty firmware).

At least, if using blktrace, you could find that superblock write of 
btrfs is submitting bio using FWFSM (Flush, Write, FUA, Sync, Meta).

So for compatible SATA device, it is possible to use FUA.
It's block driver to emulate FUA by addressing Write then Flush for 
incompatible disk.

However, in my previous test with FUA compatible HDD (you could check 
kernel "Write cache:" line), it turns out that at least for DB workload, 
the performance improvement is hard to notice and sometimes even reduce 
the performance.

Maybe it's related to the workload (PostgreSQL), but FUA support may or 
may not affect performance as you expected.

Thanks,
Qu
> 
> I also wonder if RAID10 is any better (or actually worse?) for
> metadata (and system) chunks than RAID1.
> 
> On Tue, Aug 8, 2017 at 1:59 PM, Bernhard Landauer <oberon@manjaro.org> wrote:
>> Hello everyone
>>
>> I am looking for a way to test different available schedulers with Manjaro's
>> bfq-patched kernels on sytems with both SSD and spinning drives. Since
>> phoronix-test-suite apparently is currently useless for this task due to its
>> bad config for bfq I am looking for alternatives. Do you have any
>> suggestions for me?
>> Thank you.
>>
>> kind regards
>> Bernhard Landauer
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
