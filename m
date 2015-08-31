Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27825 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752085AbbHaLFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 07:05:25 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7VB5Cf7009046
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 19:05:12 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/4] btrfs-progs: Use common function to parse unit arguments
Date: Mon, 31 Aug 2015 19:03:40 +0800
Message-ID: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are using separate code for parse unit mode in current code,
better to use common function.

This patchset introduce common function to parse arguments for setting
unit: get_unit_mode_from_arg()
and common help message for unit argument, to make every tool in btrfs having
same interface for setting unit.

The merit are:
1: Unify current each tool's arguments for unit
2: Make tools in future easy to implement such argument
3: Changes(enhancement) in common function have effect on all
   relative tools

Changelog v1->v2:
 Keep short options for 'fi df' command, to keeps option compatibility
 with the standalone 'df' commmand, suggested-by:
 David Sterba <dsterba@suse.cz>

Zhao Lei (4):
  btrfs-progs: Introduce get_unit_mode_from_arg for common use
  btrfs-progs: Use common unit parser for btrfs filesystem command
  btrfs-progs: Use common unit parser for btrfs device command
  btrfs-progs: Use common unit parser for btrfs qgroup command

 cmds-device.c     |  74 ++++-----------------------------
 cmds-fi-usage.c   |  79 ++++-------------------------------
 cmds-filesystem.c | 121 ++++++------------------------------------------------
 cmds-qgroup.c     |  47 ++-------------------
 utils.c           | 102 +++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |  24 +++++++++++
 6 files changed, 156 insertions(+), 291 deletions(-)

-- 
1.8.5.1

