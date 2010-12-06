From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 06 Dec 2010 14:13:00 +0100
Message-ID: <BbNRb6Ey1uB@helmut.hullen.de>
References: <20101206124851.GC4273@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206124851.GC4273@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.12.10:

>>>> But after copying about 300 MByte (part of a 1.5-GByte *.mpg) I
>>>> got "no space left on device". Looks like balancing has stolen
>>>> about 300 GByte.
>>
>>>    This sounds exactly like a problem I've had. What output do you
>>> get from "btrfs fi df /srv/MM"?
>>
>> I've just written a script for gathering the (perhaps) interesting
>> data ...
>>
>> # btrfs filesystem show
>> Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
>> 	Total devices 2 FS bytes used 2.37TB
>> 	devid    2 size 1.35TB used 1.20TB path /dev/sdc3
>> 	devid    1 size 1.81TB used 1.20TB path /dev/sdf2
>>
>> Btrfs Btrfs v0.19
>>
>> # btrfs filesystem df /srv/MM
>> Data: total=2.39TB, used=2.37TB
>> Metadata: total=5.25GB, used=3.51GB
>> System: total=12.00MB, used=188.00KB

>    Can you try that again with either the latest 2.6.37-rc, or with
> the btrfs-unstable kernel? There's a bug in earlier versions that
> breaks the reporting of RAID types, which is what I wanted to see
> here.

Do you mean

  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

as "btrfs-unstable kernel"?

Compiling 2.6.37-rc is no big problem, it only needs som time.

Just now I'm using

Kernel 2.6.35.8
btrfs-git from 20101117

>> I've moved about 50 Gbyte away from "srv/MM" in the meantime, before
>> running the script with this output.
>>
>> And I don't dare running "balance" again - maybe it reduces the
>> available space again and again.

>    If you've hit the bug I think you have, then yes, it will.

Hmm - it can't get worse ...
If the error is related to the kernel or to the btrfs version and I try  
a newer one: can that lead to more free space?

Viele Gruesse!
Helmut
