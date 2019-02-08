Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E34C282CB
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20FD821917
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FdVmqnxN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfBHHCy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:02:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfBHHCx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 02:02:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x186wxQC163043
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=u15wczotaJo4jpznpYJrbHEo+19ugVD4Kytc305/BKQ=;
 b=FdVmqnxNlDPVtwsutQ+HSUuJk3pmdOg0J+kux145/iqesykh+h3cd/bznftILmi2/ixj
 1qlts7aUF4LkB/8iwU9GFTE8VAN0Nl6caXdlr9bX/5bbYQuZiXWsYevhy3JolIZ5pTv+
 d+ZwEMaid7IGeZVNV4mMDgbEJ55jd0eeW4LsIzx0kFr92G5BatagrjftrOVzFNbfWaJ+
 aflUnDPJECSMIO79xPB2RfRLfVL7ntl3y5gGcw0QtsQP+dVeaJvX/xYwVfG4Gn5whGeP
 sFgR06lSCIwO81F1W2MXBKLPNcQmexRNhlYRLdPcPP/kfq+/Tzt64z3GtEmGeg4Pt29s Gg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qd98njy54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 07:02:52 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1872qrc023988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:52 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1872pAf026098
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:51 GMT
Received: from tpasj.sg.oracle.com (/10.186.49.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 23:02:51 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs: drop redundant forward declaration in props.c
Date:   Fri,  8 Feb 2019 15:02:34 +0800
Message-Id: <1549609355-11053-5-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
References: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=987 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902080051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Drop forward declaration of the functions,
prop_compression_validate(), prop_compression_apply() and
prop_compression_extract().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 6f52e3d21012..77a03076b18e 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -23,12 +23,6 @@ struct prop_handler {
 	int inheritable;
 };
 
-static int prop_compression_validate(const char *value, size_t len);
-static int prop_compression_apply(struct inode *inode,
-				  const char *value,
-				  size_t len);
-static const char *prop_compression_extract(struct inode *inode);
-
 static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
 {
 	struct hlist_head *h;
-- 
1.8.3.1

