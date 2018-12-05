Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E678C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1270C2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1270C2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbeLEGko (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:49760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbeLEGkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0051EAEDA
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 10/13] btrfs-progs: Move btrfs_check_nodesize to fsfeatures.c to fix missing-prototypes warning
Date:   Wed,  5 Dec 2018 14:40:15 +0800
Message-Id: <20181205064018.27755-11-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

And fsfeatures.c is indeed a better location for that function.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fsfeatures.c | 23 +++++++++++++++++++++++
 utils.c      | 23 -----------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fsfeatures.c b/fsfeatures.c
index 7d85d60f1277..13ad030870cd 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -225,3 +225,26 @@ u32 get_running_kernel_version(void)
 	return version;
 }
 
+int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
+{
+	if (nodesize < sectorsize) {
+		error("illegal nodesize %u (smaller than %u)",
+				nodesize, sectorsize);
+		return -1;
+	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		error("illegal nodesize %u (larger than %u)",
+			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
+		return -1;
+	} else if (nodesize & (sectorsize - 1)) {
+		error("illegal nodesize %u (not aligned to %u)",
+			nodesize, sectorsize);
+		return -1;
+	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
+		   nodesize != sectorsize) {
+		error(
+		"illegal nodesize %u (not equal to %u for mixed block group)",
+			nodesize, sectorsize);
+		return -1;
+	}
+	return 0;
+}
diff --git a/utils.c b/utils.c
index b274f46fdd9d..a7e34b804551 100644
--- a/utils.c
+++ b/utils.c
@@ -2266,29 +2266,6 @@ int btrfs_tree_search2_ioctl_supported(int fd)
 	return ret;
 }
 
-int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
-{
-	if (nodesize < sectorsize) {
-		error("illegal nodesize %u (smaller than %u)",
-				nodesize, sectorsize);
-		return -1;
-	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		error("illegal nodesize %u (larger than %u)",
-			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
-		return -1;
-	} else if (nodesize & (sectorsize - 1)) {
-		error("illegal nodesize %u (not aligned to %u)",
-			nodesize, sectorsize);
-		return -1;
-	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
-		   nodesize != sectorsize) {
-		error("illegal nodesize %u (not equal to %u for mixed block group)",
-			nodesize, sectorsize);
-		return -1;
-	}
-	return 0;
-}
-
 /*
  * Copy a path argument from SRC to DEST and check the SRC length if it's at
  * most PATH_MAX and fits into DEST. DESTLEN is supposed to be exact size of
-- 
2.19.2

