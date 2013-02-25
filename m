Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43280 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab3BYOC5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 09:02:57 -0500
Received: by mail-pb0-f50.google.com with SMTP id up1so1667570pbc.23
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 06:02:56 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH 2/4] Btrfs-progs: disable qgroup level 0 for userspace use
Date: Mon, 25 Feb 2013 22:02:52 +0800
Message-Id: <1361800972-1978-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

To implement a strict hierarchy quota, qgroup level 0
should not be allowed to create/destroy by users.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 cmds-qgroup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 26f0ab0..06505fa 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -86,6 +86,11 @@ static int qgroup_create(int create, int argc, char **argv)
 	memset(&args, 0, sizeof(args));
 	args.create = create;
 	args.qgroupid = parse_qgroupid(argv[1]);
+	if (!(args.qgroupid >> 48)) {
+		fprintf(stderr, "ERROR: unable to create/destroy qgroup "
+				"level 0\n");
+		return 30;
+	}
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
-- 
1.7.7.6

