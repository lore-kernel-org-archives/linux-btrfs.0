Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:48911 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754036AbeDBCA1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Apr 2018 22:00:27 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 8A789AC01AD
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Apr 2018 11:00:18 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: mkfs rootdir: use lgetxattr() not to follow a
 symbolic link
Message-ID: <f53cc5d0-24ff-81b7-68db-0c615edf4936@jp.fujitsu.com>
Date: Mon, 2 Apr 2018 10:59:31 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs-test 016 "rootdir-bad-symbolic-link" fails when selinux is enabled.
This is because add_xattr_item() uses getxattr() and tries to follow a
bad symbolic link for selinux item, which causes ENOENT error.

The line above already uses llistxattr() for getting list of xattr in
order not to follow a symbolic link, so just use lgetxattr() too.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 mkfs/rootdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 33c3ff1e..ff00bb0f 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -249,7 +249,7 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 		cur_name_len = strlen(cur_name);
 		next_location += cur_name_len + 1;
 
-		ret = getxattr(file_name, cur_name, cur_value, XATTR_SIZE_MAX);
+		ret = lgetxattr(file_name, cur_name, cur_value, XATTR_SIZE_MAX);
 		if (ret < 0) {
 			if (errno == ENOTSUP)
 				return 0;
-- 
2.14.3

