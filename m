Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54197 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753472AbbIYCiL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 22:38:11 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <stephane_btrfs@lesimple.fr>
Subject: [PATCH 0/2] Btrfs: Fix a insane extent_buffer copy behavior for qgroup
Date: Fri, 25 Sep 2015 10:37:59 +0800
Message-ID: <1443148681-3015-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stephane Lesimple reported an qgroup rescan bug:

[92098.841309] general protection fault: 0000 [#1] SMP
[92098.841338] Modules linked in: ...
[92098.841814] CPU: 1 PID: 24655 Comm: kworker/u4:12 Not tainted
4.3.0-rc1 #1
[92098.841868] Workqueue: btrfs-qgroup-rescan btrfs_qgroup_rescan_helper
[btrfs]
[92098.842261] Call Trace:
[92098.842277]  [<ffffffffc035a5d8>] ? read_extent_buffer+0xb8/0x110
[btrfs]
[92098.842304]  [<ffffffffc0396d00>] ? btrfs_find_all_roots+0x60/0x70
[btrfs]
[92098.842329]  [<ffffffffc039af3d>]
btrfs_qgroup_rescan_worker+0x28d/0x5a0 [btrfs]
...

The triggering function btrfs_disk_key_to_cpu(), which should never
fail.
But it turned out that the extent_buffere being called on is memcpied
from an existing one.

Such behavior to copy a structure with page pointers and locks in it is
never a sane thing.

Fix it by do it in memory other than extent_buffer.

Qu Wenruo (2):
  btrfs: Add support to do stack item key operation
  btrfs: qgroup: Don't copy extent buffer to do qgroup rescan

 fs/btrfs/ctree.h  | 20 ++++++++++++++++++++
 fs/btrfs/qgroup.c | 22 ++++++++++++----------
 2 files changed, 32 insertions(+), 10 deletions(-)

-- 
2.5.3

