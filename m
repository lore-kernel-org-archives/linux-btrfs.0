Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:48747 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaBZB1P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 20:27:15 -0500
Received: by mail-ig0-f181.google.com with SMTP id y6so279786igj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 17:27:14 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 25 Feb 2014 19:27:14 -0600
Message-ID: <CAKZK7uyXxnbX-i2f5Bp5ndOO9ia57j-qRmYRBUBi3i-TTgA53A@mail.gmail.com>
Subject: Detailed RAID Status and Errors
From: Justin Brown <justin.brown@fandingo.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm finishing up my data migration to Btrfs, and I've run into an
error that I'm trying to explore in more detail. I'm using Fedora 20
with Btrfs v0.20-rc1.

My array is a 5 disk (4x 1TB and 1x 2TB) RAID 6 (-d raid6 -m raid6). I
completed my rsync to this array, and I figured that it would be
prudent to run a scrub before I consider this array the canonical
version of my data. The scrub is still running, but I current have the
following status:

~$ btrfs scrub status t
scrub status for 7b7afc82-f77c-44c0-b315-669ebd82f0c5
scrub started at Mon Feb 24 20:10:54 2014, running for 86080 seconds
total bytes scrubbed: 2.71TiB with 1 errors
error details: read=1
corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

It is accompied by the following messages in the journal:

Feb 25 15:16:24 localhost kernel: ata4.00: exception Emask 0x0 SAct
0x3f SErr 0x0 action 0x0
Feb 25 15:16:24 localhost kernel: ata4.00: irq_stat 0x40000008
Feb 25 15:16:24 localhost kernel: ata4.00: failed command: READ FPDMA QUEUED
Feb 25 15:16:24 localhost kernel: ata4.00: cmd
60/08:08:b8:24:af/00:00:58:00:00/40 tag 1 ncq 4096 in
                                           res
41/40:00:be:24:af/00:00:58:00:00/40 Emask 0x409 (media error) <F>
Feb 25 15:16:24 localhost kernel: ata4.00: status: { DRDY ERR }
Feb 25 15:16:24 localhost kernel: ata4.00: error: { UNC }
Feb 25 15:16:24 localhost kernel: ata4.00: configured for UDMA/133
Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd] Unhandled sense code
Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd]
Feb 25 15:16:24 localhost kernel: Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd]
Feb 25 15:16:24 localhost kernel: Sense Key : Medium Error [current]
[descriptor]
Feb 25 15:16:24 localhost kernel: Descriptor sense data with sense
descriptors (in hex):
Feb 25 15:16:24 localhost kernel:         72 03 11 04 00 00 00 0c 00
0a 80 00 00 00 00 00
Feb 25 15:16:24 localhost kernel:         58 af 24 be
Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd]
Feb 25 15:16:24 localhost kernel: Add. Sense: Unrecovered read error -
auto reallocate failed
Feb 25 15:16:24 localhost kernel: sd 3:0:0:0: [sdd] CDB:
Feb 25 15:16:24 localhost kernel: Read(10): 28 00 58 af 24 b8 00 00 08 00
Feb 25 15:16:24 localhost kernel: end_request: I/O error, dev sdd,
sector 1487873214
Feb 25 15:16:24 localhost kernel: ata4: EH complete
Feb 25 15:16:24 localhost kernel: btrfs: i/o error at logical
2285387870208 on dev /dev/sdf1, sector 1488392888, root 5, inode
357715, offset 48787456, length 4096, links 1 (path:
PATH/TO/REDACTED_FILE)
Feb 25 15:16:24 localhost kernel: btrfs: bdev /dev/sdf1 errs: wr 0, rd
1, flush 0, corrupt 0, gen 0
Feb 25 15:16:24 localhost kernel: btrfs: unable to fixup (regular)
error at logical 2285387870208 on dev /dev/sdf1

I have a few questions:

* How is "total bytes scrubbed" determined? This array only has 2.2TB
of space used, so I'm confused about how many total bytes need to be
scrubbed before it is finished.

* What is the best way to recover from this error? If I delete
PATH/TO/REDACTED_FILE and recopy it, will everything be okay? (I found
a thread on the Arch Linux forums,
https://bbs.archlinux.org/viewtopic.php?id=170795, that mentions this
as a solution, but I can't tell if it's the proper method.

* Should I run another scrub? (I'd like to avoid another scrub if
possible because the scrub has been running for 24 hours already.)

* When a scrub is not running, is there any `btrfs` command that will
show me corrected and uncorrectable errors that occur during normal
operation? I guess something similar to `mdadm -D`.

* It seems like this type of error shouldn't happen on RAID6 as there
should be enough information to recover between the data, p parity,
and q parity. Is this just an implementation limitation of the current
RAID 5/6 code?

Thanks,
Justin
