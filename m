Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36763 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbcF2S13 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 14:27:29 -0400
Received: by mail-io0-f180.google.com with SMTP id s63so53569313ioi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 11:27:29 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id c89sm2253826iod.1.2016.06.29.11.19.24
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2016 11:19:25 -0700 (PDT)
Subject: Re: Kernel bug during RAID1 replace
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20160627233612.662d2a9a@system>
 <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system>
 <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
 <20160628010618.58e235fa@system>
 <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
 <20160628024940.3b323b26@system>
 <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
 <20160629005208.5e9addcf@system>
 <CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
 <20160629115055.29018e6a@system>
 <CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
 <20160629201208.275b37ad@system>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <16e65a07-03b6-2540-fc96-3538c5bc5c99@gmail.com>
Date: Wed, 29 Jun 2016 14:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <20160629201208.275b37ad@system>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-29 14:12, Saint Germain wrote:
> On Wed, 29 Jun 2016 11:28:24 -0600, Chris Murphy
> <lists@colorremedies.com> wrote :
>
>>> Already got a backup. I just really want to try to repair it (in
>>> order to test BTRFS).
>>
>> I don't know that this is a good test because I think the file system
>> has already been sufficient corrupted that it can't be fixed. Part of
>> the problem is that Btrfs isn't aware of faulty drives like mdadm or
>> lvm yet, so it looks like it'll try to write to all devices and it's
>> possible for significant confusion to happen if they're each getting
>> different generation writes. Significant as in, currently beyond
>> repair.
>>
>>>>> On the other hand it seems interesting to repair instead of just
>>>>> giving up. It gives a good look at BTRFS resiliency/reliability.
>>>>
>>>> On the one hand Btrfs shouldn't become inconsistent in the first
>>>> place, that's the design goal. On the other hand, I'm finding from
>>>> the problems reported on the list that Btrfs increasingly mounts
>>>> at least read only and allows getting data off, even when the file
>>>> system isn't fully functional or repairable.
>>>>
>>>> In your case, once there are metadata problems even with raid 1,
>>>> it's difficult at best. But once you have the backup you could try
>>>> some other things once it's certain the hardware isn't adding to
>>>> the problems, which I'm still not yet certain of.
>>>>
>>>
>>> I'm ready to try anything. Let's experiment.
>>
>> I kinda think it's a waste of time. Someone else maybe has a better
>> idea?
>>
>> I think your time is better spent finding out when and why the device
>> with all of these write errors happened. It must have gone missing for
>> a while, and you need to find out why that happened and prevent it; OR
>> you have to be really vigilent at every mount time to make sure both
>> devices have the same transid (generation). In my case when I tried to
>> sabotage this, being of by a generation of 1 wasn't a problem for
>> Btrfs to automatically fix up but I suspect it was only a generation
>> mismatch in the superblock.
>>
>
> Ok I will follow your advice and start over with a fresh BTRFS volume.
> As explained on another email, rsync doesn't support reflink, so do you
> think it is worth trying with BTRFS send instead ?
> Is it safe to copy this way or rsync is more reliable in case of faulty
> BTRFS volume ?
>
If you have the space, btrfs restore would probably be the best option. 
It's not likely, but using send has a risk of contaminating the new 
filesystem as well.

