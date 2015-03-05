Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40633 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753958AbbCECWT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 21:22:19 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <zblaxell@furryterror.org>, <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH v3 0/3] Enhancement for df command.
Date: Thu, 5 Mar 2015 10:18:35 +0800
Message-ID: <1425521918-30212-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This is V3, just rebase it against 4.0-rc1.

Any comment is welcome!!

Thanx

Dongsheng Yang (3):
  Btrfs: get more accurate output in df command.
  Btrfs: raid56: simplify the parameter of nr_parity_stripes().
  Btrfs: adapt df command to RAID5/6.

 fs/btrfs/ctree.h       |  1 -
 fs/btrfs/extent-tree.c | 41 ------------------------
 fs/btrfs/raid56.h      |  8 ++---
 fs/btrfs/super.c       | 86 +++++++++++++++++++++++++++++++-------------------
 fs/btrfs/volumes.c     |  2 +-
 5 files changed, 59 insertions(+), 79 deletions(-)

-- 
1.8.4.2

