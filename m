Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59758 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750798AbaLCERt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 23:17:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB34HQCe008377
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Dec 2014 12:17:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/6] More generic inode nlink repair function
Date: Wed, 3 Dec 2014 12:18:26 +0800
Message-ID: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update on patch 4 and 6, other is not changed.
This nlink repair function is more generic than the original one.

The old one can only handle a specific case that the inode_ref is
invalid, either point to a non-exist parent inode or point to a invalid
inode(not dir or conflicting index/name).

The new one will reset all the backref, no matter it is valid or not,
and re-add all the valid backref, this make the nlink handles more
corrupt cases.

Qu Wenruo (6):
  btrfs-progs: print root dir verbose error in fsck
  btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.
  btrfs-progs: Import lookup/del_inode_ref() function.
  btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.
  btrfs-progs: Add btrfs_mkdir() function for the incoming 'lost+found' 
       fsck mechanism.
  btrfs-progs: Add fixing function for inodes whose nlink dismatch

 Makefile     |   2 +-
 cmds-check.c | 311 ++++++++++++++++++++++++++++++++++++--
 ctree.c      |   6 +
 ctree.h      |  38 +++++
 inode-item.c | 318 +++++++++++++++++++++++++++++++++++++++
 inode.c      | 484 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1148 insertions(+), 11 deletions(-)
 create mode 100644 inode.c

-- 
2.1.3

