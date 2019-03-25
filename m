Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFADC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A6920700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfCYSpC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:38850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DF885AEC6
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C2D27DA98F; Mon, 25 Mar 2019 19:46:13 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 00/30] Redundant argument cleanups, part 1
Date:   Mon, 25 Mar 2019 19:46:13 +0100
Message-Id: <cover.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is first batch of utterly trivial changes that clean the cruft that
accumulated over the years. When fs_info has been added to
extent_buffer, few of the functions have been updated to reduce the
redundant arugments.

This series removes fs_info/eb combination. There are more such pairs,
patchsets will follow. Once all of them are cleaned, I strongly hope
that new code will not reintroduce them.

As the changes touch a lot of files, I'll merge the series either
partially or at some appropriate time not to create unnecessary
conflicts with pending patches.

David Sterba (30):
  btrfs: get fs_info from eb in lock_extent_buffer_for_io
  btrfs: get fs_info from eb in repair_eb_io_failure
  btrfs: get fs_info from eb in write_one_eb
  btrfs: get fs_info from eb in leaf_data_end
  btrfs: get fs_info from eb in btrfs_exclude_logged_extents
  btrfs: get fs_info from eb in check_tree_block_fsid
  btrfs: get fs_info from eb in tree_mod_log_eb_copy
  btrfs: get fs_info from eb in clean_tree_block
  btrfs: get fs_info from eb in btrfs_leaf_free_space
  btrfs: get fs_info from eb in read_node_slot
  btrfs: get fs_info from eb in btree_read_extent_buffer_pages
  btrfs: get fs_info from eb in btrfs_verify_level_key
  btrfs: tree-checker: get fs_info from eb in generic_err
  btrfs: tree-checker: get fs_info from eb in file_extent_err
  btrfs: tree-checker: get fs_info from eb in check_csum_item
  btrfs: tree-checker: get fs_info from eb in dir_item_err
  btrfs: tree-checker: get fs_info from eb in check_dir_item
  btrfs: tree-checker: get fs_info from eb in block_group_err
  btrfs: tree-checker: get fs_info from eb in check_block_group_item
  btrfs: tree-checker: get fs_info from eb in check_extent_data_item
  btrfs: tree-checker: get fs_info from eb in check_leaf_item
  btrfs: tree-checker: get fs_info from eb in check_leaf
  btrfs: get fs_info from eb in btrfs_check_leaf_full
  btrfs: get fs_info from eb in btrfs_check_leaf_relaxed
  btrfs: get fs_info from eb in btrfs_check_node
  btrfs: get fs_info from eb in should_balance_chunk
  btrfs: get fs_info from eb in btrfs_check_chunk_valid
  btrfs: get fs_info from eb in read_one_chunk
  btrfs: get fs_info from eb in read_one_chunk
  btrfs: get fs_info from eb in btrfs_check_leaf_write

 fs/btrfs/ctree.c           | 139 +++++++++++++++++-----------------
 fs/btrfs/ctree.h           |  11 +--
 fs/btrfs/delayed-inode.c   |   3 +-
 fs/btrfs/disk-io.c         |  39 +++++-----
 fs/btrfs/disk-io.h         |   5 +-
 fs/btrfs/extent-tree.c     |  10 +--
 fs/btrfs/extent_io.c       |  18 ++---
 fs/btrfs/extent_io.h       |   3 +-
 fs/btrfs/file-item.c       |   4 +-
 fs/btrfs/file.c            |   2 +-
 fs/btrfs/free-space-tree.c |   2 +-
 fs/btrfs/print-tree.c      |   2 +-
 fs/btrfs/qgroup.c          |   2 +-
 fs/btrfs/tree-checker.c    | 149 ++++++++++++++++++-------------------
 fs/btrfs/tree-checker.h    |  11 +--
 fs/btrfs/tree-log.c        |   8 +-
 fs/btrfs/volumes.c         |  27 ++++---
 fs/btrfs/xattr.c           |   2 +-
 18 files changed, 207 insertions(+), 230 deletions(-)

-- 
2.21.0

