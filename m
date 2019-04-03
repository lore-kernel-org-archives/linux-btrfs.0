Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C187C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05D9A206DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JuSBdqTQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfDCQvv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 12:51:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44500 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfDCQvv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 12:51:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33Ghur8136788;
        Wed, 3 Apr 2019 16:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=rBdb/DYjiT4NRYx2+9hjID/jlfP/pcuSin7YjI8MtBk=;
 b=JuSBdqTQR/6nsCBMFnBaCAfZQFwvIx9LfRmVT3+Vg6JJw1CoidS7AQH45xjHB+BtjVFP
 yKu/eOdr8MSgdalp1XGvGBiVmFnTUqaHI/alZIeiluKO8UfTkUs91hM16Y6SzXRMHqfO
 afbqgWuX6QGlFiA2tmqZBeISY/LUG3IoRIkJ2hAWS7iHWSsfmddV33pPyEgvb/YR3bzP
 LC8FuyqpwHIrqQWsIZWS4sHovCbVYHlVrh6kG1tT4yZh1reoAbNLgPle1i6uxllceuoB
 fAF9biqtwbeUS46jQq93kcn4vLPwwKvRGCBOHYEpsw3IMjDaQ13pptcCouRlPWpd3pdK ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2rhwydaey6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33GpjGs172166;
        Wed, 3 Apr 2019 16:51:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rm8f678mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x33Gpiq0032111;
        Wed, 3 Apr 2019 16:51:44 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 09:51:43 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [PATCH 0/4] property fixes and cleanups
Date:   Thu,  4 Apr 2019 00:51:30 +0800
Message-Id: <20190403165134.12378-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030114
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030114
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Both mainline and misc-5.2 fails the test case that transaction 
generation number must be unaltered if the property validation fails.

For example:
btrfs in dump-super /dev/sdb | grep ^generation; \
btrfs prop set /btrfs compression lz; sync; \
btrfs in dump-super /dev/sdb | grep ^generation
generation		53
ERROR: failed to set compression for /btrfs: Invalid argument
generation		54

Which the patch in the mailing list fixes and based on misc-5.2
  [PATCH 4/4 RESEND] btrfs: fix property validate fail should not increment

But, now I notice that the reason for which the original code failed
is different from the reason for which misc-5.2 failed. Former failed
because the malformed 'lz' was only abled to be caught by handle->apply(),
and in latter we were calling the start_transaction() too early before the
handle->validation() which few of the patches in misc-5.1 did. My bad.

As per your misc-5.2 branch please drop the following patches as I have
better fixes as in this patch.

584aebf26bbf btrfs: merge btrfs_setxattr and do_setxattr
ab54ee38fff7 btrfs: don't create transaction in btrfs_setxattr
0cbf560f72e1 btrfs: start transaction in btrfs_xattr_handler_set
db0f220e98eb btrfs: start transaction in btrfs_set_acl
56e9e992c00a btrfs: start transaction in btrfs_set_prop_trans
3e2299ea6a8b btrfs: refactor btrfs_set_prop and add btrfs_set_prop_trans
737e67ce0f3f btrfs: merge _btrfs_set_prop helpers

And please apply the patches as in this set.

Anand Jain (4):
  btrfs: rename __btrfs_set_prop to btrfs_set_prop_trans
  btrfs: rename __btrfs_set_acl to do_set_acl
  btrfs: fix zstd compression parameter
  btrfs: fix vanished compression property after failed set

 fs/btrfs/acl.c   | 12 +++++-------
 fs/btrfs/props.c | 23 ++++++++++-------------
 2 files changed, 15 insertions(+), 20 deletions(-)

-- 
2.17.1

