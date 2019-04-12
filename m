Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D8BC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 05:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDA1920643
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 05:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1+qapQiK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfDLFYa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:24:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfDLFYa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 01:24:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C5OS1W166278;
        Fri, 12 Apr 2019 05:24:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=Q9NP0w+Mar9Alj4vkTb5z9pE9BGO3twN2QUdXwVPTtc=;
 b=1+qapQiKspAGkHhQ3Tw4cRH58ji9ZKCKTkkkBVYQOJeJIlM0Rd6Kzi3By90rwF3KRJPD
 0ppNzyJztRic93lVh7K4nI2ujNRGlVFkSozgWUoxv9zP5C+E1Td//NRwNGnQ82C9AhjG
 frzwms7DW6zhH4WDmf0G9+opLJORD45XsPGhG+9MSJgZOBdbGt7u66fPBevAsFWq1ON7
 lSSf+pPHU+Vt7pk+DasyZRdNNoSL0SUDSZCVIs3x2vT1799xfuMO7Gseep8DP3mhBZZm
 Vigxyo+8jgYDgZG8XnJuMThLZEAR+bcIbktlXPZeLMVuKOm5o4tRpRK5FDdpZF3m9JZd Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rpmrqmcgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 05:24:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C5O308001825;
        Fri, 12 Apr 2019 05:24:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2rtd84c9pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 05:24:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C5ORou004038;
        Fri, 12 Apr 2019 05:24:27 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Apr 2019 22:24:26 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] fstests: generic/077: fix populate fs use _fill_fs()
Date:   Fri, 12 Apr 2019 13:24:18 +0800
Message-Id: <20190412052418.22206-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120036
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120037
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Test case generic/077 uses files under /lib or /usr to fill SCRATCH_MNT.
If /usr or /lib is below 256mb then test fails to run, or if these dirs
are too large it takes a long time for the cp to finish. On my machine
it takes 645sec.

This patch propose to use the common/populate function _fill_fs() to
write files into the target directory instead. However I am not too
sure about the motivation of this test case in the first place, and
why does it wanted to cp /usr or /lib, and why fs should become full?
Any idea? Thanks.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/077     | 24 +++++-------------------
 tests/generic/077.out |  3 +--
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/tests/generic/077 b/tests/generic/077
index d11b49c6ff15..d8e5551f1925 100755
--- a/tests/generic/077
+++ b/tests/generic/077
@@ -14,18 +14,6 @@ here=`pwd`
 tmp=/tmp/$$
 status=1
 
-# Something w/ enough data to fill 256M of fs...
-filler=""
-[ -d /lib/modules ] && \
-	[ $(( $(du -h -m /lib/modules | tail -1| cut -f1) * 2 )) -ge 256 ] && \
-	filler=/lib/modules
-
-# fall back in case /lib/modules doesn't exist or smaller
-[[ -z $filler ]] && \
-	[ -d /usr ] && \
-	[ $(( $(du -h -m /usr | tail -1| cut -f1) * 2 )) -ge 256 ] && \
-	filler=/usr
-
 _cleanup()
 {
 	cd /
@@ -38,13 +26,12 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/filter
 . ./common/attr
+. ./common/populate
 
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
 
-[ ! -d $filler ] && _notrun "No directory at least 256MB to source files from"
-
 _require_scratch
 _require_attrs
 _require_acls
@@ -64,11 +51,10 @@ mkdir $SCRATCH_MNT/subdir
 echo "*** set default ACL"
 setfacl -R -dm u:fsgqa:rwx,g::rwx,o::r-x,m::rwx $SCRATCH_MNT/subdir
 
-echo "*** populate filesystem, pass #1" | tee -a $seqres.full
-cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
-
-echo "*** populate filesystem, pass #2" | tee -a $seqres.full
-cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
+blksz="$(_get_block_size $SCRATCH_MNT/subdir)"
+echo "*** populate filesystem" | tee -a $seqres.full
+echo "*** fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0" >> $seqres.full
+_fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0 >> $seqres.full 2>&1
 
 _check_scratch_fs
 
diff --git a/tests/generic/077.out b/tests/generic/077.out
index eae7226ab29c..9c143c902a2c 100644
--- a/tests/generic/077.out
+++ b/tests/generic/077.out
@@ -1,7 +1,6 @@
 QA output created by 077
 *** create filesystem
 *** set default ACL
-*** populate filesystem, pass #1
-*** populate filesystem, pass #2
+*** populate filesystem
 *** all done
 *** unmount
-- 
2.17.1

