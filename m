Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50967 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3A1FQd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 00:16:33 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 07/10] Btrfs-progs: put find_mount_root() in commands.h
Date: Mon, 28 Jan 2013 13:22:36 +0800
Message-Id: <1359350559-25671-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359350559-25671-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359350559-25671-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A useful function need to define it in a header file.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 commands.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/commands.h b/commands.h
index 8114a73..9b77f3e 100644
--- a/commands.h
+++ b/commands.h
@@ -103,3 +103,6 @@ int cmd_qgroup(int argc, char **argv);
 
 /* subvolume exported functions */
 int test_issubvolume(char *path);
+
+/* send.c */
+int find_mount_root(const char *path, char **mount_root);
-- 
1.8.1.227.g44fe835

