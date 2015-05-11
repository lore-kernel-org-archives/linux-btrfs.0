Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47846 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbbEKNpZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 09:45:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/1] btrfs-progs: use the correct variable
Date: Mon, 11 May 2015 21:55:52 +0800
Message-Id: <1431352552-3391-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

its res instead of ret

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index cbb3243..1022656 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -183,7 +183,7 @@ static int cmd_rm_dev(int argc, char **argv)
 		if (res) {
 			const char *msg;
 
-			if (ret > 0)
+			if (res > 0)
 				msg = btrfs_err_str(res);
 			else
 				msg = strerror(e);
-- 
1.7.1

