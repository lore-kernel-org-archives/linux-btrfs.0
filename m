Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab3KMJ3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 04:29:30 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: sbehrens@giantdisaster.de
Subject: [PATCH] Btrfs-progs: try harder to make btrfs receive successfully
Date: Wed, 13 Nov 2013 17:25:46 +0800
Message-Id: <1384334746-11503-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
	# mkfs.btrfs -f <dev>
	# mount <dev> <mnt>
	# mkdir <mnt>/backup
	# btrfs sub create <mnt>/subv
	# btrfs sub snapshot -r <mnt>/subv <mnt>/snap1
	# btrfs sub snapshot -r <mnt>/subv <mnt>/snap2
	# btrfs send <mnt>/snap2 -p <mnt>/snap1 -f sent_file
	# btrfs receive -f sent_file <mnt>/backup

Above steps will make btrfs receive fails with "ERROR: can not find parent subvolume",
this is because we try to find parent subvolume by RECEIVED_SUBVOL_KEY,and it
will return ENOENT if parent snapshot has not been sent or it has been deleted.Actually,
we can try harder to find whether parent subvolume exists by searching uuid key.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-receive.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index 2b880c0..95dc3ec 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -234,6 +234,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
 			parent_ctransid, NULL, subvol_search_by_received_uuid);
 	if (!parent_subvol) {
+		parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
+				parent_ctransid, NULL, subvol_search_by_uuid);
+	}
+	if (!parent_subvol) {
 		ret = -ENOENT;
 		fprintf(stderr, "ERROR: could not find parent subvolume\n");
 		goto out;
-- 
1.8.3.1

