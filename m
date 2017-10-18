Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54412 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935991AbdJRIBJ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 18 Oct 2017 04:01:09 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/5] btrfs-progs: mkfs: Fix overwritten return value for mkfs
Date: Wed, 18 Oct 2017 16:00:51 +0800
Message-Id: <20171018080054.25509-3-wqu@suse.com>
In-Reply-To: <20171018080054.25509-1-wqu@suse.com>
References: <20171018080054.25509-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For mkfs failure, especially --rootdir errors like EPERM/ENOSPC, the out
branch will overwrite return value, causing wrong status code.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 1b4cabc1ef90..5817f114c1a1 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1423,6 +1423,7 @@ int main(int argc, char **argv)
 	int zero_end = 1;
 	int fd = -1;
 	int ret;
+	int close_ret;
 	int i;
 	int mixed = 0;
 	int nodesize_forced = 0;
@@ -1938,9 +1939,9 @@ raid_groups:
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
2.14.2

