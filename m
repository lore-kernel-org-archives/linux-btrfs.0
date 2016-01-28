Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34733 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbcA1QSI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 11:18:08 -0500
Received: by mail-ig0-f175.google.com with SMTP id ik10so16830514igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 08:18:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160128153756.GA19617@fox.rh.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
	<pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
	<20160123214127.GA601@fox.wireless.rit.edu>
	<CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
	<20160127224549.GA4891@fox.rh.rit.edu>
	<20160127235528.GA5498@fox.rh.rit.edu>
	<56AA0A0A.1060807@gmail.com>
	<20160128153756.GA19617@fox.rh.rit.edu>
Date: Thu, 28 Jan 2016 09:18:06 -0700
Message-ID: <CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 8:37 AM, Sean Greenslade
<sean@seangreenslade.com> wrote:
> On Thu, Jan 28, 2016 at 07:31:06AM -0500, Austin S. Hemmelgarn wrote:
>> >Got the opportunity to reboot, and things appear to be OK. Still, I
>> >would expect replace to work without requiring a reboot, so this may
>> >still be a bug. I'm running a scrub to verify things, and once that
>> >completes I'll do the second replace and see if I encounter the same
>> >problem.
>>
>> That is unusual, it's supposed to work without needing a reboot or rescan,
>> so I think you may have found a bug.
>
> Did the second replace, and encountered a slightly different issue.
> Btrfs fi show did list both new devices after the replace completed,
> however the partition was no longer mounted. Trying to mount, the mount
> command returned 0 but the partition was not actually mounted. I got
> this in dmesg:
>
> [Thu Jan 28 10:20:20 2016] BTRFS info (device sdd1): disk space caching
> is enabled
> [Thu Jan 28 10:20:20 2016] BTRFS: has skinny extents
> [Thu Jan 28 10:20:20 2016] BTRFS: bdev /dev/sda1 errs: wr 0, rd 186,
> flush 0, corrupt 0, gen 0

Those read errors are a persistent counter. Use 'btrfs dev stat' to
see them for each device, and use -z to clear. I think this is in
DEV_ITEM, and it should be dev.uuid based, so the counter ought to be
with this specific device, not merely "sda1". So ... I'd look in the
journal for the time during the replace and see where those read
errors might have come from if this is supposed to be a new drive and
you're not expecting read errors already.

Like I mentioned in my first reply to this thread, sct erc... it's
very important to get these settings right.




>
> I ejected and re-inserted the HDDs, and everything was happy again. The
> mount actually succeeded, with the same dmesg output. If I had to guess,
> I'd say there's probably some stale state left over in the kernel after
> the replace. I may try to create a test case to reproduce this later if
> I have time.
>
> Additionally, the filesystem did not expand to the larger drives after
> the replace. So I ran btrfs fi resize max, and I got the following:
>
>
> Label: none  uuid: 573863ec-d55e-4817-8c11-70bb8523b643
>         Total devices 2 FS bytes used 1.64TiB
>                 devid    1 size 2.73TiB used 1.71TiB path /dev/sdb1
>                 devid    2 size 1.82TiB used 1.71TiB path /dev/sda1
>
> [Thu Jan 28 10:32:36 2016] BTRFS: new size for /dev/sdb1 is 3000591912960
>
> It only resized one of the two devices, and I'm suspicious because the
> one that didn't resize is also the one that reports read errors in the
> mount dmesg output.
>
> Any ideas on what to try next? I'm kicking off a scrub for now.

Three things from the man page:

-       resize [<devid>:][+/-]<size>[kKmMgGtTpPeE]|[<devid>:]max <path>

-           Resize a mounted filesystem identified by path. A
particular device can be resized by specifying a devid.

-           If max is passed, the filesystem will occupy all available
space on the device respecting devid (remember, devid 1 by default).


Try:

btrfs fi resize 2:max <mountpoint>




-- 
Chris Murphy
