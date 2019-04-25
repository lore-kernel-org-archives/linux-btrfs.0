Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347D5C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 11:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03FC2217FA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 11:55:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2o7j/YOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfDYLzb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:55:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54440 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfDYLza (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 07:55:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBs9AC067921
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:55:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=DQqfTQPW4O909lNypJ/V9UzMzLgE8M+nLrQAY9Sj9pc=;
 b=2o7j/YOBZUoMuoyoRS7WRL8kU3yPkRDrpFJpkzv5odqZHGrGfY7VMaSdTCYkNrQstNho
 bG1G0Mmx8jA6doRUhL89tHJ6BHP5TvDpvt7nGO1euCHZrE52n/wVi4f6BzwTIRnS9z93
 PLzEeNhiKbvZysK6eoQ5Gl5vPTyCyegFniPwq2OlwBoea1llXgS8aZtZEgg8PcNktThW
 yNw4ReY1dGxXpIb9ZokzlVyXeLI3cRcZDdUP2zU3JWddQOC+GveFOG0kDNi/6wh+HseB
 3yrLiosiFGAa76Vd4i/Q63C1Dn+pEc2bnqZm4N6vpnwAh98jN6oCaLsl89WEQYjGcmBv zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2ryrxd82eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:55:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBslRa136083
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:55:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2s0dwfbxcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:55:28 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3PBtRQc015791
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:55:27 GMT
Received: from dhcp-10-186-51-152.sg.oracle.com (/10.186.51.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 04:55:27 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] readmirror feature
Date:   Thu, 25 Apr 2019 19:55:21 +0800
Message-Id: <20190425115524.2482-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=811
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904250076
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=844 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904250076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

These patches are tested to be working fine.

Function call chain  __btrfs_map_block()->find_live_mirror() uses
thread pid to determine the %mirror_num when the mirror_num=0.

This patch introduces a framework so that we can add policies to determine
the %mirror_num. And adds the devid as the readmirror policy.

The property is stored as an extented attributes of root inode
(BTRFS_FS_TREE_OBJECTID).
User provided devid list is validated against the fs_devices::dev_list.

 For example:
   Usage:
     btrfs property set <mnt> readmirror devid<n>[,<m>...]
     btrfs property set <mnt> readmirror ""

   mkfs.btrfs -fq -draid1 -mraid1 /dev/sd[b-d] && mount /dev/sdb /btrfs
   btrfs prop set /btrfs readmirror devid1,2
   btrfs prop get /btrfs readmirror
    readmirror=devid1,2
   getfattr -n btrfs.readmirror --absolute-names /btrfs
    btrfs.readmirror="devid1,2"
   btrfs prop set /btrfs readmirror ""
   getfattr -n btrfs.readmirror --absolute-names /btrfs
    /btrfs: btrfs.readmirror: No such attribute
   btrfs prop get /btrfs readmirror

RFC->v1:
  Drops pid as one of the readmirror policy choices and as usual remains
  as default. And when the devid is reset the readmirror policy falls back
  to pid.
  Drops the mount -o readmirror idea, it can be added at a later point of
  time.
  Property now accepts more than 1 devid as readmirror device. As shown
  in the example above.

Anand Jain (3):
  btrfs: add inode pointer to prop_handler::validate()
  btrfs: add readmirror property framework
  btrfs: add readmirror devid property

 fs/btrfs/props.c   | 120 +++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/props.h   |   4 +-
 fs/btrfs/volumes.c |  25 +++++++++-
 fs/btrfs/volumes.h |   8 +++
 fs/btrfs/xattr.c   |   2 +-
 5 files changed, 150 insertions(+), 9 deletions(-)

Anand Jain (2):
  btrfs-progs: add helper to create xattr name
  btrfs-progs: add readmirror policy

 props.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 7 deletions(-)
-- 
2.20.1 (Apple Git-117)

