Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61924 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbbJMMyA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 08:54:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9DCrT99019602
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 20:53:29 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/3] btrfs-progs: mkfs: Fix different mixed type by argument sequence
Date: Tue, 13 Oct 2015 20:52:16 +0800
Message-ID: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Given a 200G vdd1 and 1G vdd2:

In current code:
 mkfs.btrfs -f /dev/vdd1 /dev/vdd2
 and
 mkfs.btrfs -f /dev/vdd2 /dev/vdd1
 will create different "mixed" type.

See [PATCH 2/3] for detail.

This patchset also include some small fixs.

Zhao Lei (3):
  btrfs-progs: mkfs: Remove saved_optind in mkfs.btrfs
  btrfs-progs: mkfs: Fix different mixed type by argument sequence
  btrfs-progs: mkfs: Fix inaccurate mixed information

 mkfs.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

-- 
1.8.5.1

