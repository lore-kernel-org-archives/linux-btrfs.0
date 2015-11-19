Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbbKSKoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 05:44:12 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 03CA9ACBD
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 10:43:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: constify static arrays
Date: Thu, 19 Nov 2015 11:42:31 +0100
Message-Id: <de37f1d3a183e134a1a392309d79f2b3091204d7.1447929577.git.dsterba@suse.com>
In-Reply-To: <cover.1447929577.git.dsterba@suse.com>
References: <cover.1447929577.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are a few statically initialized arrays that can be made const.
The remaining (like file_system_type, sysfs attributes or prop handlers)
do not allow that due to type mismatch when passed to the APIs or
because the structures are modified through other members.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/inode.c | 2 +-
 fs/btrfs/ioctl.c | 2 +-
 fs/btrfs/super.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8c58191249cc..63ec26c716fa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -174,7 +174,7 @@ struct btrfs_ordered_sum;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-static int btrfs_csum_sizes[] = { 4 };
+static const int btrfs_csum_sizes[] = { 4 };
 
 /* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bf93a6bf7ca1..1f1ee8e2d3c7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -84,7 +84,7 @@ struct kmem_cache *btrfs_path_cachep;
 struct kmem_cache *btrfs_free_space_cachep;
 
 #define S_SHIFT 12
-static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
+static const unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
 	[S_IFREG >> S_SHIFT]	= BTRFS_FT_REG_FILE,
 	[S_IFDIR >> S_SHIFT]	= BTRFS_FT_DIR,
 	[S_IFCHR >> S_SHIFT]	= BTRFS_FT_CHRDEV,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da94138eb85e..fd429d7f40ab 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5286,7 +5286,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 static int btrfs_ioctl_get_supported_features(struct file *file,
 					      void __user *arg)
 {
-	static struct btrfs_ioctl_feature_flags features[3] = {
+	static const struct btrfs_ioctl_feature_flags features[3] = {
 		INIT_FEATURE_FLAGS(SUPP),
 		INIT_FEATURE_FLAGS(SAFE_SET),
 		INIT_FEATURE_FLAGS(SAFE_CLEAR)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 24154e422945..b813fd76f03f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -309,7 +309,7 @@ enum {
 	Opt_err,
 };
 
-static match_table_t tokens = {
+static const match_table_t tokens = {
 	{Opt_degraded, "degraded"},
 	{Opt_subvol, "subvol=%s"},
 	{Opt_subvolid, "subvolid=%s"},
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
