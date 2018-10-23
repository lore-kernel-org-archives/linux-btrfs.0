Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF91BC46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873E120665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 873E120665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbeJWR5Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:16 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33304 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728580AbeJWR5P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:15 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602827"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:36 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E3DD64B710E9
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:35 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:42 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 02/13] btrfs-progs: lowmem: move nbytes check before isize check
Date:   Tue, 23 Oct 2018 17:41:36 +0800
Message-ID: <20181023094147.7906-3-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: E3DD64B710E9.AC4A5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For files, lowmem repair will try to check nbytes and isize,
but isize check depends nbytes.

Once bytes has been repaired, then isize should be checked and
repaired.
So move nbytes check before isize check. Also set nbytes to
extent_size once repaired successfully.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index c8e4f13d816f..76e7be81ceb1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2125,7 +2125,7 @@ out:
 		error("failed to set nbytes in inode %llu root %llu",
 		      ino, root->root_key.objectid);
 	else
-		printf("Set nbytes in inode item %llu root %llu\n to %llu", ino,
+		printf("Set nbytes in inode item %llu root %llu to %llu\n", ino,
 		       root->root_key.objectid, nbytes);
 
 	/* research path */
@@ -2543,28 +2543,31 @@ out:
 			}
 		}
 
-		if (!nbytes && !no_holes && extent_end < isize) {
-			if (repair)
-				ret = punch_extent_hole(root, path, inode_id,
-						extent_end, isize - extent_end);
+		if (nbytes != extent_size) {
+			if (repair) {
+				ret = repair_inode_nbytes_lowmem(root, path,
+							 inode_id, extent_size);
+				if (!ret)
+					nbytes = extent_size;
+			}
 			if (!repair || ret) {
 				err |= NBYTES_ERROR;
 				error(
-	"root %llu INODE[%llu] size %llu should have a file extent hole",
-				      root->objectid, inode_id, isize);
+	"root %llu INODE[%llu] nbytes %llu not equal to extent_size %llu",
+				      root->objectid, inode_id, nbytes,
+				      extent_size);
 			}
 		}
 
-		if (nbytes != extent_size) {
+		if (!nbytes && !no_holes && extent_end < isize) {
 			if (repair)
-				ret = repair_inode_nbytes_lowmem(root, path,
-							 inode_id, extent_size);
+				ret = punch_extent_hole(root, path, inode_id,
+						extent_end, isize - extent_end);
 			if (!repair || ret) {
 				err |= NBYTES_ERROR;
 				error(
-	"root %llu INODE[%llu] nbytes %llu not equal to extent_size %llu",
-				      root->objectid, inode_id, nbytes,
-				      extent_size);
+	"root %llu INODE[%llu] size %llu should have a file extent hole",
+				      root->objectid, inode_id, isize);
 			}
 		}
 	}
-- 
2.19.1



