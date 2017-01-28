Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754126AbdA3T5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 14:57:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 12526202C8
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 19:55:19 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD44202AE
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 19:55:17 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix leak of subvolume writers counter
Date: Sat, 28 Jan 2017 06:06:54 +0000
Message-Id: <1485583614-26225-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

When falling back from a nocow write to a regular cow write, we were
leaking the subvolume writers counter in 2 situations, preventing
snapshot creation from ever completing in the future, as it waits
for that counter to go down to zero before the snapshot creation
starts.

In run_delalloc_nocow, maybe not release subv_writers conter,
will lead to create snapshot hang.

Signed-off-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
[Improved changelog and subject]
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a713d9d..7221d66 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1404,10 +1404,16 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			 * either valid or do not exist.
 			 */
 			if (csum_exist_in_range(fs_info, disk_bytenr,
-						num_bytes))
+						num_bytes)) {
+				if (!nolock)
+					btrfs_end_write_no_snapshoting(root);
 				goto out_check;
-			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
+			}
+			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
+				if (!nolock)
+					btrfs_end_write_no_snapshoting(root);
 				goto out_check;
+			}
 			nocow = 1;
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = found_key.offset +
-- 
2.7.0.rc3

