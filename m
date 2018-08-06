Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbeHFDMy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2018 23:12:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7613xR2085955
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 01:06:17 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2kn43njrpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Aug 2018 01:06:17 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7616GjX019611
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 01:06:16 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7616GFx030177
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 01:06:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND v8] Add cli and ioctl to forget scanned device(s)
Date: Mon,  6 Aug 2018 09:09:47 +0800
Message-Id: <20180806010949.26915-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[applies on misc-next and for-next-20180801]

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

 cmds-device.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |  2 ++
 2 files changed, 60 insertions(+)

-- 
2.7.0

