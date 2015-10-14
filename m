Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752448AbbJNH2U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 03:28:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: [PULL REQUEST][PATCH 0/2] Small fixes for 4.3 merge windows
Date: Wed, 14 Oct 2015 15:26:11 +0800
Message-ID: <1444807573-29853-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This pull is quite a small one, with 2 small and safe patches.

The first one is a fix that get missing in 4.2 merge windows.
Just remove an empty header I created in qgroup rework.

The other one is found in qgroup reserve rework, but that's also very
small and safe, with test case submitted:
https://patchwork.kernel.org/patch/7292921/

I was planning to include two qgroup rescan fix patches, but doesn't get
further comment from David, so they may be delayed to 4.4, with qgroup
reserve rework.

Thanks,
Qu

Qu Wenruo (2):
  btrfs: Remove empty header file extent-tree.h
  btrfs: Avoid truncate tailing page if fallocate range doesn't exceed
    inode size

 fs/btrfs/extent-tree.h | 0
 fs/btrfs/file.c        | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 fs/btrfs/extent-tree.h

-- 
2.6.1

