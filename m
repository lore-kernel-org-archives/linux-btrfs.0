Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59353 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbbASLWf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 06:22:35 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 10/16] Btrfs: Avoid trustless page-level-repair in dev-replace
Date: Mon, 19 Jan 2015 19:20:59 +0800
Message-ID: <1421666465-3892-11-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Current code of page level repair for dev-replace can only support
io-error, we can't use it in checksum-fail case.

We can skip this kind of repair in dev-replace just as we in scrub.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9afc6dd..6cf0dc7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1099,6 +1099,10 @@ nodatasum_case:
 		}
 	}
 
+	/* can only fix I/O errors from here on */
+	if (sblock_bad->no_io_error_seen)
+		goto did_not_correct_error;
+
 	/*
 	 * for dev_replace, pick good pages and write to the target device.
 	 */
@@ -1181,10 +1185,6 @@ nodatasum_case:
 	 * area are unreadable.
 	 */
 
-	/* can only fix I/O errors from here on */
-	if (sblock_bad->no_io_error_seen)
-		goto did_not_correct_error;
-
 	success = 1;
 	for (page_num = 0; page_num < sblock_bad->page_count; page_num++) {
 		struct scrub_page *page_bad = sblock_bad->pagev[page_num];
-- 
1.8.5.1

