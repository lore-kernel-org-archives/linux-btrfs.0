Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:53100 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3EJUZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 16:25:06 -0400
Received: by mail-we0-f180.google.com with SMTP id n5so4225958wev.25
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 13:25:05 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Btrfs balance invalid argument error
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
In-Reply-To: <20130510202126.GE26072@carfax.org.uk>
Date: Fri, 10 May 2013 22:25:02 +0200
Cc: =?iso-8859-1?Q?Marcus_L=F6vgren?= <marcuslvgrn@gmail.com>,
        linux-btrfs@vger.kernel.org
Message-Id: <2549B5BE-9254-4E57-A7F1-82CAD2EE0E30@yerf-it.nl>
References: <CAB_++mrnzWd9BNHMEK=k7rVdV1x+VjX7JW2ANnEaJ_i1PG-rUA@mail.gmail.com> <20130510202126.GE26072@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 10, 2013, at 10:21 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Fri, May 10, 2013 at 10:07:56PM +0200, Marcus Lövgren wrote:
>> Hi list,
>> 
>> I am using kernel 3.9.0, btrfs-progs 0.20-rc1-253-g7854c8b.
>> 
>> I have a three disk array of level single:
>> 
>> # btrfs fi sh
>> Label: none  uuid: 2e905f8f-e525-4114-afa6-cce48f77b629
>>        Total devices 3 FS bytes used 3.80TB
>>        devid    1 size 2.73TB used 2.25TB path /dev/sdd
>>        devid    2 size 2.73TB used 1.55TB path /dev/sdc
>>        devid    3 size 2.73TB used 0.00 path /dev/sdb
>> 
>> Btrfs v0.20-rc1-253-g7854c8b
>> 
>> # btrfs fi df /mnt/data
>> Data: total=3.79TB, used=3.79TB
>> System: total=4.00MB, used=420.00KB
>> Metadata: total=6.01GB, used=4.87GB
>> 
>> 
>> When running
>> # btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/data
>> 
>> I get
>> 
>> ERROR: error during balancing '/mnt/data' - Invalid argument
>> There may be more info in syslog - try dmesg | tail
>> 
>> dmesg | tail says:
>> 
>> btrfs: unable to start balance with target data profile 128
>> 
>> Isn't it possible to convert raid level to raid5?
> 
>   Yes, it should be possible. It looks like the kernel's got a
> problem with it, which is odd because 3.9 should know about RAID-5.
> 

Wasn't there some issues that the kernel or tools wanted 4 disks when converting to raid5?

Remco

>   Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>    --- I think that everything darkling says is actually a joke. ---    
>         It's just that we haven't worked out most of them yet.          

