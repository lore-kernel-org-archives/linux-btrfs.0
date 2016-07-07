Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34054 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbcGGPSY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 11:18:24 -0400
Received: by mail-vk0-f42.google.com with SMTP id d67so24356944vkh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 08:18:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALLEBqFoy0MXgPJBHG=yQnXQwWJsBQJFBofNqwmJTjZFK9sV2g@mail.gmail.com>
References: <CALLEBqG65hkAd+KyoNZudCKv58OuBm3L5VOjWcvMQ5GfGNCngA@mail.gmail.com>
 <CAJCQCtS=5Zx_toc3WuOpymyVUYFZMUo=wh+ZmTC=jh6bL3XYXg@mail.gmail.com>
 <CALLEBqF7HZ0VmMpFmoTik0_2FBXp7q5Z4EHxe_fMDY9ni2j44Q@mail.gmail.com> <CALLEBqFoy0MXgPJBHG=yQnXQwWJsBQJFBofNqwmJTjZFK9sV2g@mail.gmail.com>
From: Stanislaw Kaminski <stasheck.fora@gmail.com>
Date: Thu, 7 Jul 2016 17:17:46 +0200
Message-ID: <CALLEBqGr9-jnba4XTV=JaVuNKPhNgEJuLZFmmLEkw-7HOB-Asg@mail.gmail.com>
Subject: Re: Out of space error even though there's 100 GB unused?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris, Alex, Hugo,

Running now: Linux archb3 4.6.2-1-ARCH #1 PREEMPT Mon Jun 13 02:11:34
MDT 2016 armv5tel GNU/Linux

Seems to be working fine. I started a defrag, and it seems I'm getting
my space back:
$ sudo btrfs fi usage /home
Overall:
    Device size:                   1.81TiB
    Device allocated:              1.73TiB
    Device unallocated:           80.89GiB
    Device missing:                  0.00B
    Used:                          1.65TiB
    Free (estimated):            159.63GiB      (min: 119.19GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 240.00KiB)

Data,single: Size:1.72TiB, Used:1.65TiB
   /dev/sda4       1.72TiB

Metadata,DUP: Size:3.50GiB, Used:2.16GiB
   /dev/sda4       7.00GiB

System,DUP: Size:32.00MiB, Used:224.00KiB
   /dev/sda4      64.00MiB

Unallocated:
   /dev/sda4      80.89GiB

I deleted some unfinished torrent, ~10 GB in size, but as you can see,
"Free space" has grown by 60 GB (re-checked now and it's 1 GB more now
- so definitely caused by defrag).

What has changed between 4.6.2 and 4.6.3?

Cheers,
Stan

2016-07-07 12:28 GMT+02:00 Stanislaw Kaminski <stasheck.fora@gmail.com>:
> Too early report, the issue is back. Back to testing....
>
> 2016-07-07 12:18 GMT+02:00 Stanislaw Kaminski <stasheck.fora@gmail.com>:
>> Hi all,
>> I downgraded to 4.4.1-1 - all fine, 4.5.5.-1 - also fine, then got
>> back to 4.6.3-2 - and it's still fine. Apparently running under
>> different kernel somehow fixed the glitch (as far as I can test...).
>>
>> That leaves me with the other question: before issues, I 1.6 TiB was
>> used, now all the tools report 1.7 TiB issued (except for btrfs fs du
>> /home, this reports 1.6 TiB). How is that possible?
>>
>> Cheers,
>> Stan
>>
>> 2016-07-06 19:42 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
>>> On Wed, Jul 6, 2016 at 3:55 AM, Stanislaw Kaminski
>>> <stasheck.fora@gmail.com> wrote:
>>>
>>>>     Device unallocated:           97.89GiB
>>>
>>> There should be no problem creating any type of block group from this
>>> much space. It's a bug.
>>>
>>> I would try regression testing. Kernel 4.5.7 has some changes that may
>>> or may not relate to this (they should only relate when there is no
>>> unallocated space left) so you could try 4.5.6 and 4.5.7. And also
>>> 4.4.14.
>>>
>>> But also the kernel messages are important. There is this obscure
>>> enospc with error -28, so either with or without enospc_debug mount
>>> option is useful to try in 4.6.3 (I think it's less useful in older
>>> kernels).
>>>
>>> But do try nospace_cache first. If that works, you could then mount
>>> with clear_cache one time and see if that provides an enduring fix. It
>>> can take some time to rebuild the cache after clear_cache is used.
>>>
>>>
>>>
>>> --
>>> Chris Murphy
