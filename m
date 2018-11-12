Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543CAC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 05:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1382F214F1
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 05:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tkR8cuq3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1382F214F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbeKLO4n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 09:56:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeKLO4n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 09:56:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAC4xUZr086867
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 05:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=y9My/nWHCl3DXEvtB1Xjv366BIus3VumiHg4nAtSMw4=;
 b=tkR8cuq31fB8ctdqaQhriQXaLEbx7Pr2blAibKAcqjS17eryvWF0mSMU/oRjnvtVAK7D
 jPpin1RBe994n1WR8SFSXoXoBExpbWo+h5tPWsiMj3Sca9ylZ9T2YN3JIJTx+JaR09hg
 6AJEuGhlpUVTAvPmxolFfW+AEHJ6i+U+4TxYRUqE6Fqu2StG3nrC4Uy1UrbAoLeFthkD
 g3v0RlKaFBH+5QWU3uSAIDMkyo80lybcuV25wlQBiFHTkb6RBIuIlsv22Sl/ODhTC8j0
 v4Cbon8a1RfSHAEmfgGtuEHs93lA3QqiHBpwMcZa5aNYu02L9OUSTd2O4cI40KtJLNb2 iw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nnw6eb8p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 05:05:12 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAC55A51016179
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 05:05:11 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAC55AYX007198
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 05:05:10 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 21:05:10 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove redundant replace_state init
Date:   Mon, 12 Nov 2018 13:05:15 +0800
Message-Id: <1541999115-10540-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9074 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=624
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811120046
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

dev_replace::replace_state has been set to
BTRFS_DEV_REPLACE_ITEM_STATE_NEVER_STARTED (0) in the same function,
So delete the line which sets replace_state = 0;

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cc25a34f87b0..cdc4313446a9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -59,7 +59,6 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 			BTRFS_DEV_REPLACE_ITEM_STATE_NEVER_STARTED;
 		dev_replace->cont_reading_from_srcdev_mode =
 		    BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_ALWAYS;
-		dev_replace->replace_state = 0;
 		dev_replace->time_started = 0;
 		dev_replace->time_stopped = 0;
 		atomic64_set(&dev_replace->num_write_errors, 0);
-- 
1.8.3.1

