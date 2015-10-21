Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43210 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbbJUIrf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 04:47:35 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9L8lY2t023404
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t9L8lYgH028308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:34 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t9L8lYd7003070
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 1/3] btrfs-progs: introduce framework to check kernel supported features
Date: Wed, 21 Oct 2015 16:45:47 +0800
Message-Id: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the newer kernel, supported kernel features can be known from
  /sys/fs/btrfs/features
however this interface was introduced only after 3.14, and most the
incompatible FS features were introduce before 3.14.

This patch proposes to maintain kernel version against the feature list,
and so that will be the minimum kernel version needed to use the feature.

Further, for features supported later than 3.14 this list can still be
updated, so it serves as a repository which can be displayed for easy
reference.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 utils.h |  1 +
 2 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index b754686..cd5a626 100644
--- a/utils.c
+++ b/utils.c
@@ -32,10 +32,12 @@
 #include <linux/loop.h>
 #include <linux/major.h>
 #include <linux/kdev_t.h>
+#include <linux/version.h>
 #include <limits.h>
 #include <blkid/blkid.h>
 #include <sys/vfs.h>
 #include <sys/statfs.h>
+#include <sys/utsname.h>
 #include <linux/magic.h>
 
 #include "kerncompat.h"
@@ -567,21 +569,28 @@ out:
 	return ret;
 }
 
+/*
+ * min_ker_ver: update with minimum kernel version at which the feature
+ * was integrated into the mainline. For the transit period, that is
+ * feature not yet in mainline but in mailing list and for testing,
+ * please use "0.0" to indicate the same.
+ */
 static const struct btrfs_fs_feature {
 	const char *name;
 	u64 flag;
 	const char *desc;
+	const char *min_ker_ver;
 } mkfs_features[] = {
 	{ "mixed-bg", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS,
-		"mixed data and metadata block groups" },
+		"mixed data and metadata block groups", "2.7.31"},
 	{ "extref", BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF,
-		"increased hardlink limit per file to 65536" },
+		"increased hardlink limit per file to 65536", "3.7"},
 	{ "raid56", BTRFS_FEATURE_INCOMPAT_RAID56,
-		"raid56 extended format" },
+		"raid56 extended format", "3.9"},
 	{ "skinny-metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA,
-		"reduced-size metadata extent refs" },
+		"reduced-size metadata extent refs", "3.10"},
 	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
-		"no explicit hole extents for files" },
+		"no explicit hole extents for files", "3.14"},
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
@@ -3077,3 +3086,53 @@ unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode)
 
 	return unit_mode;
 }
+
+static int version_to_code(char *v)
+{
+	int i = 0;
+	char *b[3] = {NULL};
+	char *save_b = NULL;
+
+	for (b[i] = strtok_r(v, ".", &save_b);
+		b[i] != NULL;
+		b[i] = strtok_r(NULL, ".", &save_b))
+		i++;
+
+	if (b[2] == NULL)
+		return KERNEL_VERSION(atoi(b[0]), atoi(b[1]), 0);
+	else
+		return KERNEL_VERSION(atoi(b[0]), atoi(b[1]), atoi(b[2]));
+
+}
+
+static int get_kernel_code()
+{
+	int ret;
+	struct utsname utsbuf;
+	char *version;
+
+	ret = uname(&utsbuf);
+	if (ret)
+		return -ret;
+
+	version = strtok(utsbuf.release, "-");
+
+	return version_to_code(version);
+}
+
+u64 btrfs_features_allowed_by_kernel(void)
+{
+	int i;
+	int local_kernel_code = get_kernel_code();
+	u64 features = 0;
+
+	for (i = 0; i < ARRAY_SIZE(mkfs_features) - 1; i++) {
+		char *ver = strdup(mkfs_features[i].min_ker_ver);
+
+		if (local_kernel_code >= version_to_code(ver))
+			features |= mkfs_features[i].flag;
+
+		free(ver);
+	}
+	return (features);
+}
diff --git a/utils.h b/utils.h
index 192f3d1..9044643 100644
--- a/utils.h
+++ b/utils.h
@@ -104,6 +104,7 @@ void btrfs_list_all_fs_features(u64 mask_disallowed);
 char* btrfs_parse_fs_features(char *namelist, u64 *flags);
 void btrfs_process_fs_features(u64 flags);
 void btrfs_parse_features_to_string(char *buf, u64 flags);
+u64 btrfs_features_allowed_by_kernel(void);
 
 struct btrfs_mkfs_config {
 	char *label;
-- 
2.4.1

