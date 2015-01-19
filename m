Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63914 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404AbbASMAy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 07:00:54 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0JBLaJU007804
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 19:21:37 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 00/16] Btrfs: Cleanup for raid56 scrub
Date: Mon, 19 Jan 2015 19:20:49 +0800
Message-ID: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Hi, everyone,

These are v2 of cleanup patchs for raid56's scrub functions, it is
based on review for new-developed raid56's scrub code.

Some small typo-fix and cleanup for other functions are also included in
this patchset.

Changelog v1->v2:
1: scrib -> scrub in description.
   Suggested by: Brendan Hide <brendan@swiftspirit.co.za>
2: get/put_btrfs_bio() -> btrfs_get/put_bio()
   Suggested by: David Sterba <dsterba@suse.cz>
3: bbio->ref_count -> bbio->refs
   Suggested by: David Sterba <dsterba@suse.cz>
4: all ref_count -> refs in other code(new PATCH 16/16)
   Suggested by: David Sterba <dsterba@suse.cz>

Many thanks for above people for review these patch.

Thanks
Zhaolei

Zhao Lei (16):
  Btrfs: fix a out-of-bound access of raid_map
  Btrfs: sort raid_map before adding tgtdev stripes
  Btrfs: Make raid_map array be inlined in btrfs_bio structure
  Btrfs: add ref_count and free function for btrfs_bio
  Btrfs: Fix a jump typo of nodatasum_case to avoid wrong WARN_ON()
  Btrfs: Remove noneed force_write in scrub_write_block_to_dev_replace
  Btrfs: Cleanup btrfs_bio_counter_inc_blocked()
  Btrfs: btrfs_rm_dev_replace_blocked(): Use wait_event()
  Btrfs: Break loop when reach BTRFS_MAX_MIRRORS in
    scrub_setup_recheck_block()
  Btrfs: Avoid trustless page-level-repair in dev-replace
  Btrfs: Separate finding-right-mirror and writing-to-target's process
    in scrub_handle_errored_block()
  Btrfs: Combine per-page recover in dev-replace and scrub
  Btrfs: Simplify scrub_setup_recheck_block()'s argument
  Btrfs: Include map_type in raid_bio
  Btrfs: Introduce BTRFS_BLOCK_GROUP_RAID56_MASK to check raid56 simply
  Rename all ref_count to refs in struct

 fs/btrfs/ctree.h       |   3 +
 fs/btrfs/dev-replace.c |  25 ++---
 fs/btrfs/extent-tree.c |   2 +-
 fs/btrfs/extent_io.c   |   2 +-
 fs/btrfs/inode.c       |   3 +-
 fs/btrfs/raid56.c      | 104 ++++++-----------
 fs/btrfs/raid56.h      |  11 +-
 fs/btrfs/reada.c       |   4 +-
 fs/btrfs/scrub.c       | 296 ++++++++++++++++++++++---------------------------
 fs/btrfs/volumes.c     | 176 +++++++++++++++--------------
 fs/btrfs/volumes.h     |  18 +--
 11 files changed, 297 insertions(+), 347 deletions(-)

-- 
1.8.5.1

