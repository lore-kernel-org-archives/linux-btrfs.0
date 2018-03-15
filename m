Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbeCOMgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4E5DFACBA
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:35 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/8] Make the code -Wunused clean
Date: Thu, 15 Mar 2018 14:36:21 +0200
Message-Id: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series eliminates all -Wunused warnings in the code base. 

Nikolay Borisov (8):
  btrfs: Remove unused op_key var from add_delayed_refs
  btrfs: Remove unused length var from scrub_handle_errored_block
  btrfs: Remove unused tot_len var from lzo_decompress
  btrfs: Remove unused root var from relink_file_extents
  btrfs: remove max_active var from open_ctree
  btrfs: Remove unused parent_level var from btrfs_realloc_node
  btrfs: Remove unused extent_root var from caching_thread
  btrfs: Remove unused flush var in shrink_delalloc

 fs/btrfs/backref.c     | 5 +----
 fs/btrfs/ctree.c       | 3 ---
 fs/btrfs/disk-io.c     | 3 ---
 fs/btrfs/extent-tree.c | 7 -------
 fs/btrfs/inode.c       | 2 --
 fs/btrfs/lzo.c         | 2 --
 fs/btrfs/scrub.c       | 2 --
 7 files changed, 1 insertion(+), 23 deletions(-)

-- 
2.7.4

