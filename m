Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753515AbdGXSAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 14:00:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 994DAAB1E
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 18:00:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Trivial cleanups
Date: Mon, 24 Jul 2017 19:59:06 +0200
Message-Id: <cover.1500919093.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (4):
  btrfs: fix spelling of snapshotting
  btrfs: drop ancient page flag mappings
  btrfs: remove trivial wrapper btrfs_force_ra
  btrfs: drop chunk locks at the end of close_ctree

 fs/btrfs/ctree.h       | 21 +++------------------
 fs/btrfs/disk-io.c     |  4 +---
 fs/btrfs/extent-tree.c | 22 +++++++++++-----------
 fs/btrfs/file.c        | 10 +++++-----
 fs/btrfs/inode.c       | 22 +++++++++++-----------
 fs/btrfs/ioctl.c       | 14 +++++++-------
 fs/btrfs/send.c        |  2 +-
 7 files changed, 39 insertions(+), 56 deletions(-)

-- 
2.13.0

