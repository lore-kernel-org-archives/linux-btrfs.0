Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA0AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F1A20851
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfCGLbq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:31:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:50562 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbfCGLbq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 06:31:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 378EE6A1B5
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2019 11:31:45 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: Move btrfs_num_copies() call out of the loop in read_tree_block()
Date:   Thu,  7 Mar 2019 19:31:32 +0800
Message-Id: <20190307113133.27003-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190307113133.27003-1-wqu@suse.com>
References: <20190307113133.27003-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_num_copies really only needs to be called once, so move it out of
the verification loop in read_tree_block().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 369592eb7b5c..1736d4a1f94b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -349,6 +349,7 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 	if (btrfs_buffer_uptodate(eb, parent_transid))
 		return eb;
 
+	num_copies = btrfs_num_copies(fs_info, eb->start, eb->len);
 	while (1) {
 		ret = read_whole_eb(fs_info, eb, mirror_num);
 		if (ret == 0 && csum_tree_block(fs_info, eb, 1) == 0 &&
@@ -376,7 +377,6 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 			ret = -EIO;
 			break;
 		}
-		num_copies = btrfs_num_copies(fs_info, eb->start, eb->len);
 		if (num_copies == 1) {
 			ignore = 1;
 			continue;
-- 
2.21.0

