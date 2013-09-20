Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39900 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3ITR7k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 13:59:40 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 20 Sep 2013 23:29:37 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id F17C91258051
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 23:29:44 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8KHxXnO48431194
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 23:29:33 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8KHxZnu020294
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 23:29:35 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com
Subject: [PATCH] btrfs-progs: clear_extent_bits: Fix memory leak.
Date: Fri, 20 Sep 2013 23:29:33 +0530
Message-ID: <14081838.aIEpgWmujO@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'prealloc' extent_state structure is leaked for the case when an 'extent
range' encapsulates/covers the 'desired range'.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 extent_io.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index acc4702..1c481d5 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -210,9 +210,11 @@ int clear_extent_bits(struct extent_io_tree *tree, u64 start,
 	int set = 0;
 
 again:
-	prealloc = alloc_extent_state();
-	if (!prealloc)
-		return -ENOMEM;
+	if (!prealloc) {
+		prealloc = alloc_extent_state();
+		if (!prealloc)
+			return -ENOMEM;
+	}
 
 	/*
 	 * this search will find the extents that end after
-- 
1.8.3.1


