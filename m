Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:39696 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbeGPTSM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 15:18:12 -0400
Received: by mail-it0-f68.google.com with SMTP id 198-v6so14696353ite.4
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 11:49:30 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: kreijack@inwind.it, waxhead@dirtcellar.net,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1f32e709-4505-9f04-ff6c-41894761cd84@gmail.com>
Date: Mon, 16 Jul 2018 14:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-16 14:29, Goffredo Baroncelli wrote:
> On 07/15/2018 04:37 PM, waxhead wrote:
>> David Sterba wrote:
>>> An interesting question is the naming of the extended profiles. I picked
>>> something that can be easily understood but it's not a final proposal.
>>> Years ago, Hugo proposed a naming scheme that described the
>>> non-standard raid varieties of the btrfs flavor:
>>>
>>> https://marc.info/?l=linux-btrfs&m=136286324417767
>>>
>>> Switching to this naming would be a good addition to the extended raid.
>>>
>> As just a humble BTRFS user I agree and really think it is about time to move far away from the RAID terminology. However adding some more descriptive profile names (or at least some aliases) would be much better for the commoners (such as myself).
>>
>> For example:
>>
>> Old format / New Format / My suggested alias
>> SINGLE  / 1C     / SINGLE
>> DUP     / 2CD    / DUP (or even MIRRORLOCAL1)
>> RAID0   / 1CmS   / STRIPE
> 
> 
>> RAID1   / 2C     / MIRROR1
>> RAID1c3 / 3C     / MIRROR2
>> RAID1c4 / 4C     / MIRROR3
>> RAID10  / 2CmS   / STRIPE.MIRROR1
> 
> Striping and mirroring/pairing are orthogonal properties; mirror and parity are mutually exclusive. What about
> 
> RAID1 -> MIRROR1
> RAID10 -> MIRROR1S
> RAID1c3 -> MIRROR2
> RAID1c3+striping -> MIRROR2S
> 
> and so on...
> 
>> RAID5   / 1CmS1P / STRIPE.PARITY1
>> RAID6   / 1CmS2P / STRIPE.PARITY2
> 
> To me these should be called something like
> 
> RAID5 -> PARITY1S
> RAID6 -> PARITY2S
> 
> The S final is due to the fact that usually RAID5/6 spread the data on all available disks
> 
> Question #1: for "parity" profiles, does make sense to limit the maximum disks number where the data may be spread ? If the answer is not, we could omit the last S. IMHO it should.
Currently, there is no ability to cap the number of disks that striping 
can happen across.  Ideally, that will change in the future, in which 
case not only the S will be needed, but also a number indicating how 
wide the stripe is.

> Question #2: historically RAID10 is requires 4 disks. However I am guessing if the stripe could be done on a different number of disks: What about RAID1+Striping on 3 (or 5 disks) ? The key of striping is that every 64k, the data are stored on a different disk....
This is what MD and LVM RAID10 do.  They work somewhat differently from 
what BTRFS calls raid10 (actually, what we currently call raid1 works 
almost identically to MD and LVM RAID10 when more than 3 disks are 
involved, except that the chunk size is 1G or larger).  Short of drastic 
internal changes to how that profile works, this isn't likely to happen.

In spite of both of these, there is practical need for indicating the 
stripe width.  Depending on the configuration of the underlying storage, 
it's fully possible (and sometimes even certain) that you will see 
chunks with differing stripe widths, so properly reporting the stripe 
width (in devices, not bytes) is useful for monitoring purposes).

Consider for example a 6-device array using what's currently called a 
raid10 profile where 2 of the disks are smaller than the other four.  On 
such an array, chunks will span all six disks (resulting in 2 copies 
striped across 3 disks each) until those two smaller disks are full, at 
which point new chunks will span only the remaining four disks 
(resulting in 2 copies striped across 2 disks each).
