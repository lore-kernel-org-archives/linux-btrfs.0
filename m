Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:39139 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbdLUM10 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 07:27:26 -0500
Received: by mail-it0-f50.google.com with SMTP id 68so10646252ite.4
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 04:27:26 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Tomasz Pala <gotar@polanet.pl>,
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
 <CAA91j0X_MZ+EjgZMNGrfChBdFed_G3oLttdpYjCOq-vERzoiKw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <94b6b4cb-9f1a-c90b-5ffb-fb4d7385526b@gmail.com>
Date: Thu, 21 Dec 2017 07:27:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAA91j0X_MZ+EjgZMNGrfChBdFed_G3oLttdpYjCOq-vERzoiKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-21 06:44, Andrei Borzenkov wrote:
> On Tue, Dec 19, 2017 at 11:47 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2017-12-19 15:41, Tomasz Pala wrote:
>>>
>>> On Tue, Dec 19, 2017 at 12:35:20 -0700, Chris Murphy wrote:
>>>
>>>> with a read only file system. Another reason is the kernel code and
>>>> udev rule for device "readiness" means the volume is not "ready" until
>>>> all member devices are present. And while the volume is not "ready"
>>>> systemd will not even attempt to mount. Solving this requires kernel
>>>> and udev work, or possibly a helper, to wait an appropriate amount of
>>>
>>>
>>> Sth like this? I got such problem a few months ago, my solution was
>>> accepted upstream:
>>>
>>> https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f
>>>
>>> Rationale is in referred ticket, udev would not support any more btrfs
>>> logic, so unless btrfs handles this itself on kernel level (daemon?),
>>> that is all that can be done.
>>
>> Or maybe systemd can quit trying to treat BTRFS like a volume manager (which
>> it isn't) and just try to mount the requested filesystem with the requested
>> options?
> 
> You can't mount filesystem until sufficient number of devices are
> present and not waiting (at least attempting to wait) for them opens
> you to races on startup. So far systemd position was - it is up to
> filesystem to give it something to wait on. And while apparently
> everyone agrees that current "btrfs device ready" does not fit the
> bill, this is the only thing we have.
No, it isn't.  You can just make the damn mount call with the supplied 
options.  If it succeeds, the volume was ready, if it fails, it wasn't, 
it's that simple, and there's absolutely no reason that systemd can't 
just do that in a loop until it succeeds or a timeout is reached.  That 
isn't any more racy than waiting on them is (waiting on them to be ready 
and then mounting them is a TOCTOU race condition), and it doesn't have 
any of these issues with the volume being completely unusable in a 
degraded state.

Also, it's not 'up to the filesystem', it's 'up to the underlying 
device'.  LUKS, LVM, MD, and everything else that's an actual device 
layer is what systemd waits on.  XFS, ext4, and any other filesystem 
except BTRFS (and possibly ZFS, but I'm not 100% sure about that) 
provides absolutely _NOTHING_ to wait on.  Systemd just chose to handle 
BTRFS like a device layer, and not a filesystem, so we have this crap to 
deal with, as well as the fact that it makes it impossible to manually 
mount a BTRFS volume with missing or failed devices in degraded mode 
under systemd (because it unmounts it damn near instantly because it 
somehow thinks it knows better than the user what the user wants to do).
> 
> This integration issue was so far silently ignored both by btrfs and
> systemd developers. 
It's been ignored by BTRFS devs because there is _nothing_ wrong on this 
side other than the naming choice for the ioctl.  Systemd is _THE ONLY_ 
init system which has this issue, every other one works just fine.

As far as the systemd side, I have no idea why they are ignoring it, 
though I suspect it's the usual spoiled brat mentality that seems to be 
present about everything that people complain about regarding systemd.
