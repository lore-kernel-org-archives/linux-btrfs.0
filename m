Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20725 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbKYMI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:58 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 5/7] btrfs-progs: introduce framework version to features
Date: Wed, 25 Nov 2015 20:08:18 +0800
Message-Id: <1448453300-8449-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As discussed in the mailing list this provides a framework to introduce
the feature where mkfs and btrfs-convert can set the default features
as per the given mainline kernel version.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 23 +++++++++++++++++++++++
 utils.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/utils.c b/utils.c
index 216efa6..a9b46b8 100644
--- a/utils.c
+++ b/utils.c
@@ -3222,3 +3222,26 @@ int btrfs_features_allowed_by_sysfs(u64 *features)
 	closedir(dir);
 	return 0;
 }
+
+int btrfs_features_allowed_by_version(char *version, u64 *features)
+{
+	int i;
+	int code;
+	char *ver = strdup(version);
+
+	*features = 0;
+	code = version_to_code(ver);
+	free(ver);
+	if (code < 0)
+		return code;
+
+	for (i = 0; i < ARRAY_SIZE(mkfs_features) - 1; i++) {
+		ver = strdup(mkfs_features[i].min_ker_ver);
+
+		if (code >= version_to_code(ver))
+			*features |= mkfs_features[i].flag;
+
+		free(ver);
+	}
+	return 0;
+}
diff --git a/utils.h b/utils.h
index cb20d73..1418e84 100644
--- a/utils.h
+++ b/utils.h
@@ -106,6 +106,7 @@ void btrfs_process_fs_features(u64 flags);
 void btrfs_parse_features_to_string(char *buf, u64 flags);
 u64 btrfs_features_allowed_by_kernel(void);
 int btrfs_features_allowed_by_sysfs(u64 *features);
+int btrfs_features_allowed_by_version(char *version, u64 *features);
 
 struct btrfs_mkfs_config {
 	char *label;
-- 
2.6.2

