Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD26C6786F
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 04:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 042172086A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 04:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pO0oe7Xt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 042172086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbeJLLhJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 07:37:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbeJLLhJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 07:37:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9C444Et100561
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=mY4dhA4EBTrZ8eHSrJPemOH5JJWqSHukfsO9RoFu8FE=;
 b=pO0oe7XtceZKX+xTG1xbCxif/hPp7dqMZDJbbnlaw4P22pI+cdKF/75n8c8eID8/hGg4
 fMYUUCMxIOI5qJVvNUGlAqhxN3DzmBv0nOcsX4+OvAc++asUA/cE+BXFkERm6UBMEuJr
 b7wpziO20fJkJ+ImKy71oVlN4ki6c2wPZY6aun4+zWKtAt7UKatZmk6Vsi5h/Oiu1KEh
 VFnUs7c0nob04UxjLbog77DMpEf6GGbaqlifi+Vshvm2NXQOA/F127BxPEVYEEmBPk9Q
 zw7mqS/uCBmPTli3Q8K7FRD6Pq/WE4dBvPUN427tznDV992fpK2/xrtmJ+AjHu4mZLKQ 8g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mxn0qg48k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9C46fBh014474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:42 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9C46fTM005792
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:41 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Oct 2018 04:06:40 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v9] Add cli and ioctl to forget scanned device(s)
Date:   Fri, 12 Oct 2018 12:06:28 +0800
Message-Id: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9043 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=872
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810120040
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v9:
 Make forget as a btrfs device scan option.
 Use forget in the fstests, now you can run fstests with btrfs as rootfs
  which helps to exercise the uuid_mutex lock.

v8:
 Change log update in the kernel patch.

v7:
 Use struct btrfs_ioctl_vol_args (instead of struct
  btrfs_ioctl_vol_args_v2) as its inline with other ioctl
  btrfs-control
 The CLI usage/features remains same. However internally the ioctl flag
  is not required to delete all the unmounted devices. Instead leave
  btrfs_ioctl_vol_args::name NULL.

v6:
 Use the changed fn name btrfs_free_stale_devices().

 Change in title:
 Old v5:
 Cover-letter:
  [PATCH v5] Add cli and ioctl to ignore a scanned device
 Kernel:
  [PATCH v5] btrfs: introduce feature to ignore a btrfs device
 Progs:
  [PATCH v5] btrfs-progs: add 'btrfs device ignore' cli

v5:
  Adds feature to delete all stale devices
  Reuses btrfs_free_stale_devices() fn and so depends on the
    patch-set [1] in the ML.
  Uses struct btrfs_ioctl_vol_args_v2 instead of
    struct btrfs_ioctl_vol_args as arg
  Does the device path matching instead of btrfs_device matching
    (we won't delete the mounted device as btrfs_free_stale_devices()
    checks for it)
v4:
  No change. But as the ML thread may be confusing, so resend.
v3:
  No change. Send to correct ML.
v2:
  Accepts review from Nikolay, details are in the specific patch.
  Patch 1/2 is renamed from
    [PATCH 1/2] btrfs: refactor btrfs_free_stale_device() to get device list delete
  to
    [PATCH 1/2] btrfs: add function to device list delete

Adds cli and ioctl to forget a scanned device or forget all stale
devices in the kernel.


Anand Jain (1):
  btrfs: introduce feature to forget a btrfs device

 fs/btrfs/super.c           | 3 +++
 fs/btrfs/volumes.c         | 9 +++++++++
 fs/btrfs/volumes.h         | 1 +
 include/uapi/linux/btrfs.h | 2 ++
 4 files changed, 15 insertions(+)

Anand Jain (1):
  btrfs-progs: add cli to forget one or all scanned devices

 cmds-device.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 ioctl.h       |  2 ++
 2 files changed, 56 insertions(+), 9 deletions(-)

[1]
Anand Jain (1):
  fstests: btrfs use forget if not reload

 common/btrfs    | 20 ++++++++++++++++++++
 tests/btrfs/124 |  6 +++---
 tests/btrfs/125 |  6 +++---
 tests/btrfs/154 |  6 +++---
 tests/btrfs/164 |  4 ++--
 5 files changed, 31 insertions(+), 11 deletions(-)

-- 
1.8.3.1

