Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31985 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932272AbcLLJdF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 04:33:05 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 0/3 for-4.10] RAID56 scrub fixes
Date: Mon, 12 Dec 2016 17:32:49 +0800
Message-Id: <20161212093249.8133-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixes 2 scrub bugs:
1) Scrub recover correct data, but wrong parity
2) Scrub report wrong csum error number, or even unrecoverable error

The patches are still undergoing xfstests, but currect for-linus-4.10 is already
causing deadlock for btrfs/011, even without the patches.

So I'd remove btrfs/011 and continue the test, even these test cases won't trigger
real recover code.

But the current internal test cases are quite good so far.
I'll test them for several extra loop, and submit the internal test for reference.
(Since it's not suitable for xfstest, so I'd only submit the test script, which
needs manually to probe chunk layout)

Qu Wenruo (3):
  btrfs: scrub: Introduce full stripe lock for RAID56
  btrfs: scrub: Fix RAID56 recovery race condition
  btrfs: raid56: Use correct stolen pages to calculate P/Q

 fs/btrfs/ctree.h       |   4 ++
 fs/btrfs/extent-tree.c |   3 +
 fs/btrfs/raid56.c      |  62 ++++++++++++++--
 fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 257 insertions(+), 4 deletions(-)

-- 
2.10.2



