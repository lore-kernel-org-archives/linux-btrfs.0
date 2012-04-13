From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 4/5] btrfs: droptree implementation
Date: Fri, 13 Apr 2012 08:48:56 +0200
Message-ID: <4F87CC58.6070807@gmx.net>
References: <cover.1334241664.git.sensille@gmx.net> <6a200b1882b935d4dbde8d496b4ef655a4f750de.1334241664.git.sensille@gmx.net> <4F879544.2000807@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F879544.2000807@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13.04.2012 04:53, Tsutomu Itoh wrote:
> Hi, Arne,
> 
> (2012/04/13 0:54), Arne Jansen wrote:
>> This is an implementation of snapshot deletion using the readahead
>> framework. Multiple snapshots can be deleted at once and the trees
>> are not enumerated sequentially but in parallel in many branches.
>> This way readahead can reorder the request to better utilize all
>> disks. For a more detailed description see inline comments.
>>
>> Signed-off-by: Arne Jansen<sensille@gmx.net>
>> ---

[snip]

>> +/*
>> + * read the saved state from the droptree inode and prepare everything so
>> + * it gets started by droptree_restart
>> + */
>> +static int droptree_read_state(struct btrfs_fs_info *fs_info,
>> +			       struct inode *inode,
>> +			       struct reada_control *top_rc,
>> +			       struct list_head *droplist)
>> +{
>> +	struct io_ctl io_ctl;
>> +	u32 version;
>> +	u64 generation;
>> +	struct droptree_node **stack;
>> +	int ret = 0;
>> +
>> +	stack = kmalloc(sizeof(*stack) * BTRFS_MAX_LEVEL, GFP_NOFS);
>> +	if (!stack)
>> +		return -ENOMEM;
>> +
>> +	io_ctl_init(&io_ctl, inode, fs_info->tree_root);
>> +	io_ctl.check_crcs = 0;
>> +	io_ctl_prepare_pages(&io_ctl, inode, 1);
>> +
>> +	version = io_ctl_get_u32(&io_ctl);
>> +	if (version != DROPTREE_VERSION) {
>> +		printk(KERN_ERR "btrfs: snapshot deletion state has been saved "
>> +				"with a different version, ignored\n");
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +	/* FIXME generation is currently not needed */
>> +	generation = io_ctl_get_u64(&io_ctl);
>> +
>> +	while (1) {
>> +		struct btrfs_key key;
>> +		int ret;
>> +		struct btrfs_root *del_root;
>> +		struct droptree_root *dr;
>> +		int level;
>> +		int max_level;
>> +		struct droptree_node *root_dn;
>> +
>> +		key.objectid = io_ctl_get_u64(&io_ctl);
>> +		if (key.objectid == 0)
>> +			break;
>> +
>> +		key.type = BTRFS_ROOT_ITEM_KEY;
>> +		key.offset = io_ctl_get_u64(&io_ctl);
>> +		max_level = level = io_ctl_get_u8(&io_ctl);
>> +
>> +		BUG_ON(level<  0 || level>= BTRFS_MAX_LEVEL); /* incons. fs */
>> +		del_root = btrfs_read_fs_root_no_radix(fs_info->tree_root,
>> +							&key);
>> +		if (IS_ERR(del_root)) {
>> +			ret = PTR_ERR(del_root);
>> +			BUG(); /* inconsistent fs */
>> +		}
>> +
>> +		root_dn = droptree_alloc_node(NULL);
>> +		/*
>> +		 * FIXME in this phase is should still be possible to undo
>> +		 * everything and return a failure. Same goes for the allocation
>> +		 * failures below
>> +		 */
>> +		BUG_ON(!root_dn); /* can't back out */
>> +		dr = droptree_add_droproot(droplist, root_dn, del_root);
>> +		BUG_ON(!dr); /* can't back out */
>> +
>> +		stack[level] = root_dn;
>> +
>> +		while (1) {
>> +			u64 start;
>> +			u64 len;
>> +			u64 nritems;
>> +			u32 *map;
>> +			int n;
>> +			int i;
>> +			int parent_slot;
>> +			struct droptree_node *dn;
>> +
>> +			parent_slot = io_ctl_get_u16(&io_ctl);
>> +			if (parent_slot == DROPTREE_STATE_GO_UP) {
>> +				++level;
>> +				BUG_ON(level>  max_level); /* incons. fs */
>> +				continue;
>> +			}
>> +			if (parent_slot == DROPTREE_STATE_GO_DOWN) {
>> +				--level;
>> +				BUG_ON(level<  0); /* incons. fs */
>> +				continue;
>> +			}
>> +			if (parent_slot == DROPTREE_STATE_END)
>> +				break;
>> +			start = io_ctl_get_u64(&io_ctl);
>> +			if (start == 0)
>> +				break;
>> +
>> +			len = io_ctl_get_u64(&io_ctl);
>> +			nritems = io_ctl_get_u16(&io_ctl);
>> +			n = DT_BITS_TO_U32(nritems);
>> +			BUG_ON(n>  999999); /* incons. fs */
>> +			BUG_ON(n == 0); /* incons. fs */
>> +
>> +			map = kmalloc(n * sizeof(u32), GFP_NOFS);
>> +			BUG_ON(!map); /* can't back out */
>> +
>> +			for (i = 0; i<  n; ++i)
>> +				map[i] = io_ctl_get_u32(&io_ctl);
>> +
>> +			if (level == max_level) {
>> +				/* only for root node */
>> +				dn = stack[level];
>> +			} else {
>> +				dn = droptree_alloc_node(dr);
>> +				BUG_ON(!dn); /* can't back out */
>> +				dn->parent = stack[level + 1];
>> +				dn->parent_slot = parent_slot;
>> +				list_add_tail(&dn->next,
>> +					&stack[level+1]->children);
>> +				stack[level] = dn;
>> +			}
>> +			dn->level = level;
>> +			dn->start = start;
>> +			dn->len = len;
>> +			dn->map = map;
>> +			dn->nritems = nritems;
>> +			dn->generation = 0;
>> +		}
>> +		ret = droptree_reada_root(top_rc, dr);
>> +		BUG_ON(ret); /* can't back out */
>> +	}
>> +out:
>> +	io_ctl_drop_pages(&io_ctl);
>> +	io_ctl_free(&io_ctl);
>> +	kfree(stack);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * called from transaction.c with a list of roots to delete
>> + */
>> +void droptree_drop_list(struct btrfs_fs_info *fs_info, struct list_head *list)
>> +{
>> +	struct btrfs_root *root = fs_info->tree_root;
>> +	struct inode *inode = NULL;
>> +	struct btrfs_path *path = NULL;
>> +	int ret;
>> +	struct btrfs_trans_handle *trans;
>> +	u64 alloc_hint = 0;
>> +	u64 prealloc;
>> +	loff_t oldsize;
>> +	long max_nodes;
>> +	int i;
>> +	struct list_head droplist;
>> +	struct droptree_root *dr;
>> +	struct droptree_root *dtmp;
>> +	int running_roots = 0;
>> +	struct reada_control *top_rc = NULL;
>> +
>> +	if (btrfs_fs_closing(fs_info))
>> +		return;
>> +
>> +	inode = droptree_get_inode(fs_info);
> 
>> +	if (IS_ERR(inode))
> 
> 	if (IS_ERR_OR_NULL(inode))

got it, thanks for catching it.

-Arne

> 
> Thanks,
> Tsutomu
> 
> 
