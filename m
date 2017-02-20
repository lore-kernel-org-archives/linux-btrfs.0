Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44801 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdBTSZb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:25:31 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92486AAB2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:25:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Remove some BUG_ONs
Date: Mon, 20 Feb 2017 19:24:58 +0100
Message-Id: <cover.1487614974.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Minor cleanup in the BUG_ONs, where could be either removed or replaced by
proper error handling where the call chain is ready for that. For 4.11.

David Sterba (3):
      btrfs: remove BUG_ON from __tree_mod_log_insert
      btrfs: handle allocation error in update_dev_stat_item
      btrfs: do proper error handling in btrfs_insert_xattr_item

 fs/btrfs/ctree.c    | 2 --
 fs/btrfs/dir-item.c | 3 ++-
 fs/btrfs/volumes.c  | 3 ++-
 3 files changed, 4 insertions(+), 4 deletions(-)
