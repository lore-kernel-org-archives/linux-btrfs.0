Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6364 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755533AbbGHDqg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 23:46:36 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t683iqde024529
	for <linux-btrfs@vger.kernel.org>; Wed, 8 Jul 2015 11:44:52 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 0/4] btrfs: Fix data checksum error cause by replace with io-load
Date: Wed, 8 Jul 2015 11:44:05 +0800
Message-ID: <cover.1436326244.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

This patchset is used to fix data checksum error cause by replace with io-load.
It cause xfstests btrfs/070 and btrfs/071 sometimes failed.

See description in [PATCH 4/4] for detail.

Changelog v2->v3:
1: Fix a typo(caused in rebase) which make xfstests failed in
   btrfs/073 and btrfs/066.
2: Rebase on top of integration-4.2
3: Do full xfstests(generic and btrfs group with 10 mount options)

Changelog v1->v2:
1: Update subject to reflect the problem being fixed.
2: Update description to say reason why set read-only can fix the
   problem.
3: Use a helper function to avoid duplicated code block for set
   chunk ro.
All of above are suggested by: David Sterba <dsterba@suse.cz>



Zhao Lei (4):
  btrfs: Use ref_cnt for set_block_group_ro()
  btrfs: Separate scrub_blocked_if_needed() to scrub_pause_on/off()
  btrfs: use scrub_pause_on/off() to reduce code in
    scrub_enumerate_chunks()
  btrfs: Fix data checksum error cause by replace with io-load.

 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/extent-tree.c | 42 +++++++++++++++++++++---------------------
 fs/btrfs/relocation.c  | 14 ++++++--------
 fs/btrfs/scrub.c       | 35 +++++++++++++++++++++++++++--------
 4 files changed, 57 insertions(+), 40 deletions(-)

-- 
1.8.5.1

