Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BE1C10F11
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 00:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6E7F208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 00:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfDYA4B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 20:56:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:48138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726455AbfDYA4A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 20:56:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84C3DADD8
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 00:55:59 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Filip Manana <fdmanana@suse.com>
Subject: [PATCH v3] btrfs: ctree: Dump the leaf before BUG_ON()
Date:   Thu, 25 Apr 2019 08:55:53 +0800
Message-Id: <20190425005553.3126-1-wqu@suse.com>
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

Reviewed-by: Filip Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Dump slot/old key/new key.
v3:
- Output message update, to avoid "on-disk" wording.
- Use BUG() to replace BUG_ON(1) to make clang quite.

 fs/btrfs/ctree.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5116c2a1f0f9..5df76c17775a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3185,11 +3185,31 @@ void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 	slot = path->slots[0];
 	if (slot > 0) {
 		btrfs_item_key(eb, &disk_key, slot - 1);
-		BUG_ON(comp_keys(&disk_key, new_key) >= 0);
+		if (unlikely(comp_keys(&disk_key, new_key) >= 0)) {
+			btrfs_crit(fs_info,
+		"slot %u key (%llu %u %llu) new key (%llu %u %llu)",
+				   slot, btrfs_disk_key_objectid(&disk_key),
+				   btrfs_disk_key_type(&disk_key),
+				   btrfs_disk_key_offset(&disk_key),
+				   new_key->objectid, new_key->type,
+				   new_key->offset);
+			btrfs_print_leaf(eb);
+			BUG();
+		}
 	}
 	if (slot < btrfs_header_nritems(eb) - 1) {
 		btrfs_item_key(eb, &disk_key, slot + 1);
-		BUG_ON(comp_keys(&disk_key, new_key) <= 0);
+		if (unlikely(comp_keys(&disk_key, new_key) <= 0)) {
+			btrfs_crit(fs_info,
+		"slot %u key (%llu %u %llu) new key (%llu %u %llu)",
+				   slot, btrfs_disk_key_objectid(&disk_key),
+				   btrfs_disk_key_type(&disk_key),
+				   btrfs_disk_key_offset(&disk_key),
+				   new_key->objectid, new_key->type,
+				   new_key->offset);
+			btrfs_print_leaf(eb);
+			BUG();
+		}
 	}
 
 	btrfs_cpu_key_to_disk(&disk_key, new_key);
-- 
2.21.0

