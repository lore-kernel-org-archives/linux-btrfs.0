Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:51076 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966578AbeFSQ6s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:58:48 -0400
Received: by mail-it0-f67.google.com with SMTP id u4-v6so1401940itg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 09:58:48 -0700 (PDT)
Subject: Re: btrfs balance did not progress after 12H
To: james harvey <jamespharvey20@gmail.com>, Marc MERLIN <marc@merlins.org>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20180618130055.3rzngk5a5sktfp7p@merlins.org>
 <20180619154730.fblylttw2nyps4cp@merlins.org>
 <CA+X5Wn5_TEH5zwWS8cihnadK_hFg9CL6NcT9Q28mDxtZK97Beg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ab17f789-d475-9812-9c76-83702fc2bd65@gmail.com>
Date: Tue, 19 Jun 2018 12:58:44 -0400
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5_TEH5zwWS8cihnadK_hFg9CL6NcT9Q28mDxtZK97Beg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-19 12:30, james harvey wrote:
> On Tue, Jun 19, 2018 at 11:47 AM, Marc MERLIN <marc@merlins.org> wrote:
>> On Mon, Jun 18, 2018 at 06:00:55AM -0700, Marc MERLIN wrote:
>>> So, I ran this:
>>> gargamel:/mnt/btrfs_pool2# btrfs balance start -dusage=60 -v .  &
>>> [1] 24450
>>> Dumping filters: flags 0x1, state 0x0, force is off
>>>    DATA (flags 0x2): balancing, usage=60
>>> gargamel:/mnt/btrfs_pool2# while :; do btrfs balance status .; sleep 60; done
>>> 0 out of about 0 chunks balanced (0 considered), -nan% left
> 
> This (0/0/0, -nan%) seems alarming.  I had this output once when the
> system spontaneously rebooted during a balance.  I didn't have any bad
> effects afterward.
> 
>>> Balance on '.' is running
>>> 0 out of about 73 chunks balanced (2 considered), 100% left
>>> Balance on '.' is running
>>>
>>> After about 20mn, it changed to this:
>>> 1 out of about 73 chunks balanced (6724 considered),  99% left
> 
> This seems alarming.  I wouldn't think # considered should ever exceed
> # chunks.  Although, it does say "about", so maybe it can a little
> bit, but I wouldn't expect it to exceed it by this much.
Actually, output like this is not unusual.  In the above line, the 1 is 
how many chunks have been actually processed, the 73 is how many the 
command expects to process (that is, the count of chunks that fit the 
filtering requirements, in this case, ones which are 60% or less full), 
and the 6724 is how many it has checked against the filtering 
requirements.  So, if you've got a very large number of chunks, and are 
selecting a small number with filters, then the considered value is 
likely to be significantly higher than the first two.
> 
>>> Balance on '.' is running
>>>
>>> Now, 12H later, it's still there, only 1 out of 73.
>>>
>>> gargamel:/mnt/btrfs_pool2# btrfs fi show .
>>> Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
>>>          Total devices 1 FS bytes used 12.72TiB
>>>          devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
>>>
>>> gargamel:/mnt/btrfs_pool2# btrfs fi df .
>>> Data, single: total=13.57TiB, used=12.60TiB
>>> System, DUP: total=32.00MiB, used=1.55MiB
>>> Metadata, DUP: total=121.50GiB, used=116.53GiB
>>> GlobalReserve, single: total=512.00MiB, used=848.00KiB
>>>
>>> kernel: 4.16.8
>>>
>>> Is that expected? Should I be ready to wait days possibly for this
>>> balance to finish?
>>
>> It's now beeen 2 days, and it's still stuck at 1%
>> 1 out of about 73 chunks balanced (6724 considered),  99% left
> 
> First, my disclaimer.  I'm not a btrfs developer, and although I've
> ran balance many times, I haven't really studied its output beyond the
> % left.  I don't know why it says "about", and I don't know if it
> should ever be that far off.
> 
> In your situation, I would run "btrfs pause <path>", wait to hear from
> a btrfs developer, and not use the volume whatsoever in the meantime.
I would say this is probably good advice.  I don't really know what's 
going on here myself actually, though it looks like the balance got 
stuck (the output hasn't changed for over 36 hours, unless you've got an 
insanely slow storage array, that's extremely unusual (it should only be 
moving at most 3GB of data per chunk)).

That said, I would question the value of repacking chunks that are 
already more than half full.  Anything above a 50% usage filter 
generally takes a long time, and has limited value in most cases (higher 
values are less likely to reduce the total number of allocated chunks). 
With `-duszge=50` or less, you're guaranteed to reduce the number of 
chunk if at least two match, and it isn't very time consuming for the 
allocator, all because you can pack at least two matching chunks into 
one 'new' chunk (new in quotes because it may re-pack them into existing 
slack space on the FS).  Additionally, `-dusage=50` is usually 
sufficient to mitigate the typical ENOSPC issues that regular balancing 
is supposed to help with.
