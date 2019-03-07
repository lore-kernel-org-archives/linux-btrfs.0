Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB3AC4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAB1120851
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfCGLbn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:31:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:50524 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbfCGLbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 06:31:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 347C76A147
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2019 11:31:42 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs-progs: Use mirror_num start from 1 to avoid unnecessary retry
Date:   Thu,  7 Mar 2019 19:31:31 +0800
Message-Id: <20190307113133.27003-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190307113133.27003-1-wqu@suse.com>
References: <20190307113133.27003-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
If the first copy of a tree block is corrupted but the other copy is
good, btrfs-progs will report the error twice:
  checksum verify failed on 30556160 found 42A2DA71 wanted 00000000
  checksum verify failed on 30556160 found 42A2DA71 wanted 00000000

While kernel only report it once, just as expected:
  BTRFS warning (device dm-3): dm-3 checksum verify failed on 30556160 wanted 0 found 42A2DA71 level 0

[CAUSE]
We use mirror_num = 0 in read_tree_block() of btrfs-progs.

At first glance it's pretty OK, but mirror num 0 in btrfs means ANY
good copy. Real mirror num starts from 1.
In the context of read_tree_block(), since it's read_tree_block() to do
all the checks, mirror num 0 just means the first copy.

So if the first copy is corrupted, btrfs-progs will try mirror num 1
next, which is just the same as mirror num 0.
After reporting the same error on the same copy, btrfs-progs will
finally try mirror num 2, and get the good copy.

[FIX]
The fix is way simpler than all the above analyse, just starts from
mirror num 1.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 797b9b79ea3c..369592eb7b5c 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -325,7 +325,7 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 	struct extent_buffer *eb;
 	u64 best_transid = 0;
 	u32 sectorsize = fs_info->sectorsize;
-	int mirror_num = 0;
+	int mirror_num = 1;
 	int good_mirror = 0;
 	int num_copies;
 	int ignore = 0;
@@ -381,7 +381,7 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 			ignore = 1;
 			continue;
 		}
-		if (btrfs_header_generation(eb) > best_transid && mirror_num) {
+		if (btrfs_header_generation(eb) > best_transid) {
 			best_transid = btrfs_header_generation(eb);
 			good_mirror = mirror_num;
 		}
-- 
2.21.0

