Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:44759 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965953AbeFSQar (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:30:47 -0400
Received: by mail-ot0-f194.google.com with SMTP id w13-v6so327870ote.11
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 09:30:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180619154730.fblylttw2nyps4cp@merlins.org>
References: <20180618130055.3rzngk5a5sktfp7p@merlins.org> <20180619154730.fblylttw2nyps4cp@merlins.org>
From: james harvey <jamespharvey20@gmail.com>
Date: Tue, 19 Jun 2018 12:30:46 -0400
Message-ID: <CA+X5Wn5_TEH5zwWS8cihnadK_hFg9CL6NcT9Q28mDxtZK97Beg@mail.gmail.com>
Subject: Re: btrfs balance did not progress after 12H
To: Marc MERLIN <marc@merlins.org>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 19, 2018 at 11:47 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Jun 18, 2018 at 06:00:55AM -0700, Marc MERLIN wrote:
>> So, I ran this:
>> gargamel:/mnt/btrfs_pool2# btrfs balance start -dusage=60 -v .  &
>> [1] 24450
>> Dumping filters: flags 0x1, state 0x0, force is off
>>   DATA (flags 0x2): balancing, usage=60
>> gargamel:/mnt/btrfs_pool2# while :; do btrfs balance status .; sleep 60; done
>> 0 out of about 0 chunks balanced (0 considered), -nan% left

This (0/0/0, -nan%) seems alarming.  I had this output once when the
system spontaneously rebooted during a balance.  I didn't have any bad
effects afterward.

>> Balance on '.' is running
>> 0 out of about 73 chunks balanced (2 considered), 100% left
>> Balance on '.' is running
>>
>> After about 20mn, it changed to this:
>> 1 out of about 73 chunks balanced (6724 considered),  99% left

This seems alarming.  I wouldn't think # considered should ever exceed
# chunks.  Although, it does say "about", so maybe it can a little
bit, but I wouldn't expect it to exceed it by this much.

>> Balance on '.' is running
>>
>> Now, 12H later, it's still there, only 1 out of 73.
>>
>> gargamel:/mnt/btrfs_pool2# btrfs fi show .
>> Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
>>         Total devices 1 FS bytes used 12.72TiB
>>         devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
>>
>> gargamel:/mnt/btrfs_pool2# btrfs fi df .
>> Data, single: total=13.57TiB, used=12.60TiB
>> System, DUP: total=32.00MiB, used=1.55MiB
>> Metadata, DUP: total=121.50GiB, used=116.53GiB
>> GlobalReserve, single: total=512.00MiB, used=848.00KiB
>>
>> kernel: 4.16.8
>>
>> Is that expected? Should I be ready to wait days possibly for this
>> balance to finish?
>
> It's now beeen 2 days, and it's still stuck at 1%
> 1 out of about 73 chunks balanced (6724 considered),  99% left

First, my disclaimer.  I'm not a btrfs developer, and although I've
ran balance many times, I haven't really studied its output beyond the
% left.  I don't know why it says "about", and I don't know if it
should ever be that far off.

In your situation, I would run "btrfs pause <path>", wait to hear from
a btrfs developer, and not use the volume whatsoever in the meantime.
I can make some guesses where to go from here, but won't, as I don't
want to screw things up for you.

What version of btrfs-progs do you have?
