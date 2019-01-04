Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703CCC43444
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 05:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 347392184B
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 05:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CG3NVTIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfADFcF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 00:32:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfADFcF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2019 00:32:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x045SwBI099147
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Jan 2019 05:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=ahp8A4coE+rO5ChJeKBvuYiRSnTmh2PIgZbwkKjYzgs=;
 b=CG3NVTIPpAlRXlmQ/ENQByA5yUmQwzCXHZfCC+5mQW1JUeDu7s4+tIvUKBf3Eq65P+uq
 SwYKm0W748A7hoCp+SZ3ptJ9K8po0DtVO6npIVYD6oh9td7XQxbk6CZ8YpNcm8dBIHnP
 zNdj50UpKAxX9ClFmNgLiNNtGA2eOgkW267t0ZIU+IMwm4zX4gVcKRshCt8liIyTRxqy
 l3G9JY2MjzqUjX/aDhl7izaeoB2xsbU4BSy+WzOaR2yYFNfAdkDygGgn2BXTNKQILPXa
 gMtTCE2aVj/8tnIl4aVhpOyyZVRbEwHNMi2IWE8JOcgGlJgIkJsl6nyjkKmx9mhOonNT NA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jrac8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jan 2019 05:32:03 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x045Vvd0000560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Jan 2019 05:31:57 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x045Vusu008437
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Jan 2019 05:31:57 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 21:31:56 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v14] Add cli and ioctl to forget scanned device(s)
Date:   Fri,  4 Jan 2019 13:31:51 +0800
Message-Id: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9125 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901040048
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v14:
 Splits refactoring part of btrfs_free_stale_devices() into a new patch

v13:
 Please ref individual patches.

v12:
  Fixed coding style - leave space between " : ".

v11:
 btrfs-progs: Bring the code into the else part of if(forget).
	      Use strerror to print the erorr instead of ret.

v10:
 Make btrfs-progs changes more readable.
 With an effort to keep the known bug [1] as it is..
  [1]
   The cli 'btrfs device scan --all /dev/sdb' which should have scanned
    only one device, ends up scanning all the devices and I am not trying
    to fix this bug in this patch because..
  . -d|--all is marked as deprecated, I hope -d option would go away
  . For now some script might be using this bug as a feature, and fixing
    this bug might lead to mount failure.

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

Anand Jain (2):
  btrfs: refactor btrfs_free_stale_devices() to get return value
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
