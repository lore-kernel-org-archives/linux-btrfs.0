Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57072 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2GCAZ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 20:25:29 -0400
Received: by pbbrp8 with SMTP id rp8so8277877pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 17:25:29 -0700 (PDT)
From: Shawn Landden <shawnlandden@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Shawn Landden <shawnlandden@gmail.com>
Subject: [PATCH] Check for failure in open_ctree() call. (LP: #926186)
Date: Mon,  2 Jul 2012 17:25:26 -0700
Message-Id: <1341275126-17671-1-git-send-email-shawnlandden@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 btrfstune.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 47830c5..f746e14 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -107,6 +107,10 @@ int main(int argc, char *argv[])
 	}
 
 	root = open_ctree(device, 0, 1);
+	if (!root) {
+		fprintf(stderr, "unable to open ctree\n");
+		return 1;
+        }
 
 	if (seeding_flag) {
 		ret = update_seeding_flag(root, seeding_value);
-- 
1.7.9.5

