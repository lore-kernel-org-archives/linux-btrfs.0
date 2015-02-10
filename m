Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41222 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbbBJAzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 19:55:18 -0500
Received: by mail-lb0-f180.google.com with SMTP id z12so12150168lbi.11
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 16:55:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
From: constantine <costas.magnuse@gmail.com>
Date: Tue, 10 Feb 2015 00:54:56 +0000
Message-ID: <CANcfdL2FgE9UDCjVkzNUa8X1y63=JLfjcwqT4=KDLOu-YTe=sA@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you everybody for your support, care, cheerful comments and
understandable criticism. I am in the process of backing up every
file.

Could you please answer two questions?:

1.  I am testing various files and all seem readable. Is there a way
to list every file that resides on a particular device (like
/dev/sdc1?) so as to check them? There are a handful of files that
seem corrupted, since I get from scrub:
"""
BTRFS: checksum error at logical 10792783298560 on dev /dev/sdc1,
sector 737159648, root 5, inode 1376754, offset 175428419584, length
4096, links 1 (path: long/path/file.img)
""",
but are these the only files that could be corrupted?


2. Chris mentioned:

A. On Mon, Feb 9, 2015 at 12:31 AM, Chris Murphy
<lists@colorremedies.com> wrote:
> [[[try # btrfs device delete /dev/sdc1 /mnt/mountpoint]]]. Just realize that any data that's on both the
> failed drive and sdc1 will be lost

and later

B. On Mon, Feb 9, 2015 at 1:34 AM, Chris Murphy <lists@colorremedies.com> wrote:
> So now I have a 4 device
> raid1 mounted degraded. And I can still device delete another device.
> So one device missing and one device removed.

So when I do the "# btrfs device delete /dev/sdc1 /mnt/mountpoint" the
normal behavior would for the files that are located in /dev/sdc1 (and
also were on the missing/failed drive) to be transferred to other
drives and not lose them, right? (Does B. hold and contradict A.?)



Long PS: Obviously, I have backed-up critical data that "I would
almost consider committing suicide" if I lost them with services like
tarsnap/dropbox/etc. However, I did not do this for
non-critical-yet-important
data-that-would-make-me-depressed-if-I-lost-them-for-some-months
because of budget constraints.

For network stumblers, RAID-1 btrfs was working for me for a couple
years and had the sense that I was covered. I obviously was not since
I neglected looking at dmesg after each scrub. Second, I rushed and
added both of the new 6TB in the array, instead of only one of them
and using the second for backing up my data. After the whole process,
I suppose I will have a more robust array structure the RED/RAID
drives and appropriate cron jobs as indicated in the thread.
