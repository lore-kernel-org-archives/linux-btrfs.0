Return-Path: <SRS0=l4CM=5L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89997C43331
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Mar 2020 08:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6A920719
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Mar 2020 08:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgCZIeV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 04:34:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:49858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgCZIeV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Mar 2020 04:34:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 19C51AC46
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2020 08:34:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 28/39] btrfs: relocation: Open-code read_fs_root() for handle_indirect_tree_backref()
Date:   Thu, 26 Mar 2020 16:33:05 +0800
Message-Id: <20200326083316.48847-29-wqu@suse.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200326083316.48847-1-wqu@suse.com>
References: <20200326083316.48847-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The backref code is going to be moved to backref.c, and read_fs_root()
is just a simple wrapper, open-code it to prepare to the incoming code
move.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 23ed17cd54c4..c44a797b3b25 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -474,12 +474,16 @@ static int handle_indirect_tree_backref(struct btrfs_backref_cache *cache,
 	struct btrfs_backref_edge *edge;
 	struct extent_buffer *eb;
 	struct btrfs_root *root;
+	struct btrfs_key root_key;
 	struct rb_node *rb_node;
 	int level;
 	bool need_check = true;
 	int ret;
 
-	root = read_fs_root(fs_info, ref_key->offset);
+	root_key.objectid = ref_key->offset;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+	root = btrfs_get_fs_root(fs_info, &root_key, false);
 	if (IS_ERR(root))
 		return PTR_ERR(root);
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
-- 
2.26.0

