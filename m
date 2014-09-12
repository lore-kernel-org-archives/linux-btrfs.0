Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5324 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753AbaILKmR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 06:42:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8CAgPPN017328
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 18:42:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 04/11] Btrfs: fix missing error handler if submiting re-read bio fails
Date: Fri, 12 Sep 2014 18:43:57 +0800
Message-ID: <1410518644-31806-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
References: <5405C08B.9020009@fb.com>
 <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forgot to free failure record and bio after submitting re-read bio failed,
fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- None
---
 fs/btrfs/extent_io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 92a6d9f..f8dda46 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2348,6 +2348,11 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	ret = tree->ops->submit_bio_hook(inode, read_mode, bio,
 					 failrec->this_mirror,
 					 failrec->bio_flags, 0);
+	if (ret) {
+		free_io_failure(inode, failrec, 0);
+		bio_put(bio);
+	}
+
 	return ret;
 }
 
-- 
1.9.3

