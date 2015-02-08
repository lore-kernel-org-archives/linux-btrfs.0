Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:40242 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbbBHXbm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 18:31:42 -0500
Received: by mail-yk0-f170.google.com with SMTP id q9so9979944ykb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 15:31:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
	<CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
	<CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
	<CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
Date: Sun, 8 Feb 2015 16:31:41 -0700
Message-ID: <CAJCQCtQ10ZP4V5Pj6cmuuzGdb6EQk8XprO2a5jiOb3AToBn58g@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: constantine <costas.magnuse@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 8, 2015 at 4:04 PM, constantine <costas.magnuse@gmail.com> wrote:
> Thank you very much for your help. I do not have any recovery backup
> and I need these data :(

Sorry to not be more sympathetic, but by definition data that isn't
backed up is not important data. On top of it, the setup you have is
fragile, not least of which is that you're using a relatively new
filesystem and a 3.19rc kernel from December... This is for testing
purposes, not production usage. So I'd say, you're doing it wrong and
this is the sort of thing that can happen. But mainly the issue here
is significantly misbehaving hardware well before the current drive
failure and nothing was done about it sooner, i.e. Oh my god I need to
make a backup now while I still can.


> Before my problems begun I was running btrfs-scrub in a weekly basis
> and I only got 17 uncorrectable errors for this array, concerning
> files that I do not care of, so I ignored them. I clearly should not.

The primary error is the lack of a backup while using supposedly
important data. But 17 uncorrectable errors on a raid1 is a major
warning sign something isn't right. A properly functioning raid1
volume doesn't have uncorrectable errors.


> SCT Error Recovery Control command not supported

These drives lack SCTERC support, which means they're consumer drives
that aren't intended to be used in raid.

> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)

Two drives have appropriate SCTERC settings for raid.

> # for letter in i d c g a b; do cat /sys/block/sd$letter/device/timeout; done
> 30
> 30
> 30
> 30
> 30
> 30

The SCSI command timer is set incorrectly for the drives that do not
have SCTERC support. So pretty much everything that could be done
wrong was done wrong. The lack of SCTERC plus 30 second time out means
there's a good chance that read failures aren't being reported by the
drive to the kernel, so the kernel (Btrfs specifically) doesn't
actually fix the problems; instead the command timer is reached, and
the link to the device is reset instead.




> The only way I can think of making a backup with my current available
> hardware is removing my one WD Red 6TB from the array and copying
> every file on this removed disk.
> Can I remove the /dev/sdb without letting any of the data enter the
> soon-to-fail /dev/sdc1?

No. What I would do is make sure no further changes happen to this
volume, consider it read only. Get the supposedly important
information off the volume first. Then the next step is to *add* a
good drive of any size; then delete sdc1. Only then can you correctly
remove another drive.

Even if Btrfs allowed it, I think it's a bad idea to try and remove
drives from a degraded array. This could be possible if it weren't for
sdc1 producing so many errors. Since it is, I don't see a way to do
it, and if you try I think I'll make things much worse. If you try
doing this, I'm not going to help anymore, put it that way. It's a big
problem when a stranger cares more about your data than you do!

Backup the data. That's first. Go buy a drive. There can be no
possible excuses if this is truly important data.


-- 
Chris Murphy
