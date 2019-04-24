Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07835C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 14:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEC022089F
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 14:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfDXObl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 10:31:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:46970 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfDXObl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 10:31:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7DCDFAE4B
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 14:31:40 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: ctree: Dump the leaf before BUG_ON()
Date:   Wed, 24 Apr 2019 22:31:34 +0800
Message-Id: <20190424143134.32699-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have a user reporting BUG_ON() triggered in
btrfs_set_item_key_safe().

Let's dump the leaf content before triggering BUG_ON() so that we can
have some clue on what's going wrong.
The output of tree locks should help us to debug such problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
- Also dump the slot/disk_key/new_key.
---
 fs/btrfs/ctree.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f52eb952597b..61e6e2a23a8a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3185,11 +3185,31 @@ void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 	slot = path->slots[0];
 	if (slot > 0) {
 		btrfs_item_key(eb, &disk_key, slot - 1);
-		BUG_ON(comp_keys(&disk_key, new_key) >= 0);
+		if (unlikely(comp_keys(&disk_key, new_key) >= 0)) {
+			btrfs_crit(fs_info,
+		"on-disk slot %u key (%llu, %u, %llu) new key (%llu %u %llu)",
+				   slot, btrfs_disk_key_objectid(&disk_key),
+				   btrfs_disk_key_type(&disk_key),
+				   btrfs_disk_key_offset(&disk_key),
+				   new_key->objectid, new_key->type,
+				   new_key->offset);
+			btrfs_print_leaf(eb);
+			BUG_ON(1);
+		}
 	}
 	if (slot < btrfs_header_nritems(eb) - 1) {
 		btrfs_item_key(eb, &disk_key, slot + 1);
-		BUG_ON(comp_keys(&disk_key, new_key) <= 0);
+		if (unlikely(comp_keys(&disk_key, new_key) <= 0)) {
+			btrfs_crit(fs_info,
+		"on-disk slot %u key (%llu, %u, %llu) new key (%llu %u %llu)",
+				   slot, btrfs_disk_key_objectid(&disk_key),
+				   btrfs_disk_key_type(&disk_key),
+				   btrfs_disk_key_offset(&disk_key),
+				   new_key->objectid, new_key->type,
+				   new_key->offset);
+			btrfs_print_leaf(eb);
+			BUG_ON(1);
+		}
 	}
 
 	btrfs_cpu_key_to_disk(&disk_key, new_key);
-- 
2.21.0

