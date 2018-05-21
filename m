Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43601 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbeEUJ1b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 05:27:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4DB39ADAC
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 09:27:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Cleanup alloc_reserved_tree_block signature 
Date: Mon, 21 May 2018 12:27:19 +0300
Message-Id: <1526894843-8732-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At the moment alloc_reserved_tree_block takes 8 friggin arguments. The irony 
is that all of those are really derived from 3 structures. This series ends up 
reducing the arguments to 3. As a result some code, private to alloc_reserved_tree_block
is moved from run_delayed_tree_ref. Patch 1 removes the fs_info argument, 
Patch 2 replaces all arguments derived from btrfs_delayed_ref_node with the 
nodes itself, Patch 3 replaces the last 2 arguments with btrfs_delayed_extent_op
and finally, Patch 4 simplifies the code a bit by removing one extra check.

All in all this doesn't provide any functional changes but makes the code 
easier to follow. Also it has survived 2 xfstest runs. 

Nikolay Borisov (4):
  btrfs: Remove fs_info argument from alloc_reserved_tree_block
  btrfs: Simplify alloc_reserved_tree_block interface
  btrfs: Pass btrfs_delayed_extent_op to alloc_reserved_tree_block
  btrfs: Streamline shared ref check in alloc_reserved_tree_block

 fs/btrfs/extent-tree.c | 76 ++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

-- 
2.7.4

