Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22919C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F174B21852
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfB0GG3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 01:06:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:34058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbfB0GG2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 01:06:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 90965AC5F;
        Wed, 27 Feb 2019 06:06:27 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v1.1 07/14] btrfs-progs: lowmem: delete unaligned bytes extent data under repair
Date:   Wed, 27 Feb 2019 14:05:45 +0800
Message-Id: <20190227060552.3841-8-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190227060552.3841-1-wqu@suse.com>
References: <20190227060552.3841-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

If found a extent data item has unaligned part, lowmem repair
just deletes it.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 7bd18902e106..bedf18628cc9 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3037,6 +3037,7 @@ out:
 }
 
 /*
+ * If @err contains BYTES_UNALIGNED then delete the extent data item.
  * If @err contains BACKREF_MISSING then add extent of the
  * file_extent_data_item.
  *
@@ -3088,6 +3089,13 @@ static int repair_extent_data_item(struct btrfs_root *root,
 	else
 		parent = 0;
 
+	if (err & BYTES_UNALIGNED) {
+		ret = delete_item(root, pathp);
+		if (!ret)
+			err = 0;
+		goto out;
+	}
+
 	/* now repair only adds backref */
 	if ((err & BACKREF_MISSING) == 0)
 		return err;
-- 
2.21.0

