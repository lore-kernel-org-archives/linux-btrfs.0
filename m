Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7682 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933084AbbIDNZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:25:57 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DPjs2030019
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:25:45 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/5] btrfs-progs: Introduce --extra-dev option
Date: Fri, 4 Sep 2015 21:24:14 +0800
Message-ID: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some command in current tools can't support filesystem with multiple
loop device, for example:
 # truncate -s 200M ./1.img
 # truncate -s 200M ./2.img
 # mkfs.btrfs -f ./1.img ./2.img
 #
 # btrfs rescue chunk-recover -v ./1.img
 All Devices:
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue super-recover -v ./1.img
 All Devices:
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue zero-log ./1.img
 warning devid 2 not found already
 Clearing log on ./1.img, previous log_root 0, level 0
 ...

As a workaround, we can bind all of above image files to loop device,
but to make things simple, this patch introduce --extra-dev option,
to specify non-block-device manually, as:
 # btrfs rescue chunk-recover -v --extra-device=./2.img ./1.img
 All Devices:
        Device: id = 2, name = ./2.img
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue super-recover --extra-dev=./2.img -v ./1.img
 All Devices:
        Device: id = 2, name = ./2.img
        Device: id = 1, name = ./1.img
 ...
 # btrfs rescue zero-log --extra-dev=./2.img ./1.img
 Clearing log on ./1.img, previous log_root 0, level 0

We can add multiple extra-dev by:
 --extra-dev="1.img,2.img"
 or
 --extra-dev=1.img --extra-dev=2.img

Zhao Lei (5):
  btrfs-progs: Introduce --extra-dev option
  btrfs-progs: Support extra-dev for btrfs rescue
  btrfs-progs: Avoid using uninitialized optind in cmd_rescue_zero_log
  btrfs-progs: add help command to btrfs rescue zero-log
  btrfs-progs: update manual for --extra-dev and -h for btrfs rescue

 Documentation/btrfs-rescue.asciidoc | 13 ++++++-
 cmds-rescue.c                       | 39 +++++++++++++++++----
 utils.c                             | 70 +++++++++++++++++++++++++++++++++++++
 utils.h                             |  5 +++
 4 files changed, 119 insertions(+), 8 deletions(-)

-- 
1.8.5.1

