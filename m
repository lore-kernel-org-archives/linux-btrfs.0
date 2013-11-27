Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3317 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3K0Fci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 00:32:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAR5WXtT019628
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 13:32:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4] btrfs-progs: Fix a segfault when using btrfs-corrupt-block with "-U"
Date: Wed, 27 Nov 2013 13:33:28 +0800
Message-Id: <1385530408-28858-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using "-U" option with btrfs-corrupt-block, it will cause a
segfault due to a missing break in getopt switch.

Reported-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index f0c14a9..a2828d4 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -758,6 +758,7 @@ int main(int ac, char **av)
 				break;
 			case 'U':
 				chunk_tree = 1;
+				break;
 			case 'i':
 				inode = atoll(optarg);
 				if (inode == 0) {
-- 
1.8.4.2

