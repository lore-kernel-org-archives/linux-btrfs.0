Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31998 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752182AbbH0NkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 09:40:03 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7RDdqrU017130
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 21:39:52 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/4] btrfs-progs: Use common function to parse unit arguments
Date: Thu, 27 Aug 2015 21:38:19 +0800
Message-ID: <cover.1440682373.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are using separate code for parse unit mode in current code,
result is each command have different argument for unit mode:

 # btrfs filesystem show --help
   ...
   --raw              raw numbers in bytes
   --human-readable   human friendly numbers, base 1024 (default)
   --iec              use 1024 as a base (KiB, MiB, GiB, TiB)
   --si               use 1000 as a base (kB, MB, GB, TB)
   --kbytes           show sizes in KiB, or kB with --si
   --mbytes           show sizes in MiB, or MB with --si
   --gbytes           show sizes in GiB, or GB with --si
   --tbytes           show sizes in TiB, or TB with --si
   ...
 #
 # btrfs filesystem df --help
   ...
   -b|--raw           raw numbers in bytes
   -h|--human-readable
                      human friendly numbers, base 1024 (default)
   -H                 human friendly numbers, base 1000
   --iec              use 1024 as a base (KiB, MiB, GiB, TiB)
   --si               use 1000 as a base (kB, MB, GB, TB)
   -k|--kbytes        show sizes in KiB, or kB with --si
   -m|--mbytes        show sizes in MiB, or MB with --si
   -g|--gbytes        show sizes in GiB, or GB with --si
   -t|--tbytes        show sizes in TiB, or TB with --si
   ...
 #

This patchset introduce common function to parse arguments for setting
unit: get_unit_mode_from_arg()
and common help message for unit argument,
to make every tool in btrfs have same interface for setting unit.

The merit are:
1: Unify current each tool's arguments for unit
2: Make tools in future easy to implement such argument
3: Changes(enhancement) in common function have effect on all
   relative tools

Zhao Lei (4):
  btrfs-progs: Introduce get_unit_mode_from_arg for common use
  btrfs-progs: Use common unit parser for btrfs filesystem command
  btrfs-progs: Use common unit parser for btrfs device command
  btrfs-progs: Use common unit parser for btrfs qgroup command

 cmds-device.c     |  74 ++++-----------------------------
 cmds-fi-usage.c   |  79 ++++-------------------------------
 cmds-filesystem.c | 121 ++++++------------------------------------------------
 cmds-qgroup.c     |  47 ++-------------------
 utils.c           |  70 +++++++++++++++++++++++++++++++
 utils.h           |  14 +++++++
 6 files changed, 114 insertions(+), 291 deletions(-)

-- 
1.8.5.1

