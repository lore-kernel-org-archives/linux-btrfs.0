Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57481 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3ITRve (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 13:51:34 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 9020B9A0371
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 11:51:33 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id xVLgVdHkfQfdyvx2 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 11:51:32 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix the min ticks check in print_seek_histogram
Date: Fri, 20 Sep 2013 13:51:31 -0400
Message-ID: <1379699491-9060-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before I had been dividing by 5 but that gave me too much output so I changed it
to 20 without changing the min seeks test.  Fix this to avoid a divide by 0
problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-calc-size.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index ab942c6..b2c888c 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -228,7 +228,7 @@ static void print_seek_histogram(struct root_stats *stat)
 	u64 max_seek = stat->max_seek_len;
 	int digits = 1;
 
-	if (stat->total_seeks < 5)
+	if (stat->total_seeks < 20)
 		return;
 
 	while ((max_seek /= 10))
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kerne
