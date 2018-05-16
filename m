Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:11786 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbeEPIGu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 04:06:50 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A287DAC0264
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 17:06:47 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id F2CD46926E4
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 17:06:46 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 0/2] btrfs: sysfs: Add entry which shows rmdir(2) can work for subvolume
Date: Wed, 16 May 2018 17:09:25 +0900
Message-ID: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[based on current misc-next]

-----
changelog
  v1 -> v2
    - Explicitly set start of enum btrfs_feature_set as 0 in 1st patch
    - Create new sysfs group which shows static feature (i.e. features
      which only depends on kernel version). See 2nd path.
-----

This adds new sysfs entry
  /sys/fs/btrfs/static_features/rmdir_subvol
to indicate that the kernel can delete a subvolume by rmdir(2),
which is allowed by: https://www.spinics.net/lists/linux-btrfs/msg76938.html

The aim of adding a entry is to enable a user program (e.g. xfstest)
to detect a feature.

The first patch is a cleanup and the second one is a main part.

Tomohiro Misono (2):
  btrfs: sysfs: Use enum/define value intead of magic number
  btrfs: sysfs: Add entry which shows rmdir(2) can work for subvolume

 fs/btrfs/sysfs.c | 40 +++++++++++++++++++++++++++++++++++-----
 fs/btrfs/sysfs.h |  4 ++--
 2 files changed, 37 insertions(+), 7 deletions(-)

-- 
2.14.3


