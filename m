Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47008 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933665AbdKGInZ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:25 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 10/12] btrfs-progs: mkfs: Introduce quota runtime feature
Date: Tue,  7 Nov 2017 16:42:57 +0800
Message-Id: <20171107084259.22367-14-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce quota runtime feature for mkfs.

The result fs will has quota enabled, with consistent qgroup accounting.

This is quite handy to test quota with fstests, which doesn't support to
call ioctl for btrfs at mount time.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/mkfs.btrfs.asciidoc | 7 +++++++
 fsfeatures.c                      | 3 +++
 fsfeatures.h                      | 2 ++
 mkfs/main.c                       | 8 ++++++++
 4 files changed, 20 insertions(+)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 7def34cc9074..66bac3d3eb0c 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -220,6 +220,13 @@ RUNTIME FEATURES
 Btrfs has some feature which can be enabled by ioctl after mount.
 Some of such features can also be enabled during creation time.
 
+*quota*::
+(kernel support since 3.4)
++
+Enable btrfs quota support. Result filesystem will have quota enabled and all
+qgroup accounting correct.
+See also `btrfs-quota`(8).
+
 BLOCK GROUPS, CHUNKS, RAID
 --------------------------
 
diff --git a/fsfeatures.c b/fsfeatures.c
index 02205dcec32d..c76043be73a2 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -98,6 +98,9 @@ static const struct btrfs_feature mkfs_features[] = {
 };
 
 static const struct btrfs_feature runtime_features[] = {
+	{ "quota", BTRFS_RUNTIME_FEATURE_QUOTA, NULL,
+		VERSION_TO_STRING2(3, 4), NULL, 0, NULL, 0,
+		"enable btrfs quota support" },
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
diff --git a/fsfeatures.h b/fsfeatures.h
index 7ea4a2b47740..131412540c75 100644
--- a/fsfeatures.h
+++ b/fsfeatures.h
@@ -39,6 +39,8 @@
 
 #define BTRFS_FEATURE_LIST_ALL		(1ULL << 63)
 
+#define BTRFS_RUNTIME_FEATURE_QUOTA	(1ULL << 0)
+
 void btrfs_list_all_fs_features(u64 mask_disallowed);
 void btrfs_list_all_runtime_features(u64 mask_disallowed);
 char *btrfs_parse_fs_features(char *namelist, u64 *flags);
diff --git a/mkfs/main.c b/mkfs/main.c
index bca97146cecb..76e3e719061e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -2041,6 +2041,14 @@ raid_groups:
 		goto out;
 	}
 
+	if (runtime_features & BTRFS_RUNTIME_FEATURE_QUOTA) {
+		ret = setup_quota_root(fs_info);
+		if (ret < 0) {
+			error("failed to initialize quota: %d (%s)", ret,
+				strerror(-ret));
+			goto out;
+		}
+	}
 	if (verbose) {
 		char features_buf[64];
 
-- 
2.15.0

