Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874DAC67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E70E20665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E70E20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbeJWR5O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:14 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbeJWR5O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:14 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602825"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:36 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5A1744B710E8
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:35 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:41 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 01/13] btrfs-progs: lowmem: add argument path to punch_extent_hole()
Date:   Tue, 23 Oct 2018 17:41:35 +0800
Message-ID: <20181023094147.7906-2-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 5A1744B710E8.A8F90
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since repair will do CoW, the outer path may be invalid,
add an argument path to punch_extent_hole().
When punch_extent_hole() returns, path will still point to the item
before calling punch_extent_hole();

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1bce44f5658a..c8e4f13d816f 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1710,15 +1710,20 @@ out:
 /*
  * Wrapper function of btrfs_punch_hole.
  *
+ * @path:	will point to the item while calling the function.
+ *
  * Returns 0 means success.
  * Returns not 0 means error.
  */
-static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
-			     u64 len)
+static int punch_extent_hole(struct btrfs_root *root, struct btrfs_path *path,
+			     u64 ino, u64 start, u64 len)
 {
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
+	struct btrfs_key key;
+	int ret;
+	int ret2;
 
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
@@ -1732,6 +1737,12 @@ static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
 		       ino);
 
 	btrfs_commit_transaction(trans, root);
+
+	btrfs_release_path(path);
+	ret2 = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret2 > 0)
+		ret2 = -ENOENT;
+	ret |= ret2;
 	return ret;
 }
 
@@ -1963,7 +1974,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 	/* Check EXTENT_DATA hole */
 	if (!no_holes && *end != fkey.offset) {
 		if (repair)
-			ret = punch_extent_hole(root, fkey.objectid,
+			ret = punch_extent_hole(root, path, fkey.objectid,
 						*end, fkey.offset - *end);
 		if (!repair || ret) {
 			err |= FILE_EXTENT_ERROR;
@@ -2534,7 +2545,7 @@ out:
 
 		if (!nbytes && !no_holes && extent_end < isize) {
 			if (repair)
-				ret = punch_extent_hole(root, inode_id,
+				ret = punch_extent_hole(root, path, inode_id,
 						extent_end, isize - extent_end);
 			if (!repair || ret) {
 				err |= NBYTES_ERROR;
-- 
2.19.1



