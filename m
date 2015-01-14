Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbbANSgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 13:36:32 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 06F5DAB0E
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 18:36:30 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PULL] [PATCH 0/5] Btrfs: leak in btrfs_find_item and cleanups
Date: Wed, 14 Jan 2015 19:36:30 +0100
Message-Id: <cover.1421259762.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Coverity for btrfs-progs spotted a variable leak in btrfs_find_item though the
same error is not reported in the kernel project and the code is the same.  The
leak is very rare though and does not need to go to stable immediatelly. The
rest of patches are cleanups in the related codepaths.

You can also pull the changes from
  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fix/find-item-path-leak

Top commit: 1d4c08e0a60be3561
Base: 3.19-rc4

David Sterba (5):
  btrfs: fix leak of path in btrfs_find_item
  btrfs: cleanup, remove inode_item_info helper
  btrfs: cleanup, remove inode_ref_info helper
  btrfs: simplify insert_orphan_item
  btrfs: expand btrfs_find_item if found_key is NULL

 fs/btrfs/backref.c  | 28 ++++++----------------------
 fs/btrfs/backref.h  |  3 ---
 fs/btrfs/ctree.c    | 18 +++++-------------
 fs/btrfs/disk-io.c  | 15 +++++++++++++--
 fs/btrfs/inode.c    | 10 +++++++---
 fs/btrfs/scrub.c    | 10 +++++++++-
 fs/btrfs/tree-log.c | 11 ++++++-----
 7 files changed, 46 insertions(+), 49 deletions(-)

-- 
1.8.4.5

