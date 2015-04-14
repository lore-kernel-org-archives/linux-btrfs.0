Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33445 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbbDNKo7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 06:44:59 -0400
Received: by layy10 with SMTP id y10so4506588lay.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 03:44:58 -0700 (PDT)
From: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
Subject: [PATCH] btrfs-progs: enforce chroot for btrfs receive
Date: Tue, 14 Apr 2015 13:44:32 +0300
Message-Id: <217a387d55b5828a82fadad98dd88a959e7a13ed.1429008167.git.lauri.vosandi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch forces btrfs receive to issue chroot before
parsing the btrfs stream to confine the process and
minimize damage that could be done via malicious
btrfs stream.

Signed-off-by: Lauri Võsandi <lauri.vosandi@gmail.com>
---
 cmds-receive.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 44ef27e..8be92ea 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -867,15 +867,17 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
 		goto out;
 	}
 
-	/*
-	 * find_mount_root returns a root_path that is a subpath of
-	 * dest_dir_full_path. Now get the other part of root_path,
-	 * which is the destination dir relative to root_path.
-	 */
-	r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
-	while (r->dest_dir_path[0] == '/')
-		r->dest_dir_path++;
+	if (chroot(dest_dir_full_path)) {
+		ret = -errno;
+		fprintf(stderr,
+			"ERROR: failed to chroot to %s, %s\n",
+			dest_dir_full_path,
+			strerror(-ret));
+		goto out;
+	}
 
+	r->root_path = r->dest_dir_path = strdup("/");
+	
 	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
 	if (ret < 0)
 		goto out;
-- 
1.9.1

