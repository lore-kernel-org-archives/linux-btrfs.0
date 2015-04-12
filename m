Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34039 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbDLGfZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Apr 2015 02:35:25 -0400
Received: by pacyx8 with SMTP id yx8so67445860pac.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 23:35:24 -0700 (PDT)
Received: from WangdeMacBook-Pro.local ([104.156.239.76])
        by mx.google.com with ESMTPSA id ef3sm3587628pbc.26.2015.04.11.23.35.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 11 Apr 2015 23:35:24 -0700 (PDT)
Message-ID: <552A1228.4090700@gmail.com>
Date: Sun, 12 Apr 2015 14:35:20 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix wrong check for btrfs_force_chunk_alloc()
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_force_chunk_alloc() return 1 for allocation chunk successfully.
This problem exists since commit c87f08ca4.

With this patch, we might fix some enospc problems for balances.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d830853..c453464 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4037,7 +4037,7 @@ restart:
 	if (trans && progress && err == -ENOSPC) {
 		ret = btrfs_force_chunk_alloc(trans, rc->extent_root,
 					      rc->block_group->flags);
-		if (ret == 0) {
+		if (ret == 1) {
 			err = 0;
 			progress = 0;
 			goto restart;
-- 
1.7.12.4
