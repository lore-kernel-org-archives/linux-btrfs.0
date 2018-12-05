Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3630CC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB182082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEB182082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbeLEGke (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:49724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeLEGke (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD764AEB4
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:32 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 05/13] btrfs-progs: Fix Wimplicit-fallthrough warning
Date:   Wed,  5 Dec 2018 14:40:10 +0800
Message-Id: <20181205064018.27755-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although most fallthrough case is pretty obvious, we still need to teach
the dumb compiler that it's an explicit fallthrough.

Also reformat the code to use common indent.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 utils.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/utils.c b/utils.c
index a310300829eb..b274f46fdd9d 100644
--- a/utils.c
+++ b/utils.c
@@ -1134,15 +1134,25 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mod
 	num_divs = 0;
 	last_size = size;
 	switch (unit_mode & UNITS_MODE_MASK) {
-	case UNITS_TBYTES: base *= mult; num_divs++;
-	case UNITS_GBYTES: base *= mult; num_divs++;
-	case UNITS_MBYTES: base *= mult; num_divs++;
-	case UNITS_KBYTES: num_divs++;
-			   break;
+	case UNITS_TBYTES:
+		base *= mult;
+		num_divs++;
+		__attribute__ ((fallthrough));
+	case UNITS_GBYTES:
+		base *= mult;
+		num_divs++;
+		__attribute__ ((fallthrough));
+	case UNITS_MBYTES:
+		base *= mult;
+		num_divs++;
+		__attribute__ ((fallthrough));
+	case UNITS_KBYTES:
+		num_divs++;
+		break;
 	case UNITS_BYTES:
-			   base = 1;
-			   num_divs = 0;
-			   break;
+		base = 1;
+		num_divs = 0;
+		break;
 	default:
 		if (negative) {
 			s64 ssize = (s64)size;
@@ -1907,13 +1917,17 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	default:
 	case 4:
 		allowed |= BTRFS_BLOCK_GROUP_RAID10;
+		__attribute__ ((fallthrough));
 	case 3:
 		allowed |= BTRFS_BLOCK_GROUP_RAID6;
+		__attribute__ ((fallthrough));
 	case 2:
 		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
 			BTRFS_BLOCK_GROUP_RAID5;
+		__attribute__ ((fallthrough));
 	case 1:
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
+		__attribute__ ((fallthrough));
 	}
 
 	if (dev_cnt > 1 && profile & BTRFS_BLOCK_GROUP_DUP) {
-- 
2.19.2

