Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3980CC282CC
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 097EA20863
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfBKIfQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:35:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:41482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfBKIfP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 03:35:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0DD0AC89
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 08:35:13 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 00/12] FITRIM improvements
Date:   Mon, 11 Feb 2019 10:34:58 +0200
Message-Id: <20190211083510.27591-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is the second version of the FITRIM patchset. For background information 
consult the previous [0] post. Changes since v1: 

 * Dropped some cleanup patches as they have been merged in the meantime. 

 * In Patch 2 switched list iteration to list_for_each_entry_safe in
   btrfs_cleanup_one_transaction. (Johanness Thumshirn) 

 * Fixed a bug in Patch 12 which leads to infinite loop. Now find_first_clear_bit
   returns void since it doesn't have enough context to tell whether it exhausted 
   the search space

 * Fixed kerneldoc format in Patch 11 (Johaness Thumshirn)

 * Rebased on latest misc-next branch

 * Further testing of the patchset with newly enabled shared/298 test - succeeds. 
 
 [0] https://lore.kernel.org/linux-btrfs/20190130145102.4708-1-nborisov@suse.com/

Jeff Mahoney (2):
  btrfs: combine device update operations during transaction commit
  btrfs: replace pending/pinned chunks lists with io tree

Nikolay Borisov (10):
  btrfs: Honour FITRIM range constraints during free space trim
  btrfs: Handle pending/pinned chunks before blockgroup relocation
    during device shrink
  btrfs: Rename and export clear_btree_io_tree
  btrfs: Populate ->orig_block_len during read_one_chunk
  btrfs: Introduce new bits for device allocation tree
  btrfs: Remove 'trans' argument from find_free_dev_extent(_start)
  btrfs: Factor out in_range macro
  btrfs: Optimize unallocated chunks discard
  btrfs: Implement find_first_clear_extent_bit
  btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit

 fs/btrfs/ctree.h            |   8 +-
 fs/btrfs/dev-replace.c      |   2 +-
 fs/btrfs/disk-io.c          |  18 +--
 fs/btrfs/extent-tree.c      | 102 +++++--------
 fs/btrfs/extent_io.c        | 103 +++++++++++++-
 fs/btrfs/extent_io.h        |  19 ++-
 fs/btrfs/extent_map.c       |  38 +++++
 fs/btrfs/extent_map.h       |   1 -
 fs/btrfs/free-space-cache.c |   4 -
 fs/btrfs/transaction.c      |  53 ++-----
 fs/btrfs/transaction.h      |   2 +-
 fs/btrfs/volumes.c          | 277 ++++++++++++++----------------------
 fs/btrfs/volumes.h          |  23 ++-
 13 files changed, 332 insertions(+), 318 deletions(-)

-- 
2.17.1

