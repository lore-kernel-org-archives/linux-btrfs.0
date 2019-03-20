Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DDDC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E442184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfCTGhh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:37:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:40906 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727726AbfCTGhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:37:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7326AC93;
        Wed, 20 Mar 2019 06:37:35 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCh v2 7/9] btrfs: tree-checker: Enhance chunk checker to validate chunk profiler
Date:   Wed, 20 Mar 2019 14:37:15 +0800
Message-Id: <20190320063717.31770-8-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320063717.31770-1-wqu@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
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
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tree-checker.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 004219175f0c..fef0cd8c90a5 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -556,6 +556,13 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
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
 	"missing chunk type flag, have 0x%llx one bit must be set in 0x%llx",
-- 
2.21.0

