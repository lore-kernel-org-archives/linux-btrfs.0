Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46123 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751268AbaBZCIP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 21:08:15 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Detailed RAID Status and Errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKZK7uyXxnbX-i2f5Bp5ndOO9ia57j-qRmYRBUBi3i-TTgA53A@mail.gmail.com>
Date: Tue, 25 Feb 2014 19:08:09 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4100767A-7529-4AC0-9898-A55C13D14F18@colorremedies.com>
References: <CAKZK7uyXxnbX-i2f5Bp5ndOO9ia57j-qRmYRBUBi3i-TTgA53A@mail.gmail.com>
To: Justin Brown <justin.brown@fandingo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 25, 2014, at 6:27 PM, Justin Brown <justin.brown@fandingo.org> wrote:

> Hello,
> 
> I'm finishing up my data migration to Btrfs, and I've run into an
> error that I'm trying to explore in more detail. I'm using Fedora 20
> with Btrfs v0.20-rc1.

You should have btrfs-progs-3.12-1.fc20.x86_64, it's available since November.


> I
> completed my rsync to this array, and I figured that it would be
> prudent to run a scrub before I consider this array the canonical
> version of my data.

Scrub can't fix problems with raid5/6 yet.
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/31938


> 
> total bytes scrubbed: 2.71TiB with 1 errors
> 
> * How is "total bytes scrubbed" determined? This array only has 2.2TB
> of space used, so I'm confused about how many total bytes need to be
> scrubbed before it is finished.

Total includes metadata.


> Feb 25 15:16:24 localhost kernel: ata4.00: exception Emask 0x0 SAct
> 0x3f SErr 0x0 action 0x0
> Feb 25 15:16:24 localhost kernel: ata4.00: irq_stat 0x40000008
> Feb 25 15:16:24 localhost kernel: ata4.00: failed command: READ FPDMA QUEUED
> Feb 25 15:16:24 localhost kernel: ata4.00: cmd
> 60/08:08:b8:24:af/00:00:58:00:00/40 tag 1 ncq 4096 in
>                                           res
> 41/40:00:be:24:af/00:00:58:00:00/40 Emask 0x409 (media error) <F>
> Feb 25 15:16:24 localhost kernel: ata4.00: status: { DRDY ERR }
> Feb 25 15:16:24 localhost kernel: ata4.00: error: { UNC }
> Feb 25 15:16:24 localhost kernel: ata4.00: configured for UDMA/133
> Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd] Unhandled sense code
> Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd]
> Feb 25 15:16:24 localhost kernel: Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd]
> Feb 25 15:16:24 localhost kernel: Sense Key : Medium Error [current]
> [descriptor]
> Feb 25 15:16:24 localhost kernel: Descriptor sense data with sense
> descriptors (in hex):
> Feb 25 15:16:24 localhost kernel:         72 03 11 04 00 00 00 0c 00
> 0a 80 00 00 00 00 00
> Feb 25 15:16:24 localhost kernel:         58 af 24 be
> Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd]

All of this looks like a conventional bad sector read error. It's concerning why there'd be a bad sector after having just written to it when putting all your data on this volume. What do you get for:

smartctl -x /dev/sdd
smartctl -l scterc /dev/sdd


> Feb 25 15:16:24 localhost kernel: Add. Sense: Unrecovered read error -
> auto reallocate failed

Also not reassuring.


> * What is the best way to recover from this error? If I delete
> PATH/TO/REDACTED_FILE and recopy it, will everything be okay? (I found
> a thread on the Arch Linux forums,
> https://bbs.archlinux.org/viewtopic.php?id=170795, that mentions this
> as a solution, but I can't tell if it's the proper method.
> 
> * Should I run another scrub? (I'd like to avoid another scrub if
> possible because the scrub has been running for 24 hours already.)

No, balance in this case due to the present scrub on radi5/6 limitation.


> 
> * When a scrub is not running, is there any `btrfs` command that will
> show me corrected and uncorrectable errors that occur during normal
> operation? I guess something similar to `mdadm -D`.

btrfs device stats /dev/X


> 
> * It seems like this type of error shouldn't happen on RAID6 as there
> should be enough information to recover between the data, p parity,
> and q parity. Is this just an implementation limitation of the current
> RAID 5/6 code?


The first problem is a device error on /dev/sdd reported to libata, which is the bulk of what you posted. However this:

> kernel: btrfs: i/o error at logical 2285387870208 on dev /dev/sdf1, sector 1488392888, root 5, inode 357715, offset 48787456, length 4096, links 1 (path: PATH/TO/REDACTED_FILE)
> kernel: btrfs: bdev /dev/sdf1 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
> kernel: btrfs: unable to fixup (regular) error at logical 2285387870208 on dev /dev/sdf1

Is a bit confusing to me because it's a different drive. First, sdd itself reported a read error. Then btrfs detects an i/o error (?) on /dev/sdf. That's unexpected, although the fact it can't fix the error is expected with the current raid5/raid6 support. What I can't tell is if the two errors affected the same stripe but by the looks of it the data itself is OK.

The hardware problems need to be addressed for sure especially because while btrfs raid5/6 will reconstruct data from parity, it doesn't yet write reconstructed data back to bad sectors yet.


Chris Murphy