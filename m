Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34851 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbcAVDiH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 22:38:07 -0500
Received: by mail-ig0-f176.google.com with SMTP id t15so140836666igr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 19:38:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.20.1601211702400.579@unknown18cf5e8bc07f.att.net>
References: <alpine.OSX.2.20.1601190308520.34954@ioko>
	<CAGfcS_=0Fu96a=SZwYkkV7Ukk7Jc_8c6sn8ZeiacocTcRbMp8w@mail.gmail.com>
	<CAJCQCtTSHepYgTxiJ49wPsrO0Hh-NFEcxbo6DzG7XyFyi9ySSg@mail.gmail.com>
	<alpine.OSX.2.20.1601211317410.38375@ioko>
	<CAJCQCtQLFdWf35bFK2exkSg2yWu2ZtAUO+xDO6j8ZGado9VGNw@mail.gmail.com>
	<alpine.OSX.2.20.1601211702400.579@unknown18cf5e8bc07f.att.net>
Date: Thu, 21 Jan 2016 20:38:06 -0700
Message-ID: <CAJCQCtSH-=5c8FR2at2AWtpRGOepOxHRgzFD8LfVft7cD9tJTQ@mail.gmail.com>
Subject: Re: FS corruption when mounting non-degraded after mounting degraded
From: Chris Murphy <lists@colorremedies.com>
To: Rian Hunter <rian@thelig.ht>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 6:21 PM, Rian Hunter <rian@thelig.ht> wrote:

>
> "SCT Error Recovery Control command not supported" is printed for all my
> devices for the "smartctl" command.
>
> # cat /sys/block/sd{a,b,c,d,e,f,g,h}/device/timeout
> 30
> 30
> 30
> 30
> 30
> 30
> 30
> 30

This combination is a misconfigured setup. The SCT ERC value must be
lower than thekernel block device timout value. When SCT ERC is not
supported, that means the value is unknown but in effect it means it
can be stratospheric, 120+ seconds is not unheard of.

So your use case must be prepared for non-deterministic, rare
(hopefully), total stalls of 2-3 minutes. If your use case can't ever
tolerate such a hang while a drive is in deep recovery doing a read on
a marginal/bad sector, then the drives are disqualified for the use
case, you have to get drives that have configurable SCT ERC, and do
something like 'smartctl -l scterc,70,70' on every device at startup,
since it's not a persistent setting.

In the meantime you need to change the block device timeout for all
drives to something nutty like 160. This also is not a persistent
setting. This will permit a drive with a bad sector to actually report
a read failure rather than the SATA link being reset by the kernel.
The kernel uses this timeout value to know when to give up waiting for
a hung drive, and the drive is hanging because it's in deep read
recovery so its whole queue just stalls until there's a read error, or
the read succeeds.

What will suck is that some of these deep recoveries will work, so
instead of getting a read error, which is a prerequisite for Btrfs (or
md raid or lvm raid or any raid) to fix the slow sector, the drive
just gets slower and slower when it has one or more frequently used
bad blocks *until* it hits the drive's own internal timeout. The work
around for this (instead of waiting for that sector to get bad enough
to actually fail to read) is to do a full balance. That rewrites all
data, and sectors with recent writes are fast. Any persistently bad
sectors at write time will be remapped by drive firmware in favor of
reserve sectors.



>>
>> Do you have dmesg output that includes sysrq+w at the time of the hung
>> tasks warnings? That's pretty much always requested by devs in these
>> cases.
>
>
> This is dmesg before the freeze:

https://www.kernel.org/doc/Documentation/sysrq.txt

If you get a hung task message, enable sysrq, then write w to the
trigger path, then capture dmesg to a file and post that to a bug
report.


>
>
> Yes I searched and I found your opinion on this. I was fairly
> confident that the "unrecoverable errors" in the scrub were due to it
> being degraded.  I did the scrub because I felt I was running out of
> options.
>
> My only opinion, after going through this experience would be that
> btrfs-scrub fail fast and returned a hard error like "Cannot scrub
> degraded mount." That would have saved me some time.

Yes that's my position also until a dev tells me to shush. It's
probably be a pretty straight forward patch for btrfs-progs to have
scrub first check for degraded mount and fail with the error message
you propose if it is; David might accept it! But if he doesn't he'll
probably suggest a better way to handle such cases if there is one.

Btrfs is always doing a passive on-the-fly scrub anyway. An active
read and write scrub where every single stripe *will* have a read
error that the scrub code has to do something with just seems to me
like taxing an array that's already in duress.

Maybe a compromise is a -f flag that forces scrub anyway? Maybe it's a
valid stress test, but I still remain unconvinced it's a good
production task.





>
>>> From a black box perspective, this led me to believe that the
>>> corruption happened during the replace operation after mounting
>>> normally after first mounting with "-o degraded." Of course,
>>> knowledge of the internals could easily verify this.
>>
>>
>> Filesystems are really difficult, so even knowledge of the internals
>> doesn't guarantee the devs will understand where the problem first
>> started in this case.
>
>
> Fair point. I have experience writing a file system myself and I agree.
> Though sometimes it helps when you have a non-zero mental model of
> the internals.

Well at least they can look at the call traces, and maybe ask some
intelligent questions. I can't do that yet.

-- 
Chris Murphy
