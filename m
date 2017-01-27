Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50138 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbdA0VLy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jan 2017 16:11:54 -0500
Date: Fri, 27 Jan 2017 14:37:29 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20170127193728.GA50013@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.10 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.10

Has some fixes that we've collected from the list.  We still have one 
more pending to nail down a regression in lzo compression, but I wanted 
to get this batch out the door.

Omar Sandoval (3) commits (+2/-6):
     Btrfs: remove ->{get, set}_acl() from btrfs_dir_ro_inode_operations (+0/-2)
     Btrfs: remove old tree_root case in btrfs_read_locked_inode() (+1/-4)
     Btrfs: disable xattr operations on subvolume directories (+1/-0)

Liu Bo (1) commits (+12/-1):
     Btrfs: fix truncate down when no_holes feature is enabled

Chandan Rajendra (1) commits (+2/-2):
     Btrfs: Fix deadlock between direct IO and fast fsync

Wang Xiaoguang (1) commits (+1/-0):
     btrfs: fix false enospc error when truncating heavily reflinked file

Total: (6) commits (+17/-9)

  fs/btrfs/inode.c | 26 +++++++++++++++++---------
  1 file changed, 17 insertions(+), 9 deletions(-)
