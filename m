Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35599 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753965AbdIDUgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 16:36:00 -0400
Received: by mail-oi0-f48.google.com with SMTP id n18so11177347oig.2
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 13:36:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <05997689-bcdb-d136-a35a-6c0c7beeb1c0@profihost.ag>
References: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
 <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com>
 <e43a6dea-0e4c-50e4-da0d-03ac3ab9a97f@profihost.ag> <CAGqmi7537YtkTLfkk8tUoA5Zn9SMvUoGicg+R_4Nm6LupALEow@mail.gmail.com>
 <05997689-bcdb-d136-a35a-6c0c7beeb1c0@profihost.ag>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 4 Sep 2017 23:35:19 +0300
Message-ID: <CAGqmi76_WpVTfaSNJK4GV=Xsf7KcF_A8EJCbHLFPoPXO-ai4ag@mail.gmail.com>
Subject: Re: speed up big btrfs volumes with ssds
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Henk Slager <eye1tm@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-04 21:32 GMT+03:00 Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:
>> May be you can make work your raid setup faster by:
>> 1. Use Single Profile
>
> I'm already using the raid0 profile - see below:

If i understand correctly, you have a very big data set with random RW
access, so:
I'm saying about single profile for compact writes to one device, that
can make WB cache more effective
Because writes will not spread on several devices and as result that
increase chance that full stripe will be overwriten
That's will just work as raid0 with very big stripe size.

> Data,RAID0: Size:22.57TiB, Used:21.08TiB
> Metadata,RAID0: Size:90.00GiB, Used:82.28GiB
> System,RAID0: Size:64.00MiB, Used:1.53MiB
>
>> 2. Use different stripe size for HW RAID5:
>>     i think 16kb will be optimal with 5 devices per raid group
>>     That will give you 64kb data stripe and 16kb parity
>>     Btrfs raid0 use 64kb as stripe so that can make data access
>> unaligned (or use single profile for btrfs)
>
> That sounds like an interesting idea except for the unaligned writes.
> Will need to test this.

Afaik btrfs also use 64kb for metadata:
https://github.com/torvalds/linux/blob/e26f1bea3b833fb2c16fb5f0a949da1efa219de3/fs/btrfs/extent-tree.c#L6678

>> 3. Use btrfs ssd_spread to decrease RMW cycles.
> Can you explain this?

Long description:
https://www.spinics.net/lists/linux-btrfs/msg67515.html

Short:
that option will change allocator logic.
Allocator will spread writes more aggressively and always try write to
new/empty area.
So in theory that will write new data to new empty chunk, so if you
have much free space that will make some guaranty to not touch old
data, so not do RWM and in theory always do full stripe write.

But if you expect that you array will be near full and you don't want
do defragment on that, that can easy get you enospace error.

> Stefan

That just my IMHO,
Thanks.
-- 
Have a nice day,
Timofey.
