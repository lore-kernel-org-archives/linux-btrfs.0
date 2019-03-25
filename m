Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659A0C10F03
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 396E620700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbfCYSp3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:38996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730298AbfCYSp3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 057EAAF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6710EDA98F; Mon, 25 Mar 2019 19:46:41 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 12/30] btrfs: get fs_info from eb in btrfs_verify_level_key
Date:   Mon, 25 Mar 2019 19:46:41 +0100
Message-Id: <678d2d1704502200423419789d1fd5334995cf72.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/ctree.c   | 2 +-
 fs/btrfs/disk-io.c | 6 +++---
 fs/btrfs/disk-io.h | 3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3e26254fefe8..0998e7fba98b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2420,7 +2420,7 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 			 * being cached, read from scrub, or have multiple
 			 * parents (shared tree blocks).
 			 */
-			if (btrfs_verify_level_key(fs_info, tmp,
+			if (btrfs_verify_level_key(tmp,
 					parent_level - 1, &first_key, gen)) {
 				free_extent_buffer(tmp);
 				return -EUCLEAN;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3b8114ad7b8c..496b00a78a24 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -394,10 +394,10 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *eb, int level,
+int btrfs_verify_level_key(struct extent_buffer *eb, int level,
 			   struct btrfs_key *first_key, u64 parent_transid)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int found_level;
 	struct btrfs_key found_key;
 	int ret;
@@ -471,7 +471,7 @@ static int btree_read_extent_buffer_pages(struct extent_buffer *eb,
 			if (verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
 				ret = -EIO;
-			else if (btrfs_verify_level_key(fs_info, eb, level,
+			else if (btrfs_verify_level_key(eb, level,
 						first_key, parent_transid))
 				ret = -EUCLEAN;
 			else
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 917634f2bae9..a32158f0c2fc 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -39,8 +39,7 @@ static inline u64 btrfs_sb_offset(int mirror)
 struct btrfs_device;
 struct btrfs_fs_devices;
 
-int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *eb, int level,
+int btrfs_verify_level_key(struct extent_buffer *eb, int level,
 			   struct btrfs_key *first_key, u64 parent_transid);
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 				      u64 parent_transid, int level,
-- 
2.21.0

