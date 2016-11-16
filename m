Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33722 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbcKPBHz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2016 20:07:55 -0500
Received: by mail-it0-f65.google.com with SMTP id c20so4020514itb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2016 17:07:55 -0800 (PST)
Received: from hary-Aspire-X3400G.Belkin (174-84-237-140.res.bhn.net. [174.84.237.140])
        by smtp.googlemail.com with ESMTPSA id l3sm2486748iti.3.2016.11.15.17.07.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Nov 2016 17:07:54 -0800 (PST)
From: Harinath Nampally <harinath922@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Minor coverity defect fix - CID 1125928 In set_file_xattrs: Dereference of an explicit null value
Date: Tue, 15 Nov 2016 20:07:53 -0500
Message-Id: <1479258473-30053-1-git-send-email-harinath922@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 cmds-restore.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index a8c67a5..6c2ea8a 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -509,6 +509,9 @@ static int set_file_xattrs(struct btrfs_root *root, u64 inode,
 
 		while (cur < total_len) {
 			len = btrfs_dir_name_len(leaf, di);
+                        if (len == 0) {
+                                goto out;
+                        }
 			if (len > name_len) {
 				free(name);
 				name = (char *) malloc(len + 1);
-- 
2.7.4

