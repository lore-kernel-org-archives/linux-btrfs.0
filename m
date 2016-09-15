Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:36837 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752706AbcIOTP4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 15:15:56 -0400
Received: by mail-yb0-f196.google.com with SMTP id u125so1943335ybg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 12:15:56 -0700 (PDT)
From: Vincent Batts <vbatts@hashbangbash.com>
To: linux-btrfs@vger.kernel.org
Cc: Vincent Batts <vbatts@hashbangbash.com>
Subject: [PATCH] btrfs-progs: subvolume verbose delete flag
Date: Thu, 15 Sep 2016 15:15:50 -0400
Message-Id: <20160915191550.12371-2-vbatts@hashbangbash.com>
In-Reply-To: <20160915191550.12371-1-vbatts@hashbangbash.com>
References: <20160915191550.12371-1-vbatts@hashbangbash.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was already the logic for verbose output, but the flag parsing did
not include it.

Signed-off-by: Vincent Batts <vbatts@hashbangbash.com>
---
 cmds-subvolume.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e7ef67d..f8c9f48 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -245,6 +245,7 @@ static const char * const cmd_subvol_delete_usage[] = {
 	"",
 	"-c|--commit-after      wait for transaction commit at the end of the operation",
 	"-C|--commit-each       wait for transaction commit after deleting each subvolume",
+	"-v|--verbose           verbose output of operations",
 	NULL
 };
 
@@ -267,10 +268,11 @@ static int cmd_subvol_delete(int argc, char **argv)
 		static const struct option long_options[] = {
 			{"commit-after", no_argument, NULL, 'c'},  /* commit mode 1 */
 			{"commit-each", no_argument, NULL, 'C'},  /* commit mode 2 */
+			{"verbose", no_argument, NULL, 'v'},
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "cC", long_options, NULL);
+		c = getopt_long(argc, argv, "cCv", long_options, NULL);
 		if (c < 0)
 			break;
 
-- 
2.9.0

