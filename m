Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35044 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbdJHUbA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 16:31:00 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 70140200AD
        for <linux-btrfs@vger.kernel.org>; Sun,  8 Oct 2017 22:30:58 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: prefix sysfs attribute struct names
Date: Sun,  8 Oct 2017 22:30:58 +0200
Message-Id: <20171008203058.28931-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently struct names for sysfs are generated only based on the
attribute names. This means that attribute names cannot be reused in
multiple places throughout the complete btrfs sysfs hierarchy.

E.g. allocation/data/total_bytes and allocation/data/single/total_bytes
result in the same struct name btrfs_attr_total_bytes. A workaround for
this case was made in the past by ad hoc creating an extra macro
wrapper, BTRFS_RAID_ATTR, that inserts some extra text in the struct
name.

Instead of polluting sysfs.h with such kind of extra macro definitions,
and only doing so when there are collisions, use a prefix which gets
inserted in the struct name, so we keep everything nicely grouped
together by default.

Current collections of attributes are:
* (the toplevel, empty prefix)
* allocation
* space_info
* raid
* features

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 fs/btrfs/sysfs.c | 64 +++++++++++++++++++++++++++++---------------------------
 fs/btrfs/sysfs.h | 26 ++++++++++-------------
 2 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 883881b16c86..37ad89f9facb 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -247,7 +247,7 @@ static ssize_t global_rsv_size_show(struct kobject *kobj,
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	return btrfs_show_u64(&block_rsv->size, &block_rsv->lock, buf);
 }
-BTRFS_ATTR(global_rsv_size, global_rsv_size_show);
+BTRFS_ATTR(allocation, global_rsv_size, global_rsv_size_show);
 
 static ssize_t global_rsv_reserved_show(struct kobject *kobj,
 					struct kobj_attribute *a, char *buf)
@@ -256,15 +256,15 @@ static ssize_t global_rsv_reserved_show(struct kobject *kobj,
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	return btrfs_show_u64(&block_rsv->reserved, &block_rsv->lock, buf);
 }
-BTRFS_ATTR(global_rsv_reserved, global_rsv_reserved_show);
+BTRFS_ATTR(allocation, global_rsv_reserved, global_rsv_reserved_show);
 
 #define to_space_info(_kobj) container_of(_kobj, struct btrfs_space_info, kobj)
 #define to_raid_kobj(_kobj) container_of(_kobj, struct raid_kobject, kobj)
 
 static ssize_t raid_bytes_show(struct kobject *kobj,
 			       struct kobj_attribute *attr, char *buf);
-BTRFS_RAID_ATTR(total_bytes, raid_bytes_show);
-BTRFS_RAID_ATTR(used_bytes, raid_bytes_show);
+BTRFS_ATTR(raid, total_bytes, raid_bytes_show);
+BTRFS_ATTR(raid, used_bytes, raid_bytes_show);
 
 static ssize_t raid_bytes_show(struct kobject *kobj,
 			       struct kobj_attribute *attr, char *buf)
@@ -277,7 +277,8 @@ static ssize_t raid_bytes_show(struct kobject *kobj,
 
 	down_read(&sinfo->groups_sem);
 	list_for_each_entry(block_group, &sinfo->block_groups[index], list) {
-		if (&attr->attr == BTRFS_RAID_ATTR_PTR(total_bytes))
+		if (&attr->attr == \
+		    BTRFS_ATTR_PTR(raid, total_bytes))
 			val += block_group->key.offset;
 		else
 			val += btrfs_block_group_used(&block_group->item);
@@ -287,8 +288,8 @@ static ssize_t raid_bytes_show(struct kobject *kobj,
 }
 
 static struct attribute *raid_attributes[] = {
-	BTRFS_RAID_ATTR_PTR(total_bytes),
-	BTRFS_RAID_ATTR_PTR(used_bytes),
+	BTRFS_ATTR_PTR(raid, total_bytes),
+	BTRFS_ATTR_PTR(raid, used_bytes),
 	NULL
 };
 
@@ -311,7 +312,7 @@ static ssize_t btrfs_space_info_show_##field(struct kobject *kobj,	\
 	struct btrfs_space_info *sinfo = to_space_info(kobj);		\
 	return btrfs_show_u64(&sinfo->field, &sinfo->lock, buf);	\
 }									\
-BTRFS_ATTR(field, btrfs_space_info_show_##field)
+BTRFS_ATTR(space_info, field, btrfs_space_info_show_##field)
 
 static ssize_t btrfs_space_info_show_total_bytes_pinned(struct kobject *kobj,
 						       struct kobj_attribute *a,
@@ -331,19 +332,20 @@ SPACE_INFO_ATTR(bytes_may_use);
 SPACE_INFO_ATTR(bytes_readonly);
 SPACE_INFO_ATTR(disk_used);
 SPACE_INFO_ATTR(disk_total);
-BTRFS_ATTR(total_bytes_pinned, btrfs_space_info_show_total_bytes_pinned);
+BTRFS_ATTR(space_info, total_bytes_pinned, \
+	   btrfs_space_info_show_total_bytes_pinned);
 
 static struct attribute *space_info_attrs[] = {
-	BTRFS_ATTR_PTR(flags),
-	BTRFS_ATTR_PTR(total_bytes),
-	BTRFS_ATTR_PTR(bytes_used),
-	BTRFS_ATTR_PTR(bytes_pinned),
-	BTRFS_ATTR_PTR(bytes_reserved),
-	BTRFS_ATTR_PTR(bytes_may_use),
-	BTRFS_ATTR_PTR(bytes_readonly),
-	BTRFS_ATTR_PTR(disk_used),
-	BTRFS_ATTR_PTR(disk_total),
-	BTRFS_ATTR_PTR(total_bytes_pinned),
+	BTRFS_ATTR_PTR(space_info, flags),
+	BTRFS_ATTR_PTR(space_info, total_bytes),
+	BTRFS_ATTR_PTR(space_info, bytes_used),
+	BTRFS_ATTR_PTR(space_info, bytes_pinned),
+	BTRFS_ATTR_PTR(space_info, bytes_reserved),
+	BTRFS_ATTR_PTR(space_info, bytes_may_use),
+	BTRFS_ATTR_PTR(space_info, bytes_readonly),
+	BTRFS_ATTR_PTR(space_info, disk_used),
+	BTRFS_ATTR_PTR(space_info, disk_total),
+	BTRFS_ATTR_PTR(space_info, total_bytes_pinned),
 	NULL,
 };
 
@@ -361,8 +363,8 @@ struct kobj_type space_info_ktype = {
 };
 
 static const struct attribute *allocation_attrs[] = {
-	BTRFS_ATTR_PTR(global_rsv_reserved),
-	BTRFS_ATTR_PTR(global_rsv_size),
+	BTRFS_ATTR_PTR(allocation, global_rsv_reserved),
+	BTRFS_ATTR_PTR(allocation, global_rsv_size),
 	NULL,
 };
 
@@ -415,7 +417,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 
 	return len;
 }
-BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
+BTRFS_ATTR_RW(, label, btrfs_label_show, btrfs_label_store);
 
 static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
@@ -425,7 +427,7 @@ static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);
 }
 
-BTRFS_ATTR(nodesize, btrfs_nodesize_show);
+BTRFS_ATTR(, nodesize, btrfs_nodesize_show);
 
 static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
@@ -436,7 +438,7 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 			fs_info->super_copy->sectorsize);
 }
 
-BTRFS_ATTR(sectorsize, btrfs_sectorsize_show);
+BTRFS_ATTR(, sectorsize, btrfs_sectorsize_show);
 
 static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
@@ -447,7 +449,7 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 			fs_info->super_copy->sectorsize);
 }
 
-BTRFS_ATTR(clone_alignment, btrfs_clone_alignment_show);
+BTRFS_ATTR(, clone_alignment, btrfs_clone_alignment_show);
 
 static ssize_t quota_override_show(struct kobject *kobj,
 				   struct kobj_attribute *a, char *buf)
@@ -487,14 +489,14 @@ static ssize_t quota_override_store(struct kobject *kobj,
 	return len;
 }
 
-BTRFS_ATTR_RW(quota_override, quota_override_show, quota_override_store);
+BTRFS_ATTR_RW(, quota_override, quota_override_show, quota_override_store);
 
 static const struct attribute *btrfs_attrs[] = {
-	BTRFS_ATTR_PTR(label),
-	BTRFS_ATTR_PTR(nodesize),
-	BTRFS_ATTR_PTR(sectorsize),
-	BTRFS_ATTR_PTR(clone_alignment),
-	BTRFS_ATTR_PTR(quota_override),
+	BTRFS_ATTR_PTR(, label),
+	BTRFS_ATTR_PTR(, nodesize),
+	BTRFS_ATTR_PTR(, sectorsize),
+	BTRFS_ATTR_PTR(, clone_alignment),
+	BTRFS_ATTR_PTR(, quota_override),
 	NULL,
 };
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index d7da1a4c2f6c..928cc5c23347 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -20,21 +20,16 @@ enum btrfs_feature_set {
 	.store	= _store,						\
 }
 
-#define BTRFS_ATTR_RW(_name, _show, _store)			\
-	static struct kobj_attribute btrfs_attr_##_name =		\
+#define BTRFS_ATTR_RW(_prefix, _name, _show, _store)			\
+	static struct kobj_attribute btrfs_attr_##_prefix##_##_name =	\
 			__INIT_KOBJ_ATTR(_name, 0644, _show, _store)
 
-#define BTRFS_ATTR(_name, _show)					\
-	static struct kobj_attribute btrfs_attr_##_name =		\
+#define BTRFS_ATTR(_prefix, _name, _show)				\
+	static struct kobj_attribute btrfs_attr_##_prefix##_##_name =	\
 			__INIT_KOBJ_ATTR(_name, 0444, _show, NULL)
 
-#define BTRFS_ATTR_PTR(_name)    (&btrfs_attr_##_name.attr)
-
-#define BTRFS_RAID_ATTR(_name, _show)					\
-	static struct kobj_attribute btrfs_raid_attr_##_name =		\
-			__INIT_KOBJ_ATTR(_name, 0444, _show, NULL)
-
-#define BTRFS_RAID_ATTR_PTR(_name)    (&btrfs_raid_attr_##_name.attr)
+#define BTRFS_ATTR_PTR(_prefix, _name)					\
+	(&btrfs_attr_##_prefix##_##_name.attr)
 
 
 struct btrfs_feature_attr {
@@ -43,15 +38,16 @@ struct btrfs_feature_attr {
 	u64 feature_bit;
 };
 
-#define BTRFS_FEAT_ATTR(_name, _feature_set, _prefix, _feature_bit)	     \
-static struct btrfs_feature_attr btrfs_attr_##_name = {			     \
+#define BTRFS_FEAT_ATTR(_name, _feature_set, _feature_prefix, _feature_bit)  \
+static struct btrfs_feature_attr btrfs_attr_features_##_name = {	     \
 	.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,			     \
 				      btrfs_feature_attr_show,		     \
 				      btrfs_feature_attr_store),	     \
 	.feature_set	= _feature_set,					     \
-	.feature_bit	= _prefix ##_## _feature_bit,			     \
+	.feature_bit	= _feature_prefix ##_## _feature_bit,		     \
 }
-#define BTRFS_FEAT_ATTR_PTR(_name)    (&btrfs_attr_##_name.kobj_attr.attr)
+#define BTRFS_FEAT_ATTR_PTR(_name)					     \
+	(&btrfs_attr_features_##_name.kobj_attr.attr)
 
 #define BTRFS_FEAT_ATTR_COMPAT(name, feature) \
 	BTRFS_FEAT_ATTR(name, FEAT_COMPAT, BTRFS_FEATURE_COMPAT, feature)
-- 
2.11.0

