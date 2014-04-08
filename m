Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ae0-f63.auone-net.jp ([106.187.230.63]:46398 "EHLO
	dmta03.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756586AbaDHNrh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 09:47:37 -0400
Received: from amlmta302.auone-net.jp (amlmta302-MM [10.188.22.207])
	by dmta03.auone-net.jp (au one net mail) with ESMTP id 92374DA0711
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Apr 2014 22:38:03 +0900 (JST)
Date: Tue, 8 Apr 2014 22:38:02 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Make property work with -t option
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <5343fbbb0004ae2a0000372000000eae180002ee59c3@amlmta302.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs prop list -t f .
btrfs property list: too many arguments
...
# btrfs prop get -t f . label
btrfs property get: too many arguments
...
# btrfs prop set -t f . label abc
btrfs property set: too many arguments
...

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 cmds-property.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index df53f91..8b4869f 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -392,7 +392,7 @@ static int cmd_get(int argc, char **argv)
 	char *name = NULL;
 	int types = 0;
 
-	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 5))
 		usage(cmd_get_usage);
 
 	parse_args(argc, argv, cmd_get_usage, &types, &object, &name, NULL);
@@ -417,7 +417,7 @@ static int cmd_set(int argc, char **argv)
 	char *value;
 	int types = 0;
 
-	if (check_argc_min(argc, 4) || check_argc_max(argc, 5))
+	if (check_argc_min(argc, 4) || check_argc_max(argc, 6))
 		usage(cmd_set_usage);
 
 	parse_args(argc, argv, cmd_set_usage, &types, &object, &name, &value);
@@ -437,7 +437,7 @@ static int cmd_list(int argc, char **argv)
 	char *object = NULL;
 	int types = 0;
 
-	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
 		usage(cmd_list_usage);
 
 	parse_args(argc, argv, cmd_list_usage, &types, &object, NULL, NULL);
-- 
1.9.1

