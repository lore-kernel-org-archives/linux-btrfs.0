From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH 1/3] btrfs: extended inode refs
Date: Wed, 25 Apr 2012 12:19:21 +0200
Message-ID: <4F97CFA9.9010200@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <1333656543-4843-2-git-send-email-mfasheh@suse.de> <4F86D3CB.1010505@jan-o-sch.net> <20120424222356.GS17950@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120424222356.GS17950@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 25.04.2012 00:23, Mark Fasheh wrote:
> Jan, firstly thanks very much for the thorough review! I wanted to make sure
> I got the collision handling going before addressing the issues you found.
> Again thanks, and my notes are below.



> On Thu, Apr 12, 2012 at 03:08:27PM +0200, Jan Schmidt wrote:
>>> +/*
>>> + * Theoretical limit is larger, but we keep this down to a sane
>>> + * value. That should limit greatly the possibility of collisions on
>>> + * inode ref items.
>>> + */
>>> +#define BTRFS_LINK_MAX 65535U
>>
>> Do we really want an artificial limit like that?
> 
> I took a look at other file systems and this seems to be a pretty reasonable
> maximum. Ext4 and XFS in particular have similar limits.
> 
> Granted, btrfs should be better equipped to deal with large numbers of hard
> links - at least in the area of consistency checking.
> 
> That said, I think keeping this down to "only" 65 thousand hard links per
> inode should work out fine. Also it's not a large change to increase or
> remove the limit should we have to.

Agreed.

>>> -struct btrfs_inode_ref *
>>> +static int find_name_in_ext_backref(struct btrfs_path *path, const char *name,
>>> +				   int name_len, struct btrfs_inode_extref **ref_ret)
>>> +{
>>> +	struct extent_buffer *leaf;
>>> +	struct btrfs_inode_extref *ref;
>>> +	unsigned long ptr;
>>> +	unsigned long name_ptr;
>>> +	u32 item_size;
>>> +
>>> +	leaf = path->nodes[0];
>>> +	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
>>> +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
>>> +	ref = (struct btrfs_inode_extref *)ptr;
>>> +
>>> +	/*
>>> +	 * There isn't actually anything to "search" in an extended
>>> +	 * backref - one name is directly attached to each
>>> +	 * item. Instead what we're really doing here is some sort of
>>> +	 * sanity check - does the name exist where it should have
>>> +	 * been found. If all is well, we'll return success and the
>>> +	 * inode ref object.
>>> +	 */
>>
>> In that case, the name is not a good choice. However, if we change how
>> we deal with hash collisions, the name might be right and the comment
>> might go away as we really look through more than one item. If we leave
>> it like this, please rename that function.
> 
> Yeah, great catch. In the newer version as you've noted, it *is* actually a
> 'find me the name' function, so the comment (and resulting EROFS) have been
> removed.
> 
> 
>>> +	name_ptr = (unsigned long)(&ref->name);
>>> +	if (btrfs_inode_extref_name_len(leaf, ref) == name_len
>>> +	    && (memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)) {
>>> +		*ref_ret = ref;
>>> +		return 1;
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * Figure the key offset of an extended inode ref
>>> + */
>>> +u64 btrfs_extref_key_off(u64 parent_objectid, const char *name, int name_len)
>>
>> I'd suggest to call this one btrfs_extref_hash and move it to
>> fs/btrfs/hash.h. That way, we can also drop the include for
>> <linux/crc32c.h> above.
> 
> Done.
> 
> 
>>> +{
>>> +	return (u64) crc32c(parent_objectid, name, name_len);
>>> +}
>>> +
>>> +static struct btrfs_inode_ref *
>>>  btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
>>> -			struct btrfs_root *root,
>>> -			struct btrfs_path *path,
>>> -			const char *name, int name_len,
>>> -			u64 inode_objectid, u64 ref_objectid, int mod)
>>> +		       struct btrfs_root *root,
>>> +		       struct btrfs_path *path,
>>> +		       const char *name, int name_len,
>>> +		       u64 inode_objectid, u64 ref_objectid, int ins_len,
>>> +		       int cow)
>>>  {
>>> +	int ret;
>>>  	struct btrfs_key key;
>>>  	struct btrfs_inode_ref *ref;
>>> -	int ins_len = mod < 0 ? -1 : 0;
>>> -	int cow = mod != 0;
>>> -	int ret;
>>>  
>>>  	key.objectid = inode_objectid;
>>>  	key.type = BTRFS_INODE_REF_KEY;
>>> @@ -76,20 +115,137 @@ btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
>>>  	return ref;
>>>  }
>>>  
>>> -int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>>> +struct btrfs_inode_extref *
>>> +btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
>>> +			  struct btrfs_root *root,
>>> +			  struct btrfs_path *path,
>>> +			  const char *name, int name_len,
>>> +			  u64 inode_objectid, u64 ref_objectid, int ins_len,
>>> +			  int cow)
>>> +{
>>> +	int ret;
>>> +	struct btrfs_key key;
>>> +	struct btrfs_inode_extref *ref;
>>                                    ^^^
>> Please use some other identifier than the one we use for struct
>> btrfs_inode_ref. Suggestion: extref or eref.
> 
> Yeah I'll make sure they're all changed to extref. Makes it much easier to
> read.
> 
> 
>>> +
>>> +	key.objectid = inode_objectid;
>>> +	key.type = BTRFS_INODE_EXTREF_KEY;
>>> +	key.offset = btrfs_extref_key_off(ref_objectid, name, name_len);
>>                      ^^^^^^^^^^^^^^^^^^^^
>> Get's clearer when that is called btrfs_extref_hash.
>>
>>> +
>>> +	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
>>> +	if (ret < 0)
>>> +		return ERR_PTR(ret);
>>> +	if (ret > 0)
>>> +		return NULL;
>>> +	if (!find_name_in_ext_backref(path, name, name_len, &ref))
>>> +		return NULL;
>>> +	return ref;
>>> +}
>>> +
>>> +int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
>>> +			      struct btrfs_root *root,
>>> +			      struct btrfs_path *path,
>>> +			      const char *name, int name_len,
>>> +			      u64 inode_objectid, u64 ref_objectid, int mod,
>>> +			      u64 *ret_index)
>>> +{
>>> +	struct btrfs_inode_ref *ref1;
>>> +	struct btrfs_inode_extref *ref2;
>>                                    ^^^^
>> Please, use "ref" and ("eref" or "extref").
>>
>>> +	int ins_len = mod < 0 ? -1 : 0;
>>> +	int cow = mod != 0;
>>> +
>>> +	ref1 = btrfs_lookup_inode_ref(trans, root, path, name, name_len,
>>> +				      inode_objectid, ref_objectid, ins_len,
>>> +				      cow);
>>> +	if (IS_ERR(ref1))
>>> +		return PTR_ERR(ref1);
>>> +
>>> +	if (ref1 != NULL) {
>>> +		*ret_index = btrfs_inode_ref_index(path->nodes[0], ref1);
>>> +		return 0;
>>> +	}
>>> +
>>> +	btrfs_release_path(path);
>>> +
>>> +	ref2 = btrfs_lookup_inode_extref(trans, root, path, name,
>>> +					 name_len, inode_objectid,
>>> +					 ref_objectid, ins_len, cow);
>>> +	if (IS_ERR(ref2))
>>> +		return PTR_ERR(ref2);
>>> +
>>> +	if (ref2) {
>>> +		*ret_index = btrfs_inode_extref_index(path->nodes[0], ref2);
>>> +		return 0;
>>> +	}
>>> +
>>> +	return -ENOENT;
>>> +}
>>> +
>>> +int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
>>>  			   struct btrfs_root *root,
>>>  			   const char *name, int name_len,
>>>  			   u64 inode_objectid, u64 ref_objectid, u64 *index)
>>>  {
>>>  	struct btrfs_path *path;
>>>  	struct btrfs_key key;
>>> +	struct btrfs_inode_extref *ref2;
>>                                    ^^^^
>>
>>> +	struct extent_buffer *leaf;
>>> +	int ret;
>>> +
>>> +	key.objectid = inode_objectid;
>>> +	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
>>> +	key.offset = btrfs_extref_key_off(ref_objectid, name, name_len);
>>> +
>>> +	path = btrfs_alloc_path();
>>> +	if (!path)
>>> +		return -ENOMEM;
>>> +
>>> +	path->leave_spinning = 1;
>>> +
>>> +	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>>> +	if (ret > 0) {
>>> +		ret = -ENOENT;
>>> +		goto out;
>>> +	} else if (ret < 0) {
>>> +		goto out;
>>> +	}
>>
>> Clearer (to me):
>>
>> if (ret > 0)
>> 	ret = -ENOENT;
>> if (ret < 0)
>> 	goto out;
> 
> Agreed, changed.
> 
>>
>>> +
>>> +	/*
>>> +	 * Sanity check - did we find the right item for this name?
>>> +	 * This should always succeed so error here will make the FS
>>> +	 * readonly.
>>> +	 */
>>> +	if (!find_name_in_ext_backref(path, name, name_len, &ref2)) {
>>> +		btrfs_std_error(root->fs_info, -ENOENT);
>>> +		ret = -EROFS;
>>
>> Simply returning -EROFS doesn't make the fs read-only, does it? I'd
>> suggest to return -EIO and drop the comment above.
> 
> Actually, the btrfs_std_error() line above that makes the FS readonly (in
> which case EROFS is a good return value).

Got it. -EROFS is a good choice, then.

> Btw, I think that since is this a request to delete the item that not
> finding it in the tree (even with the possiblity of collision handling) is
> still a possible corruption.
> 
> 
>>> +		goto out;
>>> +	}
>>> +
>>> +	leaf = path->nodes[0];
>>> +	if (index)
>>> +		*index = btrfs_inode_extref_index(leaf, ref2);
>>> +
>>> +	ret = btrfs_del_item(trans, root, path);
>>> +
>>> +out:
>>> +	btrfs_free_path(path);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>>> +			struct btrfs_root *root,
>>> +			const char *name, int name_len,
>>> +			u64 inode_objectid, u64 ref_objectid, u64 *index)
>>> +{
>>> +	struct btrfs_path *path;
>>> +	struct btrfs_key key;
>>>  	struct btrfs_inode_ref *ref;
>>>  	struct extent_buffer *leaf;
>>>  	unsigned long ptr;
>>>  	unsigned long item_start;
>>>  	u32 item_size;
>>>  	u32 sub_item_len;
>>> -	int ret;
>>> +	int ret, search_ext_refs = 0;
>>                ^^^^^^^^^^^^^^^^^^^^^
>> Documentation/CodingStyle:
>> --
>> To this end, use just one data declaration per line (no commas for
>> multiple data declarations).
>> --
>>
>> You do this multiple times in your whole patch set.
> 
> Sure, I can change that. There's lots of kernel code that blatantly ignores
> this but I suppose that's no excuse...
> 
> 
>>>  	int del_len = name_len + sizeof(*ref);
>>>  
>>>  	key.objectid = inode_objectid;
>>> @@ -105,12 +261,14 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>>>  	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>>>  	if (ret > 0) {
>>>  		ret = -ENOENT;
>>> +		search_ext_refs = 1;
>>>  		goto out;
>>>  	} else if (ret < 0) {
>>>  		goto out;
>>>  	}
>>>  	if (!find_name_in_backref(path, name, name_len, &ref)) {
>>>  		ret = -ENOENT;
>>> +		search_ext_refs = 1;
>>>  		goto out;
>>>  	}
>>>  	leaf = path->nodes[0];
>>> @@ -132,6 +290,59 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>>>  				  item_size - sub_item_len, 1);
>>>  out:
>>>  	btrfs_free_path(path);
>>> +
>>> +	if (search_ext_refs) {
>>
>> As far as I see it, you can drop search_ext_refs and simply go this way
>> on ret == -ENOENT.
> 
> I actually made it explicit on purpose. If you look at the function there's
> several places where ret can be set and then bubbled down. Instead of
> depending on the called functions never setting -ENOENT (and future
> programmers to get that it's a 'magic' value), I prefer to just explicitely
> set a single int variable.

Okay, sounds reasonable.

>>> +		/* 
>>                   ^
>> Catched by accident: trailing whitespace.
> 
> Oh thanks.
> 
>>
>>> +		 * No refs were found, or we could not find the
>>> +		 * name in our ref array. Find and remove the extended
>>> +		 * inode ref then.
>>> +		 */
>>> +		return btrfs_del_inode_extref(trans, root, name, name_len,
>>> +					      inode_objectid, ref_objectid, index);
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
>>> +				     struct btrfs_root *root,
>>> +				     const char *name, int name_len,
>>> +				     u64 inode_objectid, u64 ref_objectid, u64 index)
>>
>> Are we missing a check against BTRFS_LINK_MAX in this function?
> 
> No, the caller is supposed to check this, in theory before starting a
> transaction to change the FS. So btrfs_link() does the checking for us.

Is that worth a comment? Or is that clear to anybody familiar with such
things anyway (in which case I'd not add that comment)?

>>> +{
>>> +	struct btrfs_path *path;
>>> +	struct btrfs_key key;
>>> +	struct btrfs_inode_extref *ref;
>> extref
>>
>>> +	unsigned long ptr;
>>> +	int ret;
>>> +	int ins_len = name_len + sizeof(*ref);
>>> +
>>> +	key.objectid = inode_objectid;
>>> +	key.type = BTRFS_INODE_EXTREF_KEY;
>>> +	key.offset = btrfs_extref_key_off(ref_objectid, name, name_len);
>>> +
>>> +	path = btrfs_alloc_path();
>>> +	if (!path)
>>> +		return -ENOMEM;
>>> +
>>> +	path->leave_spinning = 1;
>>> +	ret = btrfs_insert_empty_item(trans, root, path, &key,
>>> +				      ins_len);
>>> +	if (ret < 0)
>>> +		goto out;
>>> +
>>> +	ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
>>> +			     struct btrfs_inode_extref);
>>> +
>>> +	btrfs_set_inode_extref_name_len(path->nodes[0], ref, name_len);
>>> +	btrfs_set_inode_extref_index(path->nodes[0], ref, index);
>>> +	btrfs_set_inode_extref_parent(path->nodes[0], ref, ref_objectid);
>>> +
>>> +	ptr = (unsigned long)&ref->name;
>>> +	write_extent_buffer(path->nodes[0], name, ptr, name_len);
>>> +	btrfs_mark_buffer_dirty(path->nodes[0]);
>>> +
>>> +out:
>>> +	btrfs_free_path(path);
>>>  	return ret;
>>>  }
>>>  
>>> @@ -189,6 +400,19 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
>>>  
>>>  out:
>>>  	btrfs_free_path(path);
>>> +
>>> +	if (ret == -EMLINK) {
>>> +		struct btrfs_super_block *disk_super = root->fs_info->super_copy;
>>> +		/* We ran out of space in the ref array. Need to
>>> +		 * add an extended ref. */
>>> +		if (btrfs_super_incompat_flags(disk_super)
>>> +		    & BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
>>> +			ret = btrfs_insert_inode_extref(trans, root, name,
>>> +							name_len,
>>> +							inode_objectid,
>>> +							ref_objectid, index);
>>> +	}
>>> +
>>>  	return ret;
>>>  }
>>>  
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index 892b347..0ca525d 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -2689,7 +2689,6 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
>>>  	struct btrfs_trans_handle *trans;
>>>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>>>  	struct btrfs_path *path;
>>> -	struct btrfs_inode_ref *ref;
>>>  	struct btrfs_dir_item *di;
>>>  	struct inode *inode = dentry->d_inode;
>>>  	u64 index;
>>> @@ -2803,17 +2802,16 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
>>>  	}
>>>  	btrfs_release_path(path);
>>>  
>>> -	ref = btrfs_lookup_inode_ref(trans, root, path,
>>> -				dentry->d_name.name, dentry->d_name.len,
>>> -				ino, dir_ino, 0);
>>> -	if (IS_ERR(ref)) {
>>> -		err = PTR_ERR(ref);
>>> +	ret = btrfs_get_inode_ref_index(trans, root, path, dentry->d_name.name,
>>> +					dentry->d_name.len, ino, dir_ino, 0, &index);
>>
>> This line is >80 chars. Please use scripts/checkpatch.pl to catch those.
> 
> Fixed.
> 
> 
>>> +	if (ret) {
>>> +		err = ret;
>>>  		goto out;
>>>  	}
>>> -	BUG_ON(!ref);
>>> +
>>>  	if (check_path_shared(root, path))
>>>  		goto out;
>>> -	index = btrfs_inode_ref_index(path->nodes[0], ref);
>>> +
>>>  	btrfs_release_path(path);
>>>  
>>>  	/*
>>> @@ -4484,6 +4482,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>>>  	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
>>>  	key[0].offset = 0;
>>>  
>>> +	/*
>>> +	 * Start new inodes with a V1 ref. This is slightly more
>>> +	 * efficient for small numbers of hard links.
>>> +	 */
>>
>> I'd drop that comment. extref is no "V2" kind of ref. But you can leave
>> it in if you feel it helps anyone later. 
> 
> Yeah at one point they were called 'v2' due to developer laziness :)
> 
> I've updated the comment:
> 
> 	/*
> 	 * Start new inodes with an inode_ref. This is slightly more
> 	 * efficient for small numbers of hard links since they will
> 	 * be packed into one item. Extended refs will kick in if we
> 	 * add more hard links than can fit in the ref item.
> 	 */
> 
> 
> It could probably still be improved beyond that. Mostly I want to point out
> that we never start with extended refs so that anyone looking at the code
> will understand the 'flow' of btrfs inode references.

I think its fine like it stands above.

-Jan

>>>  	key[1].objectid = objectid;
>>>  	btrfs_set_key_type(&key[1], BTRFS_INODE_REF_KEY);
>>>  	key[1].offset = ref_objectid;
>>> @@ -4777,7 +4779,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>>>  	if (root->objectid != BTRFS_I(inode)->root->objectid)
>>>  		return -EXDEV;
>>>  
>>> -	if (inode->i_nlink == ~0U)
>>> +	if (inode->i_nlink >= BTRFS_LINK_MAX)
>>>  		return -EMLINK;
>>>  
>>>  	err = btrfs_set_inode_index(dir, &index);
>>
>> Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> 
> Thanks again Jan. I'll be sure to CC you on my next drop!
> 	--Mark
> 
> --
> Mark Fasheh
