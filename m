Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:56317 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeFDHmV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2018 03:42:21 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 6CEF7AC01EF
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Jun 2018 16:42:15 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: Check error of btrfs_iget() in
 btrfs_search_path_in_tree_user()
References: <cover.1528076364.git.misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <c88f81e3-1dff-35a8-89ce-d9d3050be101@jp.fujitsu.com>
Date: Mon, 4 Jun 2018 16:41:07 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1528076364.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---

Hi david,

It seems that v8 patch I sent last week is missed and commit in misc-next
tree is also a bit updated from v7, so I resend the fix as a separate patch.

Please fold this patch to current misc-next (head is the commit to be fixed:
"btrfs: Add unprivileged version of ino_lookup ioctl").

Thanks,
Tomohiro Misono

 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d29992f7dc63..5556e9ea2a4b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2438,6 +2438,10 @@ static int btrfs_search_path_in_tree_user(struct inode *inode,
 			}
 
 			temp_inode = btrfs_iget(sb, &key2, root, NULL);
+			if (IS_ERR(temp_inode)) {
+				ret = PTR_ERR(temp_inode);
+				goto out;
+			}
 			ret = inode_permission(temp_inode, MAY_READ | MAY_EXEC);
 			iput(temp_inode);
 			if (ret) {
-- 
2.14.3


