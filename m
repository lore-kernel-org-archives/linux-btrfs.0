Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab3JUVUm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 17:20:42 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0D1AEA640D
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 23:20:40 +0200 (CEST)
Message-Id: <20131021212007.251977073@suse.com>
Date: Mon, 21 Oct 2013 17:19:46 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: [patch 06/13] btrfs: publish unknown feature bits in sysfs
References: <20131021211940.432195222@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the compat and compat-ro bits, it's possible for file systems to
exist that have features that aren't supported by the kernel's file system
implementation yet still be mountable.

This patch publishes read-only info on those features using a prefix:number
format, where the number is the bit number rather than the shifted value.
e.g. "compat:12"

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/sysfs.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

--- a/fs/btrfs/sysfs.c	2013-10-21 16:10:00.700027002 -0400
+++ b/fs/btrfs/sysfs.c	2013-10-21 16:10:01.076018741 -0400
@@ -22,6 +22,7 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/kobject.h>
+#include <linux/bug.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -131,6 +132,101 @@ void btrfs_sysfs_remove_one(struct btrfs
 	wait_for_completion(&fs_info->kobj_unregister);
 }
 
+const char * const btrfs_feature_set_names[3] = {
+	[FEAT_COMPAT]	 = "compat",
+	[FEAT_COMPAT_RO] = "compat_ro",
+	[FEAT_INCOMPAT]	 = "incompat",
+};
+
+#define NUM_FEATURE_BITS 64
+static char btrfs_unknown_feature_names[3][NUM_FEATURE_BITS][13];
+static struct btrfs_feature_attr btrfs_feature_attrs[3][NUM_FEATURE_BITS];
+
+static void init_feature_attrs(void)
+{
+	struct btrfs_feature_attr *fa;
+	int set, i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(btrfs_unknown_feature_names) !=
+		     ARRAY_SIZE(btrfs_feature_attrs));
+	BUILD_BUG_ON(ARRAY_SIZE(btrfs_unknown_feature_names[0]) !=
+		     ARRAY_SIZE(btrfs_feature_attrs[0]));
+
+	for (i = 0; btrfs_supported_feature_attrs[i]; i++) {
+		struct btrfs_feature_attr *sfa;
+		struct attribute *a = btrfs_supported_feature_attrs[i];
+		sfa = attr_to_btrfs_feature_attr(a);
+		fa = &btrfs_feature_attrs[sfa->feature_set][sfa->feature_bit];
+
+		fa->kobj_attr.attr.name = sfa->kobj_attr.attr.name;
+	}
+
+	for (set = 0; set < FEAT_MAX; set++) {
+		for (i = 0; i < ARRAY_SIZE(btrfs_feature_attrs[set]); i++) {
+			char *name = btrfs_unknown_feature_names[set][i];
+			fa = &btrfs_feature_attrs[set][i];
+
+			if (fa->kobj_attr.attr.name)
+				continue;
+
+			snprintf(name, 13, "%s:%u",
+				 btrfs_feature_set_names[set], i);
+
+			fa->kobj_attr.attr.name = name;
+			fa->kobj_attr.attr.mode = S_IRUGO;
+			fa->feature_set = set;
+			fa->feature_bit = 1ULL << i;
+		}
+	}
+}
+
+static u64 supported_feature_masks[3] = {
+	[FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
+	[FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
+	[FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
+};
+
+static int add_unknown_feature_attrs(struct btrfs_fs_info *fs_info)
+{
+	int set;
+
+	for (set = 0; set < FEAT_MAX; set++) {
+		int i, count, ret, index = 0;
+		struct attribute **attrs;
+		struct attribute_group agroup = {
+			.name = "features",
+		};
+		u64 features = get_features(fs_info, set);
+		features &= ~supported_feature_masks[set];
+
+		count = hweight64(features);
+
+		if (!count)
+			continue;
+
+		attrs = kcalloc(count + 1, sizeof(void *), GFP_KERNEL);
+
+		for (i = 0; i < NUM_FEATURE_BITS; i++) {
+			struct btrfs_feature_attr *fa;
+
+			if (!(features & (1ULL << i)))
+				continue;
+
+			fa = &btrfs_feature_attrs[set][i];
+			attrs[index++] = &fa->kobj_attr.attr;
+		}
+
+		attrs[index] = NULL;
+		agroup.attrs = attrs;
+
+		ret = sysfs_merge_group(&fs_info->super_kobj, &agroup);
+		kfree(attrs);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
@@ -146,7 +242,15 @@ int btrfs_sysfs_add_one(struct btrfs_fs_
 	error = sysfs_create_group(&fs_info->super_kobj,
 				   &btrfs_feature_attr_group);
 	if (error)
-		btrfs_sysfs_remove_one(fs_info);
+		goto failure;
+
+	error = add_unknown_feature_attrs(fs_info);
+	if (error)
+		goto failure;
+
+	return 0;
+failure:
+	btrfs_sysfs_remove_one(fs_info);
 	return error;
 }
 
@@ -157,6 +261,8 @@ int btrfs_init_sysfs(void)
 	if (!btrfs_kset)
 		return -ENOMEM;
 
+	init_feature_attrs();
+
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	if (ret) {
 		kset_unregister(btrfs_kset);



