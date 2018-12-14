Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742B9C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D544206C2
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544816737;
	bh=dVBYFU5Y/Kdgy1cgSecFp+KM6PL/SDfVFNo5+WyGyp4=;
	h=From:To:Subject:Date:List-ID:From;
	b=V7vdCbmDazn1VexIrSZejQ81LVAQKdUhJhbnLk+hGFBR8Cj1qSQXAcPsokvg9mAzR
	 1LPkuXSYIFfmKEVEa6DqH3VPSPa/JUTlTocr/wyVLK+qlgd1PEU0IWIH3JhRsyVr1r
	 tXwUqGu6F8M5uIh+Z6SZUtV3YyA5xsKzCLmh5T6g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbeLNTpf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 14:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbeLNTpf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 14:45:35 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AFF5206C2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 19:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544816735;
        bh=dVBYFU5Y/Kdgy1cgSecFp+KM6PL/SDfVFNo5+WyGyp4=;
        h=From:To:Subject:Date:From;
        b=BoiR7fUF9sqBkt2p9+ZmOtUOA181lPWGdDz+JTJlCq1WcrOghOiS/D2PKMwCgDiHJ
         RjNCfDB2ADseR+84jjRHt3+joM5aYoLH9oxacwqZeFzk+ci2ymKwV1qfx/zWJvnxPK
         TKjla5sduV6YQJXZO7/+dYxKMl8xVlrBCuhSNscw=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not overwrite error return value in the device replace ioctl
Date:   Fri, 14 Dec 2018 19:45:32 +0000
Message-Id: <20181214194532.21841-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_dev_replace_by_ioctl() failed we would overwrite the
error returned to user space with -EFAULT if the call to copy_to_user()
failed as well. Fix that by calling copy_to_user() only if no error
happened before.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b101df822e9..abe45fd97ab5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4401,7 +4401,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 		break;
 	}
 
-	if (copy_to_user(arg, p, sizeof(*p)))
+	if (ret == 0 && copy_to_user(arg, p, sizeof(*p)))
 		ret = -EFAULT;
 out:
 	kfree(p);
-- 
2.11.0

