Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55790 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbbJTCVB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 22:21:01 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix a typo which causes super_copy corrupted
Date: Tue, 20 Oct 2015 10:20:44 +0800
Message-ID: <1445307644-28147-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_read_dev_super(), a wrong parameter for memcpy will copy wrong
address of a stack pointer to super_copy.
Which will cause a lot of unpredictable error.

What a stupid typo from myself!!!!!

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index f7e6c41..139bc80 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1480,7 +1480,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 
 		if (check_super(buf))
 			return -1;
-		memcpy(sb, &buf, BTRFS_SUPER_INFO_SIZE);
+		memcpy(sb, buf, BTRFS_SUPER_INFO_SIZE);
 		return 0;
 	}
 
-- 
2.6.1

