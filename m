Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53100 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaJHJni (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Oct 2014 05:43:38 -0400
Received: by mail-pa0-f44.google.com with SMTP id et14so8816869pad.31
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Oct 2014 02:43:38 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: return error when canonicalize_path failed
Date: Wed,  8 Oct 2014 17:42:29 +0800
Message-Id: <1412761349-32721-2-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1412761349-32721-1-git-send-email-guaneryu@gmail.com>
References: <1412761349-32721-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Error out cmd_start_replace() if canonicalize_path() dstdev failed, add
the missing "goto leave_with_error;"

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 cmds-replace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-replace.c b/cmds-replace.c
index 51b7aaf..d5648d5 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -213,6 +213,7 @@ static int cmd_start_replace(int argc, char **argv)
 		fprintf(stderr,
 			"ERROR: Could not canonicalize path '%s': %s\n",
 			argv[optind + 1], strerror(errno));
+		goto leave_with_error;
 	}
 
 	if (is_numerical(srcdev)) {
-- 
1.8.3.1

