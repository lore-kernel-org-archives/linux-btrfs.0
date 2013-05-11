Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46786 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3EKKOa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 06:14:30 -0400
Received: by mail-ea0-f171.google.com with SMTP id b15so839850eae.30
        for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 03:14:29 -0700 (PDT)
Message-ID: <518E1A00.8000401@gmail.com>
Date: Sat, 11 May 2013 12:14:24 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Marcus_L=F6vgren?= <marcuslvgrn@gmail.com>,
        Remco Hosman - Yerf IT <remco@yerf-it.nl>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs balance invalid argument error
References: <CAB_++mrnzWd9BNHMEK=k7rVdV1x+VjX7JW2ANnEaJ_i1PG-rUA@mail.gmail.com> <20130510202126.GE26072@carfax.org.uk> <2549B5BE-9254-4E57-A7F1-82CAD2EE0E30@yerf-it.nl> <CAB_++moSXQVBq=dLKHiUk3acL6Rhn9r1BAdPAFb+FphrzjHD2Q@mail.gmail.com> <20130510214618.GG26072@carfax.org.uk>
In-Reply-To: <20130510214618.GG26072@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 05/10/2013 11:46 PM, Hugo Mills wrote:
> On Fri, May 10, 2013 at 11:43:34PM +0200, Marcus Lövgren wrote:
>> Yes, you were right! Adding another drive to the array made it continue
>> without errors. Is this already reported as a bug?
>
>    I believe it has been, yes. I think we've even had a patch out for
> it. I haven't looked to see if it's got into 3.10.
>
Yes, there is a patch but as far as I've seen it didn't hit 3.10 (yet).
I'll repost it immediately.

Thanks for reminding me on that,
Andreas

>    Hugo.
>
>> Thanks for the help,
>> Marcus
>>
>>
>> 2013/5/10 Remco Hosman - Yerf IT <remco@yerf-it.nl>
>>
>>> On May 10, 2013, at 10:21 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>
>>>> On Fri, May 10, 2013 at 10:07:56PM +0200, Marcus Lövgren wrote:
>>>>> Hi list,
>>>>>
>>>>> I am using kernel 3.9.0, btrfs-progs 0.20-rc1-253-g7854c8b.
>>>>>
>>>>> I have a three disk array of level single:
>>>>>
>>>>> # btrfs fi sh
>>>>> Label: none  uuid: 2e905f8f-e525-4114-afa6-cce48f77b629
>>>>>        Total devices 3 FS bytes used 3.80TB
>>>>>        devid    1 size 2.73TB used 2.25TB path /dev/sdd
>>>>>        devid    2 size 2.73TB used 1.55TB path /dev/sdc
>>>>>        devid    3 size 2.73TB used 0.00 path /dev/sdb
>>>>>
>>>>> Btrfs v0.20-rc1-253-g7854c8b
>>>>>
>>>>> # btrfs fi df /mnt/data
>>>>> Data: total=3.79TB, used=3.79TB
>>>>> System: total=4.00MB, used=420.00KB
>>>>> Metadata: total=6.01GB, used=4.87GB
>>>>>
>>>>>
>>>>> When running
>>>>> # btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/data
>>>>>
>>>>> I get
>>>>>
>>>>> ERROR: error during balancing '/mnt/data' - Invalid argument
>>>>> There may be more info in syslog - try dmesg | tail
>>>>>
>>>>> dmesg | tail says:
>>>>>
>>>>> btrfs: unable to start balance with target data profile 128
>>>>>
>>>>> Isn't it possible to convert raid level to raid5?
>>>>
>>>>   Yes, it should be possible. It looks like the kernel's got a
>>>> problem with it, which is odd because 3.9 should know about RAID-5.
>>>>
>>>
>>> Wasn't there some issues that the kernel or tools wanted 4 disks when
>>> converting to raid5?
>>>
>>> Remco
>>>
>>>>   Hugo.
>>>>
>


