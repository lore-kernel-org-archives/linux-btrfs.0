Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:36702 "EHLO pim.lukas-pirl.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdIYJ7N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 05:59:13 -0400
Received: from [172.27.3.191] (unknown [195.37.142.77])
        by pim.lukas-pirl.de (Postfix) with ESMTPSA id 516D56BA5736
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 11:50:33 +0200 (CEST)
From: Lukas Pirl <btrfs@lukas-pirl.de>
Subject: btrfs scrub crashes OS
To: linux-btrfs@vger.kernel.org
Message-ID: <6e6dc9a3-b3e9-2831-8149-94f7c11b9df1@lukas-pirl.de>
Date: Mon, 25 Sep 2017 11:50:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

I experience reproducible OS crashes when scrubbing a btrfs file system.
Apart from that, the file system mounts rw and is usable without any
problems (including modifying snapshots and all that).

When the system crashes (i.e., freezes), there are no errors printed to
the system logs or via `dmesg` (had a display connected).

Recovery is only possible via power-cycling the machine.

The host experienced a lot of crashes and ATA errors due to hardware
failures in the past.
To the best of my knowledge, the hardware is stable now.

`btrfs device stats` outputs zeros for all counters.

`btrfsck --readonly --mode lowmem` outputs a bunch of
  referencer count mismatch …
and
  ERROR: data extent[… …] backref lost
see https://pastebin.com/seC4fReP for the full log.

System info:
btrfs RAID 1 (~1.5 years old), 7 SATA HDDs
  MIXED_BACKREF, BIG_METADATA, EXTENDED_IREF, SKINNY_METADATA, NO_HOLES
  no quotas in use
  see also https://pastebin.com/4me6zDsN for more details
btrfs-progs v4.12
GNU/Linux 4.12.0-0.bpo.1-amd64 #1 SMP Debian 4.12.6-1~bpo9+1 x86_64

The question, obviously, is how can I make this fs "scrubable" again?
Are the errors found by btrfsck safe to repair using btrfsck or some
other tool?

Thank you so much in advance,

Lukas
