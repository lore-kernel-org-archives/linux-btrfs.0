Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753620AbeAKFK1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:27 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 87D0849F0E49
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:21 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 64/67] btrfs-progs: add the stack prefix for super_csum_type set/get function
Date: Thu, 11 Jan 2018 13:09:36 +0800
Message-ID: <20180111050939.21251-65-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_csum_type set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 convert/common.c          | 2 +-
 ctree.h                   | 4 ++--
 disk-io.c                 | 2 +-
 mkfs/common.c             | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index dd6e68fb..5e036536 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -320,7 +320,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	u32 csum_size;
 	u16 csum_type;
 
-	csum_type = btrfs_super_csum_type(sb);
+	csum_type = btrfs_stack_super_csum_type(sb);
 	csum_size = BTRFS_CSUM_SIZE;
 	printf("csum_type\t\t%hu (", csum_type);
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
diff --git a/convert/common.c b/convert/common.c
index 97e9938d..925c7348 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -131,7 +131,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	super->__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_stack_super_nodesize(super, cfg->nodesize);
 	btrfs_set_stack_super_stripesize(super, cfg->stripesize);
-	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
+	btrfs_set_stack_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
 	btrfs_set_super_cache_generation(super, -1);
 	btrfs_set_stack_super_incompat_flags(super, cfg->features);
diff --git a/ctree.h b/ctree.h
index 2f1a6be4..8639d0c1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2204,7 +2204,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_compat_ro_flags, struct btrfs_super_block,
 			 compat_ro_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
-BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
@@ -2214,7 +2214,7 @@ BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_super_block, magic, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
-	int t = btrfs_super_csum_type(s);
+	int t = btrfs_stack_super_csum_type(s);
 	BUG_ON(t >= ARRAY_SIZE(btrfs_csum_sizes));
 	return btrfs_csum_sizes[t];
 }
diff --git a/disk-io.c b/disk-io.c
index c37a40e4..11545e97 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1292,7 +1292,7 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		}
 	}
 
-	csum_type = btrfs_super_csum_type(sb);
+	csum_type = btrfs_stack_super_csum_type(sb);
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
 		error("unsupported checksum algorithm %u", csum_type);
 		return -EIO;
diff --git a/mkfs/common.c b/mkfs/common.c
index 40f2a9f4..fcc3216f 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -170,7 +170,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	super.__unused_leafsize = cpu_to_le32(cfg->nodesize);
 	btrfs_set_stack_super_nodesize(&super, cfg->nodesize);
 	btrfs_set_stack_super_stripesize(&super, cfg->stripesize);
-	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
+	btrfs_set_stack_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
 	btrfs_set_stack_super_incompat_flags(&super, cfg->features);
-- 
2.15.1



