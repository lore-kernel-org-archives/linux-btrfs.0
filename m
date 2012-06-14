Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:31899 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab2FNRQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 13:16:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] Btrfs: tree mod log fixes for 3.5-rc3
Date: Thu, 14 Jun 2012 19:16:32 +0200
Message-Id: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This are my current fixes for the tree mod log. With these patches,
backref walking looks really stable now. My qgroup tests are getting
really close to succeeding :-)

Everything's pretty small and non-invasive, so it should be fine for the
upcomming rc.

You can also pull from

	git://git.jan-o-sch.net/btrfs-unstable for-chris

Thanks,
Jan

Jan Schmidt (6):
  Btrfs: remove call to btrfs_header_nritems with no effect
  Btrfs: remove obsolete btrfs_next_leaf call from
    __resolve_indirect_ref
  Btrfs: use btrfs_read_lock_root_node in get_old_root
  Btrfs: fix return value for __tree_mod_log_oldest_root
  Btrfs: add btrfs_next_old_leaf
  Btrfs: fix race in tree mod log addition

 fs/btrfs/backref.c |   17 +++-------
 fs/btrfs/ctree.c   |   86 ++++++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/ctree.h   |    2 +
 3 files changed, 70 insertions(+), 35 deletions(-)

-- 
1.7.3.4

