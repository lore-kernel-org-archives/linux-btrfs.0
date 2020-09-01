Return-Path: <SRS0=FDMB=CK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDA6C433E2
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CCF920BED
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgIAOkn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:40:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:55606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbgIAOkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Sep 2020 10:40:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8CABBB656;
        Tue,  1 Sep 2020 14:40:03 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/5] btrfs: Re-arrange statements in setup_items_for_insert
Date:   Tue,  1 Sep 2020 17:39:57 +0300
Message-Id: <20200901144001.4265-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901144001.4265-1-nborisov@suse.com>
References: <20200901144001.4265-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Rearrange statements calculating the offset of the newly added items so
that the calculation has to be done only once. No functional change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 31e356240fce..0f325aaa5c1c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4823,8 +4823,8 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key + i);
 		btrfs_set_item_key(leaf, &disk_key, slot + i);
 		item = btrfs_item_nr(slot + i);
-		btrfs_set_token_item_offset(&token, item, data_end - data_size[i]);
 		data_end -= data_size[i];
+		btrfs_set_token_item_offset(&token, item, data_end);
 		btrfs_set_token_item_size(&token, item, data_size[i]);
 	}
 
-- 
2.17.1

