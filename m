Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8448 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1754034AbcKOCux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 21:50:53 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: kreijack@libero.it
Subject: [PATCH 0/2] RAID5/6 scrub race fix
Date: Tue, 15 Nov 2016 10:50:22 +0800
Message-Id: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the so-called famous RAID5/6 scrub error.

Thanks Goffredo Baroncelli for reporting the bug, and make it into our
sight.
(Yes, without the Phoronix report on this,
https://www.phoronix.com/scan.php?page=news_item&px=Btrfs-RAID-56-Is-Bad,
I won't ever be aware of it)

Unlike many of us(including myself) assumed, it's not a timed bomb buried
deeply into the RAID5/6 code, but a race condition in scrub recovery
code.

The problem is not found because normal mirror based profiles aren't
affected by the race, since they are independent with each other.

Although this time the fix doesn't affect the scrub code much, it should
warn us that current scrub code is really hard to maintain.

Abuse of workquque to delay works and the full fs scrub is race prone.

Xfstest will follow a little later, as we don't have good enough tools
to corrupt data stripes pinpointly.

Qu Wenruo (2):
  btrfs: scrub: Introduce full stripe lock for RAID56
  btrfs: scrub: Fix RAID56 recovery race condition

 fs/btrfs/ctree.h       |   4 ++
 fs/btrfs/extent-tree.c |   3 +
 fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 199 insertions(+)

-- 
2.10.2



