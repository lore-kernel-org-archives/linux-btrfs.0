Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:44258 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbdJ3IKp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 04:10:45 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 04F31AC00E4
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 17:10:41 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 659DABD6682
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 17:10:40 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
Message-ID: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
Date: Mon, 30 Oct 2017 17:10:34 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the print_inode_item(), the argument order of sequence and flags are
reversed:

printf("... sequence %llu flags 0x%llx(%s)\n",
				... 
	       (unsigned long long)btrfs_inode_flags(eb,ii),
 	       (unsigned long long)btrfs_inode_sequence(eb, ii),
				...)

So, just fix it.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 print-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index 3c585e3..8abd760 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -896,8 +896,8 @@ static void print_inode_item(struct extent_buffer *eb,
 	       btrfs_inode_uid(eb, ii),
 	       btrfs_inode_gid(eb, ii),
 	       (unsigned long long)btrfs_inode_rdev(eb,ii),
-	       (unsigned long long)btrfs_inode_flags(eb,ii),
 	       (unsigned long long)btrfs_inode_sequence(eb, ii),
+	       (unsigned long long)btrfs_inode_flags(eb,ii),
 	       flags_str);
 	print_timespec(eb, btrfs_inode_atime(ii), "\t\tatime ", "\n");
 	print_timespec(eb, btrfs_inode_ctime(ii), "\t\tctime ", "\n");
-- 
2.9.5


