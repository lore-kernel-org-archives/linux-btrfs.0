Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754222AbeFUCIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 22:08:37 -0400
Subject: Re: [PATCH 00/34] fs_info cleanup of extent-tree.c
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c9663258-1f07-0542-4002-650684ca7bfb@gmx.com>
Date: Thu, 21 Jun 2018 10:08:24 +0800
MIME-Version: 1.0
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月20日 20:48, Nikolay Borisov wrote:
> Hello, 
> 
> This series aims at removing all the redundant btrfs_fs_info args being 
> passed to functions in extent-tree.c. Each patch removes the arg from a 
> one function hence it should be fairly easy to review each one of those 
> patches. I'm mainly exploiting the fact that most of the time we have a 
> function which takes a transaction handle, which is always valid (ie can't be 
> null) and at the same time we are passing an fs_info. The former actually 
> contains a reference to the fs info so can be referenced directly from the 
> transaction. Additionally, 2 patches also exploit the fact that block group 
> cache structs also hold a reference to fs_info so there is no point in 
> passing it there as well. 
> 
> To spice things up a bit, here is the output of stackdelta before/after the 
> patch set is applied: 
> 
> ./fs/btrfs/extent-tree.c	__btrfs_inc_extent_ref	152	144	-8
> ./fs/btrfs/extent-tree.c	__btrfs_run_delayed_refs	256	248	-8
> ./fs/btrfs/extent-tree.c	alloc_reserved_file_extent	128	136	+8
> ./fs/btrfs/extent-tree.c	btrfs_alloc_logged_file_extent	104	88	-16
> ./fs/btrfs/extent-tree.c	btrfs_alloc_reserved_file_extent	56	48	-8
> ./fs/btrfs/extent-tree.c	btrfs_alloc_tree_block	176	168	-8
> ./fs/btrfs/extent-tree.c	btrfs_force_chunk_alloc	24	16	-8
> ./fs/btrfs/extent-tree.c	btrfs_free_extent	104	96	-8
> ./fs/btrfs/extent-tree.c	btrfs_free_tree_block	112	104	-8
> ./fs/btrfs/extent-tree.c	btrfs_inc_block_group_ro	56	48	-8
> ./fs/btrfs/extent-tree.c	btrfs_inc_extent_ref	112	104	-8
> ./fs/btrfs/extent-tree.c	caching_thread	216	208	-8
> ./fs/btrfs/extent-tree.c	convert_extent_item_v0	120	112	-8
> ./fs/btrfs/extent-tree.c	insert_inline_extent_backref	120	112	-8
> ./fs/btrfs/extent-tree.c	lookup_inline_extent_backref	176	184	+8
> ./fs/btrfs/extent-tree.c	remove_extent_data_ref	104	96	-8
> 
> Also the output of bloat-o-meter : 
> 
> add/remove: 5/5 grow/shrink: 6/24 up/down: 2275/-2554 (-279)
> Function                                     old     new   delta
> insert_extent_data_ref                         -     738    +738
> lookup_extent_data_ref                         -     613    +613
> remove_extent_data_ref                         -     535    +535
> lookup_tree_block_ref                          -     227    +227
> insert_tree_block_ref                          -     139    +139
> btrfs_inc_extent_ref                         235     242      +7
> btrfs_make_block_group                       831     837      +6
> update_inline_extent_backref                 681     685      +4
> exclude_super_stripes                        356     360      +4
> free_excluded_extents                         95      96      +1
> alloc_reserved_file_extent                   954     955      +1
> check_system_chunk                           362     361      -1
> insert_inline_extent_backref                 224     221      -3
> flush_space                                 1691    1688      -3
> cache_block_group                           1132    1129      -3
> btrfs_free_block_groups                     1140    1137      -3
> btrfs_alloc_tree_block                      1024    1021      -3
> remove_extent_backref                        104     100      -4
> find_free_extent                            5436    5431      -5
> convert_extent_item_v0                       735     730      -5
> do_chunk_alloc                               846     838      -8
> btrfs_remove_block_group                    2805    2797      -8
> btrfs_free_extent                            306     298      -8
> btrfs_alloc_data_chunk_ondemand             1242    1234      -8
> btrfs_free_tree_block                        862     853      -9
> btrfs_force_chunk_alloc                       45      35     -10
> btrfs_read_block_groups                     2245    2233     -12
> btrfs_alloc_logged_file_extent               249     237     -12
> btrfs_alloc_reserved_file_extent              70      57     -13
> btrfs_inc_block_group_ro                     352     338     -14
> lookup_inline_extent_backref                1532    1516     -16
> caching_thread                              1465    1446     -19
> __btrfs_run_delayed_refs                    5469    5446     -23
> __btrfs_inc_extent_ref.isra                  608     566     -42
> __btrfs_free_extent.isra                    3136    3082     -54
> insert_tree_block_ref.isra                   131       -    -131
> lookup_tree_block_ref.isra                   216       -    -216
> remove_extent_data_ref.isra                  543       -    -543
> lookup_extent_data_ref.isra                  649       -    -649
> insert_extent_data_ref.isra                  729       -    -729
> Total: Before=91208, After=90929, chg -0.31%
> 
> Overall this series is a win both in code density as well as stack usage and 
> brings us closer to completely eliminating the chaotic spread ot fs_info in 
> the code base. 

Looks pretty good.

Except the last one related to the deprecated extent_ref_v0, as I prefer
to delete the whole EXTENT_REF_V0 code.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> Nikolay Borisov (34):
>   btrfs: Remove fs_info from insert_tree_block_ref
>   btrfs: Remove fs_info from insert_extent_data_ref
>   btrfs: Remove fs_info argument from insert_extent_backref
>   btrfs: Remove fs_info from remove_extent_data_ref
>   btrfs: Remove fs_info from fixup_low_keys
>   btrfs: Remove fs_info from lookup_inline_extent_backref
>   btrfs: Remove fs_info argument from update_inline_extent_backref
>   btrfs: Remove fs_info argument from lookup_tree_block_ref
>   btrfs: Remove fs_info argument from lookup_extent_data_ref
>   btrfs: Remove fs_info from lookup_extent_backref
>   btrfs: Remove fs_info from btrfs_add_delayed_tree_ref
>   btrfs: Remove fs_info from btrfs_add_delayed_data_ref
>   btrfs: Remove fs_info from btrfs_make_block_group
>   btrfs: Remove fs_info from btrfs_remove_block_group
>   btrfs: Remove fs_info from __btrfs_free_extent
>   btrfs: Remove fs_info from alloc_reserved_file_extent
>   btrfs: Remove fs_info argument from __btrfs_inc_extent_ref
>   btrfs: Remove fs_info from run_delayed_data_ref
>   btrfs: Remove fs_info from run_delayed_extent_op
>   btrfs: Remove unused fs_info from cleanup_extent_op
>   btrfs: Remove fs_info from cleanup_ref_head
>   btrfs: Remove fs_info from run_delayed_tree_ref
>   btrfs: Remove fs_info from do_chunk_alloc
>   btrfs: Remove fs_info from btrfs_alloc_chunk
>   btrfs: Remove fs_info from check_system_chunk
>   btrfs: Remove fs_info from free_excluded_extents
>   btrfs: Remove fs_info from exclude_super_stripes
>   btrfs: Remove fs_info from insert_inline_extent_backref
>   btrfs: Remove fs_info from run_one_delayed_ref
>   btrfs: Remove fs_info from remove_extent_backref
>   btrfs: Remove fs_info from btrfs_alloc_logged_file_extent
>   btrfs: Remove fs_info from btrfs_inc_block_group_ro
>   btrfs: Remove fs_info from btrfs_force_chunk_alloc
>   btrfs: Remove fs_info from convert_extent_item_v0
> 
>  fs/btrfs/ctree.c       |  18 ++--
>  fs/btrfs/ctree.h       |  17 ++-
>  fs/btrfs/delayed-ref.c |   8 +-
>  fs/btrfs/delayed-ref.h |   6 +-
>  fs/btrfs/extent-tree.c | 287 ++++++++++++++++++++++---------------------------
>  fs/btrfs/relocation.c  |   5 +-
>  fs/btrfs/scrub.c       |   2 +-
>  fs/btrfs/tree-log.c    |   1 -
>  fs/btrfs/volumes.c     |  17 ++-
>  fs/btrfs/volumes.h     |   3 +-
>  10 files changed, 161 insertions(+), 203 deletions(-)
> 
