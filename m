Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729287AbeHOSTi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:38 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A1CDAD66
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/7] eb reference count cleanups
Date: Wed, 15 Aug 2018 18:26:50 +0300
Message-Id: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a series which simplifies the way eb are used in EXTENT_BUFFER_UNMAPPED
context. The end goal was to remove the special "if we have ref count of 2 and 
EXTENT_BUFFER_UNMAPPED flag then act as if this is the last ref and free the 
buffer" case. To enable this the first 6 patches modify call sites which 
needlessly bump the reference count.

Patch 1 & 2 remove some btree locking when we are operating on unmapped extent
buffers. Each patch's changelog explains why this is safe to do . 

Patch 3,4,5 and 6 remove redundant calls to extent_buffer_get since they don't 
really add any value. In all 3 cases having a reference count of 1 is sufficient 
for the eb to be freed via btrfs_release_path.

Patch 7 removes the special handling of EXTENT_BUFFER_UNMAPPED flag in 
free_extent_buffer. Also adjust the selftest code to account for this change 
by calling one extra time free_extent_buffer. Also document which references 
are being dropped. All in all this shouldn't have any functional bearing. 

This was tested with multiple full xfstest runs as well as unloading the btrfs 
module after each one to trigger the leak check and ensure no eb's are leaked. 
I've also run it through btrfs' selftests multiple times with no problems. 

With this set applied EXTENT_BUFFER_UNMAPPED seems to be relevant only for 
selftest which leads me to believe it can be removed altogether. I will 
investigate this next but in the meantime this series should be good to go.


Nikolay Borisov (7):
  btrfs: Remove needless locking in iterate_inode_refs
  btrfs: Remove needless locking in iterate_inode_extrefs
  btrfs: Remove redundant extent_buffer_get in get_old_root
  btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind
  btrfs: Remove extra reference count bumps in btrfs_compare_trees
  btrfs: Remove unnecessary locking code in qgroup_rescan_leaf
  btrfs: Remove special handling of EXTENT_BUFFER_UNMAPPED while freeing

 fs/btrfs/backref.c           |  9 ---------
 fs/btrfs/ctree.c             |  4 ----
 fs/btrfs/extent_io.c         | 11 -----------
 fs/btrfs/qgroup.c            |  7 +------
 fs/btrfs/tests/btrfs-tests.c |  6 +++++-
 5 files changed, 6 insertions(+), 31 deletions(-)

-- 
2.7.4
