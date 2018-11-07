Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D983BC46464
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A201E2081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c9ScxHH1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A201E2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbeKGVNo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49482 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbeKGVNo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7Be0oE157649
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=l0x2wu2YY6If6JsdoR2fU50kb6//cEd1CpJuQ3R3TCw=;
 b=c9ScxHH1zmLM5896MYew9uvkoTpn39mHgPLoxp97R3EEA24i4ixev527wOA721Y/l3Wj
 0O15z/rPYqXpyAX+Sx/m8fYK5Bk1HLgJTrUDxCQCZ2FZtiAiAVRiJTztQSifoDzGboPP
 mjE0/lll/ofP6PIliHf/hATINrgPJpzU5x13IpRfkuqxiJ9IpXyO7k7PtwTXhbpEvyEr
 1W45JdKNZZifLWg907kWW3OLieZf6O59jYKlnOGzw6kNEforIkbpzWS0cArNp9sCGIgj
 k8m9PPbJsLPvqb6f1+OJb/B0UjSI8y5IsEh7GKsayvW80CE/Va3jXhk7M1zVYQB98RuV hg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nh33u2yq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA7Bhhru028846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:43 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA7Bhh69027514
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:43 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:42 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs: replace's scrub must not be running in replace suspended state
Date:   Wed,  7 Nov 2018 19:43:27 +0800
Message-Id: <1541591010-29789-7-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=603
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When the replace state is placed in the suspended state,
btrfs_scrub_cancel() should fail with -ENOTCONN as there is no
scrub running, as a safety catch check if btrfs_scrub_cancel()
returns -ENOTCONN and assert if it doesn't.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index c092ed559714..dae2b920f1a9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -831,7 +831,9 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 
 		btrfs_dev_replace_write_unlock(dev_replace);
 
-		btrfs_scrub_cancel(fs_info);
+		/* scrub for replace must not be running in suspended state */
+		if (btrfs_scrub_cancel(fs_info) != -ENOTCONN)
+			ASSERT(0);
 
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
-- 
1.8.3.1

