Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933415Ab3HNXRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:23 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHNWd005741
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:23 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSu017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:23 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/15] btrfs-progs: make many private symbols static
Date: Wed, 14 Aug 2013 16:16:41 -0700
Message-Id: <1376522205-16992-12-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-convert.c    | 2 +-
 btrfs.c            | 6 +++---
 cmds-dedup.c       | 2 +-
 crc32c.c           | 4 ++--
 ctree.c            | 4 ++--
 free-space-cache.c | 4 ++--
 help.c             | 2 +-
 radix-tree.c       | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 9a7da57..828f361 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -223,7 +223,7 @@ static int custom_free_extent(struct btrfs_root *root, u64 bytenr,
 	return intersect_with_sb(bytenr, num_bytes);
 }
 
-struct btrfs_extent_ops extent_ops = {
+static struct btrfs_extent_ops extent_ops = {
 	.alloc_extent = custom_alloc_extent,
 	.free_extent = custom_free_extent,
 };
diff --git a/btrfs.c b/btrfs.c
index 3e53a6a..050c9c3 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -31,7 +31,7 @@ static const char * const btrfs_cmd_group_usage[] = {
 static const char btrfs_cmd_group_info[] =
 	"Use --help as an argument for information on a specific group or command.";
 
-char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
+static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
@@ -184,7 +184,7 @@ int check_argc_max(int nargs, int expected)
 	return 0;
 }
 
-const struct cmd_group btrfs_cmd_group;
+static const struct cmd_group btrfs_cmd_group;
 
 static const char * const cmd_help_usage[] = {
 	"btrfs help [--full]",
@@ -239,7 +239,7 @@ static int handle_options(int *argc, char ***argv)
 	return (*argv) - orig_argv;
 }
 
-const struct cmd_group btrfs_cmd_group = {
+static const struct cmd_group btrfs_cmd_group = {
 	btrfs_cmd_group_usage, btrfs_cmd_group_info, {
 		{ "subvolume", cmd_subvolume, NULL, &subvolume_cmd_group, 0 },
 		{ "filesystem", cmd_filesystem, NULL, &filesystem_cmd_group, 0 },
diff --git a/cmds-dedup.c b/cmds-dedup.c
index 215fddc..a22b5c9 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -30,7 +30,7 @@ static const char * const dedup_cmd_group_usage[] = {
 	NULL
 };
 
-int dedup_ctl(int cmd, int argc, char **argv)
+static int dedup_ctl(int cmd, int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
diff --git a/crc32c.c b/crc32c.c
index c285d6e..dfa4e6c 100644
--- a/crc32c.c
+++ b/crc32c.c
@@ -62,7 +62,7 @@ static uint32_t crc32c_intel_le_hw_byte(uint32_t crc, unsigned char const *data,
  * Steps through buffer one byte at at time, calculates reflected 
  * crc using table.
  */
-uint32_t crc32c_intel(u32 crc, unsigned char const *data, unsigned long length)
+static uint32_t crc32c_intel(u32 crc, unsigned char const *data, unsigned long length)
 {
 	unsigned int iquotient = length / SCALE_F;
 	unsigned int iremainder = length % SCALE_F;
@@ -100,7 +100,7 @@ static void do_cpuid(unsigned int *eax, unsigned int *ebx, unsigned int *ecx,
 		: "eax", "ebx", "ecx", "edx");
 }
 
-void crc32c_intel_probe(void)
+static void crc32c_intel_probe(void)
 {
 	if (!crc32c_probed) {
 		unsigned int eax, ebx, ecx, edx;
diff --git a/ctree.c b/ctree.c
index 1b093f6..8b1fc07 100644
--- a/ctree.c
+++ b/ctree.c
@@ -136,8 +136,8 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 /*
  * check if the tree block can be shared by multiple trees
  */
-int btrfs_block_can_be_shared(struct btrfs_root *root,
-			      struct extent_buffer *buf)
+static int btrfs_block_can_be_shared(struct btrfs_root *root,
+			             struct extent_buffer *buf)
 {
 	/*
 	 * Tree blocks not in refernece counted trees and tree roots
diff --git a/free-space-cache.c b/free-space-cache.c
index 35edac2..ddeeeb6 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -792,8 +792,8 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	__btrfs_remove_free_space_cache(block_group->free_space_ctl);
 }
 
-int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
-			 u64 bytes)
+static int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
+				u64 bytes)
 {
 	struct btrfs_free_space *info;
 	int ret = 0;
diff --git a/help.c b/help.c
index 6d04293..d429a6b 100644
--- a/help.c
+++ b/help.c
@@ -20,7 +20,7 @@
 
 #include "commands.h"
 
-extern char argv0_buf[ARGV0_BUF_SIZE];
+static char argv0_buf[ARGV0_BUF_SIZE];
 
 #define USAGE_SHORT		1U
 #define USAGE_LONG		2U
diff --git a/radix-tree.c b/radix-tree.c
index ed01810..4f295fc 100644
--- a/radix-tree.c
+++ b/radix-tree.c
@@ -73,7 +73,7 @@ struct radix_tree_preload {
 	int nr;
 	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
 };
-struct radix_tree_preload radix_tree_preloads = { 0, };
+static struct radix_tree_preload radix_tree_preloads = { 0, };
 
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
-- 
1.7.11.7

