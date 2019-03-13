Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906AFC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 08:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FBCE2183F
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 08:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfCMIz0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:55:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:39142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727178AbfCMIzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 04:55:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4241FAF74;
        Wed, 13 Mar 2019 08:55:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
Subject: [PATCH 4/6] btrfs: tree-checker: Enhance chunk checker to validate chunk profiler
Date:   Wed, 13 Mar 2019 16:55:09 +0800
Message-Id: <20190313085511.23540-5-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313085511.23540-1-wqu@suse.com>
References: <20190313085511.23540-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btrfs-progs already has comprehensive type checker, to ensure there is
only 0 (SINGLE profile) or 1 (DUP/RAID0/1/5/6/10) bit set for chunk
profile bits.

Do the same work for kernel.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202765
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 5ccb4be583ea..c08609627720 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -551,6 +551,13 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 		return -EUCLEAN;
 	}
 
+	if (!is_power_of_2(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
+	    (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0) {
+		chunk_err(fs_info, leaf, chunk, logical,
+		"invalid chunk profile flag: 0x%llx, expect 0 or 1 bit set",
+			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EUCLEAN;
+	}
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "missing chunk type flag: 0x%llx", type);
-- 
2.21.0

