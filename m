Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47611C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B6682081B
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TwxpfJZZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B6682081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbeK2UaJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 15:30:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbeK2UaJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 15:30:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAT9OKWo180458
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=C+s9ePBssx/08tkNfpH9nrKdJZpVNISaOubyz5YIN3s=;
 b=TwxpfJZZTDgJnVc0WP61tHg5Oa5M7KGfwkvTOJ3HSCS7/qTAzcruxi3sO4fwj48P9t7Q
 U/ytCFG+1EyCLFAdfcq7ZKxTCnlkJ09hl0hLWChMz6wYSnX4itPZ6zkBryKrTXQK+QTU
 zbKDz1qyeIkq6WrqURmELbuSAp/8ZfcITnccpnMirjI8wWd8okZpz2CHctn49n4v5QBE
 ZMMxDEn0OZDFgMWaNsDeXzXzRVV5HGHTOhJFqGU07a0T2NEVwywjiKyfzVSXEuz0PCYG
 Q82v7UQYB5D2iH7mgTCaj/nc6rI41QZ0cCsBIBE2HI6snnIrCtEYAqjzsdfofvOhq7Zv cQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nxxkqq0bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:25 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAT9PO4O007792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:24 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAT9POaN026338
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:24 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 01:25:23 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: scrub: add scrub_lock lockdep check in scrub_workers_get
Date:   Thu, 29 Nov 2018 17:25:13 +0800
Message-Id: <1543483513-16724-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1543483513-16724-1-git-send-email-anand.jain@oracle.com>
References: <1543483513-16724-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9091 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811290082
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

scrub_workers_refcnt is protected by scrub_lock, add lockdep_assert_held()
function in scrub_workers_get().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Suggested-by: Nikolay Borisov <nborisov@suse.com>
---
v2: born
 fs/btrfs/scrub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9ade0659f017..84ef1f0d371e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3726,6 +3726,8 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	unsigned int flags = WQ_FREEZABLE | WQ_UNBOUND;
 	int max_active = fs_info->thread_pool_size;
 
+	lockdep_assert_held(&fs_info->scrub_lock);
+
 	if (fs_info->scrub_workers_refcnt == 0) {
 		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
 				flags, is_dev_replace ? 1 : max_active, 4);
-- 
1.8.3.1

