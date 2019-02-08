Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFD2C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC5C021917
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LfRsAEtG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfBHHCv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:02:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHCu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 02:02:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x186xeva159466
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=fj9NaoXNNq9Pzpg1XgjTOmzAalhivOtQ3SxhthjsvB4=;
 b=LfRsAEtG1zmuGy0RNdZfevpAe7U6LRxv6bAPcWm8fbi9UZEnl9pyPt1e6PUfjl4UXgkW
 9TZHydvmz/gGWZJ+n2NXCpL9nN1vpkwkir4EAoxf7ImLgwO0kMU0wTMSKC4evU0chAq+
 FdWqy3BQmnP7oI+pNazs+XP04rmiWIZJJA9ipqfTWcAX7JzOQm+5cx3BzRQmp5DVQfDz
 NE9zGvuqkqUC7hBr8bilg7MHSOEbfGWfL4f7APKBQgk1PbmYBs8jUl89Xx56DLBEtvaA
 JMf3lgLkNzIaq/vdIwkR+o0AdH6k/knlDPRhnqPjUmJwHIxS3Dtd7SEq4WqeEpqoVsJm Ag== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qd9artxwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 07:02:49 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1872mGA023905
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:49 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1872mNK021500
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:48 GMT
Received: from tpasj.sg.oracle.com (/10.186.49.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 23:02:48 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs: fix comment its device list mutex not volume lock
Date:   Fri,  8 Feb 2019 15:02:31 +0800
Message-Id: <1549609355-11053-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
References: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902080051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have killed volume mutex (commit: dccdb07bc996
btrfs: kill btrfs_fs_info::volume_mutex) update comment. This a trival one
seems to have escaped.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fe122e6099ae..8160749cd9ba 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1129,7 +1129,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	mutex_lock(&orig->device_list_mutex);
 	fs_devices->total_devices = orig->total_devices;
 
-	/* We have held the volume lock, it is safe to get the devices. */
+	/* We have held the device_list_mutex, it is safe to get the devices. */
 	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
 		struct rcu_string *name;
 
-- 
1.8.3.1

