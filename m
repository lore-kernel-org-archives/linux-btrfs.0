Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20697 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbKYMI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:56 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 4/7] btrfs-progs: check for numerical in version_to_code()
Date: Wed, 25 Nov 2015 20:08:17 +0800
Message-Id: <1448453300-8449-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As the version is now being passed by user it should be checked
if its numerical. We didn't need this before as version wasn't
passed by used. So this is not a bug fix.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index 0e66e2b..216efa6 100644
--- a/utils.c
+++ b/utils.c
@@ -3119,14 +3119,18 @@ static int version_to_code(char *v)
 
 	for (b[i] = strtok_r(v, ".", &save_b);
 		b[i] != NULL;
-		b[i] = strtok_r(NULL, ".", &save_b))
+		b[i] = strtok_r(NULL, ".", &save_b)) {
+		if (!is_numerical(b[i]))
+			return -EINVAL;
 		i++;
+	}
 
+	if (b[1] == NULL)
+		return KERNEL_VERSION(atoi(b[0]), 0, 0);
 	if (b[2] == NULL)
 		return KERNEL_VERSION(atoi(b[0]), atoi(b[1]), 0);
-	else
-		return KERNEL_VERSION(atoi(b[0]), atoi(b[1]), atoi(b[2]));
 
+	return KERNEL_VERSION(atoi(b[0]), atoi(b[1]), atoi(b[2]));
 }
 
 static int get_kernel_code()
-- 
2.6.2

