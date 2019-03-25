Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE5DC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B44A2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbfCYMbk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:31:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:55566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730996AbfCYMbj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 08:31:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BFB28ACAC
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 12:31:38 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 00/12] FITRIM improvements
Date:   Mon, 25 Mar 2019 14:31:20 +0200
Message-Id: <20190325123132.27835-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is v3 of the fitrim patches. Change since v2 [0]: 

 * Replaced BUG_ON with WARN_ON in patch 2

 * Added RB to patches 04/05/06/09

 * Squashed "btrfs: Transpose btrfs_close_devices/btrfs_mapping_tree_free in close_ctree"
 into patch 07. It was only sent to the mailing list as a followup.

 * Rebased all patches on latest misc-next.

 This has undergone multiple xfstest runs and I think is ready to be merged.

[0] https://lore.kernel.org/linux-btrfs/20190211083510.27591-1-nborisov@suse.com/


Jeff Mahoney (1):
  btrfs: replace pending/pinned chunks lists with io tree

Nikolay Borisov (11):
  btrfs: Honour FITRIM range constraints during free space trim
  btrfs: combine device update operations during transaction commit
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
 fs/btrfs/disk-io.c          |  20 ++-
 fs/btrfs/extent-tree.c      | 102 +++++--------
 fs/btrfs/extent_io.c        | 103 +++++++++++++-
 fs/btrfs/extent_io.h        |  19 ++-
 fs/btrfs/extent_map.c       |  38 +++++
 fs/btrfs/extent_map.h       |   1 -
 fs/btrfs/free-space-cache.c |   4 -
 fs/btrfs/transaction.c      |  51 +------
 fs/btrfs/transaction.h      |   2 +-
 fs/btrfs/volumes.c          | 277 ++++++++++++++----------------------
 fs/btrfs/volumes.h          |  23 ++-
 13 files changed, 332 insertions(+), 318 deletions(-)

-- 
2.17.1

