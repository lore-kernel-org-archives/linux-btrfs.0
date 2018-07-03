Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754096AbeGCJKN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 05:10:13 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C08BAD6F
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 09:10:12 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] Enhancement for block group/chunk verification
Date: Tue,  3 Jul 2018 17:10:04 +0800
Message-Id: <20180703091009.16399-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github, which is based on v4.18-rc1 tag:
https://github.com/adam900710/linux/tree/tree_checker_enhance

Reported by Xu Wen <wen.xu@gatech.edu>, some crafted btrfs image can
cause unexpected kernel behavior.

All of them are related to block group and chunk, so this patchset will
enhance block group and chunk verification, so kernel can detect them
and error out gracefully (with user friendly error message showing
what's going wrong)

Obvious corruption (don't need to cross check with chunk/block group),
will be addressed by enhanced tree-checker.
(Most crafted images will be caught by tree-checker)

More complex corruption will be addressed mostly at
btrfs_read_block_groups(), doing extra cross reference check for
chunk<->block group mapping.
It may cause extra mount time, but compared to the existing time
consuming block group items search, all added check is done completely
in memory using rb_tree, so it shouldn't add too much overhead.

Qu Wenruo (5):
  btrfs: tree-checker: Verify block_group_item
  btrfs: tree-checker: Detect invalid empty essential tree
  btrfs: relocation: Only remove reloc rb_trees if reloc control has
    been initialized
  btrfs: Check each block group has corresponding chunk at mount time
  btrfs: Verify every chunk has corresponding block group at mount time

 fs/btrfs/extent-tree.c  | 107 +++++++++++++++++++++++++++++++++++--
 fs/btrfs/relocation.c   |  23 ++++----
 fs/btrfs/tree-checker.c | 113 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c      |   2 +-
 fs/btrfs/volumes.h      |   2 +
 5 files changed, 232 insertions(+), 15 deletions(-)

-- 
2.18.0

