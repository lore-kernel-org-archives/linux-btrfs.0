Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53827 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3EJVpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 17:45:17 -0400
Received: by mail-qc0-f173.google.com with SMTP id c11so2480216qcv.4
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 14:45:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2549B5BE-9254-4E57-A7F1-82CAD2EE0E30@yerf-it.nl>
References: <CAB_++mrnzWd9BNHMEK=k7rVdV1x+VjX7JW2ANnEaJ_i1PG-rUA@mail.gmail.com>
	<20130510202126.GE26072@carfax.org.uk>
	<2549B5BE-9254-4E57-A7F1-82CAD2EE0E30@yerf-it.nl>
Date: Fri, 10 May 2013 23:45:16 +0200
Message-ID: <CAB_++mrGbVJ0CjqcOmbkWdUTakEVPTHGJWC4kmEo+To82stYpA@mail.gmail.com>
Subject: Re: Btrfs balance invalid argument error
From: =?ISO-8859-1?Q?Marcus_L=F6vgren?= <marcuslvgrn@gmail.com>
To: Remco Hosman - Yerf IT <remco@yerf-it.nl>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, you were right! Adding another drive to the array made it
continue without errors. Is this already reported as a bug?

Thanks for the help,
Marcus

2013/5/10 Remco Hosman - Yerf IT <remco@yerf-it.nl>:
> On May 10, 2013, at 10:21 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>> On Fri, May 10, 2013 at 10:07:56PM +0200, Marcus Lövgren wrote:
>>> Hi list,
>>>
>>> I am using kernel 3.9.0, btrfs-progs 0.20-rc1-253-g7854c8b.
>>>
>>> I have a three disk array of level single:
>>>
>>> # btrfs fi sh
>>> Label: none  uuid: 2e905f8f-e525-4114-afa6-cce48f77b629
>>>        Total devices 3 FS bytes used 3.80TB
>>>        devid    1 size 2.73TB used 2.25TB path /dev/sdd
>>>        devid    2 size 2.73TB used 1.55TB path /dev/sdc
>>>        devid    3 size 2.73TB used 0.00 path /dev/sdb
>>>
>>> Btrfs v0.20-rc1-253-g7854c8b
>>>
>>> # btrfs fi df /mnt/data
>>> Data: total=3.79TB, used=3.79TB
>>> System: total=4.00MB, used=420.00KB
>>> Metadata: total=6.01GB, used=4.87GB
>>>
>>>
>>> When running
>>> # btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/data
>>>
>>> I get
>>>
>>> ERROR: error during balancing '/mnt/data' - Invalid argument
>>> There may be more info in syslog - try dmesg | tail
>>>
>>> dmesg | tail says:
>>>
>>> btrfs: unable to start balance with target data profile 128
>>>
>>> Isn't it possible to convert raid level to raid5?
>>
>>   Yes, it should be possible. It looks like the kernel's got a
>> problem with it, which is odd because 3.9 should know about RAID-5.
>>
>
> Wasn't there some issues that the kernel or tools wanted 4 disks when converting to raid5?
>
> Remco
>
>>   Hugo.
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>    --- I think that everything darkling says is actually a joke. ---
>>         It's just that we haven't worked out most of them yet.
>
