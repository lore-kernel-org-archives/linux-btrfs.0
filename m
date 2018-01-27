Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:39413 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbeA0Fu6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 00:50:58 -0500
Received: by mail-lf0-f52.google.com with SMTP id w27so3206612lfd.6
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 21:50:57 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Christophe Yayon <cyayon-list@nbux.org>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
Date: Sat, 27 Jan 2018 08:50:54 +0300
MIME-Version: 1.0
In-Reply-To: <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

26.01.2018 17:47, Christophe Yayon пишет:
> Hi Austin,
> 
> Thanks for your answer. It was my opinion too as the "degraded" seems to be flagged as "Mostly OK" on btrfs wiki status page. I am running Archlinux with recent kernel on all my servers (because of use of btrfs as my main filesystem, i need a recent kernel).
> 
> Your idea to add a separate entry in grub.cfg with rootflags=degraded is attractive, i will do this...
> 
> Just a last question, i thank that it was necessary to add "degraded" option in grub.cfg AND fstab to allow boot in degraded mode. I am not sure that only grub.cfg is sufficient... 
> Yesterday, i have done some test and boot a a system with only 1 of 2 drive in my root raid1 array. No problem with systemd,

Are you using systemd in your initramfs (whatever implementation you are
using)? I just tested with dracut using systemd dracut module and it
does not work - it hangs forever waiting for device. Of course, there is
no way to abort it and go into command line ...

Oh, wait - what device names are you using? I'm using mount by UUID and
this is where the problem starts - /dev/disk/by-uuid/xxx will not appear
unless all devices have been seen once ...

... and it still does not work even if I change it to root=/dev/sda1
explicitly because sda1 will *not* be announced as "present" to systemd
until all devices have been seen once ...

So no, it does not work with systemd *in initramfs*. Absolutely.
