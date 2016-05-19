Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40800 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcESFNf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 01:13:35 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 3/3] btrfs-progs: clean up commands.h
Date: Thu, 19 May 2016 13:13:14 +0800
Message-Id: <1463634794-591-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
References: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is declared in utils.h so remove it
from commands.h
int test_issubvolume(const char *path);

This function does not exists delete the declaration
get_subvol_name(char *mnt, char *full_path);

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 commands.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/commands.h b/commands.h
index 2da093bf81a3..94229c112bc0 100644
--- a/commands.h
+++ b/commands.h
@@ -125,10 +125,4 @@ int cmd_dump_super(int argc, char **argv);
 int cmd_debug_tree(int argc, char **argv);
 int cmd_rescue(int argc, char **argv);
 
-/* subvolume exported functions */
-int test_issubvolume(const char *path);
-
-/* send.c */
-char *get_subvol_name(char *mnt, char *full_path);
-
 #endif
-- 
2.7.0

