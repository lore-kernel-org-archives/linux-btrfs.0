Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36587 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753043AbeE1CSc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:32 -0400
Received: by mail-it0-f48.google.com with SMTP id e20-v6so13207776itc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:32 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 5/6] btrfs-progs: add total data size, fallocate to dump
Date: Sun, 27 May 2018 22:14:40 -0400
Message-Id: <20180528021443.13923-12-linux@hmclauchlan.com>
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
References: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Howard McLauchlan <hmclauchlan@fb.com>

Adding entries to dump for new commands (total data size, fallocate).

Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
---
 send-dump.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/send-dump.c b/send-dump.c
index 1591e0cc..c5a695a2 100644
--- a/send-dump.c
+++ b/send-dump.c
@@ -316,6 +316,21 @@ static int print_update_extent(const char *path, u64 offset, u64 len,
 			  offset, len);
 }
 
+static int print_total_data_size(u64 size, void *user)
+{
+	char path;
+
+	return PRINT_DUMP(user, &path, "total_data_size", "size=%llu", size);
+}
+
+static int print_fallocate(const char *path, u32 flags, u64 offset, u64 len,
+			   void *user)
+{
+	return PRINT_DUMP(user, path, "fallocate",
+			  "flags=%u offset=%llu len=%llu", flags, offset,
+			  len);
+}
+
 struct btrfs_send_ops btrfs_print_send_ops = {
 	.subvol = print_subvol,
 	.snapshot = print_snapshot,
@@ -337,5 +352,7 @@ struct btrfs_send_ops btrfs_print_send_ops = {
 	.chmod = print_chmod,
 	.chown = print_chown,
 	.utimes = print_utimes,
-	.update_extent = print_update_extent
+	.update_extent = print_update_extent,
+	.total_data_size = print_total_data_size,
+	.fallocate = print_fallocate,
 };
-- 
2.17.0

