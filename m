Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31219 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756070AbbHZJGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 05:06:03 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7Q95rOR016058
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 17:05:53 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/2] btrfs-progs: Introduce open_btrfs_dir wrapper
Date: Wed, 26 Aug 2015 17:04:21 +0800
Message-ID: <cover.1440579753.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce open_btrfs_dir() to open a dir in btrfs
filesystem.

It can be used for several tools in btrfs-progs.

Changelog v1-v2:
1: Add error message for open_file failed case

Zhao Lei (2):
  btrfs-progs: Introduce open_btrfs_dir wrapper
  btrfs-progs: use open_btrfs_dir for btrfs device command

 cmds-device.c | 16 +++++-----------
 utils.c       | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h       |  1 +
 3 files changed, 62 insertions(+), 11 deletions(-)

-- 
1.8.5.1

