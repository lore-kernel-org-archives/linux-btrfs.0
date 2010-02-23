From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] btrfs: use RB_ROOT to intialize rb_trees instead of
 setting rb_node to NULL
Date: Tue, 23 Feb 2010 11:51:37 -0800
Message-ID: <1266954697.16916.904.camel@localhost.localdomain>
References: <20100223194304.7963.98121.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>,
	"mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"wstrepp@gmx.de" <wstrepp@gmx.de>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100223194304.7963.98121.stgit@paris.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Quick grep also shows similar initializations in jffs2, ext4 and ext3.
Let me know if you already have patch for them, otherwise I can send in
the fix for those.

Thanks,
Venki

On Tue, 2010-02-23 at 11:43 -0800, Eric Paris wrote:
> btrfs inialize rb trees in quite a number of places by settin rb_node =
> NULL;  The problem with this is that 17d9ddc72fb8bba0d4f678 in the
> linux-next tree adds a new field to that struct which needs to be NULL for
> the new rbtree library code to work properly.  This patch uses RB_ROOT as
> the intializer so all of the relevant fields will be NULL'd.  Without the
> patch I get a panic like that shown below and after the patch my system
> boots.
> 
> [    5.314627] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    5.315518] last sysfs file: /sys/kernel/uevent_seqnum
> [    5.315518] CPU 0
> [    5.315518] Modules linked in: [last unloaded: scsi_wait_scan]
> [    5.315518]
> [    5.315518] Pid: 1314, comm: mount Not tainted 2.6.33-rc8-next-20100223+ #21 /KVM
> [    5.315518] RIP: 0010:[<ffffffff81296cc0>]  [<ffffffff81296cc0>] rb_insert_color+0x20/0x120
> [    5.315518] RSP: 0018:ffff88003cc21a88  EFLAGS: 00010206
> [    5.315518] RAX: 5a5a5a5a5a5a5a5a RBX: ffffea0000d5e5b8 RCX: 0000000000000000
> [    5.315518] RDX: ffff88003d710080 RSI: ffff88003d710080 RDI: ffff88003d610058
> [    5.315518] RBP: ffff88003cc21ab8 R08: 0000000000000002 R09: 0000000000000000
> [    5.315518] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88003d710070
> [    5.315518] R13: 0000000000000010 R14: ffff88003d610058 R15: ffff88003d710080
> [    5.315518] FS:  00007ffe37b197e0(0000) GS:ffff880004000000(0000) knlGS:0000000000000000
> [    5.315518] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    5.315518] CR2: 00007ffe36d7d010 CR3: 000000003cd94000 CR4: 00000000000006f0
> [    5.315518] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    5.315518] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    5.315518] Process mount (pid: 1314, threadinfo ffff88003cc20000, task ffff88003d100000)
> [    5.315518] Stack:
> [    5.315518]  ffff88003cc21ab8 ffffea0000d5e5b8 ffff88003d710070 0000000000000010
> [    5.315518] <0> ffff88003d7100e0 0000000000010000 ffff88003cc21b48 ffffffff812058b4
> [    5.315518] <0> ffff88003cc2e060 ffff88003cc20000 0000000000000010 000000503cc2dff0
> [    5.315518] Call Trace:
> [    5.315518]  [<ffffffff812058b4>] alloc_extent_buffer+0x294/0x410
> [    5.315518]  [<ffffffff811dfa28>] btrfs_find_create_tree_block+0x28/0x30
> [    5.315518]  [<ffffffff81209cd1>] btrfs_read_sys_array+0x31/0x150
> [    5.315518]  [<ffffffff811e429a>] open_ctree+0x109a/0x1710
> [    5.315518]  [<ffffffff81133bc5>] ? sget+0x365/0x480
> [    5.315518]  [<ffffffff812980af>] ? strlcpy+0x4f/0x70
> [    5.315518]  [<ffffffff811c4f8c>] btrfs_get_sb+0x41c/0x510
> [    5.315518]  [<ffffffff8114a846>] ? alloc_vfsmnt+0xc6/0x1a0
> [    5.315518]  [<ffffffff81133249>] vfs_kern_mount+0x89/0x1a0
> [    5.315518]  [<ffffffff811333ce>] do_kern_mount+0x4e/0x110
> [    5.315518]  [<ffffffff8114cb47>] do_mount+0x547/0x800
> [    5.315518]  [<ffffffff810fe660>] ? strndup_user+0x80/0xb0
> [    5.315518]  [<ffffffff8114ce8a>] sys_mount+0x8a/0xd0
> [    5.315518]  [<ffffffff8100ae02>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  fs/btrfs/disk-io.c          |    4 ++--
>  fs/btrfs/extent_io.c        |    4 ++--
>  fs/btrfs/extent_map.c       |    2 +-
>  fs/btrfs/free-space-cache.c |    4 ++--
>  fs/btrfs/ordered-data.h     |    2 +-
>  fs/btrfs/ref-cache.h        |    2 +-
>  fs/btrfs/relocation.c       |    4 ++--
>  fs/btrfs/transaction.c      |    2 +-
>  8 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2b59201..0427183 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -901,7 +901,7 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
>  	root->highest_objectid = 0;
>  	root->name = NULL;
>  	root->in_sysfs = 0;
> -	root->inode_tree.rb_node = NULL;
> +	root->inode_tree = RB_ROOT;
>  
>  	INIT_LIST_HEAD(&root->dirty_list);
>  	INIT_LIST_HEAD(&root->orphan_list);
> @@ -1673,7 +1673,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
>  	insert_inode_hash(fs_info->btree_inode);
>  
>  	spin_lock_init(&fs_info->block_group_cache_lock);
> -	fs_info->block_group_cache_tree.rb_node = NULL;
> +	fs_info->block_group_cache_tree = RB_ROOT;
>  
>  	extent_io_tree_init(&fs_info->freed_extents[0],
>  			     fs_info->btree_inode->i_mapping, GFP_NOFS);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b177ed3..7073cbb 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -104,8 +104,8 @@ void extent_io_exit(void)
>  void extent_io_tree_init(struct extent_io_tree *tree,
>  			  struct address_space *mapping, gfp_t mask)
>  {
> -	tree->state.rb_node = NULL;
> -	tree->buffer.rb_node = NULL;
> +	tree->state = RB_ROOT;
> +	tree->buffer = RB_ROOT;
>  	tree->ops = NULL;
>  	tree->dirty_bytes = 0;
>  	spin_lock_init(&tree->lock);
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 428fcac..28d87ba 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -35,7 +35,7 @@ void extent_map_exit(void)
>   */
>  void extent_map_tree_init(struct extent_map_tree *tree, gfp_t mask)
>  {
> -	tree->map.rb_node = NULL;
> +	tree->map = RB_ROOT;
>  	rwlock_init(&tree->lock);
>  }
>  
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index cb2849f..dd831ed 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -870,7 +870,7 @@ __btrfs_return_cluster_to_free_space(
>  		tree_insert_offset(&block_group->free_space_offset,
>  				   entry->offset, &entry->offset_index, 0);
>  	}
> -	cluster->root.rb_node = NULL;
> +	cluster->root = RB_ROOT;
>  
>  out:
>  	spin_unlock(&cluster->lock);
> @@ -1355,7 +1355,7 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
>  {
>  	spin_lock_init(&cluster->lock);
>  	spin_lock_init(&cluster->refill_lock);
> -	cluster->root.rb_node = NULL;
> +	cluster->root = RB_ROOT;
>  	cluster->max_size = 0;
>  	cluster->points_to_bitmap = false;
>  	INIT_LIST_HEAD(&cluster->block_group_list);
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 1fe1282..9116c6d 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -129,7 +129,7 @@ static inline void
>  btrfs_ordered_inode_tree_init(struct btrfs_ordered_inode_tree *t)
>  {
>  	mutex_init(&t->mutex);
> -	t->tree.rb_node = NULL;
> +	t->tree = RB_ROOT;
>  	t->last = NULL;
>  }
>  
> diff --git a/fs/btrfs/ref-cache.h b/fs/btrfs/ref-cache.h
> index bc283ad..e2a55cb 100644
> --- a/fs/btrfs/ref-cache.h
> +++ b/fs/btrfs/ref-cache.h
> @@ -52,7 +52,7 @@ static inline size_t btrfs_leaf_ref_size(int nr_extents)
>  
>  static inline void btrfs_leaf_ref_tree_init(struct btrfs_leaf_ref_tree *tree)
>  {
> -	tree->root.rb_node = NULL;
> +	tree->root = RB_ROOT;
>  	INIT_LIST_HEAD(&tree->list);
>  	spin_lock_init(&tree->lock);
>  }
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index ab7ab53..0109e56 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -170,14 +170,14 @@ struct async_merge {
>  
>  static void mapping_tree_init(struct mapping_tree *tree)
>  {
> -	tree->rb_root.rb_node = NULL;
> +	tree->rb_root = RB_ROOT;
>  	spin_lock_init(&tree->lock);
>  }
>  
>  static void backref_cache_init(struct backref_cache *cache)
>  {
>  	int i;
> -	cache->rb_root.rb_node = NULL;
> +	cache->rb_root = RB_ROOT;
>  	for (i = 0; i < BTRFS_MAX_LEVEL; i++)
>  		INIT_LIST_HEAD(&cache->pending[i]);
>  	spin_lock_init(&cache->lock);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index b2acc79..2a36e23 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -69,7 +69,7 @@ static noinline int join_transaction(struct btrfs_root *root)
>  		cur_trans->commit_done = 0;
>  		cur_trans->start_time = get_seconds();
>  
> -		cur_trans->delayed_refs.root.rb_node = NULL;
> +		cur_trans->delayed_refs.root = RB_ROOT;
>  		cur_trans->delayed_refs.num_entries = 0;
>  		cur_trans->delayed_refs.num_heads_ready = 0;
>  		cur_trans->delayed_refs.num_heads = 0;
> 


