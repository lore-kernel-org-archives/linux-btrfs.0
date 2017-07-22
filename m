Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36982 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdGVRtc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 13:49:32 -0400
Received: by mail-wm0-f53.google.com with SMTP id c184so3659052wmd.0
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jul 2017 10:49:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9a16f6d5-90cd-bd04-a0ea-63e88cc3faf4@gmail.com>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
 <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com> <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
 <20170717155400.GN2866@twin.jikos.cz> <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
 <9a16f6d5-90cd-bd04-a0ea-63e88cc3faf4@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 22 Jul 2017 11:49:30 -0600
Message-ID: <CAJCQCtQBidjgsg4MadAAqoy6+dQHCkgz=8pxPX2CC=6Mwj38MQ@mail.gmail.com>
Subject: Re: btrfs device ready purpose
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 11:55 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 21.07.2017 17:36, Chris Murphy пишет:
>>>
>>> The command is just a simple wrapper around the DEVICES_READY ioctl, but
>>> now that systemd has it's own wrapper tool, there are probably no users
>>> of that subcommand in 'btrfs' tool itself. We can enhance the
>>> documentation to state the expected purpose and that normal users can
>>> ignore it.
>>
>> What is the expected purpose? It flat out does not seem to work at
>> all. It doesn't wait when devices are missing, as the man description
>> says.
>
> That's man page that is misleading. The intent was to let caller of
> "btrfs device ready" to know when it has to wait.
>
>> And echo ? returns a 0 instead of 1. I'd expect the exit code is
>> 0 to mean "yes all devices are ready", and exit code 1 "some devices
>> not ready". But right now, I get the same result no matter what.
>>
>
> That's not what I observe.
>
> linux-gtrk:~ # btrfs device ready /dev/sdb
> linux-gtrk:~ # echo $?
> 1
> linux-gtrk:~ # btrfs-debug-tree /dev/sdb
> btrfs-progs v4.5.3+20160729
> warning, device 2 is missing
> ...
>
> But if you call "btrfs device ready" AFTER kernel has already seen (or
> decided about) all devices, then it returns 0. Basically, this is not
> "filesystem ready" but "does kernel know about all devices for this
> filesystem".

OK! Super! This is the critical bit of behavior. My test is flawed.

The multiple device volume was visible to the kernel, and then I
merely deactivated the LV. The kernel had seen it, and isn't "missing"
it at least in terms of 'btrfs device ready' whereas 'btrfs fi show'
does report it as missing but is also using different ioctls. Even if
I use 'btrfs device scan' a subsequent 'btrfs device ready' exits 0.
But if I set skip activation 'lvchange -ky' and reboot, 'btrfs device
ready' on the non-missing device does result in an exit code of 1.


> Please do not confuse independent things. "btrfs device ready" simply
> tells caller whether all devices have been seen by kernel. This is poor
> man's solution for "can I mount it". What caller does with this
> information is outside of scope of btrfs.

Got it. Thanks.


>
>> I think it'd be better to return a code.
>> 0: is complete, degraded not required
>> 1: is incomplete, degraded should mount it
>> 2: is incomplete, degraded won't mount it
>>
>
> There is no way systemd can make use of this information using current
> static unit dependencies. Really, this topic came up more than once
> (including by you as well). systemd does not have adequate ways to
> represent multi-device objects (this goes beyond btrfs, Linux MD is good
> example). Sometimes it is possible to workaround it (Linux MD again).
> But at the end, systemd needs to offer framework where btrfs et al can
> plug in by providing status. Until this happens, discussion on this list
> is pointless.

Understood.


-- 
Chris Murphy
