Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21728 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752729AbbGBGyi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 02:54:38 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t626qrC3016089
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Jul 2015 14:52:54 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/2] btrfsck repair for I_ERR_FILE_WRONG_NBYTES and test case
Date: Thu, 2 Jul 2015 14:52:31 +0800
Message-ID: <1435819951-16933-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1435819951-16933-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1435819951-16933-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add repair function for I_ERR_FILE_WRONG_NBYTES and a test case for it.
Rebased to devel branch.

The second patch contains binary data, so created a pull request for it.
https://github.com/kdave/btrfs-progs/pull/7

Qu Wenruo (2):
  btrfs-progs: fsck:Add repair function for I_ERR_FILE_WRONG_NBYTES.
  btrfs-progs: tests: Add test case for I_ERR_FILE_WRONG_NBYTES repair.

 cmds-check.c                                       |  38 ++++++++++++++++++++-
 .../016-wrong-inode-nbytes/default_case.img.xz     | Bin 0 -> 1996 bytes
 2 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 tests/fsck-tests/016-wrong-inode-nbytes/default_case.img.xz

-- 
2.4.4

