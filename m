Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A871DC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 709562086B
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lHMAgpby"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 709562086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbeKGVNh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeKGVNh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7BdEup167014
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=sWmzxOZnNYJ3EIsm9AfE8/LtH/HU9s8kDFJu4cFjkH4=;
 b=lHMAgpbyzW02ZE3KoGPijGNj9hyI0Mp3Edg49waOSwMrlZg0E0kV/FzjXys2hyzeop8r
 NdWAdtnrocIH8pb947qYcn6ibBraUEerf2KQXrweTDu3r+K+ix17GusW7tylnwLs3tJe
 NMC03emuHkZbbM+QSoaZegQsYI3gx3Y9ZhZ42bdZUucZydk9ingDbKhIiMZfOCygRAPd
 p1H/RXaqWuhIKHX63c6W+Z9hCDpf0AAG7qZmPdVDsT16R0pmoEjLbkWUBDyrf3JA9c8n
 4gHAkG3R6snmZbgCDbxDtD67vUIf2lt4EMelFQh52YFgHhc9lIO3T7/wT6r1ujYI2piN EQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nh3mpty7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:36 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhaKW013225
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:36 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA7Bha69005507
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:36 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:35 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] btrfs: replace go back to suspended if target missing
Date:   Wed,  7 Nov 2018 19:43:23 +0800
Message-Id: <1541591010-29789-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=770
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

At the time of forced unmount we place the running replace to
BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED state, so when the system comes
back and suppose the target device is missing, then let the replace
state continue to be in BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED state
instead of BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED as there isn't any
matching scrub running as part of replace.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 59991165e126..47d6768a9cde 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -884,6 +884,9 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 			   "cannot continue dev_replace, tgtdev is missing");
 		btrfs_info(fs_info,
 			   "you may cancel the operation after 'mount -o degraded'");
+		dev_replace->replace_state =
+					BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
+		dev_replace->item_needs_writeback = 1;
 		btrfs_dev_replace_write_unlock(dev_replace);
 		return 0;
 	}
-- 
1.8.3.1

