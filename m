Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64089 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3KAGwt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 02:52:49 -0400
Received: by mail-pd0-f182.google.com with SMTP id q10so3467794pdj.13
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 23:52:49 -0700 (PDT)
Date: Thu, 31 Oct 2013 23:52:45 -0700
From: Kelley Nielsen <kelleynnn@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: opw-kernel@googlegroups.com
Subject: [PATCH 0/3] bootstrapping btrfs_find_item_interface
Message-ID: <cover.1383287959.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many btrfs functions that manually search the tree for an
item. They all reimplement the same mechanism and differ in the
conditions that they use to find the item. It has been proposed that a
new core interface, btrfs_find_item, be created to take the place of 
these functions, and standardize the search functionality.

This patchset takes the first steps toward the implementation of this
core interface. The first patch creates a starting point for the
interface by moving one of the search functions, __inode_item, to
ctree.c and renaming it with the core function name. The next two
patches eliminate one similar helper function each by replacing their
callers with calls to the new core function, and modifying the new core
function to ensure it fulfills the purpose of the function being
replaced.

Kelley Nielsen (3):
  Bootstrap generic btrfs_find_item interface
  btrfs_find_item expanded to include find_root_ref funcionality
  btrfs_find_item expanded to include find_orphan_item functionality

 fs/btrfs/backref.c   | 40 ++++----------------------------------
 fs/btrfs/ctree.c     | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h     |  2 ++
 fs/btrfs/disk-io.c   |  3 ++-
 fs/btrfs/inode.c     |  6 +++---
 fs/btrfs/orphan.c    | 20 -------------------
 fs/btrfs/root-tree.c | 15 --------------
 fs/btrfs/tree-log.c  |  3 ++-
 8 files changed, 68 insertions(+), 76 deletions(-)

-- 
1.8.1.2

