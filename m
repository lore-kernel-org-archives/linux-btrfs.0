Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47567 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753340AbaGJDFQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 23:05:16 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6A35BaX026101
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 11:05:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 1/4] btrfs-progs: Check fstype in find_mount_root()
Date: Thu, 10 Jul 2014 11:05:10 +0800
Message-ID: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When calling find_mount_root(), caller in fact wants to find the mount
point of *BTRFS*.

So also check ent->fstype in find_mount_root() and output proper error
messages if needed.
This will suppress a lot of "Inapproiate ioctl for device" error
message.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/utils.c b/utils.c
index 993d085..507ec6c 100644
--- a/utils.c
+++ b/utils.c
@@ -2412,6 +2412,7 @@ int find_mount_root(const char *path, char **mount_root)
 	struct mntent *ent;
 	int len;
 	int ret;
+	int not_btrfs;
 	int longest_matchlen = 0;
 	char *longest_match = NULL;
 
@@ -2432,6 +2433,10 @@ int find_mount_root(const char *path, char **mount_root)
 				free(longest_match);
 				longest_matchlen = len;
 				longest_match = strdup(ent->mnt_dir);
+				if (strcmp(ent->mnt_type, "btrfs"))
+					not_btrfs = 1;
+				else
+					not_btrfs = 0;
 			}
 		}
 	}
@@ -2443,6 +2448,12 @@ int find_mount_root(const char *path, char **mount_root)
 			path);
 		return -ENOENT;
 	}
+	if (not_btrfs) {
+		fprintf(stderr,
+			"ERROR: %s does not belong to a btrfs mount points.\n",
+			path);
+		return -EINVAL;
+	}
 
 	ret = 0;
 	*mount_root = realpath(longest_match, NULL);
-- 
2.0.1

