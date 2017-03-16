Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33546 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751459AbdCPH7h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 03:59:37 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0374549F9A64
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Mar 2017 15:59:20 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v14.2 16/16] btrfs: dedupe: Introduce new reconfigure ioctl
Date: Thu, 16 Mar 2017 15:58:54 +0800
Message-ID: <20170316075854.15788-17-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
References: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new reconfigure ioctl, and new FORCE flag for in-band dedupe
ioctls.

Now dedupe enable and reconfigure ioctl are stateful.

--------------------------------------------
| Current state |   Ioctl    | Next state  |
--------------------------------------------
| Disabled	|  enable    | Enabled     |
| Enabled       |  enable    | Not allowed |
| Enabled       |  reconf    | Enabled     |
| Enabled       |  disable   | Disabled    |
| Disabled      |  dsiable   | Disabled    |
| Disabled      |  reconf    | Not allowed |
--------------------------------------------
(While disbale is always stateless)

While for guys prefer stateless ioctl (myself for example), new FORCE
flag is introduced.

In FORCE mode, enable/disable is completely stateless.
--------------------------------------------
| Current state |   Ioctl    | Next state  |
--------------------------------------------
| Disabled	|  enable    | Enabled     |
| Enabled       |  enable    | Enabled     |
| Enabled       |  disable   | Disabled    |
| Disabled      |  disable   | Disabled    |
--------------------------------------------

Also, re-configure ioctl will only modify specified fields.
Unlike enable, un-specified fields will be filled with default value.

For example:
 # btrfs dedupe enable --block-size 64k /mnt
 # btrfs dedupe reconfigure --limit-hash 1m /mnt
Will leads to:
 dedupe blocksize: 64K
 dedupe hash limit nr: 1m

While for enable:
 # btrfs dedupe enable --force --block-size 64k /mnt
 # btrfs dedupe enable --force --limit-hash 1m /mnt
Will reset blocksize to default value:
 dedupe blocksize: 128K     << reset
 dedupe hash limit nr: 1m

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c          | 131 ++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/dedupe.h          |  13 +++++
 fs/btrfs/ioctl.c           |  13 +++++
 include/uapi/linux/btrfs.h |  11 +++-
 4 files changed, 143 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index b57de28bbf4e..442ded0457f1 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -41,6 +41,40 @@ static inline struct inmem_hash *inmem_alloc_hash(u16 algo)
 			GFP_NOFS);
 }
 
+/*
+ * Copy from current dedupe info to fill dargs.
+ * For reconf case, only fill members which is uninitialized.
+ */
+static void get_dedupe_status(struct btrfs_dedupe_info *dedupe_info,
+			      struct btrfs_ioctl_dedupe_args *dargs)
+{
+	int reconf = (dargs->cmd == BTRFS_DEDUPE_CTL_RECONF);
+
+	dargs->status = 1;
+
+	if (!reconf || (reconf && dargs->blocksize == (u64)-1))
+		dargs->blocksize = dedupe_info->blocksize;
+	if (!reconf || (reconf && dargs->backend == (u16)-1))
+		dargs->backend = dedupe_info->backend;
+	if (!reconf || (reconf && dargs->hash_algo ==(u16)-1))
+		dargs->hash_algo = dedupe_info->hash_algo;
+
+	/*
+	 * For re-configure case, if not modifying limit,
+	 * therir limit will be set to 0, unlike other fields
+	 */
+	if (!reconf || !(dargs->limit_nr || dargs->limit_mem)) {
+		dargs->limit_nr = dedupe_info->limit_nr;
+		dargs->limit_mem = dedupe_info->limit_nr *
+			(sizeof(struct inmem_hash) +
+			 btrfs_hash_sizes[dedupe_info->hash_algo]);
+	}
+
+	/* current_nr doesn't makes sense for reconfig case */
+	if (!reconf)
+		dargs->current_nr = dedupe_info->current_nr;
+}
+
 void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
 			 struct btrfs_ioctl_dedupe_args *dargs)
 {
@@ -57,15 +91,7 @@ void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
 		return;
 	}
 	mutex_lock(&dedupe_info->lock);
-	dargs->status = 1;
-	dargs->blocksize = dedupe_info->blocksize;
-	dargs->backend = dedupe_info->backend;
-	dargs->hash_algo = dedupe_info->hash_algo;
-	dargs->limit_nr = dedupe_info->limit_nr;
-	dargs->limit_mem = dedupe_info->limit_nr *
-		(sizeof(struct inmem_hash) +
-		 btrfs_hash_sizes[dedupe_info->hash_algo]);
-	dargs->current_nr = dedupe_info->current_nr;
+	get_dedupe_status(dedupe_info, dargs);
 	mutex_unlock(&dedupe_info->lock);
 	memset(dargs->__unused, -1, sizeof(dargs->__unused));
 }
@@ -114,17 +140,50 @@ static int init_dedupe_info(struct btrfs_dedupe_info **ret_info,
 static int check_dedupe_parameter(struct btrfs_fs_info *fs_info,
 				  struct btrfs_ioctl_dedupe_args *dargs)
 {
-	u64 blocksize = dargs->blocksize;
-	u64 limit_nr = dargs->limit_nr;
-	u64 limit_mem = dargs->limit_mem;
-	u16 hash_algo = dargs->hash_algo;
-	u8 backend = dargs->backend;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+
+	u64 blocksize;
+	u64 limit_nr;
+	u64 limit_mem;
+	u16 hash_algo;
+	u8 backend;
 
 	/*
 	 * Set all reserved fields to -1, allow user to detect
 	 * unsupported optional parameters.
 	 */
 	memset(dargs->__unused, -1, sizeof(dargs->__unused));
+
+	/*
+	 * For dedupe enabled fs, enable without FORCE flag is not allowed
+	 */
+	if (dargs->cmd == BTRFS_DEDUPE_CTL_ENABLE && dedupe_info &&
+	    !(dargs->flags & BTRFS_DEDUPE_FLAG_FORCE)) {
+		dargs->status = 1;
+		dargs->flags = (u8)-1;
+		return -EINVAL;
+	}
+
+	/* Check and copy parameters from existing dedupe info */
+	if (dargs->cmd == BTRFS_DEDUPE_CTL_RECONF) {
+		if (!dedupe_info) {
+			/* Info caller that dedupe is not enabled */
+			dargs->status = 0;
+			return -EINVAL;
+		}
+		get_dedupe_status(dedupe_info, dargs);
+		/*
+		 * All unmodified parameter are already copied out
+		 * go through normal validation check.
+		 */
+	}
+
+	blocksize = dargs->blocksize;
+	limit_nr = dargs->limit_nr;
+	limit_mem = dargs->limit_mem;
+	hash_algo = dargs->hash_algo;
+	backend = dargs->backend;
+
 	if (blocksize > BTRFS_DEDUPE_BLOCKSIZE_MAX ||
 	    blocksize < BTRFS_DEDUPE_BLOCKSIZE_MIN ||
 	    blocksize < fs_info->sectorsize ||
@@ -145,7 +204,8 @@ static int check_dedupe_parameter(struct btrfs_fs_info *fs_info,
 	/* Backend specific check */
 	if (backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
 		/* only one limit is accepted for enable*/
-		if (dargs->limit_nr && dargs->limit_mem) {
+		if (dargs->cmd == BTRFS_DEDUPE_CTL_ENABLE &&
+		    dargs->limit_nr && dargs->limit_mem) {
 			dargs->limit_nr = 0;
 			dargs->limit_mem = 0;
 			return -EINVAL;
@@ -178,18 +238,19 @@ static int check_dedupe_parameter(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
-			struct btrfs_ioctl_dedupe_args *dargs)
+/*
+ * Enable or re-configure dedupe.
+ *
+ * Caller must call check_dedupe_parameters first
+ */
+static int enable_reconfig_dedupe(struct btrfs_fs_info *fs_info,
+				  struct btrfs_ioctl_dedupe_args *dargs)
 {
-	struct btrfs_dedupe_info *dedupe_info;
-	int ret = 0;
-
-	ret = check_dedupe_parameter(fs_info, dargs);
-	if (ret < 0)
-		return ret;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	int ret;
 
-	dedupe_info = fs_info->dedupe_info;
 	if (dedupe_info) {
+
 		/* Check if we are re-enable for different dedupe config */
 		if (dedupe_info->blocksize != dargs->blocksize ||
 		    dedupe_info->hash_algo != dargs->hash_algo ||
@@ -216,6 +277,28 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
+			struct btrfs_ioctl_dedupe_args *dargs)
+{
+	int ret = 0;
+
+	ret = check_dedupe_parameter(fs_info, dargs);
+	if (ret < 0)
+		return ret;
+	return enable_reconfig_dedupe(fs_info, dargs);
+}
+
+int btrfs_dedupe_reconfigure(struct btrfs_fs_info *fs_info,
+			     struct btrfs_ioctl_dedupe_args *dargs)
+{
+	/*
+	 * btrfs_dedupe_enable will handle everything well,
+	 * since dargs contains all info we need to distinguish enable
+	 * and reconfigure
+	 */
+	return btrfs_dedupe_enable(fs_info, dargs);
+}
+
 static int inmem_insert_hash(struct rb_root *root,
 			     struct inmem_hash *hash, int hash_len)
 {
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 07079238cb8c..678e0d3d2635 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -109,6 +109,19 @@ static inline struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 algo)
 int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
 			struct btrfs_ioctl_dedupe_args *dargs);
 
+/*
+ * Reconfigure given parameter for dedupe
+ * Can only be called when dedupe is already enabled
+ *
+ * dargs member which don't need to be modified should be left
+ * with 0 for limit_nr/limit_offset or -1 for other fields
+ *
+ * Return 0 for success
+ * Return <0 for any error
+ * (Same error return value with dedupe_enable)
+ */
+int btrfs_dedupe_reconfigure(struct btrfs_fs_info *fs_info,
+			     struct btrfs_ioctl_dedupe_args *dargs);
 
  /*
  * Get inband dedupe info
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3bc1d5985046..686342e8384a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3325,6 +3325,19 @@ static long btrfs_ioctl_dedupe_ctl(struct btrfs_root *root, void __user *args)
 		btrfs_dedupe_status(fs_info, dargs);
 		mutex_unlock(&fs_info->dedupe_ioctl_lock);
 		break;
+	case BTRFS_DEDUPE_CTL_RECONF:
+		mutex_lock(&fs_info->dedupe_ioctl_lock);
+		ret = btrfs_dedupe_reconfigure(fs_info, dargs);
+		/*
+		 * Also copy the result to caller for further use
+		 * if enable succeeded.
+		 * For error case, dargs is already set up with
+		 * special values indicating error reason.
+		 */
+		if (!ret)
+			btrfs_dedupe_status(fs_info, dargs);
+		mutex_unlock(&fs_info->dedupe_ioctl_lock);
+		break;
 	default:
 		/*
 		 * Use this return value to inform progs that kernel
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b12c5658ab53..f0e0ec05e4b8 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -654,7 +654,16 @@ struct btrfs_ioctl_get_dev_stats {
 #define BTRFS_DEDUPE_CTL_ENABLE	1
 #define BTRFS_DEDUPE_CTL_DISABLE 2
 #define BTRFS_DEDUPE_CTL_STATUS	3
-#define BTRFS_DEDUPE_CTL_LAST	4
+#define BTRFS_DEDUPE_CTL_RECONF	4
+#define BTRFS_DEDUPE_CTL_LAST	5
+
+/*
+ * Allow enable command to be executed on dedupe enabled fs.
+ * Make dedupe_enable ioctl to be stateless.
+ *
+ * Or only dedup_reconf ioctl can be executed on dedupe enabled fs
+ */
+#define BTRFS_DEDUPE_FLAG_FORCE		(1 << 0)
 /*
  * This structure is used for dedupe enable/disable/configure
  * and status ioctl.
-- 
2.12.0



