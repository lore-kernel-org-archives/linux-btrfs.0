Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18709 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752712AbbIAHNr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 03:13:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t817DaLo020574
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 15:13:36 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 0/2] btrfs-progs: Use common unit parser for btrfs filesystem command
Date: Tue, 1 Sep 2015 15:12:05 +0800
Message-ID: <cover.1441091348.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changelog v2->v3:
 Fix lacking of -T option in v2, pointed out by:
 David Sterba <dsterba@suse.cz>

Changelog v1->v2:
 Keep short options for 'fi df' command, to keeps option compatibility
 with the standalone 'df' commmand, suggested-by:
 David Sterba <dsterba@suse.cz>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Zhao Lei (2):
  btrfs-progs: Use common unit parser for btrfs filesystem command
  btrfs-progs: Update manual for new unit arguments

 Documentation/btrfs-device.asciidoc     |  14 ++--
 Documentation/btrfs-filesystem.asciidoc |  14 ++--
 cmds-fi-usage.c                         |  63 +++--------------
 cmds-filesystem.c                       | 121 ++++----------------------------
 4 files changed, 32 insertions(+), 180 deletions(-)

-- 
1.8.5.1

