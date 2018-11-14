Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20363C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 11:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D78FA214F1
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 11:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LbkHeWkG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D78FA214F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbeKNViV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 16:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbeKNViV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 16:38:21 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AD0214F1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 11:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542195328;
        bh=YQPEoFdV5L6vhg5t6mbrh4WZzXRxc+BiOQfxQAKvmME=;
        h=From:To:Subject:Date:From;
        b=LbkHeWkG9OndoykBmIsvLgicPQptlC4ytnUTdxXwctnqhezmN+oaduIGSJNj0VK+5
         kg0mtZ8R+Rz4Z9euNG/9+KcZc2BdB9yzNizvymQWb1B4wZ9xR53kjE9l7z56Z0LtFx
         Egqn8fahNcuWCuayCi2YolXwEGMsntQS5DienWJ0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: ensure path name is null terminated at btrfs_control_ioctl
Date:   Wed, 14 Nov 2018 11:35:24 +0000
Message-Id: <20181114113524.7102-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We were using the path name received from user space without checking that
it is null terminated. While btrfs-progs is well behaved and does proper
validation and null termination, someone could call the ioctl and pass
a non-null terminated patch, leading to buffer overrun problems in the
kernel.

So just set the last byte of the path to a null character, similar to what
we do in other ioctls (add/remove/resize device, snapshot creation, etc).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6601c9aa5e35..8ad145820ea8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2235,6 +2235,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	vol = memdup_user((void __user *)arg, sizeof(*vol));
 	if (IS_ERR(vol))
 		return PTR_ERR(vol);
+	vol->name[BTRFS_PATH_NAME_MAX] = '\0';
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
-- 
2.11.0

