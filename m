Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53541 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752021AbaF1Ldd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:33 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXTiW021020
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/12] Btrfs: fix missing error handler if submiting re-read bio fails
Date: Sat, 28 Jun 2014 19:34:55 +0800
Message-ID: <1403955302-22396-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forgot to free failure record and bio after submitting re-read bio failed,
fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ac43b4..c49c1e1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2345,6 +2345,11 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
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

