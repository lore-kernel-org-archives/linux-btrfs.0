Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:49180 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbbHSIpV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 04:45:21 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3E2E9AC0377
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 17:45:19 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3051.s.css.fujitsu.com (Postfix) with SMTP id 0F993DC
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 17:45:19 +0900 (JST)
Message-Id: <201508190844.AA00004@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 19 Aug 2015 17:44:53 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: cleanup: remove unnecessary check before btrfs_free_path is called
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need not check path before btrfs_free_path() is called because
path is checked in btrfs_free_path().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-check.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4fa8709..8019fb0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9226,8 +9226,7 @@ next:
 	ret = 0;
 out:
 	free_roots_info_cache();
-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	if (trans)
 		btrfs_commit_transaction(trans, info->tree_root);
 	if (ret < 0)
-- 
2.4.5

