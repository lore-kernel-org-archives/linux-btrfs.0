Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbDMM22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 08:28:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/1] btrfs-progs: improve troubleshooting avoid duplicate error strings
Date: Mon, 13 Apr 2015 20:37:01 +0800
Message-Id: <1428928621-8001-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

my troubleshooting experience says have unique error string per module.

In the below eg, its one additional step to know error line,

cat -n cmds-device.c | egrep "error removing the device"
   185	"ERROR: error removing the device '%s' - %s\n",
   190	"ERROR: error removing the device '%s' - %s\n",

which is completely avoidable.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index 1c72e90..1c32771 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -187,7 +187,7 @@ static int cmd_rm_dev(int argc, char **argv)
 			ret++;
 		} else if (res < 0) {
 			fprintf(stderr,
-				"ERROR: error removing the device '%s' - %s\n",
+				"ERROR: ioctl error removing the device '%s' - %s\n",
 				argv[i], strerror(e));
 			ret++;
 		}
-- 
2.0.0.153.g79dcccc

