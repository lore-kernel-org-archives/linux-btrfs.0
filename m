Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:44042 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab2I3OYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 10:24:47 -0400
From: Dieter Ries <mail@dieterries.net>
To: linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 3/3] btrfs-progs: btrfsck: Print feedback about fscking to stdout.
Date: Sun, 30 Sep 2012 16:18:30 +0200
Message-Id: <1349014710-16089-4-git-send-email-mail@dieterries.net>
In-Reply-To: <1349014710-16089-1-git-send-email-mail@dieterries.net>
References: <1349014710-16089-1-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Status reports of the checking process should be printed to stdout
instead of stderr, as that is normal program output and not related to
problems in btrfsck. This patch changes this behaviour and adds the
output "Done!" after each of the parts.

Signed-off-by: Dieter Ries <mail@dieterries.net>
---
 btrfsck.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index dde63e7..245ba7d 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3557,7 +3557,7 @@ int main(int ac, char **av)
 
 	root = info->fs_root;
 
-	fprintf(stderr, "checking extents\n");
+	printf("checking extents... ");
 	if (rw)
 		trans = btrfs_start_transaction(root, 1);
 
@@ -3565,22 +3565,31 @@ int main(int ac, char **av)
 		fprintf(stderr, "Reinit crc root\n");
 		ret = btrfs_fsck_reinit_root(trans, info->csum_root);
 		if (ret) {
+			printf("\n");
 			fprintf(stderr, "crc root initialization failed\n");
 			return -EIO;
 		}
 		goto out;
 	}
 	ret = check_extents(trans, root, repair);
-	if (ret)
+	if (ret) {
 		fprintf(stderr, "Errors found in extent allocation tree\n");
+		printf("\n");
+	}
+	else
+		printf("Done!\n");
 
-	fprintf(stderr, "checking fs roots\n");
+	printf("checking fs roots... ");
 	ret = check_fs_roots(root, &root_cache);
-	if (ret)
+	if (ret) {
+		printf("\n");
 		goto out;
+	else
+		printf("Done!\n");
 
-	fprintf(stderr, "checking root refs\n");
+	printf("checking root refs... ");
 	ret = check_root_refs(root, &root_cache);
+	printf("Done!\n");
 out:
 	free_root_recs(&root_cache);
 	if (rw) {
-- 
1.7.3.GIT

