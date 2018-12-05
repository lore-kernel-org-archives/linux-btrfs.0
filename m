Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497F7C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0814F2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0814F2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbeLEGki (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:49738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeLEGkh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59D20AEB4
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 07/13] btrfs-progs: Fix Wmaybe-uninitialized warning
Date:   Wed,  5 Dec 2018 14:40:12 +0800
Message-Id: <20181205064018.27755-8-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

GCC 8.2.1 will report the following warning with "make W=1":

  ctree.c: In function 'btrfs_next_sibling_tree_block':
  ctree.c:2990:21: warning: 'slot' may be used uninitialized in this function [-Wmaybe-uninitialized]
    path->slots[level] = slot;
    ~~~~~~~~~~~~~~~~~~~^~~~~~

The culprit is the following code:

	int slot;		<< Not initialized
	int level = path->lowest_level + 1;
 	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
 	while(level < BTRFS_MAX_LEVEL) {
		slot = path->slots[level] + 1;
		^^^^^^ but we initialize @slot here.
		...
	}
	path->slots[level] = slot;

It's possible that compiler doesn't get enough hint for BUG_ON() on
lowest_level + 1 >= BTRFS_MAX_LEVEL case.

Fix it by using a do {} while() loop other than while() {} loop, to
ensure we will run the loop for at least once.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ctree.c b/ctree.c
index 46e2ccedc0bf..867e8b60b199 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2966,7 +2966,7 @@ int btrfs_next_sibling_tree_block(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *next = NULL;
 
 	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
-	while(level < BTRFS_MAX_LEVEL) {
+	do {
 		if (!path->nodes[level])
 			return 1;
 
@@ -2986,7 +2986,7 @@ int btrfs_next_sibling_tree_block(struct btrfs_fs_info *fs_info,
 		if (!extent_buffer_uptodate(next))
 			return -EIO;
 		break;
-	}
+	} while (level < BTRFS_MAX_LEVEL);
 	path->slots[level] = slot;
 	while(1) {
 		level--;
-- 
2.19.2

