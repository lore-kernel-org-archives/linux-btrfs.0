Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52325 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbbASGrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:24 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kkpg022588
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 09/10] btrfs-progs: Add new option for btrfs-find-root to search through all the metadata extents.
Date: Mon, 19 Jan 2015 14:45:11 +0800
Message-ID: <1421649912-14539-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add option '-a' for btrfs-find-root to iterate all the metadata extents
even the root is already found.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-find-root.txt |  2 ++
 btrfs-find-root.c                 | 31 +++++++++++++++++--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/Documentation/btrfs-find-root.txt b/Documentation/btrfs-find-root.txt
index c934b4c..e04cd3e 100644
--- a/Documentation/btrfs-find-root.txt
+++ b/Documentation/btrfs-find-root.txt
@@ -16,6 +16,8 @@ root tree's objectid, generation, level.
 
 OPTIONS
 -------
+-a::
+Search through all the metadata extents, even the root is already found.
 -g <generation>::
 Filter root tree by it's original transaction id, tree root's generation in default.
 -o <objectid>::
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 31fe0ae..1da5513 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -39,7 +39,7 @@
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: find-roots [-o search_objectid] "
+	fprintf(stderr, "Usage: find-roots [-a] [-o search_objectid] "
 		"[ -g search_generation ] [ -l search_level ] <device>\n");
 }
 
@@ -152,20 +152,23 @@ int main(int argc, char **argv)
 	filter.objectid = BTRFS_ROOT_TREE_OBJECTID;
 	filter.match_gen = (u64)-1;
 	filter.match_level = (u8)-1;
-	while ((opt = getopt(argc, argv, "l:o:g:")) != -1) {
+	while ((opt = getopt(argc, argv, "al:o:g:")) != -1) {
 		switch(opt) {
-			case 'o':
-				filter.objectid = arg_strtou64(optarg);
-				break;
-			case 'g':
-				filter.generation = arg_strtou64(optarg);
-				break;
-			case 'l':
-				filter.level = arg_strtou64(optarg);
-				break;
-			default:
-				usage();
-				exit(1);
+		case 'a':
+			filter.search_all = 1;
+			break;
+		case 'o':
+			filter.objectid = arg_strtou64(optarg);
+			break;
+		case 'g':
+			filter.generation = arg_strtou64(optarg);
+			break;
+		case 'l':
+			filter.level = arg_strtou64(optarg);
+			break;
+		default:
+			usage();
+			exit(1);
 		}
 	}
 
-- 
2.2.2

