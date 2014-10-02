Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaJBQw2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:52:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 85C91AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:52:27 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/6] Cleanup, remove superfluous blocksize parameter
Date: Thu,  2 Oct 2014 18:52:27 +0200
Message-Id: <cover.1412265712.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First portion of cleanups that remove a parameter that's being passed to a lot
of functions, although the value does not change during the filesystem
lifetime.  This part contains the obvious and safe changes, but there are more
pending that start to touch functionality and haven't not passed xfstests
without warnings.

You can pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanup/blocksize-diet-part1

David Sterba (6):
  btrfs: remove unused parameter from readahead_tree_block
  btrfs: return void from readahead_tree_block
  btrfs: inline code of reada_tree_block and remove it
  btrfs: remove parameter blocksize from read_tree_block
  btrfs: remove unused parameter blocksize from btrfs_find_tree_block
  btrfs: remove blocksize from btrfs_alloc_free_block and rename

 fs/btrfs/backref.c     |  6 ++----
 fs/btrfs/ctree.c       | 54 ++++++++++++++++++++------------------------------
 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/disk-io.c     | 37 +++++++++++-----------------------
 fs/btrfs/disk-io.h     |  7 +++----
 fs/btrfs/extent-tree.c | 20 ++++++++-----------
 fs/btrfs/ioctl.c       |  3 +--
 fs/btrfs/print-tree.c  |  1 -
 fs/btrfs/relocation.c  | 28 ++++++--------------------
 9 files changed, 57 insertions(+), 105 deletions(-)

-- 
1.8.4.5

