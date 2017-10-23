Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:18183 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdJWEnh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 00:43:37 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E9F97AC019E
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 13:43:30 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 44A56BD667D
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 13:43:30 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 0/2] btrfs-progs: fi: enable fi usage for filesystem top of
 seed device
Message-ID: <01e66c4f-9f8d-0bf2-1f7a-bc5784a907f3@jp.fujitsu.com>
Date: Mon, 23 Oct 2017 13:43:23 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently "fi usage" (and "dev usage") cannot run for the filesystem using
seed device.

This is because FS_INFO ioctl returns the number of devices excluding
seeds, but load_device_info() tries to access valid device from devid 0
to max_id, and results in accessing seeds too (thus causing mismatching
of number of devices).

Since only the size of non-seed devices is matter, fix this by just
skipping seed device by checking device's fsid and comparing it to the fsid
obtained by FS_INFO ioctl.

Tomohiro Misono (2):
 btrfs-progs: fi: move dev_to_fsid() to cmds-fi-usage for later use
 btrfs-progs: fi: enable fi usage for filesystem top of seed device

 cmds-fi-usage.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-usage.h   |  1 +
 cmds-filesystem.c | 27 ---------------------------
 3 files changed, 45 insertions(+), 27 deletions(-)

-- 
2.9.5

