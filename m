Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43999 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab3HHFFu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 01:05:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r7855lVU008784
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 13:05:47 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: catch error return value from find_extent_in_eb()
Date: Thu, 8 Aug 2013 13:04:18 +0800
Message-Id: <1375938259-5015-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_extent_in_eb() may return ENOMEM, catch this error return value.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 54e7610..f7781e6 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -934,6 +934,10 @@ again:
 				}
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie);
+				if (ret) {
+					free_extent_buffer(eb);
+					goto out;
+				}
 				ref->inode_list = eie;
 				free_extent_buffer(eb);
 			}
-- 
1.8.0.1

