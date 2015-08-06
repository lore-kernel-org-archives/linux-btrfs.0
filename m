Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18104 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753601AbbHFN6g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 09:58:36 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t76DudNU020380
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 21:56:39 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: abort transaction on btrfs_reloc_cow_block()
Date: Thu, 6 Aug 2015 21:56:58 +0800
Message-ID: <112f5da071c0d3446fedf7c7828c78ae586e11fb.1438869404.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_reloc_cow_block() failed in __btrfs_cow_block(), current
code just return a err-value to caller, but leave new_created extent
buffer exist and locked.

Then subsequent code (in relocate) try to lock above eb again,
and caused deadlock without any dmesg.
(eb lock use wait_event(), so no lockdep message)

It is hard to do recover work in __btrfs_cow_block() at this error
point, but we can abort transaction to avoid deadlock and operate on
unstable state.a

It also helps developer to find wrong place quickly.
(better than a frozen fs without any dmesg before patch)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/ctree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 54114b4..5f745ea 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1159,8 +1159,10 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state)) {
 		ret = btrfs_reloc_cow_block(trans, root, buf, cow);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
 			return ret;
+		}
 	}
 
 	if (buf == root->node) {
-- 
1.8.5.1

