Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16578C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09252084B
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553597402;
	bh=9MJJuSXkJ3xlyGc2EucN52tUEtBQqQuhdbMlpvJjRlE=;
	h=From:To:Subject:Date:List-ID:From;
	b=w1/IYRMUUF571UljIYIvP6k8sWD13MQHU4kZzFJSD1HzIFR44BVc5oFXiYrGj/8L5
	 xahpx44AAgHsR1pCWNKiy1wbe6e1U0f7yhbm/Rl5IcQPC2xrYLZ2/xDSTwemMvoFpn
	 nf8y+SMbMTS4ZjBSyqXpfwSKq3rcZU+DGvTamb+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfCZKuB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfCZKuB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 06:50:01 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 657CD2084B
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553597400;
        bh=9MJJuSXkJ3xlyGc2EucN52tUEtBQqQuhdbMlpvJjRlE=;
        h=From:To:Subject:Date:From;
        b=vYNJRhUqvy6Wo/hVx604ZYYrDZ+2nElqRnFrTbMk/KHApASmj1uEpxaQaSA2KBKsE
         8+PRNBHWkQFkiaPZ2/FtOtEGBRFoT0qdQ8JY3df7dL1260S8VqcE+YUf1Eepac955V
         qzqhdBfRvCP0ACC4GGpbx5GwVj7+BPAGalhwGsxw=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not allow trimming when a fs is mounted with the nologreplay option
Date:   Tue, 26 Mar 2019 10:49:56 +0000
Message-Id: <20190326104956.10314-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Whan a filesystem is mounted with the nologreplay mount option, which
requires it to be mounted in RO mode as well, we can not allow discard on
free space inside block groups, because log trees refer to extents that
are not pinned in a block group's free space cache (pinning the extents is
precisely the first phase of replaying a log tree).

So do not allow the fitrim ioctl to do anything when the filesystem is
mounted with the nologreplay option, because later it can be mounted RW
without that option, which causes log replay to happen and result in
either a failure to replay the log trees (leading to a mount failure), a
crash or some silent corruption.

Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 494f0f10d70e..01808934d21f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -501,6 +501,16 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/*
+	 * If the fs is mounted with nologreplay, which requires it to be
+	 * mounted in RO mode as well, we can not allow discard on free space
+	 * inside block groups, because log trees refer to extents that are not
+	 * pinned in a block group's free space cache (pinning the extents is
+	 * precisely the first phase of replaying a log tree).
+	 */
+	if (btrfs_test_opt(fs_info, NOLOGREPLAY))
+		return -EROFS;
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(device, &fs_info->fs_devices->devices,
 				dev_list) {
-- 
2.11.0

