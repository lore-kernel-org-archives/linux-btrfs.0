Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58467 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756738AbcASCZb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 21:25:31 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id B020241896F7
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 10:25:10 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH V7 0/3][PULL REQUEST] Unify 'norecovery' bahavior with other filesystems
Date: Tue, 19 Jan 2016 10:23:01 +0800
Message-ID: <1453170184-22869-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'Norecovery' mount option is almost a standard for all other
filesystems, including f2fs, ext4, gfs2, nilfs2, and xfs.
And since current 'recovery' mount option for btrfs is too generic, it's
better to change btrfs 'recovery' to 'usebackuproot' and then we can
safely add 'norecovery' and 'nologreplay' mount option for btrfs.

The patch itself is not huge and already tested by others since v2.
Only mount option name and patch slipting is changing during all
these version changes.

Qu Wenruo (3):
  btrfs: Introduce new mount option usebackuproot to replace recovery
  btrfs: Introduce new mount option to disable tree log replay
  btrfs: Introduce new mount option alias for nologreplay

 Documentation/filesystems/btrfs.txt | 17 +++++++++++---
 fs/btrfs/ctree.h                    |  6 +++--
 fs/btrfs/disk-io.c                  | 15 ++++++++----
 fs/btrfs/super.c                    | 47 ++++++++++++++++++++++++++++++-------
 4 files changed, 67 insertions(+), 18 deletions(-)

-- 
2.7.0



