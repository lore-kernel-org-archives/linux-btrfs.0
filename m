Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FE3C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 04:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 419B1214F1
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 04:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GiQ2nEPY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 419B1214F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbeKLOuZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 09:50:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730406AbeKLOuZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 09:50:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAC4s5Ea116929
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 04:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Rb1Wu3lKmX1iKxx6wzvGJtow2fPGgERaEGYup7Rzx34=;
 b=GiQ2nEPYkaaxntQnjgvRc6xxHlDcerLLr92RR0NpKupvs27AkB0NEWjRx4hhOizFvKUe
 qe0G+nAzcNWsPQMzvao2Xz4bya3cwDDqWYuiP4CoKvy1/vGkyEsz9bIIHVRE34QpaN+v
 dyB+ThHHrl/D2Nnm26EeiVBVegEPSvRWJO1vgH88z48L0tqN9YhD568RPtoSsylK7wk/
 qF4KHEXORqq7Bc7IeNxH97SdDt1lpxHljoDCzJ8IWiTeMHPyvd1Cmn9l0BwJNX82B03l
 qMYmyQDRYKcq0ajn8R0RG2FJC5MbxEMkAB/lElCfFI7i+NeAxnSmLiDKLVHPQvyveCrM Og== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nnwg135p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 04:58:55 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAC4wnYB015666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 04:58:50 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAC4wnSI026960
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 04:58:49 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 20:58:49 -0800
From:   Anand Jain <anand.jain@oracle.com>
Subject: [RFC] BTRFS_DEV_REPLACE_ITEM_STATE_* doesn't match with on disk
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <e932064c-6182-a87c-3475-bf1765b165bc@oracle.com>
Date:   Mon, 12 Nov 2018 12:58:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9074 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=880
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811120045
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


The dev_replace_state defines are miss matched between the
BTRFS_IOCTL_DEV_REPLACE_STATE_* and BTRFS_DEV_REPLACE_ITEM_STATE_* [1].

[1]
-----------------------------
btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED		2
btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED		3
btrfs.h:#define BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED		4

btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED	2
btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED	3
btrfs_tree.h:#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED	4
-----------------------------

The BTRFS_DEV_REPLACE_ITEM_STATE_* series is unused in both btrfs.ko and 
btrfs-progs, the on-disk also follows BTRFS_IOCTL_DEV_REPLACE_STATE_* 
(we set dev_replace->replace_state using the
BTRFS_IOCTL_DEV_REPLACE_STATE_* defines and write to the on-disk).

  359         btrfs_set_dev_replace_replace_state(eb, ptr,
  360                 dev_replace->replace_state);

IMO it should be ok to delete the BTRFS_DEV_REPLACE_ITEM_STATE_*
altogether? But how about the userland progs other than btrfs-progs?
If not at least fix the miss match as in [2], any comments?

[2]
--------------------------------------
diff --git a/include/uapi/linux/btrfs_tree.h 
b/include/uapi/linux/btrfs_tree.h
index aff1356c2bb8..9ffa7534cadf 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -805,9 +805,9 @@ struct btrfs_dev_stats_item {
  #define BTRFS_DEV_REPLACE_ITEM_CONT_READING_FROM_SRCDEV_MODE_AVOID     1
  #define BTRFS_DEV_REPLACE_ITEM_STATE_NEVER_STARTED     0
  #define BTRFS_DEV_REPLACE_ITEM_STATE_STARTED           1
-#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED         2
-#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED          3
-#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED          4
+#define BTRFS_DEV_REPLACE_ITEM_STATE_FINISHED          2
+#define BTRFS_DEV_REPLACE_ITEM_STATE_CANCELED          3
+#define BTRFS_DEV_REPLACE_ITEM_STATE_SUSPENDED         4

  struct btrfs_dev_replace_item {
         /*
--------------------------------------


Thanks, Anand
