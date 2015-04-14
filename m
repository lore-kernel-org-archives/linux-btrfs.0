Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35927 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbbDNJRz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 05:17:55 -0400
Received: by lbbqq2 with SMTP id qq2so2996042lbb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 02:17:54 -0700 (PDT)
From: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Lauri=20V=C3=B5sandi?= <lauri.vosandi@gmail.com>
Subject: [PATCH] Btrfs receive hardening patches
Date: Tue, 14 Apr 2015 12:17:46 +0300
Message-Id: <f79c8b9a79ecd8a87bb75fc7cb0b0d478a757f4b.1429002759.git.lauri.vosandi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 cmds-receive.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 44ef27e..6800401 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -867,15 +867,19 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
 		goto out;
 	}
 
-	/*
-	 * find_mount_root returns a root_path that is a subpath of
-	 * dest_dir_full_path. Now get the other part of root_path,
-	 * which is the destination dir relative to root_path.
+	/**
+	 * Enforce chroot before parsing btrfs stream
 	 */
-	r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
-	while (r->dest_dir_path[0] == '/')
-		r->dest_dir_path++;
+	if (chroot(dest_dir_full_path)) {
+		fprintf(stderr,
+			"ERROR: failed to chroot to %s\n",
+			dest_dir_full_path);
+		ret = -errno;
+		goto out;
+	}
 
+	r->root_path = r->dest_dir_path = strdup("/");
+	
 	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
 	if (ret < 0)
 		goto out;
-- 
1.9.1

