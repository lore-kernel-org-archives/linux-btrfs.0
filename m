Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28564 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752022AbbEMJRk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 05:17:40 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH 0/4] Enhance btrfs-progs for hostile image (FPE error part)
Date: Wed, 13 May 2015 17:15:32 +0800
Message-ID: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes 3 FPE error reported by Lukas Lueg<lukas.lueg@gmail.com>.
Corresponding kernel BZ#96971, BZ#97031, BZ#97041.

What a pity that I didn't realize it's a good chance to submit more patches. :)

There are still 3 BZ, but that's about memory corruption, and some even
corrupt the backtrace. So it will take a little longer to investigate it.

Qu Wenruo (4):
  btrfs-progs: Remove non-exist csum size.
  btrfs-progs: Read the whole superblock instead of struct    
    btrfs_super_block.
  btrfs-progs: Introduce better superblock check.
  btrfs-progs: Add extra chunk item check to avoid btrfs-progs crash.

 ctree.h   |   2 +-
 disk-io.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 volumes.c |  60 +++++++++++++++++++--
 3 files changed, 216 insertions(+), 21 deletions(-)

-- 
2.4.0

