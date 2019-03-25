Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9262EC4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65BF520700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbfCYSqD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:46:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:39176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729478AbfCYSqB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:46:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9CF14AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:46:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11B5BDA98F; Mon, 25 Mar 2019 19:47:14 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 26/30] btrfs: get fs_info from eb in should_balance_chunk
Date:   Mon, 25 Mar 2019 19:47:13 +0100
Message-Id: <e53de94a112f1b5150e261d83197bbdfb2350a7c.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fcb0d3f34e09..eaa9c38e848b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3601,10 +3601,10 @@ static int chunk_soft_convert_filter(u64 chunk_type,
 	return 0;
 }
 
-static int should_balance_chunk(struct btrfs_fs_info *fs_info,
-				struct extent_buffer *leaf,
+static int should_balance_chunk(struct extent_buffer *leaf,
 				struct btrfs_chunk *chunk, u64 chunk_offset)
 {
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
 	struct btrfs_balance_args *bargs = NULL;
 	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
@@ -3784,8 +3784,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 			spin_unlock(&fs_info->balance_lock);
 		}
 
-		ret = should_balance_chunk(fs_info, leaf, chunk,
-					   found_key.offset);
+		ret = should_balance_chunk(leaf, chunk, found_key.offset);
 
 		btrfs_release_path(path);
 		if (!ret) {
-- 
2.21.0

