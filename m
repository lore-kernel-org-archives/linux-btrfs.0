Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39208 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932186AbcJXCn5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Oct 2016 22:43:57 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 1/4] btrfs-progs: Fix memory leak in write_raid56_with_parity
Date: Mon, 24 Oct 2016 10:43:32 +0800
Message-Id: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ebs and pointers are allocated, but if any of the allocation failed, we
should free the allocated memory.

Reported-by: David Sterba <dsterba@suse.cz>
Resolves-Coverity-CID: 1296749
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index a7abd92..f687b0d 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2120,8 +2120,11 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 
 	ebs = malloc(sizeof(*ebs) * multi->num_stripes);
 	pointers = malloc(sizeof(*pointers) * multi->num_stripes);
-	if (!ebs || !pointers)
+	if (!ebs || !pointers) {
+		free(ebs);
+		free(pointers);
 		return -ENOMEM;
+	}
 
 	if (stripe_len > alloc_size)
 		alloc_size = stripe_len;
-- 
2.10.1



