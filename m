Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752358AbdKTUZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:25:00 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE339AB02
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 20:24:58 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: some code cleanup and documentation
Date: Mon, 20 Nov 2017 13:24:46 -0700
Message-Id: <20171120202449.22947-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series adds a bit of code cleanup and some documentation in the
form of comments. No operational change.

Edmund Nadolski (3):
  btrfs: btrfs_inode_log_parent should use defined inode_only values.
  btrfs: update some code documentation
  btrfs: remove dead code from btrfs_get_extent

 fs/btrfs/ctree.c                | 31 +++++++++++++++-------
 fs/btrfs/ctree.h                | 28 +++++++++++++++-----
 fs/btrfs/extent_map.h           | 58 ++++++++++++++++++++++++++++-------------
 fs/btrfs/file-item.c            |  3 +++
 fs/btrfs/inode.c                | 43 ++++++++++++------------------
 fs/btrfs/tree-log.c             |  7 +++--
 include/uapi/linux/btrfs_tree.h |  1 +
 7 files changed, 108 insertions(+), 63 deletions(-)

-- 
2.10.2

