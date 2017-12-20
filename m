Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:37453 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755929AbdLTTts (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 14:49:48 -0500
Received: by mail-oi0-f46.google.com with SMTP id y75so15400218oie.4
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 11:49:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171220083448.GA25687@polanet.pl>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl> <CAJCQCtQPmov53Q=BTzywawkW2froYx49M+ez9WZsRy2cp-b3+w@mail.gmail.com>
 <20171220083448.GA25687@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 20 Dec 2017 12:49:46 -0700
Message-ID: <CAJCQCtQ7fgma4-iXVO6aTY6O7odatG6Xg7b9LcY4Q21tHO+AUQ@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 20, 2017 at 1:34 AM, Tomasz Pala <gotar@polanet.pl> wrote:
> On Tue, Dec 19, 2017 at 16:59:39 -0700, Chris Murphy wrote:
>
>>> Sth like this? I got such problem a few months ago, my solution was
>>> accepted upstream:
>>> https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f
>>
>> I can't parse this commit. In particular I can't tell how long it
>> waits, or what triggers the end to waiting.
>
> The point is - it doesn't wait at all. Instead, every 'ready' btrfs
> device triggers event on all the pending devices. Consider 3-device
> filesystem consisting of /dev/sd[abd] with /dev/sdc being different,
> standalone btrfs:
>
> /dev/sda -> 'not ready'
> /dev/sdb -> 'not ready'
> /dev/sdc -> 'ready', triggers /dev/sda -> 'not ready' and /dev/sdb - still 'not ready'
> /dev/sdc -> kernel says 'ready', triggers /dev/sda - 'ready' and /dev/sdb -> 'ready'
>
> This way all the parts of a volume are marked as ready, so systemd won't
> refuse mounting using legacy device nodes like /dev/sda.
>
>
> This particular solution depends on kernel returning 'btrfs ready',
> which would obviously not work for degraded arrays unless the btrfs.ko
> handles some 'missing' or 'mount_degraded' kernel cmdline options
> _before_ actually _trying_ to mount it with -o degraded.


The thing that is valuing a Btrfs's "readiness" is udev. The kernel
doesn't care, it still instantiates a volume UUID. And if you pass -o
degraded mount to a non-ready Btrfs volume, the kernel code will try
to mount that volume in degraded mode (assuming it passes tests for
the minimum number of devices, can find all the supers it needs, and
bootstrap the chunk tree, etc)


If the udev rule were smarter, it could infer "non-ready" Btrfs volume
to mean it should wait (and complaining might be nice so we know why
it's waiting) for some period of time, and then if it's still not
ready to try to mount with -o degraded. I don't know where teaching
system about degraded attempts belongs, whether the udev rule can tell
systemd to add that mount option if a volume is still not ready, of if
systemd needs hard coded understanding of this mount option for Btrfs.
There is no risk of using -o degraded on a Btrfs volume if it's
missing too many devices, such a degraded mount will simply fail.



> After such timeout, I'd like to tell the kernel: "no more devices, give
> me all the remaining btrfs volumes in degraded mode if possible". By
> "give me btrfs vulumes" I mean "mark them as 'ready'" so the udev could
> fire it's rules. And if there would be anything for udev to distinguish
> 'ready' from 'ready-degraded' one could easily compose some notification
> scripting on top of it, including sending e-mail to sysadmin.

I think the linguistics of "btrfs devices ready" is confusing because
what we really care about is whether the volume/array can be mounted
normally (not degraded). The BTRFS_IOC_DEVICES_READY ioctl is pointed
to any one of the volume's devices, and you get a pass/fail. If it
passes (ready), all other devices are present. If it fails (not
ready), one or more devices are missing. It's not necessary to hit
every device with this ioctl to understand what's going on.

If the question can be answered with: ready, ready-degraded - It's
highly likely that you always get read-degraded as the answer for all
btrfs multiple device volumes. So if udev were to get read-degraded
will it still wait to see if the state goes to ready? How long does it
wait? Seems like it still should wait 90 seconds. In which case it's
going to try to mount with -o degraded.

So I see zero advantage and multiple disadvantages to having the
kernel do a degradedness test well before the mount will be attempted.
I think this is asking for a race condition.



-- 
Chris Murphy
