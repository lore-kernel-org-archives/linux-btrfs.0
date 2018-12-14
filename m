Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08170C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13EBE206C2
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544816719;
	bh=g2qdIqQRy/mBepZNRO/GFEy5UdLJSpg9wGSFlu65Y4c=;
	h=From:To:Subject:Date:List-ID:From;
	b=mE/YwqbyFxvv3gW8EvaBNYpcC87IfAmmON/Z1IGoR4+zDip7uj1qsZvLP/sox7vFe
	 7S8uGR4cmUUR7GM8q2wXTdoGW+M+3WfhKpFhSMq/E6BU3zljUaZdQoHnWYZMkzCDzj
	 AUxK6qX1bSyWonNOHzTzdG0xed0kBjf8UqS9YLM0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbeLNTpQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 14:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbeLNTpQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 14:45:16 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D9D206C2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 19:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544816717;
        bh=g2qdIqQRy/mBepZNRO/GFEy5UdLJSpg9wGSFlu65Y4c=;
        h=From:To:Subject:Date:From;
        b=m+CuVlnFS2gj2SiLP33Pd8sMixUMZWn+8Sg7e2cY8gmke4lmU6yQFCBO/7bpRNvKa
         o282MukSudxI3UbjFxTBRWQpLh3WXb8l5Xx3rpd6RO8lWYGtevjCUO9msxvIZ7z9Zl
         OBQQLosYkDtu/XVeOqvVb+zunw8TxykdRsocKmhs=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not overwrite error return value in scrub progress ioctl
Date:   Fri, 14 Dec 2018 19:45:13 +0000
Message-Id: <20181214194513.21741-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_scrub_progress() failed we would overwrite the error
returned to user space with -EFAULT if the call to copy_to_user() failed
as well. Fix that by calling copy_to_user() only if btrfs_scrub_progress()
returned success.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 01d18e1a393e..76848214a39f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4331,7 +4331,7 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_scrub_progress(fs_info, sa->devid, &sa->progress);
 
-	if (copy_to_user(arg, sa, sizeof(*sa)))
+	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
 	kfree(sa);
-- 
2.11.0

