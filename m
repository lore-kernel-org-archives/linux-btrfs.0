Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:30447 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965704AbdI0CAp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 22:00:45 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 47062AC0104
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:00:40 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 836C36D67D2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:00:39 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v2 0/5] btrfs-progs: subvol: fix del --commit-after
Message-ID: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Date: Wed, 27 Sep 2017 11:00:35 +0900
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
keeps fsid in hush function in cmds-filesystem.c. This patch utilizes
them.

First patch is the independent but critical. Current code is reversed in
--commit-after and --commit-each operation. i.e. --commit-after means
--commit-each actually. The patch fix this.

2rd to 4th patches make functions stated above to common and last one is
the main part.

Thanks Qu for reviewing whole patches.

change to v2:
	split the cleanup part of 4th patch and make it the independent patch
	(1st patch in new series).

Tomohiro Misono (5):
  btrfs-progs: subvol: exchange subvol del --commit-after and --commit-each
  btrfs-progs: move get_fsid() to util.c
  btrfs-progs: move seen_fsid to util.c
  btrfs-progs: change seen_fsid to hold fd and DIR*
  btrfs-progs: subvol: fix subvol del --commit-after

 cmds-filesystem.c |  88 +++------------------------------------------
 cmds-property.c   |  30 ----------------
 cmds-subvolume.c  |  72 +++++++++++++++++++++++++++----------
 utils.c           | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |  15 ++++++++
 5 files changed, 179 insertions(+), 131 deletions(-)

-- 
2.9.5

