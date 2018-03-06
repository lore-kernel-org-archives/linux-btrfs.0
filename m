Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:65461 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbeCFIaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:30:24 -0500
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id F2C6DAC00C5
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:30:14 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 46CF56D6724
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:30:14 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 0/2] btrfs: Add two new unprivileged ioctls to allow normal
 users to call "sub list/show" etc.
Message-ID: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:29:34 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds two new unprivileged ioctls:

1st patch: version of tree_search ioctl which only searches/returns subvolume related item.
2nd patch: user version of ino_lookup ioctl which also performs permission check.

They will be used to implement user version of "subvolume list/show" etc in user tools.
See each commit log for more detals.

The RFC implementation of btrfs-progs can be found in the ML titled as follows: 
  [RFC PATCH 0/7] btrfs-progs: Allow normal user to call "subvolume list/show"

Tomohiro Misono (2):
  btrfs: Add unprivileged subvolume search ioctl
  btrfs: Add unprivileged version of ino_lookup ioctl

 fs/btrfs/ioctl.c           | 472 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  18 ++
 2 files changed, 490 insertions(+)

-- 
2.14.3

