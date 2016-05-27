Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59038 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932077AbcE0Huj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 03:50:39 -0400
Received: from pps.filterd (m0049461.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4R7n7I1033516
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:50:38 -0400
Message-Id: <201605270750.u4R7n7I1033516@mx0a-001b2d01.pphosted.com>
Received: from e28smtp09.in.ibm.com (e28smtp09.in.ibm.com [125.16.236.9])
	by mx0a-001b2d01.pphosted.com with ESMTP id 236ayma0j0-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:50:37 -0400
Received: from localhost
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Fri, 27 May 2016 13:20:34 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id AFD9A394005E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 13:20:31 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4R7oGcK19661182
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 13:20:16 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4R7kjps007781
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 13:20:29 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH 1/5] Btrfs: test_check_exists: Fix infinite loop when searching for free space entries
Date: Fri, 27 May 2016 15:00:34 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>

On a ppc64 machine using 64K as the block size, assume that the RB
tree at btrfs_free_space_ctl->free_space_offset contains following
two entries:

1. A bitmap entry having an offset value of 0 and having the bits
   corresponding to the address range [128M+512K, 128M+768K] set.
2. An extent entry corresponding to the address range
   [128M-256K, 128M-128K]

In such a scenario, test_check_exists() invoked for checking the
existence of address range [128M+768K, 256M] can lead to an
infinite loop as explained below:

- Checking for the extent entry fails.
- Checking for a bitmap entry results in the free space info in
  range [128M+512K, 128M+768K] beng returned.
- rb_prev(info) returns NULL because the bitmap entry starting from
  offset 0 comes first in the RB tree.
- current_node = bitmap node.
- while (current_node)
    tmp = rb_next(bitmap_node);/*tmp is extent based free space entry*/
    Since extent based free space entry's last address is smaller
    than the address being searched for (i.e. 128M+768K) we
    incorrectly again obtain the extent node as the "next right node"
    of the RB tree and thus end up looping infinitely.

This patch fixes the issue by updating "info" variable to point to
the most recently searched free space node.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/free-space-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5e6062c..05c9ef8 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3662,6 +3662,7 @@ have_info:
 			if (tmp->offset + tmp->bytes < offset)
 				break;
 			if (offset + bytes < tmp->offset) {
+				info = tmp;
 				n = rb_prev(&info->offset_index);
 				continue;
 			}
@@ -3676,6 +3677,7 @@ have_info:
 			if (offset + bytes < tmp->offset)
 				break;
 			if (tmp->offset + tmp->bytes < offset) {
+				info = tmp;
 				n = rb_next(&info->offset_index);
 				continue;
 			}
-- 
2.7.4

