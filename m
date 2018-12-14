Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704B1C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74E31206C2
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544816707;
	bh=jZDa1tl+zDuD1lFKPlCvRUDyusThL3tgOFdjAQc/6oA=;
	h=From:To:Subject:Date:List-ID:From;
	b=ywUtm2Z7nb4L+mQrbLqX3riI0d9jnYhpyaM15SmRPX5Kt606TDbfVnG9s3KAhHCn7
	 kuRkfYpKEV/wvfIDzgC7jrI38k5RV5N9pnPYEJWnC/QwwUjJnRgjB9R4g2OQgw0HAr
	 5P7cQ6CnQr7rmMCpamibN2jPNMxEA4zF0Zair+oY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbeLNTpF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 14:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbeLNTpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 14:45:05 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A90D206C2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544816705;
        bh=jZDa1tl+zDuD1lFKPlCvRUDyusThL3tgOFdjAQc/6oA=;
        h=From:To:Subject:Date:From;
        b=AmGYxShSaoy0HkiLbjh9euTaESuguXNMF5VoDvasg/xqUvdGuSmQBk9/Vfrjp7Vi5
         C0fldVYOi3xWcaa+eDJE4wEdIMX/y3YiGbe916JM79QgR879ebDr4kz0Sk4MKNL+Qg
         dY68u9eB9qya6nwJw/5cFBpJBC+Qw01x+5VBfJKI=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not overwrite scrub error with fault error in scrub ioctl
Date:   Fri, 14 Dec 2018 19:44:59 +0000
Message-Id: <20181214194459.21691-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If scrub returned an error and then the copy_to_user() call did not
succeed, we would overwrite the error returned by scrub with -EFAULT.
Fix that by removing the call to copy_to_user() as there is no need
to do it at all.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3a27efa2b955..01d18e1a393e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4301,9 +4301,6 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY,
 			      0);
 
-	if (copy_to_user(arg, sa, sizeof(*sa)))
-		ret = -EFAULT;
-
 	if (!(sa->flags & BTRFS_SCRUB_READONLY))
 		mnt_drop_write_file(file);
 out:
-- 
2.11.0

