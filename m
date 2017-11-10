Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:53572 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdKJVwA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 16:52:00 -0500
Received: by mail-oi0-f45.google.com with SMTP id h6so7751101oia.10
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 13:52:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <011ae8c4281f0f8799d48189f540a302@wpkg.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org> <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <c6c0eb84c550f44ffe443d625c198a39@wpkg.org> <64e4c4c4341f5880349a02cf57eb3ff7@wpkg.org>
 <CAJtFHUQ34uyt-iAQKuQ-WqXMrCqxsPeqFc5LvYmZHrz+Rxs66A@mail.gmail.com> <011ae8c4281f0f8799d48189f540a302@wpkg.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 10 Nov 2017 14:51:58 -0700
Message-ID: <CAJCQCtS3kR0xeKCpMdk9mivJ+8JyToPVoKMmUUX2sp2-L1PpfA@mail.gmail.com>
Subject: Re: how to run balance successfully (No space left on device)?
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: E V <eliventer@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 10, 2017 at 12:42 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> On 2017-11-07 23:49, E V wrote:
>
>> Hmm, I used to see these phantom no space issues quite a bit on older
>> 4.x kernels, and haven't seen them since switching to space_cache=v2.
>> So it could be space cache corruption. You might try either clearing
>> you space cache, or mounting with nospace_cache, or try converting to
>> space_cache=v2 after reading up on it's caveats.
>
>
> We have space_cache=v2.


I have no idea if it's related or not, as this isn't a default mount
option and is still under testing.



>
> Unfortunately yet one more system running 4.14-rc8 with "No space left"
> during balance:
>
>
> [68443.535664] BTRFS info (device sdb3): relocating block group 591771009024
> flags data|raid1
> [68463.203330] BTRFS info (device sdb3): found 8578 extents
> [68492.238676] BTRFS info (device sdb3): found 8559 extents
> [68500.751792] BTRFS info (device sdb3): 1 enospc errors during balance
>
>
> # btrfs balance start /var/lib/lxd
> WARNING:
>
>         Full balance without filters requested. This operation is very
>         intense and takes potentially very long. It is recommended to
>         use the balance filters to narrow down the balanced data.
>         Use 'btrfs balance start --full-balance' option to skip this
>         warning. The operation will start in 10 seconds.
>         Use Ctrl-C to stop it.
> 10 9 8 7 6 5 4 3 2 1
> Starting balance without any filters.
> ERROR: error during balancing '/var/lib/lxd': No space left on device
> There may be more info in syslog - try dmesg | tail


OK I wonder if this is a bug in user space tool's error handling?
Because what you have in kernel messages is BTRFS info. It is not a
warning or an error. I interpret this as enospc error happened but it
recovered, so it was not an unhandled error condition, and definitely
non-fatal. But the user space tool is reporting a bogus "No space left
on device". It's plainly bogus because you have a lot of space on the
device, including unallocated space. So the user space tool needs to
either ignore this type of informational enospc or it needs a
different message to make it clear this is not a fatal error and was
properly handled.

Do you get any additional information when using enospc_debug mount
option and reproduce this problem?


> Unallocated:
>    /dev/sda3     112.00GiB
>    /dev/sdb3     112.00GiB

Metric shittons of space. The error is certainly bogus.



> Combined with evidence that "No space left on device" during balance can
> lead to various file corruption (we've witnessed it with MySQL), I'd day
> btrfs balance is a dangerous operation and decision to use it should be
> considered very thoroughly.

I've never heard of this. Balance is COW at the chunk level. The old
chunk is not dereferenced until it's written in the new location
correctly. Corruption during balance shouldn't be possible so if you
have a reproducer, the devs need to know about it.





-- 
Chris Murphy
