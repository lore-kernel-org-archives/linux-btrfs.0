Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768AbaKZNDP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 08:03:15 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQD2t05015492
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 21:02:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 00/11] Implement device scrub/replace for RAID56
Date: Wed, 26 Nov 2014 21:04:40 +0800
Message-ID: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset implement the device scrub/replace function for RAID56, the
most implementation of the common data is similar to the other RAID type.
The differentia or difficulty is the parity process. The basic idea is reading
and check the data which has checksum out of the raid56 stripe lock, if the
data is right, then lock the raid56 stripe, read out the other data in the
same stripe, if no IO error happens, calculate the parity and check the
original one, if the original parity is right, the scrub parity passes.
or write out the new one. But if the common data(not parity) that we read out
is wrong, we will try to recover it, and then check and repair the parity.

And in order to avoid making the code more and more complex, we copy some
code of common data process for the parity, the cleanup work is in my
TODO list.

We have done some test, the patchset worked well. Of course, more tests
are welcome. If you are interesting to use it or test it, you can pull
the patchset from

  https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace

Changelog v2 -> v3:
- Fix wrong stripe start logical address calculation which was reported
  by Chris.
- Fix unhandled raid bios for parity scrub, which are added into the plug
  list of the head raid bio.
- Fix possible deadlock caused by the pending bios in the plug list
  when the io submitters were going to sleep.
- Fix undealt use-after-free problem of the source device in the final
  device replace procedure.
- Modify the code that is used to avoid the rbio merge.

Changelog v1 -> v2:
- Change some function names in raid56.c to make them fit the code style
  of the raid56.

Thanks
Miao

Miao Xie (8):
  Btrfs, raid56: don't change bbio and raid_map
  Btrfs, scrub: repair the common data on RAID5/6 if it is corrupted
  Btrfs, raid56: use a variant to record the operation type
  Btrfs, raid56: support parity scrub on raid56
  Btrfs, replace: write dirty pages into the replace target device
  Btrfs, replace: write raid56 parity into the replace target device
  Btrfs, raid56: fix use-after-free problem in the final device replace
    procedure on raid56
  Btrfs: fix possible deadlock caused by pending I/O in plug list

Zhao Lei (3):
  Btrfs: remove noused bbio_ret in __btrfs_map_block in condition
  Btrfs: remove unnecessary code of stripe_index assignment in
    __btrfs_map_block
  Btrfs, replace: enable dev-replace for raid56

 fs/btrfs/dev-replace.c |  20 +-
 fs/btrfs/raid56.c      | 746 ++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/raid56.h      |  16 +-
 fs/btrfs/scrub.c       | 803 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.c     |  52 +++-
 fs/btrfs/volumes.h     |  14 +-
 6 files changed, 1521 insertions(+), 130 deletions(-)

-- 
1.9.3

