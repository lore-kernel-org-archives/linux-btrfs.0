Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:61954 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab2JWNz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 09:55:29 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: [PATCH 0/6] Btrfs: tree mod log fixes for 3.7-rc3
Date: Tue, 23 Oct 2012 15:55:21 +0200
Message-Id: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I've got 5 small fixes for the tree mod log and a comment fix, here.
Each of them is making the overall situation a little better. I'm not
sure whether these also fix the problems liubo was seeing, we're still
sorting that out. So there's probably one more fix to come, but if so,
I don't expect anything huge (hrhr).

You can also pull them from the usual location:

    git://git.jan-o-sch.net/btrfs-unstable for-chris

Thanks,
-Jan

Jan Schmidt (6):
  Btrfs: don't put removals from push_node_left into tree mod log twice
  Btrfs: fix a tree mod logging issue for root replacement operations
  Btrfs: tree mod log's old roots could still be part of the tree
  Btrfs: determine level of old roots
  Btrfs: fix extent buffer reference for tree mod log roots
  Btrfs: comment for loop in tree_mod_log_insert_move

 fs/btrfs/backref.c |    4 +--
 fs/btrfs/ctree.c   |   59 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ctree.h   |    1 +
 3 files changed, 48 insertions(+), 16 deletions(-)

