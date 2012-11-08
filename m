Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37619 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2KHJzU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 04:55:20 -0500
Message-ID: <509B8197.2090601@cn.fujitsu.com>
Date: Thu, 08 Nov 2012 17:55:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>, wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: [RFC PATCH] Btrfs-progs: disable qgroupid 0 for quota_tree
References: <509B8053.3080509@cn.fujitsu.com>
In-Reply-To: <509B8053.3080509@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

In kernel, qgroupid 0 is a special number when we run the quota group limit command.

So, we should not be able to create a quota group whose id is 0, otherwise the kernel
can't deal with it. Fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 70019d0..dfff1b9 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -86,6 +86,10 @@ static int qgroup_create(int create, int argc, char **argv)
 	args.create = create;
 	args.qgroupid = parse_qgroupid(argv[1]);
 
+	if (!args.qgroupid) {
+		fprintf(stderr, "ERROR: qgroup 0 is not supported\n");
+		return 30;
+	}
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-- 1.7.7.6 









