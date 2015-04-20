Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbbDTFdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 01:33:21 -0400
From: xuw2015@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>
Subject: [PATCH] btrfs-progs: fix btrfs quota rescan failed on PPC64 arch
Date: Mon, 20 Apr 2015 13:33:16 +0800
Message-Id: <1429507996-28224-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: George Wang <xuw2015@gmail.com>

PPC64 arch use such following IOC values "
\#define _IOC_NONE       1U
\#define _IOC_READ       2U
\#define _IOC_WRITE      4U
" comparing to the default IOC values "
\#define _IOC_NONE       0U
\#define _IOC_READ       2U
\#define _IOC_WRITE      1U"

This means the value "_IOW*" will be negative when we store it in the int
variables. Such as the "BTRFS_IOC_QGROUP_CREATE", it will be "0x4010942e" on
X86_64, but "0x8010942e" on PPC64.
Notice that the IOC values are the "unsigned long" type, so we use the
"unsigned long" to store it, and this can insure the comparison between the
variable and BTRFS_IOC_* valid.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 cmds-quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-quota.c b/cmds-quota.c
index 89cc89c..f6a1cfa 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -109,7 +109,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 	int e;
 	char *path = NULL;
 	struct btrfs_ioctl_quota_rescan_args args;
-	int ioctlnum = BTRFS_IOC_QUOTA_RESCAN;
+	unsigned long ioctlnum = BTRFS_IOC_QUOTA_RESCAN;
 	DIR *dirstream = NULL;
 	int wait_for_completion = 0;
 
-- 
1.9.3

