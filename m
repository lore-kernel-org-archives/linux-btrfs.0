Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45845C43444
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13E99206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546947730;
	bh=0grjVQ/5lIOSTqP1YcYeuTaFArGGmREz+m5wpNy2ZFg=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=e3rK/iVUvznnGNk1buKnndANYMsgl4rx8yVbzwInrwJZ/0+H17Tpad9v6MdRbjH04
	 4rSHBYc0qt4AchtXWUAPe+jIi0O25Is7Iqox2+zeke29lt64j8II6vUVqm9chUWYMe
	 fvj4UX5hBiL/7QQrA5TueNQPDMWPph3jTrhkN7Mo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfAHLmJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbfAHLmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 06:42:07 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47BB1206B7
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546947726;
        bh=0grjVQ/5lIOSTqP1YcYeuTaFArGGmREz+m5wpNy2ZFg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SYvDoGnfSHl1MVERqnEpVz28Uh/izCsdMee4h4juZmLk6uUu9Rtw6uSaWmhsP16p3
         yGLbJSLokN9065pmb1Dc0RhV40BGiTwoquYc9Wx+aANAaULUV2BBl2xRACLw/pQ37I
         wfLGarCxFmLr8CoFl87qYaybESxKcM32vU93aMiI=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: do not overwrite error return value in the balance ioctl
Date:   Tue,  8 Jan 2019 11:42:01 +0000
Message-Id: <20190108114201.1997-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181214194541.21891-1-fdmanana@kernel.org>
References: <20181214194541.21891-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_balance() failed we would overwrite the error
returned to user space with -EFAULT if the call to copy_to_user() failed
as well. Fix that by calling copy_to_user() only if btrfs_balance()
returned success or was canceled.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Considered the case where balance is canceled.

 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d0da86ac53bf..8dbb4ed07da1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4768,7 +4768,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	ret = btrfs_balance(fs_info, bctl, bargs);
 	bctl = NULL;
 
-	if (arg) {
+	if ((ret == 0 || ret == -ECANCELED) && arg) {
 		if (copy_to_user(arg, bargs, sizeof(*bargs)))
 			ret = -EFAULT;
 	}
-- 
2.11.0

