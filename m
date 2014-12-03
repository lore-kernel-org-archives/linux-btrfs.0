Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25179 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbaLCERt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 23:17:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB34HRLB008384
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Dec 2014 12:17:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 1/6] btrfs-progs: print root dir verbose error in fsck
Date: Wed, 3 Dec 2014 12:18:27 +0800
Message-ID: <1417580312-8516-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, when btrfsck found an error in root dir, it will only
output the following message "root %llu root dir %llu error" without any
detailed error.

Just add print_inode_error() to print out the whole error.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index 389674f..9fc1410 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1984,6 +1984,7 @@ static int check_inode_recs(struct btrfs_root *root,
 			fprintf(stderr, "root %llu root dir %llu error\n",
 				(unsigned long long)root->root_key.objectid,
 				(unsigned long long)root_dirid);
+			print_inode_error(root, rec);
 			error++;
 		}
 	} else {
-- 
2.1.3

