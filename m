Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50572 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755463AbcHYGSc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 02:18:32 -0400
Subject: Re: [PULL] Btrfs fixes, part 3
To: David Sterba <dsterba@suse.com>, <clm@fb.com>
References: <cover.1472045668.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57BE8CC3.7070001@cn.fujitsu.com>
Date: Thu, 25 Aug 2016 14:14:27 +0800
MIME-Version: 1.0
In-Reply-To: <cover.1472045668.git.dsterba@suse.com>
Content-Type: multipart/mixed;
        boundary="------------060203090606040005040402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------060203090606040005040402
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hi david and chris,

On 08/24/2016 09:42 PM, David Sterba wrote:
> Hi,
>
> this pull request contains part 2 and adds more that arrived in the meantime
> (new fixes or updated versions of patches). Assorted fixes. Please pull,
> thanks.
>
> ----------------------------------------------------------------
> The following changes since commit 10838816547a28696ca10e038b3b32f2efec5a42:
>
>    Merge branch 'integration-4.8' of git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux into for-linus-4.8 (2016-08-05 12:25:05 -0700)
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.8
>
> for you to fetch changes up to 79354fc603184885b50cf935b8b2085c2b3e0535:
>
>    Btrfs: fix lockdep warning on deadlock against an inode's log mutex (2016-08-24 14:54:42 +0200)
>
> ----------------------------------------------------------------
> Alex Lyakas (1):
>        btrfs: flush_space: treat return value of do_chunk_alloc properly
>
> Anand Jain (1):
>        btrfs: do not background blkdev_put()
>
> Filipe Manana (1):
>        Btrfs: fix lockdep warning on deadlock against an inode's log mutex
>
> Jeff Mahoney (3):
>        btrfs: properly track when rescan worker is running
>        btrfs: waiting on qgroup rescan should not always be interruptible
>        btrfs: don't create or leak aliased root while cleaning up orphans
>
> Josef Bacik (2):
>        Btrfs: fix em leak in find_first_block_group
>        Btrfs: handle pending renames with recycled inodes properly
>
> Liu Bo (6):
>        Btrfs: fix memory leak of reloc_root
>        Btrfs: add ASSERT for block group's memory leak
>        Btrfs: clarify do_chunk_alloc()'s return value
>        Btrfs: check btree node's nritems
>        Btrfs: detect corruption when non-root leaf has zero item
>        Btrfs: remove BUG() in raid56
>
> Qu Wenruo (4):
>        btrfs: backref: Fix soft lockup in __merge_refs function
>        btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent()
>        btrfs: relocation: Fix leaking qgroups numbers on data extents
>        btrfs: qgroup: Fix qgroup incorrectness caused by log replay
>
> Wang Xiaoguang (5):
>        btrfs: use correct offset for reloc_inode in prealloc_file_extent_cluster()
>        btrfs: divide btrfs_update_reserved_bytes() into two functions
>        btrfs: update btrfs_space_info's bytes_may_use timely
When I tested patch "btrfs: update btrfs_space_info's bytes_may_use 
timely", I forgot
to run dm-flakey related fstests test cases: generic/056 generic/057 
generic/059
generic/065 and generic/073, they will report a WARN about 
bytes_may_use, sorry.

I prepared a patch to fix this issue, please see the attachment, with 
this patch,
these 5 cases will pass.

Regards,
Xiaoguang Wang
>        btrfs: should block unused block groups deletion work when allocating data space
>        btrfs: fix fsfreeze hang caused by delayed iputs deal
>
>   fs/btrfs/backref.c     |   1 +
>   fs/btrfs/ctree.h       |   7 +-
>   fs/btrfs/delayed-ref.c |   7 +-
>   fs/btrfs/disk-io.c     |  69 ++++++++++++---
>   fs/btrfs/disk-io.h     |   2 +
>   fs/btrfs/extent-tree.c | 227 ++++++++++++++++++++++++++-----------------------
>   fs/btrfs/extent_io.h   |   1 +
>   fs/btrfs/file.c        |  28 +++---
>   fs/btrfs/inode-map.c   |   3 +-
>   fs/btrfs/inode.c       |  37 +++++---
>   fs/btrfs/ioctl.c       |   2 +-
>   fs/btrfs/qgroup.c      |  62 +++++++++++---
>   fs/btrfs/qgroup.h      |  36 ++++++--
>   fs/btrfs/raid56.c      |   5 +-
>   fs/btrfs/relocation.c  | 126 ++++++++++++++++++++++++---
>   fs/btrfs/root-tree.c   |  27 ++++--
>   fs/btrfs/send.c        |  36 ++++++--
>   fs/btrfs/super.c       |  16 ++++
>   fs/btrfs/transaction.c |   7 +-
>   fs/btrfs/tree-log.c    |  21 ++++-
>   fs/btrfs/tree-log.h    |   5 +-
>   fs/btrfs/volumes.c     |  69 ++++++++-------
>   22 files changed, 566 insertions(+), 228 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>




--------------060203090606040005040402
Content-Type: text/x-patch;
	name="0001-btrfs-do-not-decrease-bytes_may_use-when-replaying-e.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-btrfs-do-not-decrease-bytes_may_use-when-replaying-e.pa";
	filename*1="tch"

>From 37a68c327b8090ecf59e7019433638d7a569d3ab Mon Sep 17 00:00:00 2001
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Date: Thu, 25 Aug 2016 10:09:09 +0800
Subject: [PATCH] btrfs: do not decrease bytes_may_use when replaying extents

When replaying extents, there is no need to update bytes_may_use
in btrfs_alloc_logged_file_extent(), otherwise it'll trigger a
WARN_ON about bytes_may_use.

Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ae8f9aa..7a15990 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8242,6 +8242,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	struct btrfs_block_group_cache *block_group;
+	struct btrfs_space_info *space_info;
 
 	/*
 	 * Mixed block groups will exclude before processing the log so we only
@@ -8257,9 +8258,14 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	if (!block_group)
 		return -EINVAL;
 
-	ret = btrfs_add_reserved_bytes(block_group, ins->offset,
-				       ins->offset, 0);
-	BUG_ON(ret); /* logic error */
+	space_info = block_group->space_info;
+	spin_lock(&space_info->lock);
+	spin_lock(&block_group->lock);
+	space_info->bytes_reserved += ins->offset;
+	block_group->reserved += ins->offset;
+	spin_unlock(&block_group->lock);
+	spin_unlock(&space_info->lock);
+
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
 	btrfs_put_block_group(block_group);
-- 
2.9.0


--------------060203090606040005040402--
