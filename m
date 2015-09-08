Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754283AbbIHNSb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 09:18:31 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t88DIGc2018025
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 21:18:16 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: fix set_get typo of btrfs_inode_item->sequence
Date: Tue, 8 Sep 2015 21:16:49 +0800
Message-ID: <d4a8e4de36299596be2f85561a619346c7d70aa7.1441718128.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
References: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

s/generation/sequence
for BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, ...)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index bcad2b9..2061e1e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1423,7 +1423,7 @@ BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_generation,
 			 struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence,
-			 struct btrfs_inode_item, generation, 64);
+			 struct btrfs_inode_item, sequence, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_size,
 			 struct btrfs_inode_item, size, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_nbytes,
-- 
1.8.5.1

