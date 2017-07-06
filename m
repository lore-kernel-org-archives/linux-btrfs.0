Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0050.outbound.protection.outlook.com ([104.47.116.50]:42333
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752480AbdGFDTR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Jul 2017 23:19:17 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Btrfs Compression
Date: Thu, 6 Jul 2017 03:19:14 +0000
Message-ID: <MEXPR01MB2168F46962D1BFF8BC303A279ED50@MEXPR01MB2168.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While reading the thread about adding zstd compression, it occurred to me that there is potentially another thing affecting performance - Compressed extent size. (correct my terminology if it's incorrect).
I have two near identical RAID1 filesystems (used for backups) on near identical discs (HGST 3T), one compressed and one not. The filesystems have about 40 snapshots and are about 50% full. The uncompressed filesystem runs at about 60 MB/s, the compressed filesystem about 5-10 MB/s. There is noticeably more "noise" from the compressed filesystem from all the head thrashing that happens while rsync is happening.

Which brings me to my point - In terms of performance for compression, is there some low hanging fruit in adjusting the extent size to be more like uncompressed extents so there is not so much seeking happening? With spinning discs with large data sets it seems pointless making the numerical calculations faster if the discs can't keep up. Obviously this is assuming optimisation for speed over compression ratio.

Thoughts?

Paul.

