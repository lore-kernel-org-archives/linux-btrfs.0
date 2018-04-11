Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751925AbeDKIV0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 04:21:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0438BAF8B
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 08:21:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Misc cleanups
Date: Wed, 11 Apr 2018 11:21:16 +0300
Message-Id: <1523434880-7799-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's a collection of various cleanups I've done while working on other things. 
All of these should be pretty low-risk, have soaked for a while on my test 
branch and survived multiple xfstest runs. 

They strive to mostly untangle the code and make it more readable. 

Nikolay Borisov (4):
  btrfs: Use while loop instead of labels in __endio_write_update_ordered
  btrfs: Fix lock release order
  btrfs: Consolidate error checking for btrfs_alloc_chunk
  btrfs: Rewrite retry logic in do_chunk_alloc

 fs/btrfs/extent-tree.c | 79 +++++++++++++++++++++++---------------------------
 fs/btrfs/inode.c       | 52 ++++++++++++++++-----------------
 2 files changed, 61 insertions(+), 70 deletions(-)

-- 
2.7.4

