Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:20125 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbeGYJ1i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 05:27:38 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 5EA65AC01ED
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:17:00 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id B35496D68F3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:16:59 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] btrfs-progs: ins: Update for logical-resolve command
Date: Wed, 25 Jul 2018 17:20:15 +0900
Message-ID: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1 and 2 fix some issues in logical-resolve.
Patch 3 is a main part and adds v2 support of BTRFS_IOC_LOGICA_INO_V2

Misono Tomohiro (3):
  btrfs-progs: ins: logical-resolve: Set correct error value
  btrfs-progs: ins: logical-resolve: Print message when path cannot be
    resolved
  btrfs-progs: ins: logical-resolve: Add v2 ioctl support

 Documentation/btrfs-inspect-internal.asciidoc | 15 ++++--
 cmds-inspect.c                                | 67 +++++++++++++++++++++++++--
 ioctl.h                                       | 11 ++++-
 libbtrfsutil/btrfs.h                          | 10 +++-
 4 files changed, 93 insertions(+), 10 deletions(-)

-- 
2.14.4


