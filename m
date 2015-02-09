Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40615 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760826AbbBIUDl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:41 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 08/16] Btrfs-progs: multi-thread btrfs-image restore
Date: Mon, 9 Feb 2015 15:03:11 -0500
Message-ID: <1423512199-16552-9-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For some reason we only allow btrfs-image restore to have one thread, which is
incredibly slow with large images.  So allow us to do work with more than just
one thread.  This made my restore go from 16 minutes to 3 minutes.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-image.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index aaff26d..ea85542 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1922,7 +1922,6 @@ static int add_cluster(struct meta_cluster *cluster,
 	u32 i, nritems;
 	int ret;
 
-	BUG_ON(mdres->num_items);
 	mdres->compress_method = header->compress;
 
 	bytenr = le64_to_cpu(header->bytenr) + BLOCK_SIZE;
@@ -2433,7 +2432,7 @@ static int __restore_metadump(const char *input, FILE *out, int old_restore,
 		goto out;
 	}
 
-	while (1) {
+	while (!mdrestore.error) {
 		ret = fread(cluster, BLOCK_SIZE, 1, in);
 		if (!ret)
 			break;
@@ -2450,14 +2449,8 @@ static int __restore_metadump(const char *input, FILE *out, int old_restore,
 			fprintf(stderr, "Error adding cluster\n");
 			break;
 		}
-
-		ret = wait_for_worker(&mdrestore);
-		if (ret) {
-			fprintf(stderr, "One of the threads errored out %d\n",
-				ret);
-			break;
-		}
 	}
+	ret = wait_for_worker(&mdrestore);
 out:
 	mdrestore_destroy(&mdrestore, num_threads);
 failed_cluster:
@@ -2598,7 +2591,7 @@ int main(int argc, char *argv[])
 {
 	char *source;
 	char *target;
-	u64 num_threads = 0;
+	u64 num_threads = 1;
 	u64 compress_level = 0;
 	int create = 1;
 	int old_restore = 0;
@@ -2689,7 +2682,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (num_threads == 0 && compress_level > 0) {
+	if (num_threads == 1 && compress_level > 0) {
 		num_threads = sysconf(_SC_NPROCESSORS_ONLN);
 		if (num_threads <= 0)
 			num_threads = 1;
@@ -2708,7 +2701,7 @@ int main(int argc, char *argv[])
 		ret = create_metadump(source, out, num_threads,
 				      compress_level, sanitize, walk_trees);
 	} else {
-		ret = restore_metadump(source, out, old_restore, 1,
+		ret = restore_metadump(source, out, old_restore, num_threads,
 				       multi_devices);
 	}
 	if (ret) {
-- 
1.8.3.1

