Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:56753 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751401AbcIJGHm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 02:07:42 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: btrfs_endio_write_helper hard lock blocked qorkqueues with kernel
 4.8-rc5
Message-ID: <600fe0c5-455d-dd7b-1917-b3ab605c68c3@profihost.ag>
Date: Sat, 10 Sep 2016 08:07:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

today i've seen this one with 4.8-rc5 and the system was going to be
unresponsible.

BUG: workqueue lockup - pool cpus=14 node=1 flags=0x0 nice=0 stuck for 33s!
BUG: workqueue lockup - pool cpus=14 node=1 flags=0x0 nice=-20 stuck for
33s!
Showing busy workqueues and worker pools:
workqueue kblockd: flags=0x18
pwq 29: cpus=14 node=1 flags=0x0 nice=-20 active=9/256
pending: cfq_kick_queue, cfq_kick_queue, cfq_kick_queue, cfq_kick_queue,
cfq_kick_queue, cfq_kick_queue, cfq_kick_queue, cfq_kick_queue,
cfq_kick_queue
workqueue vmstat: flags=0xc
pwq 28: cpus=14 node=1 flags=0x0 nice=0 active=1/256
pending: vmstat_update
workqueue btrfs-endio-write: flags=0xe
pwq 66: cpus=8-15,24-31 node=1 flags=0x4 nice=0 active=8/8
in-flight: 12942:btrfs_endio_write_helper [btrfs],
11348:btrfs_endio_write_helper [btrfs], 11350:btrfs_endio_write_helper
[btrfs], 5472:btrfs_endio_write_helper [btrfs],
3277:btrfs_endio_write_helper [btrfs], 13523:btrfs_endio_write_helper
[btrfs], 5477:btrfs_endio_write_helper [btrfs],
5471:btrfs_endio_write_helper [btrfs]
delayed: btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs], btrfs_endio_write_helper
[btrfs], btrfs_endio_write_helper [btrfs]
2016-09-10 05:06:22      NMI watchdog: Watchdog detected hard LOCKUP on
cpu 0dModules linked in: netconsole ipt_REJECT nf_reject_ipv4
xt_multiport iptable_filter ip_tables x_tables 8021q garp bonding
sb_edac edac_core x86_pkg_temp_thermal coretemp kvm_intel kvm i2c_i801
i2c_smbus irqbypass ipmi_si crc32_pclmul i2c_core ghash_clmulni_intel
shpchp ipmi_msghandler button loop fuse btrfs dm_mod raid10 raid0
multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq raid1 md_mod sg sd_mod ixgbe i40e mdio
usbhid ehci_pci ehci_hcd usbcore ahci ptp aacraid usb_common libahci
pps_core
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.0-rc5-00010-g4d84bef-dirty #5
Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c 02/18/2015
task: ffffffff82c0b500 task.stack: ffffffff82c00000
RIP: 0010:[<ffffffff8255a783>] [<ffffffff8255a783>]
cpuidle_enter_state+0x153/0x2d0
RSP: 0018:ffffffff82c03ea8 EFLAGS: 00000246
RAX: ffff99ba9fa17c00 RBX: ffffe118a0200708 RCX: 000000000000001f
RDX: 0000000000000000 RSI: ffff99ba9fa152d8 RDI: 0000000000000000
RBP: ffffffff82c03ee0 R08: 0000000000000003 R09: 00000000000003c4
R10: 00000000ffffffff R11: ffff99ba9fa14d24 R12: 0000000000000003
R13: 0000000000000003 R14: 0000000000000000 R15: 00001cbd43a98fd3
FS: 0000000000000000(0000) GS:ffff99ba9fa00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f71de259000 CR3: 0000000915c06000 CR4: 00000000001406f0Stack:
0000000000000000 00001cbd43b8cc5f 0000000000000000 ffffe118a0200708
ffffffff82cc6900 ffffffff82c00000 ffffffff82c00000 ffffffff82c03ef0
ffffffff8255a937 ffffffff82c03f40 ffffffff820c879b ffffffff82c04000
Call Trace:
[<ffffffff8255a937>] cpuidle_enter+0x17/0x20
[<ffffffff820c879b>] cpu_startup_entry+0x31b/0x360
[<ffffffff826d1ff7>] rest_init+0x77/0x80
[<ffffffff82d85f6c>] start_kernel+0x468/0x475
[<ffffffff82d85120>] ? early_idt_handler_array+0x120/0x120
[<ffffffff82d8543f>] x86_64_start_reservations+0x24/0x26
[<ffffffff82d85579>] x86_64_start_kernel+0x138/0x147
Code: 31 ff e8 01 dc b6 ff 80 7d cb 00 74 17 9c 58 0f 1f 44 00 00 f6 c4
02 0f 85 39 01 00 00 31 ff e8 d4 d2 b9 ff fb 66 0f 1f 44 00 00 <4c> 8b
65 d0 48 ba cf f7 53 e3 a5 9b c4 20 4d 29 fc 4c 89 e0 49
Kernel panic - not syncing: Hard LOCKUP
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.0-rc5-00010-g4d84bef-dirty #5
Hardware name: Supermicro X10DRH/X10DRH-IT, BIOS 1.0c 02/18/2015
0000000000000000 ffff99ba9fa05b40 ffffffff823de363 ffffffff82c03d00
ffffffff82a0cf20 ffff99ba9fa05bc0 ffffffff82158a0d ffff99ba00000010
ffff99ba9fa05bd0 ffff99ba9fa05b68 0000000000000003 ffffffff82a0e634
Call Trace:
<NMI> [<ffffffff823de363>] dump_stack+0x63/0x90
[<ffffffff82158a0d>] panic+0xd9/0x220
[<ffffffff82084b5b>] nmi_panic+0x3b/0x40
[<ffffffff8211d540>] watchdog_overflow_callback+0xd0/0xe0
[<ffffffff82149f0c>] __perf_event_overflow+0x7c/0x200
[<ffffffff821547c4>] perf_event_overflow+0x14/0x20
[<ffffffff8200af3c>] intel_pmu_handle_irq+0x1cc/0x450
[<ffffffff823e0387>] ? ioremap_page_range+0x287/0x3e0
[<ffffffff8219fc3c>] ? vunmap_page_range+0x20c/0x340
[<ffffffff8219fd81>] ? unmap_kernel_range_noflush+0x11/0x20
[<ffffffff8247ddbe>] ? ghes_copy_tofrom_phys+0x11e/0x2a0
[<ffffffff8203f8ef>] ? native_apic_wait_icr_idle+0x1f/0x30
[<ffffffff82020865>] ? arch_irq_work_raise+0x35/0x40
[<ffffffff82004bad>] perf_event_nmi_handler+0x2d/0x50
[<ffffffff8201f1d6>] nmi_handle+0x66/0x120
[<ffffffff8201f4b5>] do_nmi+0x225/0x3b0
[<ffffffff826e05b1>] end_repeat_nmi+0x1a/0x1e
[<ffffffff8244533a>] ? cfb_imageblit+0x4ca/0x500
[<ffffffff8244533a>] ? cfb_imageblit+0x4ca/0x500
[<ffffffff8244533a>] ? cfb_imageblit+0x4ca/0x500
<<EOE>> <IRQ> [<ffffffff8243c244>] bit_putcs+0x2d4/0x520
[<ffffffff8243bf70>] ? bit_cursor+0x630/0x630
[<ffffffff8243799e>] fbcon_putcs+0xfe/0x130
[<ffffffff82437c86>] fbcon_redraw.isra.26+0x166/0x1d0
[<ffffffff82438998>] fbcon_scroll+0x1e8/0xd10
[<ffffffff824a7d27>] scrup+0x147/0x160
[<ffffffff824a7dc0>] lf+0x80/0x90
[<ffffffff824a806c>] vt_console_print+0x29c/0x3d0
[<ffffffff820d3859>] call_console_drivers.isra.15.constprop.31+0xe9/0xf0
[<ffffffff820d4d4e>] console_unlock+0x40e/0x570
[<ffffffff8200eb9e>] ? intel_pmu_pebs_enable+0x6e/0x170
[<ffffffff820d5191>] vprintk_emit+0x2e1/0x4c0
[<ffffffff820d5191>] ? vprintk_emit+0x2e1/0x4c0
[<ffffffff820d550f>] vprintk_default+0x1f/0x30
[<ffffffff82158de8>] printk+0x48/0x50
[<ffffffffc02a4ad0>] ? btrfs_rmw_helper+0x20/0x20 [btrfs]
[<ffffffff82158bfd>] pr_cont_work+0x68/0x6a
[<ffffffff8209fe3c>] show_workqueue_state+0x23c/0x4b0
[<ffffffff82158de8>] ? printk+0x48/0x50
[<ffffffff820a0197>] wq_watchdog_timer_fn+0xe7/0x140
[<ffffffff820a00b0>] ? show_workqueue_state+0x4b0/0x4b0
[<ffffffff820e8935>] call_timer_fn+0x35/0x130
[<ffffffff820e9909>] run_timer_softirq+0x439/0x4a0
[<ffffffff820f0e9c>] ? ktime_get+0x3c/0xb0
[<ffffffff8203ed96>] ? lapic_next_deadline+0x26/0x30
[<ffffffff820f75ef>] ? clockevents_program_event+0x7f/0x120
[<ffffffff8208a353>] __do_softirq+0x103/0x290
[<ffffffff8208a662>] irq_exit+0xc2/0xd0
[<ffffffff8203fa92>] smp_apic_timer_interrupt+0x42/0x50
[<ffffffff826def7c>] apic_timer_interrupt+0x8c/0xa0
<EOI> [<ffffffff8255a783>] ? cpuidle_enter_state+0x153/0x2d0
[<ffffffff8255a75f>] ? cpuidle_enter_state+0x12f/0x2d0
[<ffffffff8255a937>] cpuidle_enter+0x17/0x20
[<ffffffff820c879b>] cpu_startup_entry+0x31b/0x360
[<ffffffff826d1ff7>] rest_init+0x77/0x80
[<ffffffff82d85f6c>] start_kernel+0x468/0x475
[<ffffffff82d85120>] ? early_idt_handler_array+0x120/0x120
[<ffffffff82d8543f>] x86_64_start_reservations+0x24/0x26
[<ffffffff82d85579>] x86_64_start_kernel+0x138/0x147
Shutting down cpus with NMI
Kernel Offset: 0x1000000 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Hard LOCKUP


Stefan
