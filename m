Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36544 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdA1RAo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 12:00:44 -0500
Received: by mail-wm0-f42.google.com with SMTP id c85so157715174wmi.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 09:00:44 -0800 (PST)
Subject: Re: btrfs recovery
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
 <2c02d0b6-859d-f66f-e259-748db131d38d@googlemail.com>
 <304177d4-cc35-9bfc-816c-85ff3501dc50@gmail.com>
 <pan$cc953$ec4078b0$696ed46d$9618e10e@cox.net>
 <CANznX5H1iyrwzamf0NS1iu=taXPaJGnS=XecBLtFKf9r6th2vQ@mail.gmail.com>
To: "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <ea91d1e9-5895-b0bd-eb75-c1e474516fab@googlemail.com>
Date: Sat, 28 Jan 2017 17:51:21 +0100
MIME-Version: 1.0
In-Reply-To: <CANznX5H1iyrwzamf0NS1iu=taXPaJGnS=XecBLtFKf9r6th2vQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 28.01.2017 um 13:37 schrieb Janos Toth F.:
> I usually compile my kernels with CONFIG_X86_RESERVE_LOW=640 and
> CONFIG_X86_CHECK_BIOS_CORRUPTION=N because 640 kilobyte seems like a
> very cheap price to pay in order to avoid worrying about this (and
> skip the associated checking + monitoring).
> 
> Out of curiosity (after reading this email) I set these to 4 and Y (so
> 1 page = 4k reserve and checking turned ON and activated by default)
> on a useless laptop. Right after reboot, the kernel log was full of
> the same kind of Btrfs errors reported in the first email of this
> topic ("bad key order", etc). I could run a scrub with zero errors and
> successfully reboot with a read-write mounted root filesystem with the
> old kernel build (but the kernel log was still full of errors, as your
> might imagine). I tried to run "btrfs check --repair" but it seems to
> be useless in this situation, the filesystem needs to be recreated
> (not too hard in my case when it's still fully readable). Although,
> the kernel log was free of the "Corrupted low memory at" kind of
> messages (even though I let it run for hours).
Thanks for this report about the (even destructive...) test! 
It's astonishing how fast this broke... 
As mentioned in my last mail a few minutes ago, I am now following your example and the machine is running with
CONFIG_X86_RESERVE_LOW=640
(but still with checking for the first 64k active). I consider using that for all machines I'm administrating,
but it's interesting to see that major distributions targetting desktop use stay with 64. 

