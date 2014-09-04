Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19679 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbaIDC1u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 22:27:50 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s842RkIx002434
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Sep 2014 10:27:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: fix find_mount_root() to handle duplicated mount point correctly
Date: Thu, 4 Sep 2014 10:27:48 +0800
Message-ID: <1409797668-11870-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original find_mount_root() will use the first mount point match and
return it.
It was OK until the following commit, which will also check the fstype:
de22c28ef31d9721606ba059 btrfs-progs: Check fstype in find_mount_root()

With fstype check, we should check the last match, not only the first
one.
Or the following mount will not pass the find_mount_root():
/dev/sdc on /mnt/test type ext4 (rw,relatime,data=ordered)
/dev/sdb on /mnt/test type btrfs (rw,relatime,space_cache)

This patch will use the last match to do the fstype check.

Reported-by: Remco Hosman <remco@yerf-it.nl>
Signed-off-bu: Remco Hosman <remco@yerf-it.nl>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 6c09366..6a16b06 100644
--- a/utils.c
+++ b/utils.c
@@ -2359,8 +2359,8 @@ int find_mount_root(const char *path, char **mount_root)
 	while ((ent = getmntent(mnttab))) {
 		len = strlen(ent->mnt_dir);
 		if (strncmp(ent->mnt_dir, path, len) == 0) {
-			/* match found */
-			if (longest_matchlen < len) {
+			/* match found and use the latest match */
+			if (longest_matchlen <= len) {
 				free(longest_match);
 				longest_matchlen = len;
 				longest_match = strdup(ent->mnt_dir);
-- 
2.1.0

