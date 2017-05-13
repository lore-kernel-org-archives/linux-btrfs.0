Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:32798 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752293AbdEMH3a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 03:29:30 -0400
Received: by mail-lf0-f54.google.com with SMTP id m18so3009748lfj.0
        for <linux-btrfs@vger.kernel.org>; Sat, 13 May 2017 00:29:29 -0700 (PDT)
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
To: Chris Murphy <lists@colorremedies.com>, Ochi <ochi@arcor.de>
References: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
 <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
 <CAJCQCtRDn8TMiv2sh0SGM=f2ApMa_j=N8=YFF+pu38WdThM7HQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <2f1e52d4-ca30-3623-1ea7-a046bee18bda@gmail.com>
Date: Sat, 13 May 2017 10:29:26 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRDn8TMiv2sh0SGM=f2ApMa_j=N8=YFF+pu38WdThM7HQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

12.05.2017 20:07, Chris Murphy пишет:
> On Thu, May 11, 2017 at 5:24 PM, Ochi <ochi@arcor.de> wrote:
>> Hello,
>>
>> here is the journal.log (I hope). It's quite interesting. I rebooted the
>> machine, performed a mkfs.btrfs on dm-{2,3,4} and dm-3 was missing
>> afterwards (around timestamp 66.*). However, I then logged into the machine
>> from another terminal (around timestamp 118.*) which triggered something to
>> make the device appear again :O Indeed, dm-3 was once again there after
>> logging in. Does systemd mix something up?
> 

Yes :) Did you doubt?

Please, try to reproduce it and provide both journalctl and "udevadm
info --export-db" output. I have my theory what happens here.

> I don't see any Btrfs complaints. If dm-3 is the device Btrfs is
> expecting and it vanishes, then Btrfs would mention it on a read or
> write. So either nothing is happening and Btrfs isn't yet aware that
> dm-3 is gone, or it's looking at some other instance of that encrypted
> volume, maybe it's using /dev/mapper/storage1. You can find out with
> btrfs fi show.
> 

/dev/mapper/xxx should be link to /dev/dm-NN (although you are never
sure with Linux). dm-NN is *the* device. /dev/mapper/storage1 cannot
exist without /dev/dm-3, irrespectively of what btrfs shows.

> Whenever I use Btrfs on LUKS I invariably see fi show, show me one
> device using /dev/dm-0 notation and the other device is
> /dev/mapper/blah notation. I think this is just an artifact of all the
> weird behind the scenes shit with symlinks and such, and that is a
> systemd thing as far as I know.
> 

Not quite.

As implemented today, when device appears (i.e. udev gets ADD uevent)
and it is detected as part of btrfs, udev rule scans device (with
equivalent of "btrfs device ready"). At the time event is being
processed the only name that is available is canonical kernel /dev/dm-0;
all convenience syminks are created later, after all rules have been
processed. btrfs remembers device name that was passed to it.

What makes it even more confusing - some btrfs utilities seem to resolve
/dev/dm-0 to /dev/mapper/blah by itself, and some not. I am not sure
which ones.

Recently btrfsprogs got extra rule that repeats "btrfs device ready" but
now *after* symlinks have been created (using RUN directive with
/dev/mapper/blah). It updates kernel with new name. So my guess is that
for this device this rule is missing (probably it gets created in initrd
and rule is not added to it).

> Anyway, more information is needed. First see if the device is really
> missing per Btrfs (read or write something and also check with 'btrfs
> fi show') You can add systemd.log_level=debug as a boot parameter to
> get more information in the journal, although it's rather verbose. You
> could combine it with rd.udev.debug but that gets really crazy verbose
> so I tend not to use them at the same time.
> 

@ochi: Please, before running with debug repeat your test as you did and
provide udevadm info --export-db. This may be enough. In my experience
debug output while being extremely verbose contains very little
additional useful information, but has tendency of skewing relative
timing thus changing behavior.

> The other possibility is there's a conflict with dracut which may be
> doing some things, and the debug switch for that is rd.debug and is
> likewise extremely verbose, producing huge logs, so I would start out
> with just the systemd debug and see if that reveals anything
> *assuming* Btrfs is complaining. If Btrfs doesn't complain about a
> device going away then I wouldn't worry about it.
> 
> 

This is not btrfs issue in any case (except btrfs folks should really
work together with systemd folks and finally come to common
implementation of multi-device filesystems).

