Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33741 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdBFNTx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 08:19:53 -0500
Received: by mail-it0-f68.google.com with SMTP id e137so8551444itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Feb 2017 05:19:52 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id e24sm4223404itd.6.2017.02.06.05.19.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Feb 2017 05:19:40 -0800 (PST)
Subject: Re: Very slow balance / btrfs-transaction
To: linux-btrfs@vger.kernel.org
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <1f5f66cfa8eca19b7e612e3b4745d788@85337f6d4fa4>
 <20170204221051.664ada65@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <403247fe-376f-27d7-bbd5-d8acd260a8ad@gmail.com>
Date: Mon, 6 Feb 2017 08:19:37 -0500
MIME-Version: 1.0
In-Reply-To: <20170204221051.664ada65@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-04 16:10, Kai Krakow wrote:
> Am Sat, 04 Feb 2017 20:50:03 +0000
> schrieb "Jorg Bornschein" <jb@capsec.org>:
>
>> February 4, 2017 1:07 AM, "Goldwyn Rodrigues" <rgoldwyn@suse.de>
>> wrote:
>>
>>> Yes, please check if disabling quotas makes a difference in
>>> execution time of btrfs balance.
>>
>> Just FYI: With quotas disabled it took ~20h to finish the balance
>> instead of the projected >30 days. Therefore, in my case, there was a
>> speedup of factor ~35.
>>
>>
>> and thanks for the quick reply! (and for btrfs general!)
>>
>>
>> BTW: I'm wondering how much sense it makes to activate the underlying
>> bcache for my raid1 fs again. I guess btrfs chooses randomly (or
>> based predicted of disk latency?) which copy of a given extend to
>> load?
>
> As far as I know, it uses PID modulo only currently, no round-robin,
> no random value. There are no performance optimizations going into btrfs
> yet because there're still a lot of ongoing feature implementations.
>
> I think there were patches to include a rotator value in the stripe
> selection. They don't apply to the current kernel. I tried it once and
> didn't see any subjective difference for normal desktop workloads. But
> that's probably because I use RAID1 for metadata only.
I had tested similar patches myself using raid1 for everything, and saw 
near zero improvement unless I explicitly tried to create a worst-case 
performance situation.  The reality is that the current algorithm is 
actually remarkably close to being optimal for most use cases while 
using an insanely small amount of processing power and memory compared 
to an optimal algorithm (and a truly optimal algorithm is in fact 
functionally impossible in almost all cases because it would require 
predicting the future).
>
> MDRAID uses stripe selection based on latency and other measurements
> (like head position). It would be nice if btrfs implemented similar
> functionality. This would also be helpful for selecting a disk if
> there're more disks than stripesets (for example, I have 3 disks in my
> btrfs array). This could write new blocks to the most idle disk always.
> I think this wasn't covered by the above mentioned patch. Currently,
> selection is based only on the disk with most free space.
You're confusing read selection and write selection.  MDADM and DM-RAID 
both use a load-balancing read selection algorithm that takes latency 
and other factors into account.  However, they use a round-robin write 
selection algorithm that only cares about the position of the block in 
the virtual device modulo the number of physical devices.

As an example, say you have a 3 disk RAID10 array set up using MDADM 
(this is functionally the same as a 3-disk raid1 mode BTRFS filesystem). 
  Every third block starting from block 0 will be on disks 1 and 2, 
every third block starting from block 1 will be on disks 3 and 1, and 
every third block starting from block 2 will be on disks 2 and 3.  No 
latency measurements are taken, literally nothing is factored in except 
the block's position in the virtual device.

Now, that said, BTRFS does behave differently under the same 
circumstances, but this is because the striping is different for BTRFS. 
It happens at the chunk level instead of the block level.  If we look at 
an example using the same 3 devices as the MDADM example, and then for 
simplicity assume that you end up allocating alternating data and 
metadata chunks, things might look a bit like this:
* System chunk: Device 1 and 2
* Metadata chunk 0: Device 3 and 1
* Data chunk 0: Device 2 and 3
* Metadata chunk 1: Device 1 and 2
* Data chunk 1: Device 1 and 2
Overall, there is technically a pattern, but it's got a very long 
repetition period.  This is still however a near optimal allocation 
pattern given the constraints.  It also gives (just like the MDADM and 
DM-RAID method) 100% deterministic behavior, the only difference is it 
depends on a slightly different factor.  Changing this to select the 
most idle disk as you suggest would remove that determinism, increase 
the likelihood of sub-optimal layouts in terms of space usage, increase 
the number of cases where you could get ENOSPC, and provide near zero 
net performance benefit except under heavy load.  IOW, it would provide 
a pretty negative net benefit.

What actually needs to happen to improve write performance is that BTRFS 
needs to quit serializing writes when writing chunks across multiple 
devices.  In the case of a raid1 setup, it writes first to one device, 
then the other, alternating back and forth as it updates each extent. 
This combined with the COW behavior causing write amplification is what 
makes write performance so horrible for BTRFS compared to MDADM or 
DM-RAID.  It's not that we have bad device selection for writes, it's 
that we don't even try to do any kind of practical parallelization 
despite it being an embarrassingly parallel task (and yes, that 
seriously is what something that's trivial to parallelize is called in 
scientific papers...).
