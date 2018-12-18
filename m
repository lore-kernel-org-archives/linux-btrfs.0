Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313B9C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2FA6217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbeLRKrA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:47:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:38528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbeLRKq7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 05:46:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9396B004;
        Tue, 18 Dec 2018 10:46:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 03/13] btrfs-progs: lowmem: move nbytes check before isize check
Date:   Tue, 18 Dec 2018 18:46:36 +0800
Message-Id: <20181218104646.29599-4-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181218104646.29599-1-wqu@suse.com>
References: <20181218104646.29599-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

For files, lowmem repair will try to check nbytes and isize,
but isize check depends nbytes.

Once bytes has been repaired, then isize should be checked and
repaired.
So move nbytes check before isize check. Also set nbytes to
extent_size once repaired successfully.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 0f8af35d4da1..3f3f90e124d8 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2605,28 +2605,31 @@ out:
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
2.20.0

