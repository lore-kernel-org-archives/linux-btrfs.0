Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10249 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751294AbbHEIpH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 04:45:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t758hB5L017018
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Aug 2015 16:43:11 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v4 0/4] btrfs: Fix data checksum error cause by replace with io-load
Date: Wed, 5 Aug 2015 16:43:26 +0800
Message-ID: <cover.1438763783.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset is used to fix data checksum error cause by replace with
io-load.
It cause xfstests btrfs/070(071) failed randomly.

See description in [PATCH 4/4] for detail.

Changelog v3->v4:
 1: Fix regression of xfstests/061
    Patch v3 cause xfstests/061 failed in some case, because
    btrfs_inc_block_group_ro() include a btrfs_end_transaction()
    option, which will change datas in reloc_ctl->data_inode,
    and cause deadlock in relocate:
    scrub                       relocate
    ----                        ----
                                relocate_file_extent_cluster()
                                prealloc_file_extent_cluster()
                                ...
    btrfs_inc_block_group_ro()
    btrfs_wait_for_commit()
    insert_reserved_file_extent()
    btrfs_set_file_extent_disk_num_bytes()
    (modify reloc_ctl->data_inode)
    ...
                                do_relocation()
                                get_new_location() ret -EINVAL
                                (because data_inode's extent changed)
                                __btrfs_cow_block() ret -EINVAL
                                (without unlock eb)
                                btrfs_search_slot() deadlock
                                (try to lock eb again)

Changelog v2->v3:
 1: Fix a typo(caused in rebase) which make xfstests failed in
    btrfs/073 and btrfs/066.
 2: Rebase on top of integration-4.2
 3: Do full xfstests(generic and btrfs group with 10 mount options)

Changelog v1->v2:
 1: Update subject to reflect the problem being fixed.
 2: Update description to say reason why set read-only can fix the
    problem.
 3: Use a helper function to avoid duplicated code block for set
    chunk ro.
 All of above are suggested by: David Sterba <dsterba@suse.cz>

Zhao Lei (4):
  btrfs: Use ref_cnt for set_block_group_ro()
  btrfs: Separate scrub_blocked_if_needed() to scrub_pause_on/off()
  btrfs: use scrub_pause_on/off() to reduce code in
    scrub_enumerate_chunks()
  btrfs: Fix data checksum error cause by replace with io-load.

 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/extent-tree.c | 42 +++++++++++++++++++-------------------
 fs/btrfs/relocation.c  | 14 ++++++-------
 fs/btrfs/scrub.c       | 55 ++++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/volumes.c     |  2 ++
 5 files changed, 72 insertions(+), 47 deletions(-)

-- 
1.8.5.1

