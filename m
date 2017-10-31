Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53115 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJaRto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:49:44 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57236AD88
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:49:43 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] More GFP_NOFS cleanups
Date: Tue, 31 Oct 2017 18:47:53 +0100
Message-Id: <cover.1509471989.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (4):
  btrfs: prepare to drop gfp mask parameter from clear_extent_bit
  btrfs: sink gfp parameter to clear_extent_bit
  btrfs: sink gfp parameter to clear_extent_uptodate
  btrfs: use GFP_KERNEL in btrfs_alloc_inode

 fs/btrfs/extent_io.c         | 16 ++++++++--------
 fs/btrfs/extent_io.h         | 24 +++++++++++++-----------
 fs/btrfs/file.c              |  2 +-
 fs/btrfs/free-space-cache.c  |  8 +++-----
 fs/btrfs/inode.c             | 26 ++++++++++++--------------
 fs/btrfs/ioctl.c             |  2 +-
 fs/btrfs/qgroup.c            |  3 +--
 fs/btrfs/tests/inode-tests.c | 12 ++++--------
 fs/btrfs/transaction.c       |  3 +--
 9 files changed, 44 insertions(+), 52 deletions(-)

-- 
2.14.0

