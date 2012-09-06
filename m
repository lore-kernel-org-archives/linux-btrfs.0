Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21962 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab2IFKtM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:49:12 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86An7IP019748
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:49:07 +0800
Message-ID: <50487F96.5050507@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:48:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3 1/7] Btrfs-progs: move the function declarations to a new
 head file
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487F6E.6060001@cn.fujitsu.com>

Move the function declarations to a new head file.

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
---
Changelog v2 - v3:
- remove path_for_root() in send-utils.c

Changelog v1 -> v2:
- new patch.
---
 btrfs-list.c     |    1 +
 btrfs-list.h     |   21 +++++++++++++++++++++
 cmds-inspect.c   |    4 +---
 cmds-subvolume.c |    5 +----
 send-utils.c     |    4 +---
 5 files changed, 25 insertions(+), 10 deletions(-)
 create mode 100644 btrfs-list.h

diff --git a/btrfs-list.c b/btrfs-list.c
index 514cac7..ef621f0 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -35,6 +35,7 @@
 #include "transaction.h"
 #include "utils.h"
 #include <uuid/uuid.h>
+#include "btrfs-list.h"
 
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
diff --git a/btrfs-list.h b/btrfs-list.h
new file mode 100644
index 0000000..96f3641
--- /dev/null
+++ b/btrfs-list.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2012 Fujitsu.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+int list_subvols(int fd, int print_parent, int get_default, int print_uuid);
+int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
+char *path_for_root(int fd, u64 root);
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 2f0228f..f943ed9 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -24,9 +24,7 @@
 #include "ioctl.h"
 
 #include "commands.h"
-
-/* btrfs-list.c */
-char *path_for_root(int fd, u64 root);
+#include "btrfs-list.h"
 
 static const char * const inspect_cmd_group_usage[] = {
 	"btrfs inspect-internal <command> <args>",
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index aaf5dde..ffc5d95 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -29,10 +29,7 @@
 #include "qgroup.h"
 
 #include "commands.h"
-
-/* btrfs-list.c */
-int list_subvols(int fd, int print_parent, int print_uuid, int get_default);
-int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
+#include "btrfs-list.h"
 
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
diff --git a/send-utils.c b/send-utils.c
index af495a0..096fa02 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -21,9 +21,7 @@
 #include "ctree.h"
 #include "send-utils.h"
 #include "ioctl.h"
-
-/* btrfs-list.c */
-char *path_for_root(int fd, u64 root);
+#include "btrfs-list.h"
 
 static struct rb_node *tree_insert(struct rb_root *root,
 				   struct subvol_info *si,
-- 
1.7.6.5
