From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 2/3] btrfs: extended inode refs
Date: Tue, 1 May 2012 11:39:12 -0700
Message-ID: <20120501183912.GU17950@wotan.suse.de>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <1333656543-4843-3-git-send-email-mfasheh@suse.de> <4F86FA6B.8020509@jan-o-sch.net>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F86FA6B.8020509@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 05:53:15PM +0200, Jan Schmidt wrote:
> Hi Mark,
> 
> While reading 3/3 I stumbled across one more thing in this one:
> 
> On 05.04.2012 22:09, Mark Fasheh wrote:
> > +int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> > +			  u64 start_off, struct btrfs_path *path,
> > +			  struct btrfs_inode_extref **ret_ref, u64 *found_off)
> > +{
> > +	int ret, slot;
> > +	struct btrfs_key key, found_key;
> > +	struct btrfs_inode_extref *ref;
> > +	struct extent_buffer *leaf;
> > +	struct btrfs_item *item;
> > +	unsigned long ptr;
> >  
> > -/*
> > - * There are a few corners where the link count of the file can't
> > - * be properly maintained during replay.  So, instead of adding
> > - * lots of complexity to the log code, we just scan the backrefs
> > - * for any file that has been through replay.
> > - *
> > - * The scan will update the link count on the inode to reflect the
> > - * number of back refs found.  If it goes down to zero, the iput
> > - * will free the inode.
> > - */
> > -static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
> > -					   struct btrfs_root *root,
> > -					   struct inode *inode)
> > +	key.objectid = inode_objectid;
> > +	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
> > +	key.offset = start_off;
> > +
> > +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	while (1) {
> > +		leaf = path->nodes[0];
> > +		slot = path->slots[0];
> > +		if (slot >= btrfs_header_nritems(leaf)) {
> > +			/*
> > +			 * If the item at offset is not found,
> > +			 * btrfs_search_slot will point us to the slot
> > +			 * where it should be inserted. In our case
> > +			 * that will be the slot directly before the
> > +			 * next INODE_REF_KEY_V2 item. In the case
> > +			 * that we're pointing to the last slot in a
> > +			 * leaf, we must move one leaf over.
> > +			 */
> > +			ret = btrfs_next_leaf(root, path);
> > +			if (ret) {
> > +				if (ret >= 1)
> > +					ret = -ENOENT;
> > +				break;
> > +			}
> > +			continue;
> > +		}
> > +
> > +		item = btrfs_item_nr(leaf, slot);
> > +		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> > +
> > +		/*
> > +		 * Check that we're still looking at an extended ref key for
> > +		 * this particular objectid. If we have different
> > +		 * objectid or type then there are no more to be found
> > +		 * in the tree and we can exit.
> > +		 */
> > +		ret = -ENOENT;
> > +		if (found_key.objectid != inode_objectid)
> > +			break;
> > +		if (btrfs_key_type(&found_key) != BTRFS_INODE_EXTREF_KEY)
> > +			break;
> > +
> > +		ret = 0;
> > +		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> > +		ref = (struct btrfs_inode_extref *)ptr;
> > +		*ret_ref = ref;
> > +		if (found_off)
> > +			*found_off = found_key.offset + 1;
>                                                       ^^^
> It's evil to call it "found offset" an then return one larger than the
> offset found. No caller would ever expect this.
> 
> > +		break;
> > +	}
> > +
> > +out:
> > +	return ret;
> > +}
> > +
> > +static int count_inode_extrefs(struct btrfs_root *root,
> > +			       struct inode *inode, struct btrfs_path *path)
> > +{
> > +	int ret;
> > +	unsigned int nlink = 0;
> > +	u64 inode_objectid = btrfs_ino(inode);
> > +	u64 offset = 0;
> > +	struct btrfs_inode_extref *ref;
> > +
> > +	while (1) {
> > +		ret = btrfs_find_one_extref(root, inode_objectid, offset, path,
> > +					    &ref, &offset);
> > +		if (ret)
> > +			break;
> > +
> > +		nlink++;
> > +		offset++;
> 		^^^^^^^^
> Huh. See? The caller expected to get the offset found from
> btrfs_find_one_extref. As it stands you might be missing the very next key.

Oh yeah that was totally broken btw. Fixed now, but forgot to mention that
:)

btrfs_find_one_extref() now returns the actual found offset (and the callers
can just increment if they're doing a search).
	--Mark


--
Mark Fasheh
