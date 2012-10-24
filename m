Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m53-178.qiye.163.com ([123.58.178.53]:40681 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab2JXIYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 04:24:49 -0400
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com [209.85.217.174])
	by m53-178.qiye.163.com (HMail) with ESMTPA id E4B6112284C5
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 16:24:45 +0800 (CST)
Received: by mail-lb0-f174.google.com with SMTP id n3so897335lbo.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 01:24:42 -0700 (PDT)
MIME-Version: 1.0
From: Rock Lee <zimilo@code-trick.com>
Date: Wed, 24 Oct 2012 16:24:02 +0800
Message-ID: <CAMRmmpLvLEC_SayRxBJHs=-sunrn_oA6Cy=-pRd+s1v4XDE24g@mail.gmail.com>
Subject: [BUG][PATCH][BTRFS-PROGS] Bug overflow fix
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there's is a long name directory exists in the /dev, then an
overflow will hit in function utils.c btrfs_scan_one_dir:1013!

The minimal fix is to use snprintf instead of strcpy.

The reason why not using strncpy is that, if there is no null byte
among the first n bytes of src, the string  placed  in  dest
will not be null - terminated.

Signed-off-by: Rock Lee <zimilo@code-trick.com>
---
 utils.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 3c88d2e..7200aef 100644
--- a/utils.c
+++ b/utils.c
@@ -969,7 +969,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 	pending = malloc(sizeof(*pending));
 	if (!pending)
 		return -ENOMEM;
-	strcpy(pending->name, dirname);
+	snprintf(pending->name, sizeof(pending->name), "%s", dirname);

 again:
 	dirname_len = strlen(pending->name);
@@ -1010,7 +1010,8 @@ again:
 				ret = -ENOMEM;
 				goto fail;
 			}
-			strcpy(next->name, fullpath);
+			snprintf(next->name, sizeof(next->name),
+				 "%s", fullpath);
 			list_add_tail(&next->list, &pending_list);
 		}
 		if (!S_ISBLK(st.st_mode)) {
-- 
1.7.7.6
