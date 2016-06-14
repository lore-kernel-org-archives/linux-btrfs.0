Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36625 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbcFNWzr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 18:55:47 -0400
Received: by mail-wm0-f68.google.com with SMTP id m124so1787648wme.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 15:55:46 -0700 (PDT)
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Benedikt Morbach <benedikt.morbach@googlemail.com>
Subject: [PATCH] receive: strip root subvol path during process_clone
Date: Wed, 15 Jun 2016 00:55:41 +0200
Message-Id: <20160614225541.18140-1-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

otherwise we get

    ERROR: cannot open <subvol_path>: No such file or directory

because <full_root_path>/<subvol_path> doesn't exist, so openat() will fail below.

Signed-off-by: Benedikt Morbach <benedikt.morbach@googlemail.com>
---
 cmds-receive.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index f4a3a4f..a975fdd 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -753,6 +753,17 @@ static int process_clone(const char *path, u64 offset, u64 len,
 		subvol_path = strdup(si->path);
 	}
 
+	/* strip the subvolume that we are receiving to from the start of subvol_path */
+	if (r->full_root_path &&
+		strstr(subvol_path, r->full_root_path) == subvol_path) {
+		size_t root_len = strlen(r->full_root_path);
+		size_t sub_len = strlen(subvol_path);
+
+		memmove(subvol_path,
+			subvol_path + root_len + 1,
+			sub_len - root_len);
+	}
+
 	ret = path_cat_out(full_clone_path, subvol_path, clone_path);
 	if (ret < 0) {
 		error("clone: target path invalid: %s", clone_path);
-- 
2.8.4

