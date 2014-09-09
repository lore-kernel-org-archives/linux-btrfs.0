Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:53279 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaIIJTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 05:19:33 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
	by mail.windriver.com (8.14.9/8.14.5) with ESMTP id s899JXcp023053
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Sep 2014 02:19:33 -0700 (PDT)
From: <rongqing.li@windriver.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix a overflowing boundary writing in csum_tree_block
Date: Tue, 9 Sep 2014 17:19:36 +0800
Message-ID: <1410254376-6357-1-git-send-email-rongqing.li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Li RongQing <roy.qing.li@gmail.com>

It is impossible that csum_size is larger than sizeof(long), but the codes
still add the handler for this condition, like allocate new memory, for
extension. If it becomes true someday, copying csum_size size memory to local
32bit variable found and val will overflow these two variables.

Fix it by returning the max 4 byte checksum.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
---
 fs/btrfs/disk-io.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ce8b8b6..cfa2953 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -296,6 +296,8 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
 			u32 val;
 			u32 found = 0;
+
+			csum_size = min_t(u16, csum_size, sizeof(u32));
 			memcpy(&found, result, csum_size);
 
 			read_extent_buffer(buf, &val, 0, csum_size);
-- 
1.7.10.4

