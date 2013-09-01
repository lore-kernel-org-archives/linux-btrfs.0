Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50652 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3IAGPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 02:15:15 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so3488653pdi.41
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 23:15:15 -0700 (PDT)
Date: Sun, 01 Sep 2013 14:15:09 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re:  Notify caching_thread()s to give up on extent_commit_sem when
 needed.
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5222db6d.eeFXpiNC9FfIoYqJ%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Using checkpatch.pl, i get the following warnings(errors):
WARNING: please, no spaces at the start of a line
#49: FILE: fs/btrfs/ctree.h:1431:
+    atomic_t extent_commit_sem_give_up_read;$

WARNING: please, no spaces at the start of a line
#51: FILE: fs/btrfs/ctree.h:1433:
+    do { atomic_inc(&(fs_info)->extent_commit_sem_give_up_read);     \$

ERROR: code indent should use tabs where possible
#52: FILE: fs/btrfs/ctree.h:1434:
+         down_write(&(fs_info)->extent_commit_sem);                  \$

WARNING: please, no spaces at the start of a line
#52: FILE: fs/btrfs/ctree.h:1434:
+         down_write(&(fs_info)->extent_commit_sem);                  \$

ERROR: code indent should use tabs where possible
#53: FILE: fs/btrfs/ctree.h:1435:
+         atomic_dec(&(fs_info)->extent_commit_sem_give_up_read);     \$

WARNING: please, no spaces at the start of a line
#53: FILE: fs/btrfs/ctree.h:1435:
+         atomic_dec(&(fs_info)->extent_commit_sem_give_up_read);     \$

WARNING: please, no spaces at the start of a line
#54: FILE: fs/btrfs/ctree.h:1436:
+    } while (0)$

WARNING: please, no spaces at the start of a line
#66: FILE: fs/btrfs/disk-io.c:2294:
+    atomic_set(&fs_info->extent_commit_sem_give_up_read, 0);$

ERROR: code indent should use tabs where possible
#79: FILE: fs/btrfs/extent-tree.c:445:
+            if (need_resched() ||$

WARNING: please, no spaces at the start of a line
#79: FILE: fs/btrfs/extent-tree.c:445:
+            if (need_resched() ||$

ERROR: code indent should use tabs where possible
#80: FILE: fs/btrfs/extent-tree.c:446:
+                atomic_read(&fs_info->extent_commit_sem_give_up_read) > 0) {$

WARNING: please, no spaces at the start of a line
#80: FILE: fs/btrfs/extent-tree.c:446:
+                atomic_read(&fs_info->extent_commit_sem_give_up_read) > 0) {$

ERROR: patch seems to be corrupt (line wrapped?)
#85: FILE: fs/btrfs/extent-tree.c:632:
btrfs_block_group_cache *cache,

WARNING: please, no spaces at the start of a line
#90: FILE: fs/btrfs/extent-tree.c:636:
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);$

WARNING: please, no spaces at the start of a line
#100: FILE: fs/btrfs/extent-tree.c:5466:
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);$

WARNING: please, no spaces at the start of a line
#109: FILE: fs/btrfs/extent-tree.c:8223:
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);$

WARNING: please, no spaces at the start of a line
#123: FILE: fs/btrfs/transaction.c:972:
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);$

total: 5 errors, 12 warnings, 63 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks, Wang
