Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61454 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753860AbdIYKTL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 06:19:11 -0400
Subject: Re: btrfs scrub crashes OS
To: Lukas Pirl <btrfs@lukas-pirl.de>, linux-btrfs@vger.kernel.org
References: <6e6dc9a3-b3e9-2831-8149-94f7c11b9df1@lukas-pirl.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <67942154-0940-e1f3-318a-6a9a893fe351@gmx.com>
Date: Mon, 25 Sep 2017 18:19:01 +0800
MIME-Version: 1.0
In-Reply-To: <6e6dc9a3-b3e9-2831-8149-94f7c11b9df1@lukas-pirl.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月25日 17:50, Lukas Pirl wrote:
> Dear all,
> 
> I experience reproducible OS crashes when scrubbing a btrfs file system.
> Apart from that, the file system mounts rw and is usable without any
> problems (including modifying snapshots and all that).
> 
> When the system crashes (i.e., freezes), there are no errors printed to
> the system logs or via `dmesg` (had a display connected).

Even no dmesg output using tty or netconsole?

That's strange.
Normally it should be kernel BUG_ON() to cause such problem.

And if the system is still responsible (either from TTY or ssh), is 
there anything strange like tons of IO or CPU usage?

> 
> Recovery is only possible via power-cycling the machine.
> 
> The host experienced a lot of crashes and ATA errors due to hardware
> failures in the past.
> To the best of my knowledge, the hardware is stable now.
> 
> `btrfs device stats` outputs zeros for all counters.
> 
> `btrfsck --readonly --mode lowmem` outputs a bunch of
>    referencer count mismatch …
> and
>    ERROR: data extent[… …] backref lost
> see https://pastebin.com/seC4fReP for the full log.

There is a known bug for lowmem mode to report such false alert.

Btrfs-progs v4.13 should have fixed it.

As long as v4.13 btrfs check reports no error, its metadata should be good.

> 
> System info:
> btrfs RAID 1 (~1.5 years old), 7 SATA HDDs

Oh, RAID1, so normal "btrfs check --check-data-csum" can't really check 
all data checksum. (It will pass 2nd mirror if 1st one matches the csum)

You could try the out-of-tree offline scrub to do a full scrub of your 
fs unmounted, so it won't crash your system (if nothing wrong happened)
https://github.com/gujx2017/btrfs-progs/tree/offline_scrub

>    MIXED_BACKREF, BIG_METADATA, EXTENDED_IREF, SKINNY_METADATA, NO_HOLES

Only NO_HOLES is not ordinary, but shouldn't cause a problem.


Without kernel backtrace, it's tricky to locate the problem.
So I would recommend to use netconsole (IIRC more reliable, as I use it 
on my test VM to capture the dying message) or TTY output to verify 
there is no kernel message/backtrace.

Thanks,
Qu

>    no quotas in use
>    see also https://pastebin.com/4me6zDsN for more details
> btrfs-progs v4.12
> GNU/Linux 4.12.0-0.bpo.1-amd64 #1 SMP Debian 4.12.6-1~bpo9+1 x86_64
> 
> The question, obviously, is how can I make this fs "scrubable" again?
> Are the errors found by btrfsck safe to repair using btrfsck or some
> other tool?
> 
> Thank you so much in advance,
> 
> Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
