Return-Path: <SRS0=dUzf=XF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF24CC49ED6
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 07:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C71A221479
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 07:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbfIJHk1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 03:40:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:36526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729189AbfIJHk1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Sep 2019 03:40:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6BF7B011
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2019 07:40:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: ctree: Reduce one indent level for btrfs_search_old_slot()
Date:   Tue, 10 Sep 2019 15:40:18 +0800
Message-Id: <20190910074019.23158-3-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190910074019.23158-1-wqu@suse.com>
References: <20190910074019.23158-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Pretty much the same refactor for btrfs_search_slot().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c | 68 +++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1e29183cdf62..3be8b32c0d37 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2983,6 +2983,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	p->locks[level] = BTRFS_READ_LOCK;
 
 	while (b) {
+		int dec = 0;
 		level = btrfs_header_level(b);
 		p->nodes[level] = b;
 
@@ -3003,48 +3004,45 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 		if (ret < 0)
 			goto done;
 
-		if (level != 0) {
-			int dec = 0;
-			if (ret && slot > 0) {
-				dec = 1;
-				slot -= 1;
-			}
+		if (level == 0) {
 			p->slots[level] = slot;
 			unlock_up(p, level, lowest_unlock, 0, NULL);
+			goto done;
+		}
+		if (ret && slot > 0) {
+			dec = 1;
+			slot -= 1;
+		}
+		p->slots[level] = slot;
+		unlock_up(p, level, lowest_unlock, 0, NULL);
 
-			if (level == lowest_level) {
-				if (dec)
-					p->slots[level]++;
-				goto done;
-			}
+		if (level == lowest_level) {
+			if (dec)
+				p->slots[level]++;
+			goto done;
+		}
 
-			err = read_block_for_search(root, p, &b, level,
-						    slot, key);
-			if (err == -EAGAIN)
-				goto again;
-			if (err) {
-				ret = err;
-				goto done;
-			}
+		err = read_block_for_search(root, p, &b, level, slot, key);
+		if (err == -EAGAIN)
+			goto again;
+		if (err) {
+			ret = err;
+			goto done;
+		}
 
-			level = btrfs_header_level(b);
-			err = btrfs_tree_read_lock_atomic(b);
-			if (!err) {
-				btrfs_set_path_blocking(p);
-				btrfs_tree_read_lock(b);
-			}
-			b = tree_mod_log_rewind(fs_info, p, b, time_seq);
-			if (!b) {
-				ret = -ENOMEM;
-				goto done;
-			}
-			p->locks[level] = BTRFS_READ_LOCK;
-			p->nodes[level] = b;
-		} else {
-			p->slots[level] = slot;
-			unlock_up(p, level, lowest_unlock, 0, NULL);
+		level = btrfs_header_level(b);
+		err = btrfs_tree_read_lock_atomic(b);
+		if (!err) {
+			btrfs_set_path_blocking(p);
+			btrfs_tree_read_lock(b);
+		}
+		b = tree_mod_log_rewind(fs_info, p, b, time_seq);
+		if (!b) {
+			ret = -ENOMEM;
 			goto done;
 		}
+		p->locks[level] = BTRFS_READ_LOCK;
+		p->nodes[level] = b;
 	}
 	ret = 1;
 done:
-- 
2.23.0

