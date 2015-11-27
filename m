Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbbK0PdT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 10:33:19 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PATCH 0/4] Size reduction of btrfs_path
Date: Fri, 27 Nov 2015 16:31:32 +0100
Message-Id: <cover.1448637387.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can reduce size of btrfs_path by 32 bytes, which will lead to more objects
packed into one slab page. Performance should not be worse and could even
improve in some cases due to less cachelines used.
Targetting 4.5. Thanks.

Can be pulled from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/path-diet

David Sterba (4):
  btrfs: cleanup, use enum values for btrfs_path reada
  btrfs: use smaller type for btrfs_path reada
  btrfs: use smaller type for btrfs_path lowest_level
  btrfs: use smaller type for btrfs_path locks

 fs/btrfs/ctree.c       |  9 ++++-----
 fs/btrfs/ctree.h       |  7 ++++---
 fs/btrfs/extent-tree.c | 12 ++++++------
 fs/btrfs/file-item.c   |  4 ++--
 fs/btrfs/inode-map.c   |  2 +-
 fs/btrfs/inode.c       |  8 ++++----
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/relocation.c  | 12 ++++++------
 fs/btrfs/scrub.c       |  2 +-
 fs/btrfs/volumes.c     |  6 +++---
 fs/btrfs/xattr.c       |  2 +-
 11 files changed, 33 insertions(+), 33 deletions(-)

-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
