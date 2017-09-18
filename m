Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60583 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752470AbdIRHWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:22:06 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 13/14] btrfs-progs: mkfs: Fix overwritten return value for mkfs
Date: Mon, 18 Sep 2017 16:21:38 +0900
Message-Id: <20170918072139.6300-14-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For mkfs failure, especially --rootdir errors like EPERM/ENOSPC, the out
branch will overwrite return value, causing wrong status code.

Fix it so it can pass incoming test cases.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 mkfs/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index f78c24ce..caa5c2e2 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1339,6 +1339,7 @@ int main(int argc, char **argv)
 	int zero_end = 1;
 	int fd = -1;
 	int ret;
+	int close_ret;
 	int i;
 	int mixed = 0;
 	int nodesize_forced = 0;
@@ -1814,9 +1815,9 @@ raid_groups:
 	 */
 	fs_info->finalize_on_close = 1;
 out:
-	ret = close_ctree(root);
+	close_ret = close_ctree(root);
 
-	if (!ret) {
+	if (!close_ret) {
 		optind = saved_optind;
 		dev_cnt = argc - optind;
 		while (dev_cnt-- > 0) {
-- 
2.14.1

