Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36240 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758049AbcILOLK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:11:10 -0400
Received: by mail-lf0-f53.google.com with SMTP id g62so87793902lfe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 07:11:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$10305$d0b1bd23$a49643ee$465d6f6c@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <5440522.9CHaGU5Wjs@merkaba> <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com> <pan$10305$d0b1bd23$a49643ee$465d6f6c@cox.net>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 12 Sep 2016 17:11:07 +0300
Message-ID: <CAK5rZE7SMLgPpe8tAQZ9qu=vm+3Gk=73L_h2+tOPEag-0tS0Bg@mail.gmail.com>
Subject: Re: Small fs
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Just to note again:
>> Ordinary 127MB btrfs gives "Out of space" around 64MB payload. 128MB is
>> usable to the end.

> Thanks, and just to clarify for others possibly following along or
> googling it up later, that's single mode (as opposed to dup mode) for at
> least data, if in normal separate data/metadata mode, and single for the
> combined mixed-mode chunks if in mixed-bg mode, correct?
>
> Because if the data is dup mode as well, as it would be by default in
> mixed-bg mode (unless on ssd), 128 MiB should allow storing only 64 MiB
> (and that's not accounting for the system chunk or global reserve
> metadata, so it'd be less than that) data.


That's /boot on my laptop. Its fairly old fs
which is created about 3-4 years. May be 5.
I'm not so sure..

btrfs filesystem df /boot
System, single: total=4.00MiB, used=4.00KiB
Data+Metadata, single: total=124.00MiB, used=103.88MiB
GlobalReserve, single: total=4.00MiB, used=0.00B
IT IS SINGLE!!

The 128/64Mb thing happened when I created a backup
usb drive for mirroring it. Then make it 256MB.

btrfs filesystem df /mnt/back/boot
Data, single: total=8.00MiB, used=0.00B
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=32.00MiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
IT IS DUP!!

So Duncan you got it:
I'm comparing the SINGLE to DUP...
I'm not sure how I got that SINGLE though...


>> I'm experimenting with an extracted (and customized) initrd on /boot.
>> That is, /boot is a "minimal root on its own" which can switch to real
>> root or do other things. Kernel and modules at /boot will not support
>> any fs other than btrfs. (Or it may)
>> It seems a minimally usable root around 10MB is possible.
>> And it is free of udev and systemd..
>
> You don't specifically mention the distro, but given that gentoo's one of
> the only general-purpose distros that hasn't switched to systemd yet (tho
> it offers the choice for those who want it, and I've taken that choice
> here), there's a fair chance that's what you're running, as both I and
> Martin Steigerwald (based on earlier threads) are.

Now the offtopic:

- I'm on Arch. Considering to switch to Void.

- Using syslinux as bootmanager. It is rock solid and compact.
Just edit syslinux.cfg and reboot to any configuration
without any hassle.

- Also using runit side stepping systemd. It is also rock solid
and compact.

- Know your hardware and thus the Kernel.
And get rid of and middleware (all udev derivatives) playing
guess games on your machine.

- Two custom kernel configurations:
All built-in (Was using until now.)
All modules. (Now switching to this.)
Load all your modules on exactly known locations
when booting. To do this customize your
runit start up scripts.
I'm switching to "All modules" approach
after I determined and understand the key modules.
Don't affaid. Its accually very doable.
You need at most 8-9 modprobes
to get them all. If you know your HW and
kernel it is no big deal.

- Configuring kernel teaches alot.

- Compiling a kernel with only required modules
takes about 15 minutes if you got your .config
file right. Play with "make xconfig". Alot...

- Keep all your previous .config files as record.
When something goes wrong diff them for
throubleshooting.

- Dracut is a dirty hack. mkinitcpio is great.

- Compressed initrd is bad. It hides what is going
on. Extract it. Play with it. Than make it the root fs
of your /boot. (I'm now here)

- Starting X without udev is simple.
Disable hotplug.
5-6 lines of Manual entries for keyboard, mouse and
touchpad is sufficient in your /etc/X11/xorg.conf.d
