Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55319 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3JGGg0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 02:36:26 -0400
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 7 Oct 2013 16:36:24 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 13DE03578052
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 17:36:22 +1100 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r976JRGw57409540
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:19:27 +1100
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r976aKM1023232
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:36:20 +1100
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: btrfs_list_find_updated_files: Fix memory leak.
Date: Mon, 07 Oct 2013 12:06:11 +0530
Message-ID: <10157896.KS57RD9T2T@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current code returns from the function when the call to ioctl
fails. This may leak cache_dir_name and cache_full_name. Fix it.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 btrfs-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 9cadbf5..9411e4d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1686,7 +1686,7 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: can't perform the search- %s\n",
 				strerror(e));
-			return ret;
+			break;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
 		if (sk->nr_items == 0)
-- 
1.8.3.1


