Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B707C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6752B20850
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfDAF4K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:56:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:54374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfDAF4J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 01:56:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4ADDADC8
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 05:56:08 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/7] btrfs: check/original: Check and repair free space cache inode item
Date:   Mon,  1 Apr 2019 13:55:50 +0800
Message-Id: <20190401055551.6837-7-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190401055551.6837-1-wqu@suse.com>
References: <20190401055551.6837-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just like lowmem mode, also check and repair free space cache inode
item.

And since we don't really have a good timing/function to check free
space chace inodes, we use the same common mode
check_repair_free_space_inode() when iterating root tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/check/main.c b/check/main.c
index 608fe7bb02fb..7466d5d00858 100644
--- a/check/main.c
+++ b/check/main.c
@@ -3626,6 +3626,17 @@ again:
 			   key.type == BTRFS_ROOT_BACKREF_KEY) {
 			process_root_ref(leaf, path.slots[0], &key,
 					 root_cache);
+		} else if (key.type == BTRFS_INODE_ITEM_KEY &&
+			   is_fstree(key.objectid)) {
+			ret = check_repair_free_space_inode(fs_info, &path);
+			if (ret < 0 && !path.nodes[0]) {
+				err = 1;
+				goto out;
+			}
+			if (ret < 0 && path.nodes[0]) {
+				err = 1;
+				goto next;
+			}
 		}
 next:
 		path.slots[0]++;
-- 
2.21.0

