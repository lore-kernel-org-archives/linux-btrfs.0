Return-Path: <SRS0=fvYO=T3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1681C07542
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 May 2019 04:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B38E2070D
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 May 2019 04:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfE0EWM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 May 2019 00:22:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:54012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbfE0EWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 May 2019 00:22:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7EBBAC2D
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2019 04:22:10 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Output extent tree leaf if we failed to find a backref
Date:   Mon, 27 May 2019 12:22:04 +0800
Message-Id: <20190527042204.27666-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a bug report of BUG_ON() which is caused by __free_extent()
failed to lookup a backref extent:
  Failed to find [1429288337408, 168, 16384]
  btrfs unable to find ref byte nr 1429288583168 parent 0 root 2 owner 0 offset 0
  convert/source-ext2.c:834: ext2_copy_inodes: BUG_ON ret triggered, value -5
  ./btrfs-convert[0x410941]
  ./btrfs-convert(main+0x1fdc)[0x40d3b8]
  /lib64/libc.so.6(__libc_start_main+0xf3)[0x7f93bb7d2f33]
  ./btrfs-convert(_start+0x2e)[0x40a96e]

It's still uncertain how this bug can be triggered, but adding such
debug output will provide more info for us to debug.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index 1cff617baa97..db69c538bf2f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2177,6 +2177,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		       (unsigned long long)root_objectid,
 		       (unsigned long long)owner_objectid,
 		       (unsigned long long)owner_offset);
+		printf("path->slots[0]: %u path->nodes[0]:\n", path->slots[0]);
+		btrfs_print_leaf(path->nodes[0]);
 		ret = -EIO;
 		goto fail;
 	}
-- 
2.21.0

