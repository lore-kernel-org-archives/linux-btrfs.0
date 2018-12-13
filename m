Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FEAC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D7B820851
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544735811;
	bh=nLgYKe0mxM+7leaWOp77dt2fMSBjBORgDYMe6PEwuL0=;
	h=From:To:Subject:Date:List-ID:From;
	b=COVcb/WYkVk0hjpO8VpDItzVZMNJ86oozc+vs5EIZtXi9xfp9JYuIQMh4vUFqaE0v
	 4qlV8eDydKL8r2/fcDrw8mWk8PwIdfuB7MSQhktvPeoX7pX2A+PYTR6SWVqwZO+9fs
	 YlYfyJqocfxZUq5MmszAo654Yu4Bg5DpoqR6B6mA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D7B820851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbeLMVQu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbeLMVQu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 16:16:50 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29EF820851
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544735809;
        bh=nLgYKe0mxM+7leaWOp77dt2fMSBjBORgDYMe6PEwuL0=;
        h=From:To:Subject:Date:From;
        b=iM7Xd+e3eM5IfQADGBzWCK3isnrTFYTAjpphdNoyIhWrmJbdfiVnwdjIsiWx78iIU
         nayWA8CQrJ6ESTUGOH2KQPYTy43Q9ccNkoIedHSAlqYjDufWTN4ROp8PvH6cvCigYH
         gNStaWU4LzUMpVa0S4r3crszMIyM/ZfP9SlngCHo=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: setup a nofs context for memory allocation at btrfs_create_tree()
Date:   Thu, 13 Dec 2018 21:16:45 +0000
Message-Id: <20181213211645.14713-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We are holding a transaction handle when creating a tree, therefore we can
not allocate the root using GFP_KERNEL, as we could deadlock if reclaim is
triggered by the allocation, therefore setup a nofs context.

Fixes: 74e4d82757f74 ("btrfs: let callers of btrfs_alloc_root pass gfp flags")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 67afeaf28a41..3e1b846156dd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -17,6 +17,7 @@
 #include <linux/semaphore.h>
 #include <linux/error-injection.h>
 #include <linux/crc32c.h>
+#include <linux/sched/mm.h>
 #include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -1235,10 +1236,17 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *root;
 	struct btrfs_key key;
+	unsigned int nofs_flag;
 	int ret = 0;
 	uuid_le uuid = NULL_UUID_LE;
 
+	/*
+	 * We're holding a transaction handle, so use a NOFS memory allocation
+	 * context to avoid deadlock if reclaim happens.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	root = btrfs_alloc_root(fs_info, GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.11.0

