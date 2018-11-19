Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF89C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 16:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21C4B20851
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 16:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1dQRQTeA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21C4B20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbeKTCom (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 21:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729825AbeKTCom (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 21:44:42 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7814620851
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542644438;
        bh=/ddrYELQ0zVB0BWoSGnmCdS6wrZ7Trw+0QnZOSh1k+U=;
        h=From:To:Subject:Date:From;
        b=1dQRQTeAZH6EW21HhQ7OfLIddoeYbzqslstgYDTE5nN5lJTCcJl+RACuM+3F1nNnL
         xVXhVhH+4F7R78UH2Mw8oIzAkS5gKEnByPdbyMeQj1M7defmNX45nEal3+Uvc9cDrN
         IVdRoXCn3xe230jzHIh3R1PAK+TldsMi81sVL6oI=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix race between enabling quotas and subvolume creation
Date:   Mon, 19 Nov 2018 16:20:34 +0000
Message-Id: <20181119162034.13132-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We have a race between enabling quotas end subvolume creation that cause
subvolume creation to fail with -EINVAL, and the following diagram shows
how it happens:

              CPU 0                                          CPU 1

 btrfs_ioctl()
  btrfs_ioctl_quota_ctl()
   btrfs_quota_enable()
    mutex_lock(fs_info->qgroup_ioctl_lock)

                                                  btrfs_ioctl()
                                                   create_subvol()
                                                    btrfs_qgroup_inherit()
                                                     -> save fs_info->quota_root
                                                        into quota_root
                                                     -> stores a NULL value
                                                     -> tries to lock the mutex
                                                        qgroup_ioctl_lock
                                                        -> blocks waiting for
                                                           the task at CPU0

   -> sets BTRFS_FS_QUOTA_ENABLED in fs_info
   -> sets quota_root in fs_info->quota_root
      (non-NULL value)

   mutex_unlock(fs_info->qgroup_ioctl_lock)

                                                     -> checks quota enabled
                                                        flag is set
                                                     -> returns -EINVAL because
                                                        fs_info->quota_root was
                                                        NULL before it acquired
                                                        the mutex
                                                        qgroup_ioctl_lock
                                                   -> ioctl returns -EINVAL

Returning -EINVAL to user space will be confusing if all the arguments
passed to the subvolume creation ioctl were valid.

Fix it by grabbing the value from fs_info->quota_root after acquiring
the mutex.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ae1358253b7b..0bdf28499790 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2250,7 +2250,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	int i;
 	u64 *i_qgroups;
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *quota_root = fs_info->quota_root;
+	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *srcgroup;
 	struct btrfs_qgroup *dstgroup;
 	u32 level_size = 0;
@@ -2260,6 +2260,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		goto out;
 
+	quota_root = fs_info->quota_root;
 	if (!quota_root) {
 		ret = -EINVAL;
 		goto out;
-- 
2.11.0

