Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34964 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbcFNX0U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 19:26:20 -0400
Received: by mail-wm0-f67.google.com with SMTP id k184so1904592wme.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 16:26:20 -0700 (PDT)
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Benedikt Morbach <benedikt.morbach@googlemail.com>
Subject: [PATCH] btrfs-progs: receive: handle root subvol path in clone
Date: Wed, 15 Jun 2016 01:26:15 +0200
Message-Id: <20160614232615.20467-1-benedikt.morbach@googlemail.com>
In-Reply-To: <1465945606.18810.1.camel@googlemail.com>
References: <1465945606.18810.1.camel@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

otherwise we get

    ERROR: cannot open <subvol_path>: No such file or directory

because <full_root_path>/<subvol_path> doesn't exist, so openat() will fail below.

Signed-off-by: Benedikt Morbach <benedikt.morbach@googlemail.com>
---


resend with 'btrfs-progs:' in the subject.
Sorry for the noise

cheers

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

