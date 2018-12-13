Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD824C67839
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 683FA20851
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544735821;
	bh=MXeeRqCZzC+lgnHrmk8GnxeCTM2xzw1L09NYuUFhudQ=;
	h=From:To:Subject:Date:List-ID:From;
	b=djOoMywSEwC7CofhRdaKorVVSX/rUEqGH3R5hZeEY5l0Lrra2Ful/XrVYobf5TLvr
	 3TA7aWiXyEkG0CAUqos0SZeUSTLrRlDY3+30cVmVTteEuRsveu6bLCnqpJS/X74ytZ
	 hrKBjty5y+iFfzdaiNNn8tfZh3pa7W+th3guyxCQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 683FA20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbeLMVRA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbeLMVRA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 16:17:00 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2086520851
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 21:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544735819;
        bh=MXeeRqCZzC+lgnHrmk8GnxeCTM2xzw1L09NYuUFhudQ=;
        h=From:To:Subject:Date:From;
        b=p0vTpF8TsWBDyGqGkhL3uSkcDuL+YmqzQybetJQ0al70TSuL2TckzYwjVQbYabami
         auMT6EhdQqIcADwpEQOoM+plvMO3Jq6WYm1+qVYOtLy44knxTEV1DAoSTc0wdVKXh/
         KVHEMhM5H0vB73WaeBjgRbjx3BgEawCPlygU6i2Q=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: setup a nofs context for memory allocation at __btrfs_set_acl
Date:   Thu, 13 Dec 2018 21:16:56 +0000
Message-Id: <20181213211656.14765-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We are holding a transaction handle when setting an acl, therefore we can
not allocate the xattr value buffer using GFP_KERNEL, as we could deadlock
if reclaim is triggered by the allocation, therefore setup a nofs context.

Fixes: 39a27ec1004e8 ("btrfs: use GFP_KERNEL for xattr and acl allocations")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/acl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 3b66c957ea6f..5810463dc6d2 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -9,6 +9,7 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/slab.h>
 
 #include "ctree.h"
@@ -72,8 +73,16 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 	}
 
 	if (acl) {
+		unsigned int nofs_flag;
+
 		size = posix_acl_xattr_size(acl->a_count);
+		/*
+		 * We're holding a transaction handle, so use a NOFS memory
+		 * allocation context to avoid deadlock if reclaim happens.
+		 */
+		nofs_flag = memalloc_nofs_save();
 		value = kmalloc(size, GFP_KERNEL);
+		memalloc_nofs_restore(nofs_flag);
 		if (!value) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.11.0

