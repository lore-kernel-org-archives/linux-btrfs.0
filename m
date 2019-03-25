Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CA1C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEA4520700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbfCYSqE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:46:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:39200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729478AbfCYSqE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:46:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EEEB0AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:46:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 60B73DA98F; Mon, 25 Mar 2019 19:47:16 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 27/30] btrfs: get fs_info from eb in btrfs_check_chunk_valid
Date:   Mon, 25 Mar 2019 19:47:16 +0100
Message-Id: <b794e5d58c0b549703a99400160714b2a7ecc54c.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index eaa9c38e848b..12077c32523f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6714,10 +6714,10 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 }
 
 /* Return -EIO if any error, otherwise return 0. */
-static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
-				   struct extent_buffer *leaf,
+static int btrfs_check_chunk_valid(struct extent_buffer *leaf,
 				   struct btrfs_chunk *chunk, u64 logical)
 {
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	u64 length;
 	u64 stripe_len;
 	u16 num_stripes;
@@ -6836,7 +6836,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	length = btrfs_chunk_length(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 
-	ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
+	ret = btrfs_check_chunk_valid(leaf, chunk, logical);
 	if (ret)
 		return ret;
 
-- 
2.21.0

