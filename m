Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59618 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbeEQNWq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 09:22:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4HDLWjl129936
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 13:22:45 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hx29wh6e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 13:22:45 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4HDMj2G022161
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 13:22:45 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4HDMjuE006177
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 13:22:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix describe_relocation string pointer
Date: Thu, 17 May 2018 21:25:12 +0800
Message-Id: <20180517132512.16377-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like the original idea was to print the hex of the flags which
is not coded with their flag name. So use the current buf pointer bp
instead of buf.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 74656d79e511..879b76fa881a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4344,7 +4344,7 @@ static void describe_relocation(struct btrfs_fs_info *fs_info,
 		DESCRIBE_FLAG(RAID5,    "raid5");
 		DESCRIBE_FLAG(RAID6,    "raid6");
 		if (flags)
-			snprintf(buf, buf - bp + sizeof(buf), "|0x%llx", flags);
+			snprintf(bp, buf - bp + sizeof(buf), "|0x%llx", flags);
 #undef DESCRIBE_FLAG
 	}
 
-- 
2.15.0

