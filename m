Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:23763 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965051AbdIZFoR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 01:44:17 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 01781AC0130
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 14:44:14 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 60A3146E768
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 14:44:13 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 0/4] btrfs-progs: subvol: fix del --commit-after
Message-ID: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
Date: Tue, 26 Sep 2017 14:44:09 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix subvol del --commit-after to work properly:
 - SYNC ioctl will be issued even when last delete is failed
 - SYNC ioctl will be issued on each file system only once in the end

To achieve this, each deleted subvol's (parent's) fsid is checked each
time. If the fsid is seen for the first time, its fd will be kept in order
to issue SYNC ioctl in the end.

There already exists get_fsid() in cmds-property.c and seen_fsid which
keeps fsid in hush function in cmds-filesystem.c. First three patches
make them to common functions and last one is the main part.

Tomohiro Misono (4):
  btrfs-progs: move get_fsid() to util.c
  btrfs-progs: move seen_fsid to util.c
  btrfs-progs: change seen_fsid to hold fd and DIR*
  btrfs-progs: subvol: fix subvol del --commit-after

 cmds-filesystem.c |  88 +++------------------------------------------
 cmds-property.c   |  30 ----------------
 cmds-subvolume.c  |  77 ++++++++++++++++++++++++++++-----------
 utils.c           | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |  15 ++++++++
 5 files changed, 181 insertions(+), 134 deletions(-)

-- 
2.9.5

