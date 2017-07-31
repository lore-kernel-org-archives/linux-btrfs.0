Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35913 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdGaLwS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 07:52:18 -0400
Received: by mail-io0-f182.google.com with SMTP id g35so77386929ioi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 04:52:18 -0700 (PDT)
Subject: Re: Best Practice: Add new device to RAID1 pool (Summary)
To: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
 <18d96f74-00a8-9bb9-dddc-f50940d0971e@gmail.com>
 <1500905566.2781.8.camel@cloud.haefemeier.eu>
 <4b768b97-2c0b-bf67-dec0-1c5a1f7181b2@gmail.com>
 <1500914457.2781.10.camel@cloud.haefemeier.eu>
 <1501369468.2795.1.camel@cloud.haefemeier.eu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <cc38811f-98fe-1612-e34a-8ba8125a0d00@gmail.com>
Date: Mon, 31 Jul 2017 07:52:15 -0400
MIME-Version: 1.0
In-Reply-To: <1501369468.2795.1.camel@cloud.haefemeier.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-29 19:04, Cloud Admin wrote:
> Am Montag, den 24.07.2017, 18:40 +0200 schrieb Cloud Admin:
>> Am Montag, den 24.07.2017, 10:25 -0400 schrieb Austin S. Hemmelgarn:
>>> On 2017-07-24 10:12, Cloud Admin wrote:
>>>> Am Montag, den 24.07.2017, 09:46 -0400 schrieb Austin S.
>>>> Hemmelgarn:
>>>>> On 2017-07-24 07:27, Cloud Admin wrote:
>>>>>> Hi,
>>>>>> I have a multi-device pool (three discs) as RAID1. Now I want
>>>>>> to
>>>>>> add a
>>>>>> new disc to increase the pool. I followed the description on
>>>>>> https:
>>>>>> //bt
>>>>>> rfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devic
>>>>>> es
>>>>>> and
>>>>>> used 'btrfs add <device> <btrfs path>'. After that I called a
>>>>>> balance
>>>>>> for rebalancing the RAID1 using 'btrfs balance start <btrfs
>>>>>> path>'.
>>>>>> Is that anything or should I need to call a resize (for
>>>>>> example) or
>>>>>> anything else? Or do I need to specify filter/profile
>>>>>> parameters
>>>>>> for
>>>>>> balancing?
>>>>>> I am a little bit confused because the balance command is
>>>>>> running
>>>>>> since
>>>>>> 12 hours and only 3GB of data are touched. This would mean
>>>>>> the
>>>>>> whole
>>>>>> balance process (new disc has 8TB) would run a long, long
>>>>>> time...
>>>>>> and
>>>>>> is using one cpu by 100%.
>>>>>
>>>>> Based on what you're saying, it sounds like you've either run
>>>>> into a
>>>>> bug, or have a huge number of snapshots on this filesystem.
>>>>
>>>> It depends what you define as huge. The call of 'btrfs sub list
>>>> <btrfs
>>>> path>' returns a list of 255 subvolume.
>>>
>>> OK, this isn't horrible, especially if most of them aren't
>>> snapshots
>>> (it's cross-subvolume reflinks that are most of the issue when it
>>> comes
>>> to snapshots, not the fact that they're subvolumes).
>>>> I think this is not too huge. The most of this subvolumes was
>>>> created
>>>> using docker itself. I cancel the balance (this will take awhile)
>>>> and will try to delete such of these subvolumes/snapshots.
>>>> What can I do more?
>>>
>>> As Roman mentioned in his reply, it may also be qgroup related.  If
>>> you run:
>>> btrfs quota disable
>>
>> It seems quota was one part of it. Thanks for the tip. I disabled and
>> started balance new.
>> Now approx. each 5 min. one chunk will be relocated. But if I take
>> the
>> reported 10860 chunks and calc. the time it will take ~37 days to
>> finish... So, it seems I have to investigate more time into figure
>> out
>> the subvolume / snapshots structure created by docker.
>> A first deeper look shows, there is a subvolume with a snapshot,
>> which
>> has itself a snapshot, and so forth.
>>>
>>>
> Now, the balance process finished after 127h the new disc is in the
> pool... Not so long as expected but in my opinion long enough. Quota
> seems one big driver in my case. What I could see over the time at the
> beginning many extends was relocated ignoring the new disc. Properly it
> could be a good idea to rebalance using filter (like -dusage=30 for
> example) before add the new disc to decrease the time.
> But only theory. It will try to keep it in my mind for the next time.
FWIW, in my own experience, I've found that this does help, although I 
usually use '-dusage=50 -musage=50'.  The same goes for converting to a 
different profile, as in both cases, balance seems to naively assume 
that there is only one partially filled chunk (optimal behavior differs 
between that and the realistic case).
