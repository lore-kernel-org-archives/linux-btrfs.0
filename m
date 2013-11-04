Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37979 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155Ab3KDVg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:36:58 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] btrfs: remove unused variables
Date: Mon,  4 Nov 2013 22:34:20 +0100
Message-Id: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

With this patchset I removed the unused variables found with 
	make W=1 fs/btrfs/

Cheers,

Valentina Giusti (9):
  btrfs: remove unused variable from btrfs_search_forward
  btrfs: remove unused variable from btrfs_new_inode
  btrfs: remove unused variables from disk-io.c
  btrfs: remove unused variable from find_free_extent
  btrfs: remove unused variables from extent_io.c
  btrfs: remove unused variable from setup_cluster_no_bitmap
  btrfs: remove unused variable from scrub_fixup_nodatasum
  btrfs: replace path->slots[0] with otherwise unused variable 'slot'
  btrfs: fix unused variables in qgroup.c

 fs/btrfs/backref.c          |    4 ++--
 fs/btrfs/ctree.c            |    2 --
 fs/btrfs/disk-io.c          |   11 -----------
 fs/btrfs/extent-tree.c      |    2 --
 fs/btrfs/extent_io.c        |    7 -------
 fs/btrfs/free-space-cache.c |    2 --
 fs/btrfs/inode.c            |    6 ------
 fs/btrfs/qgroup.c           |   11 ++---------
 fs/btrfs/scrub.c            |    2 --
 9 files changed, 4 insertions(+), 43 deletions(-)

-- 
1.7.10.4

