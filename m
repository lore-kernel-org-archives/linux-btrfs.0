Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:41945 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbeCTGrR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 02:47:17 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id C0993AC00CF
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 15:47:11 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 26105BD6691
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 15:47:11 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: ctree.h: Fix wrong comment position about csum size
Message-ID: <cacb081b-619f-413e-0ebf-38f8e8af3d25@jp.fujitsu.com>
Date: Tue, 20 Mar 2018 15:47:06 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index da308774b8a4..8f59cb20dd4c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -86,9 +86,9 @@ struct btrfs_ordered_sum;
  */
 #define BTRFS_LINK_MAX 65535U
 
+/* four bytes for CRC32 */
 static const int btrfs_csum_sizes[] = { 4 };
 
-/* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
 
 /* ioprio of readahead is set to idle */
-- 
2.14.3


