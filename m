Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13962 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758771AbcALCHn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 21:07:43 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>
Subject: [PATCH v5 0/2][PULL REQUEST] Unify 'norecovery' bahavior with other filesystems
Date: Tue, 12 Jan 2016 10:05:11 +0800
Message-ID: <1452564313-22007-1-git-send-email-quwenruo@cn.fujitsu.com>
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
Only mount option name is changing during all these version changes.

Thanks,
Qu

Qu Wenruo (2):
  btrfs: Introduce new mount option usebackuproot to replace recovery
  btrfs: Introduce new mount option to disable tree log replay

 Documentation/filesystems/btrfs.txt | 18 +++++++++++---
 fs/btrfs/ctree.h                    |  6 +++--
 fs/btrfs/disk-io.c                  | 15 ++++++++----
 fs/btrfs/super.c                    | 47 ++++++++++++++++++++++++++++++-------
 4 files changed, 68 insertions(+), 18 deletions(-)

-- 
2.7.0



