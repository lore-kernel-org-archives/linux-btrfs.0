Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5835C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADD47217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbeLRKrJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:47:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:38626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbeLRKrJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 05:47:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CFCDEAD82;
        Tue, 18 Dec 2018 10:47:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 07/13] btrfs-progs: lowmem: delete unaligned bytes extent data under repair
Date:   Tue, 18 Dec 2018 18:46:40 +0800
Message-Id: <20181218104646.29599-8-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181218104646.29599-1-wqu@suse.com>
References: <20181218104646.29599-1-wqu@suse.com>
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
index c6255334fc07..3cb3d4634e29 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3036,6 +3036,7 @@ out:
 }
 
 /*
+ * If @err contains BYTES_UNALIGNED then delete the extent data item.
  * If @err contains BACKREF_MISSING then add extent of the
  * file_extent_data_item.
  *
@@ -3087,6 +3088,13 @@ static int repair_extent_data_item(struct btrfs_root *root,
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
2.20.0

