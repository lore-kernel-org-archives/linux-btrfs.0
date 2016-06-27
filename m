Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36359 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbcF0WzJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 18:55:09 -0400
Received: by mail-oi0-f41.google.com with SMTP id f189so221249680oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 15:55:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628002602.022258bf@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 16:55:07 -0600
Message-ID: <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 4:26 PM, Saint Germain <saintger@gmail.com> wrote:

>>
>
> Thanks for your help.
>
> Ok here is the log from the mounting, and including btrfs replace
> (btrfs replace start -f /dev/sda1 /dev/sdd1 /home):
>
> BTRFS info (device sdb1): disk space caching is enabled
> BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705631, gen 1335
> BTRFS info (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14220, gen 24

Eek. So sdb has 11+ million write errors, flush errors, read errors,
and over 1 million corruptions. It's dying or dead.

And sda has a dozen thousand+ corruptions. This isn't a good
combination, as you have two devices with problems and raid5 only
protects you from one device with problems.

You were in the process of replacing sda, which is good, but it may
not be enough...


> BTRFS info (device sdb1): dev_replace from /dev/sda1 (devid 1) to /dev/sdd1 started
> scrub_handle_errored_block: 166 callbacks suppressed
> BTRFS warning (device sdb1): checksum error at logical 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode 3434831, offset 479232, length 4096, links 1 (path: user/.local/share/zeitgeist/activity.sqlite-wal)
> btrfs_dev_stat_print_on_error: 166 callbacks suppressed
> BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14221, gen 24
> scrub_handle_errored_block: 166 callbacks suppressed
> BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445255168 on dev /dev/sda1

Shoot. You have a lot of these. It looks suspiciously like you're
hitting a case list regulars are only just starting to understand
(somewhat) where it's possible to have a legit corrupt sector that
Btrfs detects during scrub as wrong, fixes it from parity, but then
occasionally wrongly overwrites the parity with bad parity. This
doesn't cause an immediately recognizable problem. But if the volume
becomes degraded later, Btrfs must use parity to reconstruct
on-the-fly and if it hits one of these bad parities, the
reconstruction is bad, and ends up causing lots of these checksum
errors. We can tell it's not metadata corruption because a.) there's a
file listed as being affected and b.) the file system doesn't fail and
go read only. But still it means those files are likely toast...


[...snip many instances of checksum errors...]

> BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16217, gen 24
> ata2.00: exception Emask 0x0 SAct 0x4000 SErr 0x0 action 0x0
> ata2.00: irq_stat 0x40000008
> ata2.00: failed command: READ FPDMA QUEUED
> ata2.00: cmd 60/08:70:08:d8:70/00:00:0f:00:00/40 tag 14 ncq 4096 in
>          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
> ata2.00: status: { DRDY ERR }
> ata2.00: error: { UNC }
> ata2.00: configured for UDMA/133
> sd 1:0:0:0: [sdb] tag#14 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 1:0:0:0: [sdb] tag#14 Sense Key : Medium Error [current] [descriptor]
> sd 1:0:0:0: [sdb] tag#14 Add. Sense: Unrecovered read error - auto reallocate failed
> sd 1:0:0:0: [sdb] tag#14 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
> blk_update_request: I/O error, dev sdb, sector 259053576

OK yeah so bad sector on sdb. So you have two failures because sda is
already giving you trouble while being replaced and on top of it you
now get a 2nd (partial) failure via bad sectors.

So rather urgently I think you need to copy things off this volume if
you don't already have a backup so you can save as much as possible.
Don't write to the drives. You might even consider 'mount -o
remount,ro' to avoid anything writing to the volume. Copy the most
important data first, triage time.

While that happens you can safely collect some more information:

btrfs fi us <mp>
smartctl -x <dev>   ## for both drives


-- 
Chris Murphy
