Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50075 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3BYODW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 09:03:22 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so1774993pab.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 06:03:22 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH 4/4] Btrfs-progs: fix complie warning in the function filter_by_parent
Date: Mon, 25 Feb 2013 22:03:17 +0800
Message-Id: <1361800997-2040-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

See the below warning info:
warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 btrfs-list.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index d02d620..2eee4f6 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1173,7 +1173,7 @@ static int filter_full_path(struct root_info *ri, u64 data)
 
 static int filter_by_parent(struct root_info *ri, u64 data)
 {
-	return !uuid_compare(ri->puuid, (u8 *)data);
+	return !uuid_compare(ri->puuid, (u8 *)(unsigned long)data);
 }
 
 static btrfs_list_filter_func all_filter_funcs[] = {
-- 
1.7.7.6

