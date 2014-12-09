Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63937 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbaLII1g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:27:36 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RBhS013431
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:11 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
Date: Tue, 9 Dec 2014 16:27:19 +0800
Message-ID: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset introduce two new repair function and some helpers to
archive a huge goal:
  Repair btrfs whose fs tree's non-root leaf/node is corrupted when no
  duplication is valid.

The two new repair functions are:
  repair_inode_nlinks():
    Repair any inode nlink related problem.
    From fixing the nlink number and related
    inode_ref/dir_index/dir_item to recovering file name and file type
    and salvage them into the lost+found dir.
    This does not only fix a case that some users reported but also
    cooperate with repair_inode_no_item() function to salvaged heavily
    damaged inode to lost+found dir.

  repair_inode_no_item():
    Repair case for inode_item missing case, which is quite common when
    fs tree leaf/node is missing.
    This only does the inode item rebuild. Later recovery like move it
    to lost+found dir is done by repair_inode_nlinks().

The main helper is the repair_btree() function, which will drops the
corrupted non-root leaf/node and rebalance the tree to keep the
correctness of the btree.

With this patchset, even a non-root leaf/node is corrupted and no
duplication survived, btrfsck can still repair it to a mountable status.
(And normal rw should also be OK,)

The remaining unfixable problems will be inode nbytes error with file
extent discounts error, which may be fixed in next patchset.

Cc David:
Sorry for the huge change in the patchset and merge the old inode nlink
repair with new inode item rebuild patchset.

Since when developing inode item rebuild patchset, I found the old nlink
cooperated very bad with item rebuild and there is some duplicated codes
between the two patchset, no to mention the math lib introduced by nlink
repair patch.
So I decided to somewhat rebase the nlink repair patchset to provide
better generality.

Sorry again for taking your extra time rebasing the patch.

Qu Wenruo (13):
  btrfs-progs: print root dir verbose error in fsck
  btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.
  btrfs-progs: Import lookup/del_inode_ref() function.
  btrfs-progs: Add last_cache_extent() for extent-cache.
  btrfs-progs: Record highest inode number before repair.
  btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.
  btrfs-progs: Add btrfs_mkdir() function for the incoming 'lost+found' 
       fsck mechanism.
  btrfs-progs: Add count_digit() function to help calculate filename
    len.
  btrfs-progs: Add helper function find_file_name/type for nlink and    
    inode_item repair.
  btrfs-progs: Add fixing function for inodes whose nlink dismatch
  btrfs-progs: record and report leaf/node corruption in fs/subvol tree
  btrfs-progs: Recover btree by dropping corrupted leaf/node.
  btrfs-progs: Add inode item rebuild function.

 Makefile       |   2 +-
 cmds-check.c   | 579 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 ctree.c        |   6 +
 ctree.h        |  44 +++++
 extent-cache.c |   9 +
 extent-cache.h |   1 +
 inode-item.c   | 318 +++++++++++++++++++++++++++++++
 inode.c        | 540 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h        |  18 ++
 9 files changed, 1493 insertions(+), 24 deletions(-)
 create mode 100644 inode.c

-- 
2.1.3

