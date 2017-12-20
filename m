Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34967 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754317AbdLTNdI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 08:33:08 -0500
Received: by mail-it0-f66.google.com with SMTP id f143so6870078itb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 05:33:08 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
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
 <20171219222308.GE14726@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <862f03b0-9311-09f6-ee2c-d53d35d176bd@gmail.com>
Date: Wed, 20 Dec 2017 08:33:03 -0500
MIME-Version: 1.0
In-Reply-To: <20171219222308.GE14726@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-19 17:23, Tomasz Pala wrote:
> On Tue, Dec 19, 2017 at 15:47:03 -0500, Austin S. Hemmelgarn wrote:
> 
>>> Sth like this? I got such problem a few months ago, my solution was
>>> accepted upstream:
>>> https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f
>>>
>>> Rationale is in referred ticket, udev would not support any more btrfs
>>> logic, so unless btrfs handles this itself on kernel level (daemon?),
>>> that is all that can be done.
>> Or maybe systemd can quit trying to treat BTRFS like a volume manager
>> (which it isn't) and just try to mount the requested filesystem with the
>> requested options?
> 
> Tried that before ("just mount my filesystem, stupid"), it is a no-go.
> The problem source is not within systemd treating BTRFS differently, but
> in btrfs kernel logic that it uses. Just to show it:
> 
> 1. create 2-volume btrfs, e.g. /dev/sda and /dev/sdb,
> 2. reboot the system into clean state (init=/bin/sh), (or remove btrfs-scan tool),
> 3. try
> mount /dev/sda /test - fails
> mount /dev/sdb /test - works
> 4. reboot again and try in reversed order
> mount /dev/sdb /test - fails
> mount /dev/sda /test - works
> 
> THIS readiness is exposed via udev to systemd. And it must be used for
> multi-layer setups to work (consider stacked LUKS, LVM, MD, iSCSI, FC etc).
Except BTRFS _IS NOT MULTIPLE LAYERS_.  It's one layer at the filesystem 
layer, and handles the other 'layers' internally.
> 
> In short: until *something* scans all the btrfs components, so the
> kernel makes it ready, systemd won't even try to mount it.
Which is the problem here.  Systemd needs to treat BTRFS differently, 
even if the ioctl it's using gets 'fixed', currently it's treating it 
like LVM or MD, when it needs to be treated as just a filesystem with an 
extra wait condition prior to mount (and needs to trust that the user 
knows what they are doing when they mount something by hand).  The IOCTL 
systemd is using was poorly named, what it really does is say that the 
FS is ready to mount normally (that is, without needing 'device=' or 
'degraded' mount options).  Aside from this being problematic with 
degraded volumes, it's got an inherent TOCTOU race condition (so do the 
checks with all the other block layers you mentioned FWIW).  If systemd 
would just treat BTRFS like a filesystem instead of a volume manager, 
and try to mount the volume with the specified options (after waiting 
for udev to report that it's done scanning everything) instead of asking 
the kernel if it's ready, none of this would be an issue.

Put slightly differently:  I use OpenRC and sysv init.  I have a script 
that runs right after udev starts and directly scans all fixed disks for 
BTRFS signatures, and that's _all_ that I need to do to get multi-device 
BTRFS working properly with the standard local filesystem mount script 
in Gentoo.  I don't have to deal with any of this crap that systemd 
users do because Gentoo's OpenRC script for mounting local filesystems 
treats BTRFS like any other filesystem, and (sensibly) assumes that if 
the call to mount succeeds, things are ready and working.
> 
>> Then you would just be able to specify 'degraded' in
>> your mount options, and you don't have to care that the kernel refuses
>> to mount degraded filesystems without being explicitly asked to.
> 
> Exactly. But since LP refused to try mounting despite kernel "not-ready"
> state - it is the kernel that must emit 'ready'. So the
> question is: how can I make kernel to mark degraded array as "ready"?
You can't, because the DEVICE_READY IOCTL is coded to mark the volume 
ready when all component devices are ready.  IOW, it's there to say 
'this mount will work without needing -o degraded or specifying any 
devices in the mount options'.

The issue is the interaction here, not the kernel behavior by itself, 
since the kernel behavior produces no issues whatsoever for other init 
systems (though I will acknowledge that the ioctl itself is really only 
used by systemd, but I contend that that's because everything else is 
sensible enough to understand that the ioctl is functionally useless and 
just avoid it).
> 
> The obvious answer is: do it via kernel command line, just like mdadm
> does:
> rootflags=device=/dev/sda,device=/dev/sdb
> rootflags=device=/dev/sda,device=missing
> rootflags=device=/dev/sda,device=/dev/sdb,degraded
> 
> If only btrfs.ko recognized this, kernel would be able to assemble
> multivolume btrfs itself. Not only this would allow automated degraded
> mounts, it would also allow using initrd-less kernels on such volumes.
Last I checked, the 'device=' options work on upstream kernels just 
fine, though I've never tried the degraded option.  Of course, I'm also 
not using systemd, so it may be some interaction with systemd that's 
causing them to not work (and yes, I understand that I'm inclined to 
blame systemd most of the time based on significant past experience with 
systemd creating issues that never existed before).
> 
>>> It doesn't have to be default, might be kernel compile-time knob, module
>>> parameter or anything else to make the *R*aid work.
>> There's a mount option for it per-filesystem.  Just add that to all your
>> mount calls, and you get exactly the same effect.
> 
> If only they were passed...
> 

