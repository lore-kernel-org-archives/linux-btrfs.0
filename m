Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BACC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 444DB206C2
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544816728;
	bh=KhjkxYEf+JaqGvilFDweB1IRLEDARAUienApVVdYLCc=;
	h=From:To:Subject:Date:List-ID:From;
	b=F983ifPoNLzMigzc4CwbO+1CicuJiwsXGZd7JZ/eF3UqxZivpidJAfKZg5P43izcZ
	 YfCrQC5hGO5M5ekyVAfZWQkEcdZrPMLEUKHxmr4SIXdoJyoNtcVpwt2A24ghUEbwhY
	 b59iDHkjuSqR/BScM5/2jZeS1v1GF/pcedEpm6OM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbeLNTp0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 14:45:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbeLNTp0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 14:45:26 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46C0B206C2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544816726;
        bh=KhjkxYEf+JaqGvilFDweB1IRLEDARAUienApVVdYLCc=;
        h=From:To:Subject:Date:From;
        b=h+qZGOURCgtq1J769d/6Rv4Sc2Sm457yjQwmSdo8mSj01YDkruxpVZPOMS/JUxytb
         3J/OIV/83OAJWfZaywY3T9DLe5gvZlCzU4op38f4YOaRq14lkjh+ahADp6l/2Xli3l
         kEd2Y1UAsG/+QVPUPJTkB8xGbZ4pwT2VTw9WmkMQ=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not overwrite error return value in the get device stats ioctl
Date:   Fri, 14 Dec 2018 19:45:22 +0000
Message-Id: <20181214194522.21791-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_get_dev_stats() failed we would overwrite the error
returned to user space with -EFAULT if the call to copy_to_user() failed
as well. Fix that by calling copy_to_user() only if btrfs_get_dev_stats()
returned success.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 76848214a39f..0b101df822e9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4355,7 +4355,7 @@ static long btrfs_ioctl_get_dev_stats(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_get_dev_stats(fs_info, sa);
 
-	if (copy_to_user(arg, sa, sizeof(*sa)))
+	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
 	kfree(sa);
-- 
2.11.0

