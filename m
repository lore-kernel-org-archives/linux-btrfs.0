Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37404 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbdGXVVB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 17:21:01 -0400
Received: by mail-wm0-f68.google.com with SMTP id m4so16656401wmi.4
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 14:21:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aac851d3-4187-fc94-bdcb-e79b83b74da8@dirtcellar.net>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu> <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
 <aac851d3-4187-fc94-bdcb-e79b83b74da8@dirtcellar.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 24 Jul 2017 15:20:59 -0600
Message-ID: <CAJCQCtTnShjzumppLPYWzc3nXfKoTads91dtfLk8UoQ3w4_P+Q@mail.gmail.com>
Subject: Re: Best Practice: Add new device to RAID1 pool
To: waxhead <waxhead@dirtcellar.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Cloud Admin <admin@cloud.haefemeier.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 3:12 PM, waxhead <waxhead@dirtcellar.net> wrote:
>
>
> Chris Murphy wrote:
>>
>> On Mon, Jul 24, 2017 at 5:27 AM, Cloud Admin <admin@cloud.haefemeier.eu>
>> wrote:
>>
>>> I am a little bit confused because the balance command is running since
>>> 12 hours and only 3GB of data are touched.
>>
>> That's incredibly slow. Something isn't right.
>>
>> Using btrfs-debug -b from btrfs-progs, I've selected a few 100% full
>> chunks.
>>
>> [156777.077378] f26s.localdomain sudo[13757]:    chris : TTY=pts/2 ;
>> PWD=/home/chris ; USER=root ; COMMAND=/sbin/btrfs balance start
>> -dvrange=157970071552..159043813376 /
>> [156773.328606] f26s.localdomain kernel: BTRFS info (device sda1):
>> relocating block group 157970071552 flags data
>> [156800.408918] f26s.localdomain kernel: BTRFS info (device sda1):
>> found 38952 extents
>> [156861.343067] f26s.localdomain kernel: BTRFS info (device sda1):
>> found 38951 extents
>>
>> That 1GiB chunk with quite a few fragments took 88s. That's 11MB/s.
>> Even for a hard drive, that's slow. I
>
> This may be a stupid question , but are your pool of butter (or BTRFS pool)
> by any chance hooked up via USB? If this is USB2.0 at 480mitb/s then it is
> about 57MB/s / 4 drives = roughly 14.25 or about 11MB/s if you shave off
> some overhead.
>

Nope, USB 3. Typically on scrubs I get 110MB/s that winds down to
60MB/s as it progresses to the slow parts of the disk.


-- 
Chris Murphy
