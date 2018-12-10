Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFAFC04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9B3720851
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544464422;
	bh=vcicIBc3HiHzA826flgOczyIC9ytk5THa7LBdAvBNto=;
	h=From:To:Subject:Date:List-ID:From;
	b=PMWtZcYYxHEFC1ABb3DEyUZW03J5bG2QKhkObcmF4D0jtVfwqwoktUUAmJf4qXhEJ
	 tF6CtRe+iaNfgepCwQ59rhxrsFPXK3DaG+lqJYiPyXXEvVHyni9k7ZxcXciO/ibAZB
	 xuu5c/fipokBe9PX/SALEhagZ02YtQZ/P88nCCHk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9B3720851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbeLJRxj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbeLJRxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 12:53:39 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A39520851
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544464418;
        bh=vcicIBc3HiHzA826flgOczyIC9ytk5THa7LBdAvBNto=;
        h=From:To:Subject:Date:From;
        b=BNtB4vDQgY7fPzQO4bOYWZJFfLDdq2KIyHUHY7puYKugozOkw0OHKtztqeLVT/cG7
         kayncn8g9mvHjZEpP6tFEgpKu1gdJCQFWcu7/UjjQbFx8+8eigjJBjtNYbJ2grdLLh
         SeQAwmCdTx9Yd7QYPuLRDdND7hjf2SrXE2fSEL/0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use nofs context when initializing security xattrs to avoid deadlock
Date:   Mon, 10 Dec 2018 17:53:35 +0000
Message-Id: <20181210175335.15906-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When initializing the security xattrs, we are holding a transaction handle
therefore we need to use a GFP_NOFS context in order to avoid a deadlock
with reclaim in case it's triggered.

Fixes: 39a27ec1004e8 ("btrfs: use GFP_KERNEL for xattr and acl allocations")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index ea78c3d6dcfc..f141b45ce349 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -11,6 +11,7 @@
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/iversion.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
@@ -422,9 +423,15 @@ static int btrfs_initxattrs(struct inode *inode,
 {
 	const struct xattr *xattr;
 	struct btrfs_trans_handle *trans = fs_info;
+	unsigned int nofs_flag;
 	char *name;
 	int err = 0;
 
+	/*
+	 * We're holding a transaction handle, so use a NOFS memory allocation
+	 * context to avoid deadlock if reclaim happens.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
 			       strlen(xattr->name) + 1, GFP_KERNEL);
@@ -440,6 +447,7 @@ static int btrfs_initxattrs(struct inode *inode,
 		if (err < 0)
 			break;
 	}
+	memalloc_nofs_restore(nofs_flag);
 	return err;
 }
 
-- 
2.11.0

