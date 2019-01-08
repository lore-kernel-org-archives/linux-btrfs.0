Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4BFC43444
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 959332087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546947734;
	bh=s24e4wzdEhnkVTXIMZe/DZ3MM9tHtxmIOACgnY4L5MQ=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=o33NkVbZHqRti8ajvPXmsLVHNCHsQfG5liWGlIRPZ2Fzy/HNI/9+HGL5Vk59ydhB3
	 LERWVFhG8Vyba04A3GN4NepiS4lu7Yn9dIEn3r/+aly5YOQ6Mi6XMfiNesT1pZX5FZ
	 wJTWZWKGrqhyv9KTyzFXHdVz2iPKlvgRVVRFfuKk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfAHLmN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:42:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbfAHLmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 06:42:12 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F9E206B7
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 11:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546947731;
        bh=s24e4wzdEhnkVTXIMZe/DZ3MM9tHtxmIOACgnY4L5MQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ycMulcLW/EEst7kMHCM5mSgDgyu23lVaqCiI6YRDu3jlvu9xB6ow++4YJbzxSISqH
         TeYtNe/QtFG9bOJg9H5HgFwwvqrAp111WzjDcS9wXEhFs4YBlItm8GETtAC/ICM+ya
         sADM8/bZwf8uaNT1ruOTT86CFFvmZ3yeNtMZsV/8=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: do not overwrite error return value in the device replace ioctl
Date:   Tue,  8 Jan 2019 11:42:09 +0000
Message-Id: <20190108114209.2137-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181214194532.21841-1-fdmanana@kernel.org>
References: <20181214194532.21841-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_dev_replace_by_ioctl() failed we would overwrite the
error returned to user space with -EFAULT if the call to copy_to_user()
failed as well. Fix that by calling copy_to_user() only if no error
happened before or a device replace operation was canceled.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Considered the case where the device replace operation is canceled.

 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8dbb4ed07da1..0db60bfee99a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4462,7 +4462,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 		break;
 	}
 
-	if (copy_to_user(arg, p, sizeof(*p)))
+	if ((ret == 0 || ret == -ECANCELED) && copy_to_user(arg, p, sizeof(*p)))
 		ret = -EFAULT;
 out:
 	kfree(p);
-- 
2.11.0

