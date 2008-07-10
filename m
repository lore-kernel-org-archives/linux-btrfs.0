From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs orphan support
Date: Thu, 10 Jul 2008 09:04:04 -0400
Message-ID: <1215695044.24425.207.camel@think.oraclecorp.com>
References: <20080709184316.GO2088@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080709184316.GO2088@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-09 at 14:43 -0400, Josef Bacik wrote:
> Hello,
> 
> This patch makes it so btrfs can handle unlink's and truncates that are
> interrupted.  On unlink/truncate an orphan item is added with the location of
> the inode.  When the truncation/deletion is completed the orphan item is
> removed.  If a crash happens in between the orphaned inodes are processed at
> root lookup time.  This also catches the case where the inode deletion may have
> occured but the orphan item wasn't removed.  Tested with a bunch of stuff to
> make sure everything is working.  Thank you,
> 

Fantastic, thanks Josef.  A few comments below.
> d so it also defines (optimal)
> @@ -621,6 +625,10 @@ struct btrfs_root {
>  
>  	/* the dirty list is only used by non-reference counted roots */
>  	struct list_head dirty_list;
> +
> +	/* orphan crap */

Crap is worse than no comments at all ;)

>  
> +int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
> +			     struct btrfs_root *root, u64 offset,
> +			     struct btrfs_key *location)
> +{
> +	struct btrfs_disk_key disk_key;
> +	struct btrfs_dir_item *dir_item;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +	struct extent_buffer *leaf;
> +	int ret = 0;
> +	u32 data_size;
> +
> +	key.objectid = BTRFS_ORPHAN_OBJECTID;
> +	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
> +	key.offset = offset;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	data_size = sizeof(*dir_item);
> +	dir_item = insert_with_overflow(trans, root, path, &key,
> +					data_size, "", 0);

I thought your plan to move away from dir items would use a new item
type completely.

We only really need to store the objectid of the inode, which is already
encoded in the key offset field.  So, you could try an 0 length item and
we can fix up any problems that result in the btree code (I think it'll
tolerate this).

> +int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_key key;
> +	int ret = 0;
> +
> +	mutex_lock(&root->orphan_mutex);

This orphan mutex is going to serialize things pretty badly, since you
could be doing IO with it held.  Could you please make this a spin lock
held only during list manipulation?

The inode i_mutex should protect us from inserting/removing the same
inode at the same time into the orphan index.

Thanks again, this is great.

-chris


