Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:39749 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2G0KeE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 06:34:04 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <nasastry@in.ibm.com>;
	Fri, 27 Jul 2012 11:34:01 +0100
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6RAXvoN2773138
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 11:33:57 +0100
Received: from d06av12.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6RAXvex024598
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2012 04:33:57 -0600
From: Nageswara R Sastry <nasastry@in.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: chandanrmail@gmail.com
Subject: [PATCH] btrfs-progs: btrfs-image.c: Added NULL pointer check.
Date: Fri, 27 Jul 2012 16:04:14 +0530
Message-Id: <1343385254-8299-1-git-send-email-nasastry@in.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check for the return value of 'open_ctree()' before dereferencing it.

Signed-off-by: Nageswara R Sastry <nasastry@in.ibm.com>
---
 btrfs-image.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..2a33a55 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -491,6 +491,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	int ret;
 
 	root = open_ctree(input, 0, 0);
+	BUG_ON(!root);
 	BUG_ON(root->nodesize != root->leafsize);
 
 	ret = metadump_init(&metadump, root, out, num_threads,
-- 
1.7.11.1

