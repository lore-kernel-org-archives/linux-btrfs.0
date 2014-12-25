Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26385 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751625AbaLYBS6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:18:58 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP1ITri019404
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 09:18:29 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: refine btrfs-debug-tree error prompt when a mount point given
Date: Thu, 25 Dec 2014 09:16:35 +0800
Message-ID: <1419470195-2889-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, if exec:
	# btrfs-debug-tree <mount_point>
it echos:
	: Superblock bytenr is larger than device size

But it is quite misleading, because it is a valid btrfs.
In this case, we should tell the developer to provide a block device.

After apply:
	: '<mount_point>' is not a block device
	: 'usage: btrfs-debug-tree [options] device

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-debug-tree.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index e46500d..7f079a9 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -179,6 +179,12 @@ int main(int ac, char **av)
 	if (check_argc_exact(ac, 1))
 		print_usage();
 
+	ret = check_arg_type(av[optind]);
+	if (ret != BTRFS_ARG_BLKDEV) {
+		fprintf(stderr, "'%s' is not a block device\n", av[optind]);
+		print_usage();
+	}
+
 	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
 	if (!info) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
-- 
1.8.1.4

