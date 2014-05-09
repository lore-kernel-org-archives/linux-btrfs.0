Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:47232 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757643AbaEIVPP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 17:15:15 -0400
Received: from f18.lab.localdomain (lenny.home.zabbo.net [192.168.242.10])
	by tetsuo.zabbo.net (Postfix) with ESMTP id 642C1720036B
	for <linux-btrfs@vger.kernel.org>; Fri,  9 May 2014 14:15:14 -0700 (PDT)
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: return ptr error from compression workspace
Date: Fri,  9 May 2014 17:15:09 -0400
Message-Id: <1399670110-3335-2-git-send-email-zab@redhat.com>
In-Reply-To: <1399670110-3335-1-git-send-email-zab@redhat.com>
References: <1399670110-3335-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs compression wrappers translated errors from workspace
allocation to either -ENOMEM or -1.  The compression type workspace
allocators are already returning a ERR_PTR(-ENOMEM).  Just return that
and get rid of the magical -1.

This helps a future patch return errors from the compression wrappers.

Signed-off-by: Zach Brown <zab@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/compression.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ed1ff1cb..7912695 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -888,7 +888,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 
 	workspace = find_workspace(type);
 	if (IS_ERR(workspace))
-		return -1;
+		return PTR_ERR(workspace);
 
 	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
 						      start, len, pages,
@@ -924,7 +924,7 @@ static int btrfs_decompress_biovec(int type, struct page **pages_in,
 
 	workspace = find_workspace(type);
 	if (IS_ERR(workspace))
-		return -ENOMEM;
+		return PTR_ERR(workspace);
 
 	ret = btrfs_compress_op[type-1]->decompress_biovec(workspace, pages_in,
 							 disk_start,
@@ -946,7 +946,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 
 	workspace = find_workspace(type);
 	if (IS_ERR(workspace))
-		return -ENOMEM;
+		return PTR_ERR(workspace);
 
 	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
 						  dest_page, start_byte,
-- 
1.8.1.4

