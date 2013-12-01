Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51465 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3LABQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Nov 2013 20:16:29 -0500
Received: by mail-wg0-f45.google.com with SMTP id y10so8755329wgg.0
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Nov 2013 17:16:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP9B-Q=Y+uY2kErYb1ZKMsvFrbYidmGpPnUbHm8iApj7v6wK+w@mail.gmail.com>
References: <pan$e58f7$107ceb0e$e753a400$c76bf1d5@cox.net>
	<5299CC95.6010704@informatik.uni-bonn.de>
	<CAP9B-Q=Y+uY2kErYb1ZKMsvFrbYidmGpPnUbHm8iApj7v6wK+w@mail.gmail.com>
Date: Sun, 1 Dec 2013 09:16:28 +0800
Message-ID: <CAP9B-Qkh0EVTGQPRHM2OX+tH74W-sYEoD52goS7Mae=3quMjmw@mail.gmail.com>
Subject: Fwd: 2 errors when scrubbing - but I don't know what they mean
From: Shilong Wang <wangshilong1991@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cc: linux-btrfs

---------- Forwarded message ----------
From: Shilong Wang <wangshilong1991@gmail.com>
Date: 2013/12/1
Subject: Re: 2 errors when scrubbing - but I don't know what they mean
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>


Hello Sebastian,

2013/11/30 Sebastian Ochmann <ochmann@informatik.uni-bonn.de>:
> Hello,
>
> thank you for your input. I didn't know that btrfs keeps the error counters
> over mounts/reboots, but that's nice.
>
> I'm still trying to figure out how such a generation error may occur in the
> first place. One thing I noticed looking at the btrfs code is that the
> generation error counter will only get incremented in the actual scrubbing
> code (either in "scrub_checksum_super" or in "scrub_handle_errored_block",
> both in scrub.c - please correct me if I'm wrong, I'm not a btrfs dev).

Right, Scrub will read superblock with bio rather than using pagecaches.
This mean we will reread superblock from disks, if a checksum mismatch happens,
This can be the following reasons:

1.some read errors happen while scrubing, while superblocks are actually good
2.during last transaction, when we are trying to write superblocks to
disk, some silent corruption
   happens.
3.some unexpected operation write data to superblocks directly, for
example..'dd if=/dev/zero'
of=/dev/ seek=65536   count=4k' something like this.

Actually, during boot time, superblock should be fine, because will do
checksum check
when trying to using superblock. if checksum mismatch, we will refuse
to mount, After mounting,
these superblocks should be cached in memory until you umouting filesystem.

So ideal thing is your disk is fine, and during next transaction,
superblocks will be rewritten.
and during next umounting, you can mounting filesystem successfully!

However, if you find such superblocks checksum mismatch very often
during scrub, it maybe
there are something wrong with disk!

> Also, the dmesg errors I saw were not there at boot time, but about 10
> minutes after boot which was about the time when I started the scrub so I'm
> pretty sure that it was the scrub that detected the errors.
>
> The question remains what can cause superblock/gen errors. Sure it could be
> "some" read error, but I'd really like to make sure that it's not a
> systematic error. I wasn't able to reproduce it yet though.

You can reproduce this by doing 'dd if=/dev/zero of=/dev/sd*
seek=65536 count=4k' before
btrfs scrubing.

Thanks,
Wang
>
> Best
> Sebastian
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
