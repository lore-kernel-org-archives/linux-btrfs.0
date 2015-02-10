Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:42645 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbbBJHgi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 02:36:38 -0500
Received: by mail-yh0-f45.google.com with SMTP id a41so9809580yho.4
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 23:36:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL2FgE9UDCjVkzNUa8X1y63=JLfjcwqT4=KDLOu-YTe=sA@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CANcfdL2FgE9UDCjVkzNUa8X1y63=JLfjcwqT4=KDLOu-YTe=sA@mail.gmail.com>
Date: Tue, 10 Feb 2015 00:36:37 -0700
Message-ID: <CAJCQCtQ5Uf4Vm3=CHZcaqWTdTrzmr+=isO_YuuJP4W01nrs+og@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: constantine <costas.magnuse@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 9, 2015 at 5:54 PM, constantine <costas.magnuse@gmail.com> wrote:

> 1.  I am testing various files and all seem readable. Is there a way
> to list every file that resides on a particular device (like
> /dev/sdc1?) so as to check them? There are a handful of files that
> seem corrupted, since I get from scrub:
> """
> BTRFS: checksum error at logical 10792783298560 on dev /dev/sdc1,
> sector 737159648, root 5, inode 1376754, offset 175428419584, length
> 4096, links 1 (path: long/path/file.img)
> """,
> but are these the only files that could be corrupted?

It should be true the only corrupt files are the listed ones. I don't
have a good suggestion for the first question, whether btrfs restore
can help or btrfs-debug-tree - assuming you want something independent
from mounting the filesystem and just using recursive ls or tree
commands.




>
>
> 2. Chris mentioned:
>
> A. On Mon, Feb 9, 2015 at 12:31 AM, Chris Murphy
> <lists@colorremedies.com> wrote:
>> [[[try # btrfs device delete /dev/sdc1 /mnt/mountpoint]]]. Just realize that any data that's on both the
>> failed drive and sdc1 will be lost
>
> and later
>
> B. On Mon, Feb 9, 2015 at 1:34 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> So now I have a 4 device
>> raid1 mounted degraded. And I can still device delete another device.
>> So one device missing and one device removed.
>
> So when I do the "# btrfs device delete /dev/sdc1 /mnt/mountpoint" the
> normal behavior would for the files that are located in /dev/sdc1 (and
> also were on the missing/failed drive) to be transferred to other
> drives and not lose them, right? (Does B. hold and contradict A.?)

The normal case, a non-degraded volume, a device delete will
successfully migrate data, and the volume remains non-degraded.

The unusual case, a degraded volume, a device delete is suspiciously
permitted. I think this is risky and maybe ought to be disallowed, or
at least require the user to use --force. And the reason is, it's a
degraded array. The first course of business is to do a 'device
replace start' or if enough devices exist 'btrfs device delete
missing' to get the volume from degraded to normal state. And then do
any additional device deletes.

But the even more unusual case, a degrade volume, with a 2nd device
that's producing a huge pile of read, write and corruption errors,
Btrfs can't migrate any data off the dead/removed drive (obviously),
but it also has problems removing the data that now only exists on the
2nd device that spitting out errors. I don't expect this device delete
to succeed.

The difference between case A and B, is that there isn't a 2nd drive
spitting out a pile of errors. It's merely degraded, with a drive
being deleted, and even that ended in a kernel panic for me, which
I've reproduced. However, as a followup, after rebooting, the btrfs
volume is mountable (degraded) without error. I can further btrfs
device delete missing, and remount normally (not degraded). So this is
good.

>After the whole process,
> I suppose I will have a more robust array structure the RED/RAID
> drives and appropriate cron jobs as indicated in the thread.

Good ending sounds like.

-- 
Chris Murphy
