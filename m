Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34699 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620AbcBYTc3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 14:32:29 -0500
Received: by mail-io0-f182.google.com with SMTP id 9so94165522iom.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 11:32:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56CF3D78.90705@hsr.ch>
References: <nandur$4li$1@ger.gmane.org>
	<56CF3D78.90705@hsr.ch>
Date: Thu, 25 Feb 2016 12:32:28 -0700
Message-ID: <CAJCQCtTkEiNSgs8bQRdw6WaXmuOidHPnLjCYKwK-HTWT1riX+A@mail.gmail.com>
Subject: Re: btrfs raid1 filesystem on sdcard corrupted
From: Chris Murphy <lists@colorremedies.com>
To: Hegner Robert <rhegner@hsr.ch>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2016 at 10:44 AM, Hegner Robert <rhegner@hsr.ch> wrote:


This doesn't appear to be a Btrfs problem, but rather a device
problem. The first indication of a problem I see:



> [    6.697772] EXT4-fs (mmcblk0p1): recovery complete
> [    6.697804] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data
> mode. Opts: (null)

This suggests unclean shutdown/umount of ext4 that it had to do
journal recovery, or maybe it's still unclean. You should probably
fsck this volume. But it could also be unrelated to what follows now

\
> [   12.021717] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
> [   12.027695] sunxi-mmc 1c0f000.mmc: data error, sending stop command
> [   12.035780] mmcblk0: timed out sending r/w cmd command, card status 0x900
> [   12.042640] end_request: I/O error, dev mmcblk0, sector 12386304
> [   12.048680] end_request: I/O error, dev mmcblk0, sector 12386312
> [   12.054708] end_request: I/O error, dev mmcblk0, sector 12386320
> [   12.060725] end_request: I/O error, dev mmcblk0, sector 12386328


Lots of device errors. And only then Btrfs finds out about it.


> [   12.066744] BTRFS: bdev /dev/mmcblk0p3 errs: wr 1, rd 0, flush 0, corrupt
> 0, gen 0




> [   12.074324] end_request: I/O error, dev mmcblk0, sector 12386336
> [   12.080339] end_request: I/O error, dev mmcblk0, sector 12386344
> [   12.086353] end_request: I/O error, dev mmcblk0, sector 12386352
> [   12.092378] end_request: I/O error, dev mmcblk0, sector 12386360

Then more errors. And more Btrfs complaints that it can't write.


> [   45.925800] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
> [   45.931802] sunxi-mmc 1c0f000.mmc: data error, sending stop command
> [   45.938375] mmcblk0: timed out sending r/w cmd command, card status 0x900
> [   46.526949] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
> [   46.532920] sunxi-mmc 1c0f000.mmc: data error, sending stop command
> [   46.540716] mmcblk0: timed out sending r/w cmd command, card status 0x900
> [   47.129367] BTRFS: error (device mmcblk0p3) in
> btrfs_commit_transaction:1921: errno=-5 IO failure (Error while writing out
> transaction)
> [   47.141583] BTRFS info (device mmcblk0p3): forced readonly

Finally Btrfs gives up...

So it's probably a hardware problem of some sort, although it could be
an mmcblk driver problem. It might be as simple as reseating the
sdcard, and hopefully the file system isn't corrupted.



-- 
Chris Murphy
