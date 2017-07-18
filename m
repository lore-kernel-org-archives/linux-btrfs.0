Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751448AbdGSOYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 10:24:48 -0400
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3CBF22BE9
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jul 2017 14:24:47 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix dir item validation when replaying xattr deletes
Date: Tue, 18 Jul 2017 20:34:02 +0100
Message-Id: <20170718193402.11810-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We were passing an incorrect slot number to the function that validates
directory items when we are replaying xattr deletes from a log tree. The
correct slot is stored at variable 'i' and not at 'path->slots[0]', so
the call to the validation function was only correct for the first
iteration of the loop, when 'i == path->slots[0]'.
After this fix, the fstest generic/066 passes again.

Fixes: 8ee8c2d62d5f ("btrfs: Verify dir_item in replay_xattr_deletes")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f20ef211a73d..3a11ae63676e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2153,8 +2153,7 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
 			u32 this_len = sizeof(*di) + name_len + data_len;
 			char *name;
 
-			ret = verify_dir_item(fs_info, path->nodes[0],
-					      path->slots[0], di);
+			ret = verify_dir_item(fs_info, path->nodes[0], i, di);
 			if (ret) {
 				ret = -EIO;
 				goto out;
-- 
2.11.0

