Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34771 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbcCRLId (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 07:08:33 -0400
Received: by mail-wm0-f42.google.com with SMTP id p65so63521295wmp.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 04:08:32 -0700 (PDT)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH] btrfs-progs: fix incorrect column order
Date: Fri, 18 Mar 2016 12:08:24 +0100
Message-Id: <1458299304-4674-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 cmds-fi-du.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 6f3ef3d..2ffd917 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -505,8 +505,8 @@ static int du_add_file(const char *filename, int dirfd,
 		} else {
 			printf("%10s  %10s  %10s  %s\n",
 			       pretty_size_mode(file_total, unit_mode),
-			       "-",
-			       pretty_size_mode(excl, unit_mode), path);
+			       pretty_size_mode(excl, unit_mode),
+			       "-", path);
 		}
 	}
 
-- 
2.7.4

