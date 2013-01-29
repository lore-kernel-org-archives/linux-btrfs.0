Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35612 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3A2Gmw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:42:52 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 07/12] Btrfs-progs: put find_mount_root() in commands.h
Date: Tue, 29 Jan 2013 14:48:56 +0800
Message-Id: <1359442141-25498-8-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1359442141-25498-1-git-send-email-anand.jain@oracle.com>

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

