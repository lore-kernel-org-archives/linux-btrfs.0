Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33070 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752875AbaKXJJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 04:09:14 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAO98qFB012230
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 17:08:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/6] btrfs-progs: New 'lost+found' infrastructrue with
Date: Mon, 24 Nov 2014 17:06:59 +0800
Message-ID: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[SUMMARY]
Introduce the new 'lost+found' dir and related infrastructure to create it
in btrfs-progs.

[BUG]
With the new infrastructure, fix a bug that some people reported in both
kernel BZ and maillist, which there is some files' nlink is 1 but backref
points to non-exist parent.
The two reporters all report missing file(chrome config file), so we'd
better not to delete such files but use the 'lost+found' dir.

This bug is a kernel bug needing to be investigated, but the progs fix is
here before kernel fix.

[ROADMAP]
1. Fix the leaf corruption.
Currently, btrfs-progs can ignore corrupt leaf and continue
checking/reparing, however in that case, most problem can't be recovered
since its parent is missing(in corrupted leaf) and we were not able to
move them to someplace due to the missing of 'lost+found' dir.

With this patchset, there is a hope to fix such problems and I will
continue such work until we can fix most of most of the fs.

2. Unify the repair framework.
When writing the 6th patch, I think it is better to build a frame work
that unify the check and repair framework.
In 6th patch, my patchset and Josef's commit 2dc4c001 in fact has some
similar function but do the repair in different time and functions.

I will try to build a unified framework for repair, each repair will be
independent and have its own err number.
And each repair function should work like the following:
1) Check the error number
2) Do the repair
3) Update the related btrfsck record(like newly created inode, deleted inode)

Qu Wenruo (6):
  btrfs-progs: print root dir verbose error in fsck
  btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.
  btrfs-progs: Import lookup/del_inode_ref() function.
  btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.
  btrfs-progs: Add btrfs_mkdir() function for the incoming 'lost+found' 
       fsck mechanism.
  btrfs-progs: Add fixing function for inodes whose nlink dismatch

 Makefile     |   2 +-
 cmds-check.c | 284 +++++++++++++++++++++++++++++++++++--
 ctree.c      |   6 +
 ctree.h      |  38 +++++
 inode-item.c | 318 +++++++++++++++++++++++++++++++++++++++++
 inode.c      | 453 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1090 insertions(+), 11 deletions(-)
 create mode 100644 inode.c

-- 
2.1.3

