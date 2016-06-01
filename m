Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4554 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897AbcFALUM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 07:20:12 -0400
Received: from pps.filterd (m0075771.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51BJXCN004166
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 07:20:11 -0400
Message-Id: <201606011120.u51BJXCN004166@mx0a-001b2d01.pphosted.com>
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239svy930w-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 07:20:10 -0400
Received: from localhost
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 21:20:07 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 131E12BB006D
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 21:19:59 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51BJoCd6029768
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:58 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51BJP0e017813
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:26 +1000
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 1/8] Btrfs: test_check_exists: Fix infinite loop when searching for free space entries
Date: Wed,  1 Jun 2016 19:18:23 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>

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

This patch fixes the issue by checking the "tmp" variable which point
to the most recently searched free space node.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/free-space-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c6dc118..fa62335 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3662,7 +3662,7 @@ have_info:
 			if (tmp->offset + tmp->bytes < offset)
 				break;
 			if (offset + bytes < tmp->offset) {
-				n = rb_prev(&info->offset_index);
+				n = rb_prev(&tmp->offset_index);
 				continue;
 			}
 			info = tmp;
@@ -3676,7 +3676,7 @@ have_info:
 			if (offset + bytes < tmp->offset)
 				break;
 			if (tmp->offset + tmp->bytes < offset) {
-				n = rb_next(&info->offset_index);
+				n = rb_next(&tmp->offset_index);
 				continue;
 			}
 			info = tmp;
-- 
2.7.4

