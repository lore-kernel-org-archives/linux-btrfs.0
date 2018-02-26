Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38112 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbeBZCqj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Feb 2018 21:46:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1Q2kamX077291
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 02:46:37 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2gc950g2a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 02:46:35 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1Q2jccS027980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 02:45:38 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1Q2jb3k002066
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 02:45:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: verify max_inline mount parameter
Date: Mon, 26 Feb 2018 10:47:04 +0800
Message-Id: <20180226024704.15567-1-anand.jain@oracle.com>
In-Reply-To: <20180215164338.GC10193@twin.jikos.cz>
References: <20180215164338.GC10193@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't verifying the parameter passed to the max_inline mount option.
So we won't fail the mount if a junk value is specified, for example,
-o max_inline=abc. This patch checks if input is valid.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: Handle parameter with unit, such as 4K. Use memparse() 2nd arg.
v1->v2: use match_int ret value if error
        use %u instead of %d for parser

 fs/btrfs/super.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 77e0537e1db5..76b58da8d56d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -605,7 +605,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_max_inline:
 			num = match_strdup(&args[0]);
 			if (num) {
-				info->max_inline = memparse(num, NULL);
+				char *retptr;
+
+				info->max_inline = memparse(num, &retptr);
+				if (*retptr != '\0') {
+					ret = -EINVAL;
+					kfree(num);
+					goto out;
+				}
 				kfree(num);
 
 				if (info->max_inline) {
-- 
2.15.0

