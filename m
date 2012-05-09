From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 1/5] btrfs: extend readahead interface
Date: Wed, 9 May 2012 16:48:01 +0200
Message-ID: <20120509144800.GL19331@twin.jikos.cz>
References: <cover.1334241664.git.sensille@gmx.net>
 <32d2d06e11e45bde2f092d647991b712d2e825b6.1334241664.git.sensille@gmx.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <32d2d06e11e45bde2f092d647991b712d2e825b6.1334241664.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 05:54:38PM +0200, Arne Jansen wrote:
> @@ -97,30 +119,87 @@ struct reada_machine_work {
> +/*
> + * this is the default callback for readahead. It just descends into the
> + * tree within the range given at creation. if an error occurs, just cut
> + * this part of the tree
> + */
> +static void readahead_descend(struct btrfs_root *root, struct reada_control *rc,
> +			      u64 wanted_generation, struct extent_buffer *eb,
> +			      u64 start, int err, struct btrfs_key *top,
> +			      void *ctx)
> +{
> +	int nritems;
> +	u64 generation;
> +	int level;
> +	int i;
> +
> +	BUG_ON(err == -EAGAIN); /* FIXME: not yet implemented, don't cancel
> +				 * readahead with default callback */
> +
> +	if (err || eb == NULL) {
> +		/*
> +		 * this is the error case, the extent buffer has not been
> +		 * read correctly. We won't access anything from it and
> +		 * just cleanup our data structures. Effectively this will
> +		 * cut the branch below this node from read ahead.
> +		 */
> +		return;
> +	}
> +
> +	level = btrfs_header_level(eb);
> +	if (level == 0) {
> +		/*
> +		 * if this is a leaf, ignore the content.
> +		 */
> +		return;
> +	}
> +
> +	nritems = btrfs_header_nritems(eb);
> +	generation = btrfs_header_generation(eb);
> +
> +	/*
> +	 * if the generation doesn't match, just ignore this node.
> +	 * This will cut off a branch from prefetch. Alternatively one could
> +	 * start a new (sub-) prefetch for this branch, starting again from
> +	 * root.
> +	 */
> +	if (wanted_generation != generation)
> +		return;

I think I saw passing wanted_generation = 0 somewheree, but cannot find
it now again. Is it an expected value for the default RA callback,
meaning eg.  'any generation I find' ?

> +
> +	for (i = 0; i < nritems; i++) {
> +		u64 n_gen;
> +		struct btrfs_key key;
> +		struct btrfs_key next_key;
> +		u64 bytenr;
> +
> +		btrfs_node_key_to_cpu(eb, &key, i);
> +		if (i + 1 < nritems)
> +			btrfs_node_key_to_cpu(eb, &next_key, i + 1);
> +		else
> +			next_key = *top;
> +		bytenr = btrfs_node_blockptr(eb, i);
> +		n_gen = btrfs_node_ptr_generation(eb, i);
> +
> +		if (btrfs_comp_cpu_keys(&key, &rc->key_end) < 0 &&
> +		    btrfs_comp_cpu_keys(&next_key, &rc->key_start) > 0)
> +			reada_add_block(rc, bytenr, &next_key,
> +					level - 1, n_gen, ctx);
> +	}
> +}
>  
> @@ -142,65 +221,21 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
>  	re->scheduled_for = NULL;
>  	spin_unlock(&re->lock);
>  
> -	if (err == 0) {
> -		nritems = level ? btrfs_header_nritems(eb) : 0;
> -		generation = btrfs_header_generation(eb);
> -		/*
> -		 * FIXME: currently we just set nritems to 0 if this is a leaf,
> -		 * effectively ignoring the content. In a next step we could
> -		 * trigger more readahead depending from the content, e.g.
> -		 * fetch the checksums for the extents in the leaf.
> -		 */
> -	} else {
> +	/*
> +	 * call hooks for all registered readaheads
> +	 */
> +	list_for_each_entry(rec, &list, list) {
> +		btrfs_tree_read_lock(eb);
>  		/*
> -		 * this is the error case, the extent buffer has not been
> -		 * read correctly. We won't access anything from it and
> -		 * just cleanup our data structures. Effectively this will
> -		 * cut the branch below this node from read ahead.
> +		 * we set the lock to blocking, as the callback might want to
> +		 * sleep on allocations.

What about a more finer control given to the callbacks? The blocking
lock may be unnecessary if the callback does not sleep.

My idea is to add a field to 'struct reada_uptodate_ctx', preset with
BTRFS_READ_LOCK by default, but let the RA user to set it to its needs.

>  		 */
> -		nritems = 0;
> -		generation = 0;
> +		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> +		rec->rc->callback(root, rec->rc, rec->generation, eb, start,
> +				  err, &re->top, rec->ctx);
> +		btrfs_tree_read_unlock_blocking(eb);
>  	}
>  
> @@ -521,12 +593,87 @@ static void reada_control_release(struct kref *kref)
> +/*
> + * context to pass from reada_add_block to worker in case the extent is
> + * already uptodate in memory
> + */
> +struct reada_uptodate_ctx {
> +	struct btrfs_key	top;
> +	struct extent_buffer	*eb;
> +	struct reada_control	*rc;
> +	u64			logical;
> +	u64			generation;
> +	void			*ctx;
> +	struct btrfs_work	work;

eg.
        int                     lock_type;
	int                     want_lock_blocking;


> +};
> +
> +/* worker for immediate processing of uptodate blocks */
> +static void reada_add_block_uptodate(struct btrfs_work *work)
> +{
> +	struct reada_uptodate_ctx *ruc;
> +
> +	ruc = container_of(work, struct reada_uptodate_ctx, work);
> +
> +	btrfs_tree_read_lock(ruc->eb);
> +	/*
> +	 * we set the lock to blocking, as the callback might want to sleep
> +	 * on allocations.
> +	 */
> +	btrfs_set_lock_blocking_rw(ruc->eb, BTRFS_READ_LOCK);

same here

> +	ruc->rc->callback(ruc->rc->root, ruc->rc, ruc->generation, ruc->eb,
> +			 ruc->logical, 0, &ruc->top, ruc->ctx);
> +	btrfs_tree_read_unlock_blocking(ruc->eb);
> +
> +	reada_control_elem_put(ruc->rc);
> +	free_extent_buffer(ruc->eb);
> +	kfree(ruc);
> +}
> +
> @@ -886,17 +1074,18 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
>  		.offset = (u64)-1
>  	};
>  
> -	rc = kzalloc(sizeof(*rc), GFP_NOFS);
> +	rc = btrfs_reada_alloc(parent, root, key_start, key_end, callback);
>  	if (!rc)
> -		return ERR_PTR(-ENOMEM);
> +		return -ENOMEM;
>  
> -	rc->root = root;
> -	rc->key_start = *key_start;
> -	rc->key_end = *key_end;
> -	atomic_set(&rc->elems, 0);
> -	init_waitqueue_head(&rc->wait);
> -	kref_init(&rc->refcnt);
> -	kref_get(&rc->refcnt); /* one ref for having elements */
> +	if (rcp) {
> +		*rcp = rc;
> +		/*
> +		 * as we return the rc, get an addition ref on it for
                                              (additional)

> +		 * the caller
> +		 */
> +		kref_get(&rc->refcnt);
> +	}
>  
>  	node = btrfs_root_node(root);
>  	start = node->start;
> @@ -904,35 +1093,36 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
> +int btrfs_reada_wait(struct reada_control *rc)
>  {
> -	struct reada_control *rc = handle;
> +	struct btrfs_fs_info *fs_info = rc->root->fs_info;
> +	int i;
>  
>  	while (atomic_read(&rc->elems)) {
>  		wait_event_timeout(rc->wait, atomic_read(&rc->elems) == 0,
> -				   5 * HZ);
> -		dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
> +				   1 * HZ);

I think it's recommended to use msecs_to_jiffies instead of HZ.

> +		dump_devs(fs_info, atomic_read(&rc->elems) < 10 ? 1 : 0);
> +		printk(KERN_DEBUG "reada_wait on %p: %d elems\n", rc,
> +			atomic_read(&rc->elems));
>  	}
>  
> -	dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
> +	dump_devs(fs_info, atomic_read(&rc->elems) < 10 ? 1 : 0);
>  
>  	kref_put(&rc->refcnt, reada_control_release);
>  
>  	return 0;
>  }

--

The reference counting changed in a non-trivial way, I'd like to have
another look just at that to be sure, but from current review round it
looks ok.

The RA changes look independet, do you intend to submit it earlier that
with the whole droptree? It'd get wider testing.


david
