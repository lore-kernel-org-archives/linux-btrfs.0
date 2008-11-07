From: Chris Mason <chris.mason@oracle.com>
Subject: New compression fixes pushed out
Date: Thu, 06 Nov 2008 22:16:03 -0500
Message-ID: <1226027763.15281.32.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've pushed out my current batch of fixes for the compression code.  It
introduces async compression for writes and does a better job of filling
in pages for compressed extents while reading it.

The latest git trees should fix the bad page mapping errors and improve
performance even for uncompressed writes.

Checksumming is now done via an ordered work queue, which makes sure IO
is sent down to the device in the same order the writes were started.
On my 4 drive array, it pushes performance from 280MB/s 340MB/s for
sequential writes.

The same ordered work queues are used to keep ordering sane for the
async compression code.

-chris

