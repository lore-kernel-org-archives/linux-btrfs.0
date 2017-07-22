Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35428 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbdGVFz0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 01:55:26 -0400
Received: by mail-lf0-f68.google.com with SMTP id b127so2182262lfb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 22:55:25 -0700 (PDT)
Subject: Re: btrfs device ready purpose
To: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
 <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com>
 <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
 <20170717155400.GN2866@twin.jikos.cz>
 <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <9a16f6d5-90cd-bd04-a0ea-63e88cc3faf4@gmail.com>
Date: Sat, 22 Jul 2017 08:55:23 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

21.07.2017 17:36, Chris Murphy пишет:
>>
>> The command is just a simple wrapper around the DEVICES_READY ioctl, but
>> now that systemd has it's own wrapper tool, there are probably no users
>> of that subcommand in 'btrfs' tool itself. We can enhance the
>> documentation to state the expected purpose and that normal users can
>> ignore it.
> 
> What is the expected purpose? It flat out does not seem to work at
> all. It doesn't wait when devices are missing, as the man description
> says.

That's man page that is misleading. The intent was to let caller of
"btrfs device ready" to know when it has to wait.

> And echo ? returns a 0 instead of 1. I'd expect the exit code is
> 0 to mean "yes all devices are ready", and exit code 1 "some devices
> not ready". But right now, I get the same result no matter what.
> 

That's not what I observe.

linux-gtrk:~ # btrfs device ready /dev/sdb
linux-gtrk:~ # echo $?
1
linux-gtrk:~ # btrfs-debug-tree /dev/sdb
btrfs-progs v4.5.3+20160729
warning, device 2 is missing
...

But if you call "btrfs device ready" AFTER kernel has already seen (or
decided about) all devices, then it returns 0. Basically, this is not
"filesystem ready" but "does kernel know about all devices for this
filesystem".

> So it seems to me it needs to be fixed in user space or it just needs
> to be removed.
> 
> Where this stems from, is this 'help wanted' issue
> https://github.com/storaged-project/libblockdev/issues/244
> 
> The gist is that libblockdev needs to know whether a device can be
> mounted successfully without -o degraded, and that's basically what
> BTRFS_IOC_DEVICES_READY does. But at least in startup, the udev usage
> of this ioctl causes a hang. Literally systemd just sits there and
> will not try to mount such a volume, and it waits indefinitely, which
> is itself suboptimal.

Please do not confuse independent things. "btrfs device ready" simply
tells caller whether all devices have been seen by kernel. This is poor
man's solution for "can I mount it". What caller does with this
information is outside of scope of btrfs.

> I think it'd be better to return a code.
> 0: is complete, degraded not required
> 1: is incomplete, degraded should mount it
> 2: is incomplete, degraded won't mount it
> 

There is no way systemd can make use of this information using current
static unit dependencies. Really, this topic came up more than once
(including by you as well). systemd does not have adequate ways to
represent multi-device objects (this goes beyond btrfs, Linux MD is good
example). Sometimes it is possible to workaround it (Linux MD again).
But at the end, systemd needs to offer framework where btrfs et al can
plug in by providing status. Until this happens, discussion on this list
is pointless.
