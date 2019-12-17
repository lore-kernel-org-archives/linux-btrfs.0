Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C55C43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 06:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C47206D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 06:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfLQGwq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 01:52:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:54836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfLQGwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 01:52:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26AEDAD20
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 06:52:45 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: ctree.h: Sync the comment for btrfs_file_extent_item
Date:   Tue, 17 Dec 2019 14:52:40 +0800
Message-Id: <20191217065240.5919-1-wqu@suse.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The comment about data checksum on disk_bytes is completely wrong.

Sync it with fixed kernel comment to avoid confusion.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index 3e50d086..9459adf1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -916,13 +916,16 @@ struct btrfs_file_extent_item {
 	u8 type;
 
 	/*
-	 * disk space consumed by the extent, checksum blocks are included
-	 * in these numbers
+	 * disk space consumed by the data extent
+	 * Data checksum is stored in csum tree, thus no bytenr/length takes
+	 * csum into consideration.
+	 *
+	 * At this offset in the structure, the inline extent data starts.
 	 */
 	__le64 disk_bytenr;
 	__le64 disk_num_bytes;
 	/*
-	 * the logical offset in file blocks (no csums)
+	 * the logical offset in file blocks
 	 * this extent record is for.  This allows a file extent to point
 	 * into the middle of an existing extent on disk, sharing it
 	 * between two snapshots (useful if some bytes in the middle of the
@@ -930,7 +933,8 @@ struct btrfs_file_extent_item {
 	 */
 	__le64 offset;
 	/*
-	 * the logical number of file blocks (no csums included)
+	 * the logical number of file blocks. This always reflects the size
+	 * uncompressed and without encoding.
 	 */
 	__le64 num_bytes;
 
-- 
2.24.1

