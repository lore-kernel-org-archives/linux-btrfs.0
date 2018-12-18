Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E009C43444
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269E5217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbeLRKrF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:47:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:38556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbeLRKrE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 05:47:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02294AE72;
        Tue, 18 Dec 2018 10:47:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 05/13] btrfs-progs: lowmem: check unaligned disk_bytenr for extent_data
Date:   Tue, 18 Dec 2018 18:46:38 +0800
Message-Id: <20181218104646.29599-6-wqu@suse.com>
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

Add support to check unaligned disk_bytenr for extent_data.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index b7690c6dc1f1..20663617d242 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3166,7 +3166,14 @@ static int check_extent_data_item(struct btrfs_root *root,
 	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
 	offset = btrfs_file_extent_offset(eb, fi);
 
-	/* Check unaligned disk_num_bytes and num_bytes */
+	/* Check unaligned disk_bytenr, disk_num_bytes and num_bytes */
+	if (!IS_ALIGNED(disk_bytenr, root->fs_info->sectorsize)) {
+		error(
+"file extent [%llu, %llu] has unaligned disk bytenr: %llu, should be aligned to %u",
+			fi_key.objectid, fi_key.offset, disk_bytenr,
+			root->fs_info->sectorsize);
+		err |= BYTES_UNALIGNED;
+	}
 	if (!IS_ALIGNED(disk_num_bytes, root->fs_info->sectorsize)) {
 		error(
 "file extent [%llu, %llu] has unaligned disk num bytes: %llu, should be aligned to %u",
-- 
2.20.0

