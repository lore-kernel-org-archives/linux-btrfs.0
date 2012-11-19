Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab2KSIZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 03:25:01 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAJ8P0Pp003200
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2012 16:25:00 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: Fix a segmentation fault in btrfstune when <device> is invalid.
Date: Mon, 19 Nov 2012 16:24:30 +0800
Message-Id: <1353313470-25087-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When open_ctree(device, ...) failed, the return value should be checked.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 btrfstune.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 47830c5..07648d5 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -107,6 +107,8 @@ int main(int argc, char *argv[])
 	}
 
 	root = open_ctree(device, 0, 1);
+	if (!root)
+		return 1;
 
 	if (seeding_flag) {
 		ret = update_seeding_flag(root, seeding_value);
-- 
1.7.7.6

