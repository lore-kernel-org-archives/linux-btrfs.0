Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30164 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3BAH63 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 02:58:29 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 06/13] Btrfs-progs: put find_mount_root() in commands.h
Date: Fri,  1 Feb 2013 15:56:25 +0800
Message-Id: <1359705392-7485-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A useful function need to define it in a header file.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 commands.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/commands.h b/commands.h
index 61d74d7..1dd6180 100644
--- a/commands.h
+++ b/commands.h
@@ -105,3 +105,6 @@ int cmd_replace(int argc, char **argv);
 
 /* subvolume exported functions */
 int test_issubvolume(char *path);
+
+/* send.c */
+int find_mount_root(const char *path, char **mount_root);
-- 
1.8.1.227.g44fe835

