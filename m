Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:49414 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdLSWXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 17:23:10 -0500
Date: Tue, 19 Dec 2017 23:23:08 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171219222308.GE14726@polanet.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl>
 <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 15:47:03 -0500, Austin S. Hemmelgarn wrote:

>> Sth like this? I got such problem a few months ago, my solution was
>> accepted upstream:
>> https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f
>> 
>> Rationale is in referred ticket, udev would not support any more btrfs
>> logic, so unless btrfs handles this itself on kernel level (daemon?),
>> that is all that can be done.
> Or maybe systemd can quit trying to treat BTRFS like a volume manager 
> (which it isn't) and just try to mount the requested filesystem with the 
> requested options?

Tried that before ("just mount my filesystem, stupid"), it is a no-go.
The problem source is not within systemd treating BTRFS differently, but
in btrfs kernel logic that it uses. Just to show it:

1. create 2-volume btrfs, e.g. /dev/sda and /dev/sdb,
2. reboot the system into clean state (init=/bin/sh), (or remove btrfs-scan tool),
3. try
mount /dev/sda /test - fails
mount /dev/sdb /test - works
4. reboot again and try in reversed order
mount /dev/sdb /test - fails
mount /dev/sda /test - works

THIS readiness is exposed via udev to systemd. And it must be used for
multi-layer setups to work (consider stacked LUKS, LVM, MD, iSCSI, FC etc).

In short: until *something* scans all the btrfs components, so the
kernel makes it ready, systemd won't even try to mount it.

> Then you would just be able to specify 'degraded' in 
> your mount options, and you don't have to care that the kernel refuses 
> to mount degraded filesystems without being explicitly asked to.

Exactly. But since LP refused to try mounting despite kernel "not-ready"
state - it is the kernel that must emit 'ready'. So the
question is: how can I make kernel to mark degraded array as "ready"?

The obvious answer is: do it via kernel command line, just like mdadm
does:
rootflags=device=/dev/sda,device=/dev/sdb
rootflags=device=/dev/sda,device=missing
rootflags=device=/dev/sda,device=/dev/sdb,degraded

If only btrfs.ko recognized this, kernel would be able to assemble
multivolume btrfs itself. Not only this would allow automated degraded
mounts, it would also allow using initrd-less kernels on such volumes.

>> It doesn't have to be default, might be kernel compile-time knob, module
>> parameter or anything else to make the *R*aid work.
> There's a mount option for it per-filesystem.  Just add that to all your 
> mount calls, and you get exactly the same effect.

If only they were passed...

-- 
Tomasz Pala <gotar@pld-linux.org>
