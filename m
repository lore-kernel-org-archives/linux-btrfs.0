Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbeDCSPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:15:48 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] btrfs: replace GPL boilerplate by SPDX -- headers
Date: Tue,  3 Apr 2018 20:13:19 +0200
Message-Id: <b2adf6420cf31d45ed99347839ce3e559026fc1f.1522778802.git.dsterba@suse.com>
In-Reply-To: <cover.1522778802.git.dsterba@suse.com>
References: <cover.1522778802.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove GPL boilerplate text (long, short, one-line) and keep the rest,
ie. personal, company or original source copyright statements. Add the
SPDX header.

Unify the include protection macros to match the file names.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/async-thread.h      | 21 +++++----------------
 fs/btrfs/backref.h           | 19 +++----------------
 fs/btrfs/btrfs_inode.h       | 19 +++----------------
 fs/btrfs/check-integrity.h   | 19 +++----------------
 fs/btrfs/compression.h       | 19 +++----------------
 fs/btrfs/ctree.h             | 20 ++++----------------
 fs/btrfs/dedupe.h            | 20 ++++----------------
 fs/btrfs/delayed-inode.h     | 19 +++----------------
 fs/btrfs/delayed-ref.h       | 21 +++++----------------
 fs/btrfs/dev-replace.h       | 20 ++++----------------
 fs/btrfs/disk-io.h           | 20 ++++----------------
 fs/btrfs/export.h            |  1 +
 fs/btrfs/extent_io.h         |  6 ++++--
 fs/btrfs/extent_map.h        |  6 ++++--
 fs/btrfs/free-space-cache.h  | 19 +++----------------
 fs/btrfs/free-space-tree.h   | 19 +++----------------
 fs/btrfs/inode-map.h         |  5 +++--
 fs/btrfs/locking.h           | 19 +++----------------
 fs/btrfs/math.h              | 20 +++-----------------
 fs/btrfs/ordered-data.h      | 20 ++++----------------
 fs/btrfs/print-tree.h        | 21 +++++----------------
 fs/btrfs/props.h             | 19 +++----------------
 fs/btrfs/qgroup.h            | 22 +++++-----------------
 fs/btrfs/raid56.h            | 21 +++++----------------
 fs/btrfs/rcu-string.h        | 20 ++++++--------------
 fs/btrfs/ref-verify.h        | 23 ++++++-----------------
 fs/btrfs/send.h              | 20 ++++++--------------
 fs/btrfs/sysfs.h             |  7 ++++---
 fs/btrfs/tests/btrfs-tests.h | 19 +++----------------
 fs/btrfs/transaction.h       | 20 ++++----------------
 fs/btrfs/tree-checker.h      | 17 +++--------------
 fs/btrfs/tree-log.h          | 20 ++++----------------
 fs/btrfs/ulist.h             |  7 +++----
 fs/btrfs/volumes.h           | 19 +++----------------
 fs/btrfs/xattr.h             | 21 ++++-----------------
 35 files changed, 133 insertions(+), 475 deletions(-)

diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index fc957e00cef1..7861c9feba5f 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -1,24 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
  * Copyright (C) 2014 Fujitsu.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_ASYNC_THREAD_
-#define __BTRFS_ASYNC_THREAD_
+#ifndef BTRFS_ASYNC_THREAD_H
+#define BTRFS_ASYNC_THREAD_H
+
 #include <linux/workqueue.h>
 
 struct btrfs_fs_info;
@@ -85,4 +73,5 @@ void btrfs_set_work_high_priority(struct btrfs_work *work);
 struct btrfs_fs_info *btrfs_work_owner(const struct btrfs_work *work);
 struct btrfs_fs_info *btrfs_workqueue_owner(const struct __btrfs_workqueue *wq);
 bool btrfs_workqueue_normal_congested(const struct btrfs_workqueue *wq);
+
 #endif
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 0a30028d5196..54d58988483a 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 STRATO.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_BACKREF__
-#define __BTRFS_BACKREF__
+#ifndef BTRFS_BACKREF_H
+#define BTRFS_BACKREF_H
 
 #include <linux/btrfs.h>
 #include "ulist.h"
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ca15be569d69..234bae55b85d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_I__
-#define __BTRFS_I__
+#ifndef BTRFS_INODE_H
+#define BTRFS_INODE_H
 
 #include <linux/hash.h>
 #include "extent_map.h"
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
index 2de58a99ee92..9bf4359cc44c 100644
--- a/fs/btrfs/check-integrity.h
+++ b/fs/btrfs/check-integrity.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) STRATO AG 2011.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#if !defined(__BTRFS_CHECK_INTEGRITY__)
-#define __BTRFS_CHECK_INTEGRITY__
+#ifndef BTRFS_CHECK_INTEGRITY_H
+#define BTRFS_CHECK_INTEGRITY_H
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh);
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index ce796557a918..cc605f7b23fb 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_COMPRESSION_
-#define __BTRFS_COMPRESSION_
+#ifndef BTRFS_COMPRESSION_H
+#define BTRFS_COMPRESSION_H
 
 /*
  * We want to make sure that amount of RAM required to uncompress an extent is
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0eb55825862a..5474ef14d6e6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_CTREE__
-#define __BTRFS_CTREE__
+#ifndef BTRFS_CTREE_H
+#define BTRFS_CTREE_H
 
 #include <linux/mm.h>
 #include <linux/sched/signal.h>
@@ -3752,4 +3739,5 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
 #endif
 	return 0;
 }
+
 #endif
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 83ebfe28da9e..90281a7a35a8 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -1,24 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2016 Fujitsu.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_DEDUPE__
-#define __BTRFS_DEDUPE__
+#ifndef BTRFS_DEDUPE_H
+#define BTRFS_DEDUPE_H
 
 /* later in-band dedupe will expand this struct */
 struct btrfs_dedupe_hash;
+
 #endif
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 100a91e26b55..ca7a97f3ab6b 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -1,24 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Fujitsu.  All rights reserved.
  * Written by Miao Xie <miaox@cn.fujitsu.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __DELAYED_TREE_OPERATION_H
-#define __DELAYED_TREE_OPERATION_H
+#ifndef BTRFS_DELAYED_INODE_H
+#define BTRFS_DELAYED_INODE_H
 
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 9e3e5aff0937..741869dbc316 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -1,22 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
-#ifndef __DELAYED_REF__
-#define __DELAYED_REF__
+
+#ifndef BTRFS_DELAYED_REF_H
+#define BTRFS_DELAYED_REF_H
 
 #include <linux/refcount.h>
 
@@ -298,4 +286,5 @@ btrfs_delayed_node_to_data_ref(struct btrfs_delayed_ref_node *node)
 {
 	return container_of(node, struct btrfs_delayed_data_ref, node);
 }
+
 #endif
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 8566a02ef222..b6d4206188bb 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) STRATO AG 2012.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#if !defined(__BTRFS_DEV_REPLACE__)
-#define __BTRFS_DEV_REPLACE__
+#ifndef BTRFS_DEV_REPLACE_H
+#define BTRFS_DEV_REPLACE_H
 
 struct btrfs_ioctl_dev_replace_args;
 
@@ -48,4 +35,5 @@ static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
 {
 	atomic64_inc(stat_value);
 }
+
 #endif
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 453ea9f5d4e9..1a3d277b027b 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __DISKIO__
-#define __DISKIO__
+#ifndef BTRFS_DISK_IO_H
+#define BTRFS_DISK_IO_H
 
 #define BTRFS_SUPER_INFO_OFFSET SZ_64K
 #define BTRFS_SUPER_INFO_SIZE 4096
@@ -169,4 +156,5 @@ static inline void btrfs_set_buffer_lockdep_class(u64 objectid,
 {
 }
 #endif
+
 #endif
diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index 91b3908e7c54..57488ecd7d4e 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+
 #ifndef BTRFS_EXPORT_H
 #define BTRFS_EXPORT_H
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b77d84909863..a53009694b16 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __EXTENTIO__
-#define __EXTENTIO__
+
+#ifndef BTRFS_EXTENT_IO_H
+#define BTRFS_EXTENT_IO_H
 
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
@@ -572,4 +573,5 @@ noinline u64 find_lock_delalloc_range(struct inode *inode,
 #endif
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 					       u64 start);
+
 #endif
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index f6f8ba114977..5fcb80a6ce37 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __EXTENTMAP__
-#define __EXTENTMAP__
+
+#ifndef BTRFS_EXTENT_MAP_H
+#define BTRFS_EXTENT_MAP_H
 
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
@@ -93,4 +94,5 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
 int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
 			     struct extent_map **em_in, u64 start, u64 len);
+
 #endif
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 79eca4cabb1c..15e30b93db0d 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2009 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_FREE_SPACE_CACHE
-#define __BTRFS_FREE_SPACE_CACHE
+#ifndef BTRFS_FREE_SPACE_CACHE_H
+#define BTRFS_FREE_SPACE_CACHE_H
 
 struct btrfs_free_space {
 	struct rb_node offset_index;
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index ba3787df43c3..874b4feecad2 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2015 Facebook.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_FREE_SPACE_TREE
-#define __BTRFS_FREE_SPACE_TREE
+#ifndef BTRFS_FREE_SPACE_TREE_H
+#define BTRFS_FREE_SPACE_TREE_H
 
 /*
  * The default size for new free space bitmap items. The last bitmap in a block
diff --git a/fs/btrfs/inode-map.h b/fs/btrfs/inode-map.h
index 6734ec92a1e9..7a962811dffe 100644
--- a/fs/btrfs/inode-map.h
+++ b/fs/btrfs/inode-map.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __BTRFS_INODE_MAP
-#define __BTRFS_INODE_MAP
+
+#ifndef BTRFS_INODE_MAP_H
+#define BTRFS_INODE_MAP_H
 
 void btrfs_init_free_ino_ctl(struct btrfs_root *root);
 void btrfs_unpin_free_ino(struct btrfs_root *root);
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index c44a9d5f5362..29135def468e 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_LOCKING_
-#define __BTRFS_LOCKING_
+#ifndef BTRFS_LOCKING_H
+#define BTRFS_LOCKING_H
 
 #define BTRFS_WRITE_LOCK 1
 #define BTRFS_READ_LOCK 2
diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
index 1b10a3cd1195..75246f2f56ba 100644
--- a/fs/btrfs/math.h
+++ b/fs/btrfs/math.h
@@ -1,25 +1,11 @@
-
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Fujitsu.  All rights reserved.
  * Written by Miao Xie <miaox@cn.fujitsu.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_MATH_H
-#define __BTRFS_MATH_H
+#ifndef BTRFS_MATH_H
+#define BTRFS_MATH_H
 
 #include <asm/div64.h>
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 4a1672a13ba6..3be443fb3001 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_ORDERED_DATA__
-#define __BTRFS_ORDERED_DATA__
+#ifndef BTRFS_ORDERED_DATA_H
+#define BTRFS_ORDERED_DATA_H
 
 /* one of these per inode */
 struct btrfs_ordered_inode_tree {
@@ -218,4 +205,5 @@ void btrfs_wait_logged_extents(struct btrfs_trans_handle *trans,
 void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid);
 int __init ordered_data_init(void);
 void __cold ordered_data_exit(void);
+
 #endif
diff --git a/fs/btrfs/print-tree.h b/fs/btrfs/print-tree.h
index 3afd508ed8c5..4a98481688f4 100644
--- a/fs/btrfs/print-tree.h
+++ b/fs/btrfs/print-tree.h
@@ -1,23 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __PRINT_TREE_
-#define __PRINT_TREE_
+#ifndef BTRFS_PRINT_TREE_H
+#define BTRFS_PRINT_TREE_H
+
 void btrfs_print_leaf(struct extent_buffer *l);
 void btrfs_print_tree(struct extent_buffer *c);
+
 #endif
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 100f18829d50..618815b4f9d5 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2014 Filipe David Borba Manana <fdmanana@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_PROPS_H
-#define __BTRFS_PROPS_H
+#ifndef BTRFS_PROPS_H
+#define BTRFS_PROPS_H
 
 #include "ctree.h"
 
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index e63e2d497a8e..d60dd06445ce 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2014 Facebook.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_QGROUP__
-#define __BTRFS_QGROUP__
+#ifndef BTRFS_QGROUP_H
+#define BTRFS_QGROUP_H
 
 #include "ulist.h"
 #include "delayed-ref.h"
@@ -341,4 +328,5 @@ void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root);
 void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes);
 
 void btrfs_qgroup_check_reserved_leak(struct inode *inode);
-#endif /* __BTRFS_QGROUP__ */
+
+#endif
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 4ee4fe346838..f5d4c13a8dbc 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -1,24 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Fusion-io  All rights reserved.
  * Copyright (C) 2012 Intel Corp. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_RAID56__
-#define __BTRFS_RAID56__
+#ifndef BTRFS_RAID56_H
+#define BTRFS_RAID56_H
+
 static inline int nr_parity_stripes(struct map_lookup *map)
 {
 	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
@@ -65,4 +53,5 @@ void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio);
 
 int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info);
 void btrfs_free_stripe_hash_table(struct btrfs_fs_info *info);
+
 #endif
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
index 9e111e4576d4..a97dc74a4d3d 100644
--- a/fs/btrfs/rcu-string.h
+++ b/fs/btrfs/rcu-string.h
@@ -1,21 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Red Hat.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
+#ifndef BTRFS_RCU_STRING_H
+#define BTRFS_RCU_STRING_H
+
 struct rcu_string {
 	struct rcu_head rcu;
 	char str[0];
@@ -54,3 +44,5 @@ static inline void rcu_string_free(struct rcu_string *str)
 	struct rcu_string *__str = rcu_dereference(rcu_str);	\
 	__str->str;						\
 })
+
+#endif
diff --git a/fs/btrfs/ref-verify.h b/fs/btrfs/ref-verify.h
index 3bf02ce0e1e2..b7d2a4edfdb7 100644
--- a/fs/btrfs/ref-verify.h
+++ b/fs/btrfs/ref-verify.h
@@ -1,22 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2014 Facebook.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
-#ifndef __REF_VERIFY__
-#define __REF_VERIFY__
+
+#ifndef BTRFS_REF_VERIFY_H
+#define BTRFS_REF_VERIFY_H
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info);
@@ -59,4 +47,5 @@ static inline void btrfs_init_ref_verify(struct btrfs_fs_info *fs_info)
 }
 
 #endif /* CONFIG_BTRFS_FS_REF_VERIFY */
-#endif /* _REF_VERIFY__ */
+
+#endif
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 3aa4bc55754f..ead397f7034f 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -1,22 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Alexander Block.  All rights reserved.
  * Copyright (C) 2012 STRATO.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
+#ifndef BTRFS_SEND_H
+#define BTRFS_SEND_H
+
 #include "ctree.h"
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
@@ -132,3 +122,5 @@ enum {
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg);
 #endif
+
+#endif
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 80457f31c29f..b567560d9aa9 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _BTRFS_SYSFS_H_
-#define _BTRFS_SYSFS_H_
+
+#ifndef BTRFS_SYSFS_H
+#define BTRFS_SYSFS_H
 
 /*
  * Data exported through sysfs
@@ -90,4 +91,4 @@ void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 		u64 bit, enum btrfs_feature_set set);
 
-#endif /* _BTRFS_SYSFS_H_ */
+#endif
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index bc0615bac3cc..a5a0b9500d3e 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2013 Fusion IO.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_TESTS
-#define __BTRFS_TESTS
+#ifndef BTRFS_TESTS_H
+#define BTRFS_TESTS_H
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_run_sanity_tests(void);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index b6c94ce33503..c88fccd80bc5 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_TRANSACTION__
-#define __BTRFS_TRANSACTION__
+#ifndef BTRFS_TRANSACTION_H
+#define BTRFS_TRANSACTION_H
 
 #include <linux/refcount.h>
 #include "btrfs_inode.h"
@@ -228,4 +215,5 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction);
 void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info);
 void btrfs_add_dropped_root(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
+
 #endif
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index aba542755710..ff043275b784 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -1,21 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) Qu Wenruo 2017.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program.
  */
 
-#ifndef __BTRFS_TREE_CHECKER__
-#define __BTRFS_TREE_CHECKER__
+#ifndef BTRFS_TREE_CHECKER_H
+#define BTRFS_TREE_CHECKER_H
 
 #include "ctree.h"
 #include "extent_io.h"
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 88abc43312a1..122e68b89a5a 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __TREE_LOG_
-#define __TREE_LOG_
+#ifndef BTRFS_TREE_LOG_H
+#define BTRFS_TREE_LOG_H
 
 #include "ctree.h"
 #include "transaction.h"
@@ -87,4 +74,5 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
 			struct dentry *parent);
+
 #endif
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 53c913632733..02fda0a2d4ce 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -1,12 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 STRATO AG
  * written by Arne Jansen <sensille@gmx.net>
- * Distributed under the GNU GPL license version 2.
- *
  */
 
-#ifndef __ULIST__
-#define __ULIST__
+#ifndef BTRFS_ULIST_H
+#define BTRFS_ULIST_H
 
 #include <linux/list.h>
 #include <linux/rbtree.h>
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d1fcaea9fef5..79096884654f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __BTRFS_VOLUMES_
-#define __BTRFS_VOLUMES_
+#ifndef BTRFS_VOLUMES_H
+#define BTRFS_VOLUMES_H
 
 #include <linux/bio.h>
 #include <linux/sort.h>
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index e215a3212a2a..471fcac6ff55 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2007 Red Hat.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __XATTR__
-#define __XATTR__
+#ifndef BTRFS_XATTR_H
+#define BTRFS_XATTR_H
 
 #include <linux/xattr.h>
 
@@ -34,4 +21,4 @@ int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
 				     struct inode *inode, struct inode *dir,
 				     const struct qstr *qstr);
 
-#endif /* __XATTR__ */
+#endif
-- 
2.16.2

