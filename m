Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44324 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3ITSWZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 14:22:25 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sat, 21 Sep 2013 04:22:23 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 786932BB0052
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Sep 2013 04:22:20 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8KI5jF22425102
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Sep 2013 04:05:46 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8KIMJh3019289
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Sep 2013 04:22:19 +1000
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org, sekharan@us.ibm.com
Subject: [PATCH v2] btrfs-progs: clear_extent_bits: Fix memory leak.
Date: Fri, 20 Sep 2013 23:52:11 +0530
Message-ID: <2008646.Qy2BWpenWU@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'prealloc' extent_state structure is leaked for the case when the 'desired
range' encapsulates/covers the 'extent range'.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
v1->v2: Fix commit message.
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


