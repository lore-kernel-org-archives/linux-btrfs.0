Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA16C4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C315C20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbfCYSqI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:46:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:39226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729478AbfCYSqG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:46:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 638DFAFBD
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:46:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA4F0DA98F; Mon, 25 Mar 2019 19:47:18 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 28/30] btrfs: get fs_info from eb in read_one_chunk
Date:   Mon, 25 Mar 2019 19:47:18 +0100
Message-Id: <38ee8533980fd0abda53ccbf771b3bd1cdc266ef.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/volumes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 12077c32523f..de65029b8ad2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6817,10 +6817,10 @@ static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
 			      devid, uuid);
 }
 
-static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
-			  struct extent_buffer *leaf,
+static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
 {
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct extent_map *em;
@@ -7192,7 +7192,7 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 			if (cur_offset + len > array_size)
 				goto out_short_read;
 
-			ret = read_one_chunk(fs_info, &key, sb, chunk);
+			ret = read_one_chunk(&key, sb, chunk);
 			if (ret)
 				break;
 		} else {
@@ -7340,7 +7340,7 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
-			ret = read_one_chunk(fs_info, &found_key, leaf, chunk);
+			ret = read_one_chunk(&found_key, leaf, chunk);
 			if (ret)
 				goto error;
 		}
-- 
2.21.0

