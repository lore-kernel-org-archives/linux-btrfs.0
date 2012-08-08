Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab2HHIzG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 04:55:06 -0400
Message-ID: <50222958.2090407@cn.fujitsu.com>
Date: Wed, 08 Aug 2012 16:54:48 +0800
From: zhoubo <zhoub-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: btrfs community <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 1/3 V2] Btrfs-progs: move the function declarations to a new
 head file
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50222948.8030102@cn.fujitsu.com>

From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

Move the function declarations to a new head file.

Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
---
 btrfs-list.c     |    1 +
 btrfs-list.h     |   21 +++++++++++++++++++++
 cmds-inspect.c   |    4 +---
 cmds-subvolume.c |    5 +----
 4 files changed, 24 insertions(+), 7 deletions(-)
 create mode 100644 btrfs-list.h

diff --git a/btrfs-list.c b/btrfs-list.c
index c53d016..ca841f6 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,6 +34,7 @@
 #include "ctree.h"
 #include "transaction.h"
 #include "utils.h"
+#include "btrfs-list.h"
 
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
diff --git a/btrfs-list.h b/btrfs-list.h
new file mode 100644
index 0000000..3cb01f6
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
+int list_subvols(int fd, int print_parent, int get_default, int list_ro);
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
index 3508ce6..d8629fa 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -28,10 +28,7 @@
 #include "ioctl.h"
 
 #include "commands.h"
-
-/* btrfs-list.c */
-int list_subvols(int fd, int print_parent, int get_default);
-int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
+#include "btrfs-list.h"
 
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
-- 
1.6.0.6
