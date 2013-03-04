Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:42487 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932154Ab3CDVkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/14] btrfs-progs: free resources on do_rollback error returns
Date: Mon,  4 Mar 2013 16:39:53 -0600
Message-Id: <1362436804-16766-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

close fd if open, and free allocated memory in buf

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 convert.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/convert.c b/convert.c
index 4a75895..76a1076 100644
--- a/convert.c
+++ b/convert.c
@@ -2455,7 +2455,7 @@ fail:
 
 int do_rollback(const char *devname, int force)
 {
-	int fd;
+	int fd = -1;
 	int ret;
 	int i;
 	struct btrfs_root *root;
@@ -2471,7 +2471,7 @@ int do_rollback(const char *devname, int force)
 	struct btrfs_key key;
 	struct btrfs_path path;
 	struct extent_io_tree io_tree;
-	char *buf;
+	char *buf = NULL;
 	char *name;
 	u64 bytenr;
 	u64 num_bytes;
@@ -2751,7 +2751,11 @@ next_sector:
 	extent_io_tree_cleanup(&io_tree);
 	printf("rollback complete.\n");
 	return 0;
+
 fail:
+	if (fd != -1)
+		close(fd);
+	free(buf);
 	fprintf(stderr, "rollback aborted.\n");
 	return -1;
 }
-- 
1.7.1

