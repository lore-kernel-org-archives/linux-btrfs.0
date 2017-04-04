Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753075AbdDDOJe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Apr 2017 10:09:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 1652F20120
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Apr 2017 14:09:33 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9578720117
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Apr 2017 14:09:31 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix extent map leak during fallocate error path
Date: Tue,  4 Apr 2017 03:20:36 +0100
Message-Id: <1491272436-11127-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If the call to btrfs_qgroup_reserve_data() failed, we were leaking an
extent map structure. The failure can happen either due to an -ENOMEM
condition or, when quotas are enabled, due to -EDQUOT for example.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 48dfb8e..56304c4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2856,8 +2856,10 @@ static long btrfs_fallocate(struct file *file, int mode,
 			}
 			ret = btrfs_qgroup_reserve_data(inode, cur_offset,
 					last_byte - cur_offset);
-			if (ret < 0)
+			if (ret < 0) {
+				free_extent_map(em);
 				break;
+			}
 		} else {
 			/*
 			 * Do not need to reserve unwritten extent for this
-- 
2.7.0.rc3

