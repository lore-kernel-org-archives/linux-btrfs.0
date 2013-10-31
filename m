Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42212 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3JaLUw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 07:20:52 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so2350481pab.36
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 04:20:52 -0700 (PDT)
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: Remove useless variable in write_ctree_super()
Date: Thu, 31 Oct 2013 16:50:42 +0530
Message-Id: <1383218442-27700-1-git-send-email-rashika.kheria@gmail.com>
In-Reply-To: <20131030215915.GA26170@gmail.com>
References: <20131030215915.GA26170@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function write_ctree_super() in disk-io.c uses variable ret to return
the result of function write_all_supers(). Since, this variable serves
no purpose, hence the patch removes it and returns the call of the
called function.

Reviewed-by: Zach Brown <zab@redhat.com>
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This patch fixes the following issues of the previous revision-
Change Subject line

 fs/btrfs/disk-io.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 25fb77a..cc95d55 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3425,10 +3425,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors)
 {
-	int ret;
-
-	ret = write_all_supers(root, max_mirrors);
-	return ret;
+	return write_all_supers(root, max_mirrors);
 }
 
 /* Drop a fs root from the radix tree and free it. */
-- 
1.7.9.5

