Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60987 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3FJM7H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 08:59:07 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CA1389A0368
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 06:59:06 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id kUWNkHsihDDt7YVH (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 06:59:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: free csums when we're done scrubbing an extent
Date: Mon, 10 Jun 2013 08:59:04 -0400
Message-ID: <1370869144-1524-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported scrub taking up an unreasonable amount of ram as it ran.  This
is because we lookup the csums for the extent we're scrubbing but don't free it
up until after we're done with the scrub, which means we can take up a whole lot
of ram.  This patch fixes this by dropping the csums once we're done with the
extent we've scrubbed.  The user reported this to fix their problem.  Thanks,

Reported-and-tested-by: Remco Hosman <remco@hosman.xs4all.nl>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/scrub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d485055..63144e4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2499,6 +2499,7 @@ again:
 			if (ret)
 				goto out;
 
+			scrub_free_csums(sctx);
 			if (extent_logical + extent_len <
 			    key.objectid + bytes) {
 				logical += increment;
-- 
1.7.11.4

