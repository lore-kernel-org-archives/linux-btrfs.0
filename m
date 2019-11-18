Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D509C432C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 552A720740
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YUsBZcKJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKRIrO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:47:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48070 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfKRIrO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Nov 2019 03:47:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAI8i45L105142
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2019 08:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=HbAZ4jOO+LFC47kfgfDx00PWYczBj3E1aFUNOb9j2W4=;
 b=YUsBZcKJKmrh02eZJ8rVbZtQFzoyx9FJ8wAVEbkqvM5eJGaKM7bmBWBsJ0XpiJazemjR
 X0jARx6KkktVdXqTObK069v1XYrkWuH+AoSAPOwaYAKzYRYDHaZ5NkYMKEzaFC4QYDPi
 Z83pxtLuMC3+gfx0FIMeyvWhn31dO4oX0+GLJ0KDYGq0GeRAktqbFz5Bb6JoqGpUY1ul
 6CaI/97HvKyLuigyBZU1Ks15fuhwLFMoI3KiacTNStU2TuSQENa/IJ8jgMN1UD6EUVTU
 MpxtYOBRI7Qzp6mkcjvQgmCwhQm9iuvSCD1rnjeKf4Y0WLxK3huiE/9NpXCoTtby6Bq5 CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8htenq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2019 08:47:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAI8iIvS152679
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2019 08:47:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2watmr3fyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2019 08:47:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAI8lBn6018823
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2019 08:47:11 GMT
Received: from mb.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 00:47:10 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 04/15] btrfs: sysfs, move declared struct near its use
Date:   Mon, 18 Nov 2019 16:46:45 +0800
Message-Id: <20191118084656.3089-5-anand.jain@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191118084656.3089-1-anand.jain@oracle.com>
References: <20191118084656.3089-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=778
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=838 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180079
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Move struct btrfs_feature_attr and struct raid_kobject near functions
and defines where its used. No functional change.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 1d58187a6b33..d54777d5c78e 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -19,18 +19,6 @@
 #include "space-info.h"
 #include "block-group.h"
 
-struct btrfs_feature_attr {
-	struct kobj_attribute kobj_attr;
-	enum btrfs_feature_set feature_set;
-	u64 feature_bit;
-};
-
-/* For raid type sysfs entries */
-struct raid_kobject {
-	u64 flags;
-	struct kobject kobj;
-};
-
 #define __INIT_KOBJ_ATTR(_name, _mode, _show, _store)			\
 {									\
 	.attr	= { .name = __stringify(_name), .mode = _mode },	\
@@ -49,6 +37,12 @@ struct raid_kobject {
 #define BTRFS_ATTR_PTR(_prefix, _name)					\
 	(&btrfs_attr_##_prefix##_##_name.attr)
 
+struct btrfs_feature_attr {
+	struct kobj_attribute kobj_attr;
+	enum btrfs_feature_set feature_set;
+	u64 feature_bit;
+};
+
 #define BTRFS_FEAT_ATTR(_name, _feature_set, _feature_prefix, _feature_bit)  \
 static struct btrfs_feature_attr btrfs_attr_features_##_name = {	     \
 	.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,			     \
@@ -394,6 +388,12 @@ static ssize_t global_rsv_reserved_show(struct kobject *kobj,
 }
 BTRFS_ATTR(allocation, global_rsv_reserved, global_rsv_reserved_show);
 
+/* For raid type sysfs entries */
+struct raid_kobject {
+	u64 flags;
+	struct kobject kobj;
+};
+
 #define to_space_info(_kobj) container_of(_kobj, struct btrfs_space_info, kobj)
 #define to_raid_kobj(_kobj) container_of(_kobj, struct raid_kobject, kobj)
 
-- 
2.23.0

