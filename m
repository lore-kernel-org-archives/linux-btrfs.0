Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40185 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754006AbeFKHsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 03:48:38 -0400
Subject: Re: [PATCH 02/15] btrfs-progs: Remove root argument from
 btrfs_del_csums
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-3-git-send-email-nborisov@suse.com>
 <15794890-c9d4-a2da-d507-8836407c4bae@gmx.com>
 <5cf49c2c-15c6-762a-f0a0-156b309c7b03@suse.com>
 <6a63bd0b-83b0-b9e1-059d-255ec331cf59@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <09dddfe4-578d-59a6-3f02-e526c1defdfd@suse.com>
Date: Mon, 11 Jun 2018 10:48:35 +0300
MIME-Version: 1.0
In-Reply-To: <6a63bd0b-83b0-b9e1-059d-255ec331cf59@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.06.2018 10:40, Qu Wenruo wrote:
> 
> 
> On 2018年06月11日 15:02, Nikolay Borisov wrote:
>>
>>
>> On 11.06.2018 07:46, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年06月08日 20:47, Nikolay Borisov wrote:
>>>> It's not needed, since we can obtain a reference to fs_info from the
>>>> passed transaction handle. This is needed by delayed refs code.
>>>
>>> This looks a little too aggressive to me.
>>>
>>> Normally we would expect parameters like @trans then @fs_info.
>>> Although @trans only let us get @fs_info, under certain case @trans
>>> could be NULL (like btrfs_search_slot).
>>>
>>> Although for btrfs_del_csums() @tran can be NULL, I still prefer the
>>> @trans, @fs_info parameters.
>>
>> The reason I'm making those prep patches i because I would like to get
>> rid of the root argument from _free_extent,
> 
> For this part, I completely agree with you.
> 
> The root doesn't make sense, getting rid of it is completely fine.
> The abuse of btrfs_root as parameter should be stopped, and we have tons
> of such cleanup both in kernel and btrfs-progs.
> 
> The only concern is about possible NULL @trans parameter.
> However it could be easily addressed by adding 'restrict' prefix.
> 
> So just adding 'restrict', and then the whole cleanup part is fine to me.

you mean making it "struct btrfs_trans_handle * restrict trans". But
restrict deals with pointer aliasing it doesn't have any bearing on the
NULL-ability of trans. I'm afraid I don't follow your logic here, care
to explain further?

> 
> Thanks,
> Qu
> 
>> since if you look at the
>> later delayed refs patches - patch 12/15 you'd see that the adapter
>> function __free_extent2 doesn't really have a root pointer as an
>> argument. If you also take a look at 10/15 (add delayed refs
>> infrastructure), the functions which create the delayed refs also don't
>> take a struct btrfs_root as an argument.
>>
>> Alternatively I can perhaps wire up a call to btrfs_read_fs_root in
>> __free_extent which will be using the "ref->root" id to obtain struct
>> btrfs_root. However, due to the way FST fixup is implemented (I still
>> haven't sent that code) it's possible that we call __free_extent2 with
>> the freespace root set to 0 so if btrfs_read_fs_root is called it will
>> return an -ENOENT.
>>
>> In conclusion what you suggest *could* be done but it will require
>> re-engineering the currently-tested FST code + delayed refs code. Given
>> the purpose of the root argument in this callchain I'd rather eliminate
>> it altogether and not bother with it.
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>>
>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>> ---
>>>>  btrfs-corrupt-block.c |  2 +-
>>>>  ctree.h               |  3 +--
>>>>  extent-tree.c         |  2 +-
>>>>  file-item.c           | 20 ++++++++++----------
>>>>  4 files changed, 13 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
>>>> index 4fbea26cda20..3add8e63b7bb 100644
>>>> --- a/btrfs-corrupt-block.c
>>>> +++ b/btrfs-corrupt-block.c
>>>> @@ -926,7 +926,7 @@ static int delete_csum(struct btrfs_root *root, u64 bytenr, u64 bytes)
>>>>  		return PTR_ERR(trans);
>>>>  	}
>>>>  
>>>> -	ret = btrfs_del_csums(trans, root, bytenr, bytes);
>>>> +	ret = btrfs_del_csums(trans, bytenr, bytes);
>>>>  	if (ret)
>>>>  		fprintf(stderr, "Error deleting csums %d\n", ret);
>>>>  	btrfs_commit_transaction(trans, root);
>>>> diff --git a/ctree.h b/ctree.h
>>>> index de4b1b7e6416..082726238b91 100644
>>>> --- a/ctree.h
>>>> +++ b/ctree.h
>>>> @@ -2752,8 +2752,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>>>>  			u64 ino, u64 parent_ino, u64 *index);
>>>>  
>>>>  /* file-item.c */
>>>> -int btrfs_del_csums(struct btrfs_trans_handle *trans,
>>>> -		    struct btrfs_root *root, u64 bytenr, u64 len);
>>>> +int btrfs_del_csums(struct btrfs_trans_handle *trans, u64 bytenr, u64 len);
>>>>  int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
>>>>  			     struct btrfs_root *root,
>>>>  			     u64 objectid, u64 pos, u64 offset,
>>>> diff --git a/extent-tree.c b/extent-tree.c
>>>> index cbc022f6cef6..c6f09b52800f 100644
>>>> --- a/extent-tree.c
>>>> +++ b/extent-tree.c
>>>> @@ -2372,7 +2372,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>>>>  		btrfs_release_path(path);
>>>>  
>>>>  		if (is_data) {
>>>> -			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
>>>> +			ret = btrfs_del_csums(trans, bytenr, num_bytes);
>>>>  			BUG_ON(ret);
>>>>  		}
>>>>  
>>>> diff --git a/file-item.c b/file-item.c
>>>> index 7b0ff3585509..71d4e89f78d1 100644
>>>> --- a/file-item.c
>>>> +++ b/file-item.c
>>>> @@ -394,8 +394,7 @@ static noinline int truncate_one_csum(struct btrfs_root *root,
>>>>   * deletes the csum items from the csum tree for a given
>>>>   * range of bytes.
>>>>   */
>>>> -int btrfs_del_csums(struct btrfs_trans_handle *trans,
>>>> -		    struct btrfs_root *root, u64 bytenr, u64 len)
>>>> +int btrfs_del_csums(struct btrfs_trans_handle *trans, u64 bytenr, u64 len)
>>>>  {
>>>>  	struct btrfs_path *path;
>>>>  	struct btrfs_key key;
>>>> @@ -403,11 +402,10 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>>>>  	u64 csum_end;
>>>>  	struct extent_buffer *leaf;
>>>>  	int ret;
>>>> -	u16 csum_size =
>>>> -		btrfs_super_csum_size(root->fs_info->super_copy);
>>>> -	int blocksize = root->fs_info->sectorsize;
>>>> +	u16 csum_size = btrfs_super_csum_size(trans->fs_info->super_copy);
>>>> +	int blocksize = trans->fs_info->sectorsize;
>>>> +	struct btrfs_root *csum_root = trans->fs_info->csum_root;
>>>>  
>>>> -	root = root->fs_info->csum_root;
>>>>  
>>>>  	path = btrfs_alloc_path();
>>>>  	if (!path)
>>>> @@ -418,7 +416,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>>>>  		key.offset = end_byte - 1;
>>>>  		key.type = BTRFS_EXTENT_CSUM_KEY;
>>>>  
>>>> -		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>>>> +		ret = btrfs_search_slot(trans, csum_root, &key, path, -1, 1);
>>>>  		if (ret > 0) {
>>>>  			if (path->slots[0] == 0)
>>>>  				goto out;
>>>> @@ -445,7 +443,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>>>>  
>>>>  		/* delete the entire item, it is inside our range */
>>>>  		if (key.offset >= bytenr && csum_end <= end_byte) {
>>>> -			ret = btrfs_del_item(trans, root, path);
>>>> +			ret = btrfs_del_item(trans, csum_root, path);
>>>>  			BUG_ON(ret);
>>>>  		} else if (key.offset < bytenr && csum_end > end_byte) {
>>>>  			unsigned long offset;
>>>> @@ -485,12 +483,14 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>>>>  			 * btrfs_split_item returns -EAGAIN when the
>>>>  			 * item changed size or key
>>>>  			 */
>>>> -			ret = btrfs_split_item(trans, root, path, &key, offset);
>>>> +			ret = btrfs_split_item(trans, csum_root, path, &key,
>>>> +					       offset);
>>>>  			BUG_ON(ret && ret != -EAGAIN);
>>>>  
>>>>  			key.offset = end_byte - 1;
>>>>  		} else {
>>>> -			ret = truncate_one_csum(root, path, &key, bytenr, len);
>>>> +			ret = truncate_one_csum(csum_root, path, &key, bytenr,
>>>> +						len);
>>>>  			BUG_ON(ret);
>>>>  		}
>>>>  		btrfs_release_path(path);
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
