Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:48207 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbeEOHbS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:31:18 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 90211AC00DA
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:31:12 +0900 (JST)
Received: from G01JPEXCHYT17.g01.fujitsu.local (G01JPEXCHYT17.g01.fujitsu.local [10.128.194.56])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id D6F325842F8
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:31:11 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 0/2] btrfs: sysfs: Add entry which shows rmdir(2) can work for
 subvolume
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
Date: Tue, 15 May 2018 16:30:53 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[based on current misc-next]

This adds new sysfs entry
  /sys/fs/btrfs/features/rmdir_subvol
to indicate that the kernel can delete a subvolume by rmdir(2),
which is allowed by: https://www.spinics.net/lists/linux-btrfs/msg76938.html

The first patch is a cleanup and the second one is a main part.

Tomohiro Misono (2):
  btrfs: sysfs: Use enum/define value intead of magic number
  btrfs: sysfs: Add entry which shows rmdir(2) can work for subvolume

 fs/btrfs/ctree.h           |  6 ++++++
 fs/btrfs/sysfs.c           | 39 +++++++++++++++++++++++++++++----------
 fs/btrfs/sysfs.h           |  5 ++++-
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 41 insertions(+), 11 deletions(-)

-- 
2.14.3


