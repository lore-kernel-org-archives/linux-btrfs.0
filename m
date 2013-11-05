Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48131 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KED2h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 22:28:37 -0500
Received: by mail-pd0-f181.google.com with SMTP id x10so7547098pdj.40
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 19:28:36 -0800 (PST)
Date: Mon, 4 Nov 2013 19:28:34 -0800
From: Kelley Nielsen <kelleynnn@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: opw-kernel@googlegroups.com
Subject: [PATCH v2 0/3] Bootstrap the btrfs_find_item interface
Message-ID: <cover.1383621635.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many btrfs functions that manually search the tree for an
item. They all reimplement the same mechanism and differ in the
conditions that they use to find the item. Zach Brown proposed 
creating a new core interface, btrfs_find_item, take the place of
these functions, and standardize the search functionality.

This patchset takes the first steps toward the implementation of this
core interface. Create a starting point for the interface by moving 
one of the search functions, __inode_item, to ctree.c and renaming 
it with the core function name. With the next two patches, eliminate 
one similar helper function each by replacing their callers with 
calls to the new core function, and modifying the new core
function to ensure it fulfills the purpose of the function being
replaced.

Kelley Nielsen (3):
  Bootstrap generic btrfs_find_item interface
  expand btrfs_find_item() to include find_root_ref functionality
  expand btrfs_find_item() to include find_orphan_item functionality

 fs/btrfs/backref.c   | 40 ++++------------------------------------
 fs/btrfs/ctree.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h     |  2 ++
 fs/btrfs/disk-io.c   |  3 ++-
 fs/btrfs/inode.c     |  6 +++---
 fs/btrfs/orphan.c    | 20 --------------------
 fs/btrfs/root-tree.c | 15 ---------------
 fs/btrfs/tree-log.c  |  3 ++-
 8 files changed, 56 insertions(+), 76 deletions(-)

-- 
1.8.1.2

