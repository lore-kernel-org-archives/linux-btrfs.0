Return-Path: <SRS0=DXmw=ZV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C93C432C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Nov 2019 15:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36DD5216F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Nov 2019 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575040454;
	bh=BSeT0Zfz8UG1BNQzR+6kypNIoeZcvoHQP27poZ45Ijk=;
	h=From:To:Subject:Date:List-ID:From;
	b=l6j0/xe9wjfGSmISpnOvaweBwRSWu9fZt5HsA0B8H3oB8J3O6s9dKySI2icxNSZRB
	 xPA68MRVDtP1xhRCRuj/uVscYQBcTSVxFjarzDX7pUlyRa20U3HEbKTVpPllMK8D0J
	 w2Fv/R5axkW1OCXL9e6wz18ISapCU5avm5uJFHnE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfK2PON (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Nov 2019 10:14:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfK2PON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Nov 2019 10:14:13 -0500
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37BC2216F4
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Nov 2019 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575040452;
        bh=BSeT0Zfz8UG1BNQzR+6kypNIoeZcvoHQP27poZ45Ijk=;
        h=From:To:Subject:Date:From;
        b=2Qe1z+Qc18TE92tUJdPjp0wzS0C2y5kn5xRu5rpOVAkXLEsiRHAHXG/E2Y46J47qh
         I8LPf+wsHGAJVhpL9ChpcRGu4Hu5OE58GmmHPLyYMwgGrHeaCuoH1QCUS1lBRrahs+
         zX115aBT7GXO//YmKmhH7xw+C9v4rsTwn9A/s1w4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: make tree checker detect checksum items with overlapping ranges
Date:   Fri, 29 Nov 2019 15:14:10 +0000
Message-Id: <20191129151410.32219-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Having checksum items, either on the checksums tree or in a log tree, that
represent ranges that overlap each other is a sign of a corruption. Such
case confuses the checksum lookup code and can result in not being able to
find checksums or find stale checksums.

So add a check for such case.

This is motivated by a recent fix for a case where a log tree had checksum
items covering ranges that overlap each other due to extent cloning, and
resulted in missing checksums after replaying the log tree. It also helps
detect past issues such as stale and outdated checksums due to overlapping,
commit 27b9a8122ff71a ("Btrfs: fix csum tree corruption, duplicate and
outdated checksums").

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 092b8ece36d7..97f3520b8d98 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -332,7 +332,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 }
 
 static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
-			   int slot)
+			   int slot, struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	u32 sectorsize = fs_info->sectorsize;
@@ -356,6 +356,20 @@ static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
 			btrfs_item_size_nr(leaf, slot), csumsize);
 		return -EUCLEAN;
 	}
+	if (slot > 0 && prev_key->type == BTRFS_EXTENT_CSUM_KEY) {
+		u64 prev_csum_end;
+		u32 prev_item_size;
+
+		prev_item_size = btrfs_item_size_nr(leaf, slot - 1);
+		prev_csum_end = (prev_item_size / csumsize) * sectorsize;
+		prev_csum_end += prev_key->offset;
+		if (prev_csum_end > key->offset) {
+			generic_err(leaf, slot - 1,
+"csum end range (%llu) goes beyond the start range (%llu) of the next csum item",
+				    prev_csum_end, key->offset);
+			return -EUCLEAN;
+		}
+	}
 	return 0;
 }
 
@@ -1355,7 +1369,7 @@ static int check_leaf_item(struct extent_buffer *leaf,
 		ret = check_extent_data_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-		ret = check_csum_item(leaf, key, slot);
+		ret = check_csum_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_DIR_ITEM_KEY:
 	case BTRFS_DIR_INDEX_KEY:
-- 
2.11.0

