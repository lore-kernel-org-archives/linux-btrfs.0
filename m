Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C50C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD7A720866
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbeL1Ihu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 03:37:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:34310 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbeL1Ihu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 03:37:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA2AEABCE
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2018 08:37:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely reduce mount time
Date:   Fri, 28 Dec 2018 16:37:43 +0800
Message-Id: <20181228083745.3134-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from:
https://github.com/adam900710/linux/tree/bg_tree
Which is based on v4.20-rc1 tag.

This patchset will hugely reduce mount time of large fs by putting all
block group items into its own tree.

The old behavior will try to read out all block group items at mount
time, however due to the key of block group items are scattered across
tons of extent items, we must call btrfs_search_slot() for each block
group.

It works fine for small fs, but when number of block groups goes beyond
200, such tree search will become a random read, causing obvious slow
down.

On the other hand, btrfs_read_chunk_tree() is still very fast, since we
put CHUNK_ITEMS into their own tree and package them next to each other.


Following this idea, we could do the same thing for block group items,
so instead of triggering btrfs_search_slot() for each block group, we
just call btrfs_next_item() and under most case we could finish in
memory, and hugely speed up mount (see BENCHMARK below).

The only disadvantage is, this method introduce an incompatible feature,
so existing fs can't use this feature directly.
Either specify it at mkfs time, or use btrfs-progs offline convert tool
(*).

*: Mkfs and convert tool are doing the same work, however I haven't
decide if I should put this feature to btrfstune.

The RFC tag is for the comprehensive test and sysfs interface.
At least during my filling test it definitely works fine.

[[Benchmark]]
Physical device:	HDD (7200RPM)
Nodesize:		4K  (to bump up tree height)
Used size:		250G
Total size:		500G
Extent data size:	1M

All file extents on disk is in 1M size, ensured by using fallocate.

Without patchset:
Use ftrace function graph:

  3)               |  open_ctree [btrfs]() {
  3)               |    btrfs_read_chunk_tree [btrfs]() {
  3) * 69033.31 us |    }
  3)               |    btrfs_verify_dev_extents [btrfs]() {
  3) * 90376.15 us |    }
  3)               |    btrfs_read_block_groups [btrfs]() {
  2) $ 2733853 us  |    } /* btrfs_read_block_groups [btrfs] */
  2) $ 3168384 us  |  } /* open_ctree [btrfs] */

 btrfs_read_block_groups() takes 87% of the total mount time,

With patchset, and use -O bg-tree mkfs option:
  7)               |  open_ctree [btrfs]() {
  7)               |    btrfs_read_chunk_tree [btrfs]() {
  7) # 2448.562 us |    }
  7)               |    btrfs_verify_dev_extents [btrfs]() {
  7) * 19802.02 us |    }
  7)               |    btrfs_read_block_groups [btrfs]() {
  7) # 8610.397 us |    }
  7) @ 113498.6 us |  }

  open_ctree() time is only 3% of original mount time.
  And btrfs_read_block_groups() only takes 7.6% of total open_ctree()
  execution time.



Qu Wenruo (2):
  btrfs: Refactor btrfs_read_block_groups()
  btrfs: Introduce new incompat feature, BG_TREE

 fs/btrfs/ctree.h                |   5 +-
 fs/btrfs/disk-io.c              |  13 ++
 fs/btrfs/extent-tree.c          | 300 ++++++++++++++++++++------------
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |   3 +
 5 files changed, 206 insertions(+), 116 deletions(-)

-- 
2.20.1

