Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:14112 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753669AbdIDM5T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 08:57:19 -0400
Subject: Re: speed up big btrfs volumes with ssds
To: Henk Slager <eye1tm@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
 <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <e43a6dea-0e4c-50e4-da0d-03ac3ab9a97f@profihost.ag>
Date: Mon, 4 Sep 2017 14:57:18 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 04.09.2017 um 12:53 schrieb Henk Slager:
> On Sun, Sep 3, 2017 at 8:32 PM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
>> Hello,
>>
>> i'm trying to speed up big btrfs volumes.
>>
>> Some facts:
>> - Kernel will be 4.13-rc7
>> - needed volume size is 60TB
>>
>> Currently without any ssds i get the best speed with:
>> - 4x HW Raid 5 with 1GB controller memory of 4TB 3,5" devices
>>
>> and using btrfs as raid 0 for data and metadata on top of those 4 raid 5.
>>
>> I can live with a data loss every now and and than ;-) so a raid 0 on
>> top of the 4x radi5 is acceptable for me.
>>
>> Currently the write speed is not as good as i would like - especially
>> for random 8k-16k I/O.
>>
>> My current idea is to use a pcie flash card with bcache on top of each
>> raid 5.
> 
> If it can speed up depends quite a lot on what the use-case is, for
> some not-so-much-parallel-access it might work. So this 60TB is then
> 20 4TB disks or so and the 4x 1GB cache is simply not very helpful I
> think. The working set doesn't fit in it I guess. If there is mostly
> single or a few users of the fs, a single pcie based bcacheing 4
> devices can work, but for SATA SSD, I would use 1 SSD per HWraid5.

Yes that's roughly my idea as well and yes the workload is 4 users max
writing data. 50% sequential, 50% random.

> Then roughly make sure the complete set of metadata blocks fits in the
> cache. For an fs of this size let's say/estimate 150G. Then maybe same
> of double for data, so an SSD of 500G would be a first try.

I would use 1TB devices for each Raid or a 4TB PCIe card.

> You give the impression that reliability for this fs is not the
> highest prio, so if you go full risk, then put bcache in write-back
> mode, then you will have your desired random 8k-16k I/O speedup after
> the cache is warmed up. But any SW or HW failure wil result in total
> fs loss normally if SSD and HDD get out of sync somehow. Bcache
> write-through might also be acceptable, you will need extensive
> monitoring and tuning of all (bcache) parameters etc to be sure of the
> right choice of size and setup etc.

Yes i wanted to use the write back mode. Has anybody already made some
test or experience with a setup like this?

Greets,
Stefan
