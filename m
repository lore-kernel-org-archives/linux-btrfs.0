Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbbBYSZC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:25:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4F7F1AAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:25:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 09/11] btrfs: switch helper macros to static inlines in sysfs.h
Date: Wed, 25 Feb 2015 19:25:00 +0100
Message-Id: <3bf35e6bc70137e38fee63e15c5da0a0458cac28.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The conversion macros use nested container_of that leads to a warning

fs/btrfs/sysfs.c: In function 'btrfs_feature_visible':
fs/btrfs/sysfs.c:183:8: warning: declaration of '__mptr' shadows a previous local
fs/btrfs/sysfs.c:183:8: warning: shadowed declaration is here

Use of functions will add proper type checking.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.h | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index f7dd298b3cf6..63f21a2d1366 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -61,11 +61,23 @@ static struct btrfs_feature_attr btrfs_attr_##_name = {			     \
 	BTRFS_FEAT_ATTR(name, FEAT_INCOMPAT, BTRFS_FEATURE_INCOMPAT, feature)
 
 /* convert from attribute */
-#define to_btrfs_feature_attr(a) \
-			container_of(a, struct btrfs_feature_attr, kobj_attr)
-#define attr_to_btrfs_attr(a) container_of(a, struct kobj_attribute, attr)
-#define attr_to_btrfs_feature_attr(a) \
-			to_btrfs_feature_attr(attr_to_btrfs_attr(a))
+static inline struct btrfs_feature_attr*
+to_btrfs_feature_attr(struct kobj_attribute *a)
+{
+	return container_of(a, struct btrfs_feature_attr, kobj_attr);
+}
+
+static inline struct kobj_attribute* attr_to_btrfs_attr(struct attribute *attr)
+{
+	return container_of(attr, struct kobj_attribute, attr);
+}
+
+static inline struct btrfs_feature_attr*
+attr_to_btrfs_feature_attr(struct attribute *attr)
+{
+	return to_btrfs_feature_attr(attr_to_btrfs_attr(attr));
+}
+
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
-- 
2.1.3

