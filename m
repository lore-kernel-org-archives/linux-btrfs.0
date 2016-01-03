Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35118 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcACTAQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 14:00:16 -0500
Received: by mail-pa0-f51.google.com with SMTP id do7so397763pab.2
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 11:00:15 -0800 (PST)
Received: from arch-gct.localdomain ([175.114.213.172])
        by smtp.gmail.com with ESMTPSA id fc6sm120726837pac.44.2016.01.03.11.00.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Jan 2016 11:00:14 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs-progs: make private symbols to static
Date: Mon,  4 Jan 2016 03:59:55 +0900
Message-Id: <1451847598-30666-4-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
References: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 btrfs-show-super.c | 4 ++--
 qgroup-verify.c    | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index c0ffeacb928c..f11701539d1a 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -334,7 +334,7 @@ struct readable_flag_entry {
 #define DEF_INCOMPAT_FLAG_ENTRY(bit_name)		\
 	{BTRFS_FEATURE_INCOMPAT_##bit_name, #bit_name}
 
-struct readable_flag_entry incompat_flags_array[] = {
+static struct readable_flag_entry incompat_flags_array[] = {
 	DEF_INCOMPAT_FLAG_ENTRY(MIXED_BACKREF),
 	DEF_INCOMPAT_FLAG_ENTRY(DEFAULT_SUBVOL),
 	DEF_INCOMPAT_FLAG_ENTRY(MIXED_GROUPS),
@@ -354,7 +354,7 @@ static const int incompat_flags_num = sizeof(incompat_flags_array) /
 #define DEF_SUPER_FLAG_ENTRY(bit_name)			\
 	{BTRFS_SUPER_FLAG_##bit_name, #bit_name}
 
-struct readable_flag_entry super_flags_array[] = {
+static struct readable_flag_entry super_flags_array[] = {
 	DEF_HEADER_FLAG_ENTRY(WRITTEN),
 	DEF_HEADER_FLAG_ENTRY(RELOC),
 	DEF_SUPER_FLAG_ENTRY(CHANGING_FSID),
diff --git a/qgroup-verify.c b/qgroup-verify.c
index f7a94bfb0d32..0ee52ff5c857 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -49,12 +49,12 @@ struct qgroup_count {
 	struct rb_node			rb_node;
 };
 
-struct counts_tree {
+static struct counts_tree {
 	struct rb_root		root;
 	unsigned int		num_groups;
 } counts = { .root = RB_ROOT };
 
-struct rb_root by_bytenr = RB_ROOT;
+static struct rb_root by_bytenr = RB_ROOT;
 
 /*
  * List of interior tree blocks. We walk this list after loading the
@@ -68,8 +68,8 @@ struct rb_root by_bytenr = RB_ROOT;
  * exist further down the tree, the fact that our interior node has a
  * ref means we need to account anything below it to all its roots.
  */
-struct ulist *tree_blocks = NULL;	/* unode->val = bytenr, ->aux
-					 * = tree_block pointer */
+static struct ulist *tree_blocks = NULL;	/* unode->val = bytenr, ->aux
+						 * = tree_block pointer */
 struct tree_block {
 	int			level;
 	u64			num_bytes;
-- 
2.6.4

