Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB04C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D96206C2
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544816746;
	bh=+mXXvudsmOAnmFLj4EaNGWhIUVbu36Sk4QZ9AO6cC/w=;
	h=From:To:Subject:Date:List-ID:From;
	b=oqyGAAQJLlmh8O8okr6syqcvx6fnJ16AV5J082NZokFRazmhOMIpGHdQY9hfotUfq
	 /H5qluNTrUKrGeMzjZ8imblbzgoCnCkiyOIzNZ0iNys5nbSSzSe2doz43pBfTQnKZt
	 XlMaVkLrkLS1tAEqTIVFsdigOuhzTyyVLWoH3xtU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbeLNTpo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 14:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbeLNTpo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 14:45:44 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE55B206C2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 19:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544816745;
        bh=+mXXvudsmOAnmFLj4EaNGWhIUVbu36Sk4QZ9AO6cC/w=;
        h=From:To:Subject:Date:From;
        b=uMXpChS7AePbLTQktYT8QS0ioNoGPkU6A2iwDUYYgtgqOelJRh9kSewPbDXiZQKxV
         KeTcyJE1SM5g6FwC3d81+UZ/cV3QruOJ92exxbi/psIrzNqs+VW4u8dO2GoPDn561U
         kItDLyjlfK6opDJyASOFzzAZbWVGpzzPzh3MOhOs=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not overwrite error return value in the balance ioctl
Date:   Fri, 14 Dec 2018 19:45:41 +0000
Message-Id: <20181214194541.21891-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_balance() failed we would overwrite the error
returned to user space with -EFAULT if the call to copy_to_user() failed
as well. Fix that by calling copy_to_user() only if btrfs_balance()
returned success.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index abe45fd97ab5..4ad7288f77d0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4707,7 +4707,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	ret = btrfs_balance(fs_info, bctl, bargs);
 	bctl = NULL;
 
-	if (arg) {
+	if (ret == 0 && arg) {
 		if (copy_to_user(arg, bargs, sizeof(*bargs)))
 			ret = -EFAULT;
 	}
-- 
2.11.0

