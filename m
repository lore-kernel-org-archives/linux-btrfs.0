Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22248 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaCKKbM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 06:31:12 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2BAV9Qg024881
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 18:31:09 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs-progs: mkfs: don't create extent for an empty file
Date: Tue, 11 Mar 2014 18:29:08 +0800
Message-Id: <1394533749-3138-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkdir -p /tmp/test
 # touch /tmp/test/file
 # mkfs.btrfs -f /dev/sda13 -r /tmp/test
 # btrfs check /dev/sda13

For an empty file, don't create extent data for it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 mkfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index 2dc90c2..2f7dfef 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -619,6 +619,9 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 	struct extent_buffer *eb = NULL;
 	int fd;
 
+	if (st->st_size == 0)
+		return 0;
+
 	fd = open(path_name, O_RDONLY);
 	if (fd == -1) {
 		fprintf(stderr, "%s open failed\n", path_name);
-- 
1.9.0

