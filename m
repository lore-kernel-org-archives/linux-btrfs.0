Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642AbbEEGS5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:57 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456Hbus008375
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 8/8] btrfs-progs: btrfstune: Introduce new "-u" and "-U" options.
Date: Tue, 5 May 2015 14:16:46 +0800
Message-ID: <1430806606-3226-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These new options will change fsid and chunk tree uuid respectively.

This feature is useful for things like virt-clone, which needs to change
UUID of a filesystem to avoid conflicts.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfstune.asciidoc | 12 +++++--
 btrfstune.c                      | 67 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/Documentation/btrfstune.asciidoc b/Documentation/btrfstune.asciidoc
index 9620221..efd5fc8 100644
--- a/Documentation/btrfstune.asciidoc
+++ b/Documentation/btrfstune.asciidoc
@@ -25,8 +25,16 @@ Enable extended inode refs.
 -x::
 Enable skinny metadata extent refs.
 -f::
-Allow dangerous changes, e.g. clear the seeding flag. Make sure that you are
-aware of the dangers.
+Allow dangerous changes, e.g. clear the seeding flag or changing UUID.
+Make sure that you are aware of the dangers.
+-u <uuid>::
+Change fsid to <uuid>.
+-U <uuid>::
+Change chunk tree uuid to <uuid>.
+
+WARNING: If canceling a running fsid changing process, the fs will not be
+mountable due to mismatch fsid. When that happens, use *btrfstune* to change
+fsid again, and it should fix the inconsistence.
 
 When mounting the new device, btrfs will check whether the seeding flag is set
 when try to open seeding device.  If the user clears the seeding flag of the
diff --git a/btrfstune.c b/btrfstune.c
index 3e308b7..ef69a31 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -325,7 +325,9 @@ static void print_usage(void)
 	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
 	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
-	fprintf(stderr, "\t-f \t\tforce to set or clear flags, make sure that you are aware of the dangers\n");
+	fprintf(stderr, "\t-f \t\tforce to do dangerous operation, make sure that you are aware of the dangers\n");
+	fprintf(stderr, "\t-u uuid\tchange fsid\n");
+	fprintf(stderr, "\t-U uuid\tchange chunk tree uuid\n");
 }
 
 int main(int argc, char *argv[])
@@ -336,12 +338,15 @@ int main(int argc, char *argv[])
 	int extrefs_flag = 0;
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
+	char *new_fsid = NULL;
+	char *new_chunk_uuid = NULL;
 	int skinny_flag = 0;
+	enum btrfs_open_ctree_flags open_flags = OPEN_CTREE_WRITES;
 	int ret;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "S:rxf");
+		int c = getopt(argc, argv, "S:rxfu:U:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -358,6 +363,13 @@ int main(int argc, char *argv[])
 		case 'f':
 			force = 1;
 			break;
+		case 'u':
+			new_fsid = optarg;
+			open_flags |= OPEN_CTREE_IGNORE_FSID;
+			break;
+		case 'U':
+			new_chunk_uuid = optarg;
+			break;
 		default:
 			print_usage();
 			return 1;
@@ -372,13 +384,42 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (!(seeding_flag + extrefs_flag + skinny_flag)) {
+	if (!(seeding_flag + extrefs_flag + skinny_flag) &&
+	    !(new_fsid || new_chunk_uuid)) {
 		fprintf(stderr,
 			"ERROR: At least one option should be assigned.\n");
 		print_usage();
 		return 1;
 	}
 
+	if (new_fsid) {
+		uuid_t dummy_uuid;
+
+		if (uuid_parse(new_fsid, dummy_uuid) != 0) {
+			fprintf(stderr, "could not parse UUID: %s\n", new_fsid);
+			return 1;
+		}
+		if (!test_uuid_unique(new_fsid)) {
+			fprintf(stderr, "non-unique UUID: %s\n", new_fsid);
+			return 1;
+		}
+	}
+
+	if (new_chunk_uuid) {
+		uuid_t dummy_uuid;
+
+		if (uuid_parse(new_chunk_uuid, dummy_uuid) != 0) {
+			fprintf(stderr, "could not parse UUID: %s\n",
+				new_chunk_uuid);
+			return 1;
+		}
+		if (!test_uuid_unique(new_chunk_uuid)) {
+			fprintf(stderr, "non-unique UUID: %s\n",
+				new_chunk_uuid);
+			return 1;
+		}
+	}
+
 	ret = check_mounted(device);
 	if (ret < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n",
@@ -389,7 +430,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	root = open_ctree(device, 0, OPEN_CTREE_WRITES);
+	root = open_ctree(device, 0, open_flags);
 
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
@@ -424,6 +465,24 @@ int main(int argc, char *argv[])
 		total++;
 	}
 
+	if (new_fsid || new_chunk_uuid) {
+		if (!force) {
+			fprintf(stderr,
+				"Warning: It's highly recommended to run 'btrfs check' before changing UUID. \n");
+			fprintf(stderr,
+				"Also canceling running UUID change progress will cause corruption\n");
+			ret = ask_user("Are you sure to process?");
+			if (!ret) {
+				fprintf(stderr, "UUID change canceled\n");
+				return 1;
+			}
+		}
+		ret = change_uuid(root->fs_info, new_fsid, new_chunk_uuid);
+		if (!ret)
+			success++;
+		total++;
+	}
+
 	if (success == total) {
 		ret = 0;
 	} else {
-- 
2.3.7

