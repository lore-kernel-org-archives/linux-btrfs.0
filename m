Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33082 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaJBI1E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 04:27:04 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s928R2r3028683
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Oct 2014 08:27:02 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s928R1MA023061
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Oct 2014 08:27:02 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s928R151009440
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Oct 2014 08:27:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix uninitialized warining in btrfs_calc_stripe_index
Date: Thu,  2 Oct 2014 08:32:01 +0800
Message-Id: <1412209921-21002-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

chunk-recover.c: In function ‘btrfs_calc_stripe_index’:
chunk-recover.c:1481: warning: ‘index’ may be used uninitialized in this function

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 chunk-recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 209d7a7..5daffe3 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1478,7 +1478,7 @@ static int btrfs_calc_stripe_index(struct chunk_record *chunk, u64 logical)
 	u64 offset = logical - chunk->offset;
 	int stripe_nr;
 	int nr_data_stripes;
-	int index;
+	int index = 0;
 
 	stripe_nr = offset / chunk->stripe_len;
 	if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID0) {
-- 
2.0.0.153.g79dcccc

