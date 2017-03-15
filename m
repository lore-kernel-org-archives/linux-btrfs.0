Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbdCOQD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:03:57 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF2CAAC1D
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 16:02:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/7] Readahead clenups
Date: Wed, 15 Mar 2017 17:02:20 +0100
Message-Id: <cover.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I spotted some GFP_NOFS uses in readahead and converted them to GFP_KERNEL with
a few cleanups along the way.

David Sterba (7):
  btrfs: preallocate radix tree node for readahead
  btrfs: use simpler readahead zone lookups
  btrfs: preallocate radix tree node for global readahead tree
  btrfs: remove redundant parameter from btree_readahead_hook
  btrfs: remove redundant parameter from reada_find_zone
  btrfs: remove redundant parameter from reada_start_machine_dev
  btrfs: remove local blocksize variable in reada_find_extent

 fs/btrfs/ctree.h   |  3 +-
 fs/btrfs/disk-io.c |  6 ++--
 fs/btrfs/reada.c   | 89 ++++++++++++++++++++++++++++--------------------------
 fs/btrfs/volumes.c |  2 +-
 4 files changed, 51 insertions(+), 49 deletions(-)

-- 
2.12.0

