Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62106 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762898Ab3IDPX3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:29 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so464386pde.10
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:28 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 14/20] Btrfs-progs: fix magic return value in btrfs-zero-log.c
Date: Wed,  4 Sep 2013 23:22:31 +0800
Message-Id: <1378308157-4621-15-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-zero-log.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index f249aec..31ec215 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -52,10 +52,11 @@ int main(int ac, char **av)
 
 	if((ret = check_mounted(av[1])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
-		return ret;
+		goto out;
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[1]);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	root = open_ctree(av[1], 0, 1);
@@ -68,5 +69,6 @@ int main(int ac, char **av)
 	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
-	return ret;
+out:
+	return !!ret;
 }
-- 
1.7.11.7

