Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:15337 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754060AbbJHLCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 07:02:11 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t98B17T5030398
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Oct 2015 19:01:07 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v4 0/3] btrfs: Fix lost-data-profile caused by auto removing bg and balance bg
Date: Thu, 8 Oct 2015 18:59:52 +0800
Message-ID: <cover.1444301651.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changelog v3->v4:
1: Avoid down_read() in spin_lock context.
   Noticed-by: Chris Mason <clm@fb.com>

Changelog v2->v3:
1: Use list_is_singular() instead of
   block_group->list.next == block_group->list.prev
   Suggested-by: Jeff Mahoney <jeffm@suse.com>
2: Add Reviewed-by: Filipe Manana <fdmanana@suse.com>

Changelog v1->v2:
1: Put code of checking block_group->list into
   semaphore of space_info->groups_sem.
   Noticed-by: Filipe Manana <fdmanana@gmail.com>
2: Update patch description of "Fix" field
3: Use BTRFS_BLOCK_GROUP_DATA for btrfs_force_chunk_alloc
   instead of 1
4: Only reserve chunk when doing balance on data chunk.
All suggested-by: Filipe Manana <fdmanana@gmail.com>

Zhao Lei (3):
  btrfs: Fix lost-data-profile caused by auto removing bg
  btrfs: Fix lost-data-profile caused by balance bg
  btrfs: Use fs_info directly in btrfs_delete_unused_bgs

 fs/btrfs/extent-tree.c | 11 +++++++----
 fs/btrfs/volumes.c     | 24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 4 deletions(-)

-- 
1.8.5.1

