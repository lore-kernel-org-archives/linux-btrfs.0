Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A92C64EB8
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 07:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07DF420878
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 07:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07DF420878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbeJHOKq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 10:10:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:35648 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726445AbeJHOKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 10:10:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19531AEBA
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 07:00:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs-progs: lowmem check: Add check for overlapping dev extents
Date:   Mon,  8 Oct 2018 15:00:21 +0800
Message-Id: <20181008070025.27035-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008070025.27035-1-wqu@suse.com>
References: <20181008070025.27035-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add such check at check_dev_item(), since at that timing we're also
iterating dev extents for dev item accounting.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1bce44f5658a..d387423639e6 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4065,6 +4065,8 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 	u64 dev_id;
 	u64 used;
 	u64 total = 0;
+	u64 prev_devid = 0;
+	u64 prev_dev_ext_end = 0;
 	int ret;
 
 	dev_item = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
@@ -4086,8 +4088,16 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 		return REFERENCER_MISSING;
 	}
 
-	/* Iterate dev_extents to calculate the used space of a device */
+	/*
+	 * Iterate dev_extents to calculate the used space of a device
+	 *
+	 * Also make sure no dev extents overlap and end beyond device boundary
+	 */
 	while (1) {
+		u64 devid;
+		u64 physical_offset;
+		u64 physical_len;
+
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0]))
 			goto next;
 
@@ -4099,7 +4109,25 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 
 		ptr = btrfs_item_ptr(path.nodes[0], path.slots[0],
 				     struct btrfs_dev_extent);
-		total += btrfs_dev_extent_length(path.nodes[0], ptr);
+		devid = key.objectid;
+		physical_offset = key.offset;
+		physical_len = btrfs_dev_extent_length(path.nodes[0], ptr);
+
+		if (prev_devid == devid && physical_offset < prev_dev_ext_end) {
+			error(
+"dev extent devid %llu offset %llu len %llu overlap with previous dev extent end %llu",
+			      devid, physical_offset, physical_len,
+			      prev_dev_ext_end);
+			return ACCOUNTING_MISMATCH;
+		}
+		if (physical_offset + physical_len > total_bytes) {
+			error(
+"dev extent devid %llu offset %llu len %llu is beyond device boundary %llu",
+			      devid, physical_offset, physical_len,
+			      total_bytes);
+			return ACCOUNTING_MISMATCH;
+		}
+		total += physical_len;
 next:
 		ret = btrfs_next_item(dev_root, &path);
 		if (ret)
-- 
2.19.0

