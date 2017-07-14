Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54223 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750860AbdGNSbX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 14:31:23 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80E4DAAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 18:31:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Function parameter reductions
Date: Fri, 14 Jul 2017 20:30:09 +0200
Message-Id: <cover.1500056930.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (4):
  btrfs: get fs_info from eb in btrfs_print_leaf, remove argument
  btrfs: get fs_info from eb in btrfs_print_tree, remove argument
  btrfs: cleanup types storing REQ_*
  btrfs: merge REQ_OP and REQ_ flags to one parameter in
    submit_extent_page

 fs/btrfs/ctree.c       | 14 +++++++-------
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c |  6 +++---
 fs/btrfs/extent_io.c   | 24 ++++++++++++++----------
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/print-tree.c  | 10 ++++++----
 fs/btrfs/print-tree.h  |  4 ++--
 fs/btrfs/root-tree.c   |  2 +-
 8 files changed, 35 insertions(+), 29 deletions(-)

-- 
2.13.0

