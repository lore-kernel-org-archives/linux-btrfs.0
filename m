Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6D1C31E5D
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 14:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01DA820679
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 14:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbfFSOEo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:04:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:42874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729304AbfFSOEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jun 2019 10:04:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF17BAD05
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2019 14:04:42 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/4] btrfs-progs: Remove redundant if
Date:   Wed, 19 Jun 2019 17:04:37 +0300
Message-Id: <20190619140440.5550-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190619140440.5550-1-nborisov@suse.com>
References: <20190619140440.5550-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

'pin' is always true in __free_extent so there is no point in checking
it. Just remove the if and unindent the code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index c6516b2ba445..7693313c50b3 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2074,7 +2074,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		}
 	} else {
 		int mark_free = 0;
-		int pin = 1;
 
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
@@ -2088,13 +2087,11 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			}
 		}
 
-		if (pin) {
-			ret = pin_down_bytes(trans, bytenr, num_bytes,
-					     is_data);
-			if (ret > 0)
-				mark_free = 1;
-			BUG_ON(ret < 0);
-		}
+		ret = pin_down_bytes(trans, bytenr, num_bytes,
+				     is_data);
+		if (ret > 0)
+			mark_free = 1;
+		BUG_ON(ret < 0);
 
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
-- 
2.17.1

