Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:35346 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753760AbdLTIet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 03:34:49 -0500
Date: Wed, 20 Dec 2017 09:34:48 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171220083448.GA25687@polanet.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl>
 <CAJCQCtQPmov53Q=BTzywawkW2froYx49M+ez9WZsRy2cp-b3+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtQPmov53Q=BTzywawkW2froYx49M+ez9WZsRy2cp-b3+w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 16:59:39 -0700, Chris Murphy wrote:

>> Sth like this? I got such problem a few months ago, my solution was
>> accepted upstream:
>> https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f
> 
> I can't parse this commit. In particular I can't tell how long it
> waits, or what triggers the end to waiting.

The point is - it doesn't wait at all. Instead, every 'ready' btrfs
device triggers event on all the pending devices. Consider 3-device
filesystem consisting of /dev/sd[abd] with /dev/sdc being different,
standalone btrfs:

/dev/sda -> 'not ready'
/dev/sdb -> 'not ready'
/dev/sdc -> 'ready', triggers /dev/sda -> 'not ready' and /dev/sdb - still 'not ready'
/dev/sdc -> kernel says 'ready', triggers /dev/sda - 'ready' and /dev/sdb -> 'ready'

This way all the parts of a volume are marked as ready, so systemd won't
refuse mounting using legacy device nodes like /dev/sda.


This particular solution depends on kernel returning 'btrfs ready',
which would obviously not work for degraded arrays unless the btrfs.ko
handles some 'missing' or 'mount_degraded' kernel cmdline options
_before_ actually _trying_ to mount it with -o degraded.

And there is a logical problem with this - _which_ array components
should be ignored? Consider:

volume1: /dev/sda /dev/sdb
volume2: /dev/sdc /dev/sdd-broken

If /dev/sdd is missing from the system, it would never be scanned, so
/dev/sdc would be pending. It cannot be assembled just in time of
scanning alone, because the same would happen with /dev/sda and there
would be desync with /dev/sdb, which IS available - a few moments later.

This is the place for the timeout you've mentioned - there should be
*some* decent timeout allowing all the devices to show up (udev waits
for 90 seconds by default or x-systemd.device-timeout=N from fstab).

After such timeout, I'd like to tell the kernel: "no more devices, give
me all the remaining btrfs volumes in degraded mode if possible". By
"give me btrfs vulumes" I mean "mark them as 'ready'" so the udev could
fire it's rules. And if there would be anything for udev to distinguish
'ready' from 'ready-degraded' one could easily compose some notification
scripting on top of it, including sending e-mail to sysadmin.

Is there anything that would make the kernel do the above?

-- 
Tomasz Pala <gotar@pld-linux.org>
