Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23A0C282E4
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 907F320645
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZHEpzOv2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfDTLtO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40288 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfDTLtO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmtKn057486
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=uetZePFK2LeoraTa8wma1voZJyuxEjJbBhCPuRdLeEc=;
 b=ZHEpzOv29yt3ufXjPqV6r9X+PEwOPkVfLRYhTZtGxNrfnsIFEQFviFmG3yeWvEnaKo0H
 Yt2eSSc22bE7uVuEHrBwWm9uZ0+Lu+PfAPmZjutTyELd8Pb3ykvn2IY5UepxPjgbtw6K
 L0voO35bR4GPTA8oC2VeKErCZgG1eivdWG9f5gFiEpQ3tTbneS2VEdbTGQN3y5MXEL6p
 40rRcN7MEZewHFCWid0hoVb1PjaRg6Kt2AZ/O7uJa8lU+HvYaxu+9BQkNAn2o7foUzFx
 etBELnHFlAFkfw9UyiLBRbVjBYrdVGIBmCuwDgld+xa4lWaguyQ59lBWIhef+sljKYJg mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ryv2prrjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBnC9I002739
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ryrhqxf53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:12 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3KBnB0F016620
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:11 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:11 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 02/10] btrfs: export btrfs_set_prop
Date:   Sat, 20 Apr 2019 19:48:52 +0800
Message-Id: <20190420114900.15472-3-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190420114900.15472-1-anand.jain@oracle.com>
References: <20190420114900.15472-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Make btrfs_set_prop() a non static function, so that it can be called
from btrfs_ioctl_setflags(). We need btrfs_set_prop() instead of
btrfs_set_prop_trans() so that we can use the transaction which is
already started in the current thread.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 6 +++---
 fs/btrfs/props.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index e356dd2a0f73..aedf5a7d69c9 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -72,9 +72,9 @@ int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
 	return handler->validate(value, value_len);
 }
 
-static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
-			  const char *name, const char *value, size_t value_len,
-			  int flags)
+int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const char *value, size_t value_len,
+		   int flags)
 {
 	const struct prop_handler *handler;
 	int ret;
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 01d2c1899bc7..30b99348977d 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -12,6 +12,9 @@ void __init btrfs_props_init(void);
 
 int btrfs_set_prop_trans(struct inode *inode, const char *name,
 			 const char *value, size_t value_len, int flags);
+int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const char *value, size_t value_len,
+		   int flags);
 int btrfs_validate_prop(const char *name, const char *value, size_t value_len);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
-- 
2.20.1 (Apple Git-117)

