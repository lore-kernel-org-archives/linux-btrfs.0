Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753998AbeFKHGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 03:06:32 -0400
Subject: Re: [PATCH 07/15] btrfs-progs: Remove root argument from
 __free_extent
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-8-git-send-email-nborisov@suse.com>
 <b912f17a-41ce-861a-a87b-f1e118a57ccd@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ddb84b34-100d-c9b6-96cf-f76683d89be6@suse.com>
Date: Mon, 11 Jun 2018 10:06:29 +0300
MIME-Version: 1.0
In-Reply-To: <b912f17a-41ce-861a-a87b-f1e118a57ccd@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.06.2018 07:58, Qu Wenruo wrote:
> 
> 
> On 2018年06月08日 20:47, Nikolay Borisov wrote:
>> This argument is no longer used in this function so remove it.
> 
> The same concern about the aggressive removal of fs_info.
> 
> I would completely accept if it's only convert root to fs_info, but
> removing it completely and rely on trans to get fs_info, I'm still not
> 100% sure.

Freeing an extent is now related to running delayed refs, which are
keyed off a valid transaction and a valid transaction must have access
to fs_info so I think it's fine.

> 
> Thanks,
> Qu
> 
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  extent-tree.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/extent-tree.c b/extent-tree.c
>> index 9132cb3f8e15..c16bd85e92be 100644
>> --- a/extent-tree.c
>> +++ b/extent-tree.c
>> @@ -50,7 +50,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>>  				     u64 flags, struct btrfs_disk_key *key,
>>  				     int level, struct btrfs_key *ins);
>>  static int __free_extent(struct btrfs_trans_handle *trans,
>> -			 struct btrfs_root *root,
>>  			 u64 bytenr, u64 num_bytes, u64 parent,
>>  			 u64 root_objectid, u64 owner_objectid,
>>  			 u64 owner_offset, int refs_to_drop);
>> @@ -2141,7 +2140,6 @@ void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
>>   * remove an extent from the root, returns 0 on success
>>   */
>>  static int __free_extent(struct btrfs_trans_handle *trans,
>> -			 struct btrfs_root *root,
>>  			 u64 bytenr, u64 num_bytes, u64 parent,
>>  			 u64 root_objectid, u64 owner_objectid,
>>  			 u64 owner_offset, int refs_to_drop)
>> @@ -2149,7 +2147,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>>  
>>  	struct btrfs_key key;
>>  	struct btrfs_path *path;
>> -	struct btrfs_root *extent_root = root->fs_info->extent_root;
>> +	struct btrfs_root *extent_root = trans->fs_info->extent_root;
>>  	struct extent_buffer *leaf;
>>  	struct btrfs_extent_item *ei;
>>  	struct btrfs_extent_inline_ref *iref;
>> @@ -2409,8 +2407,7 @@ static int del_pending_extents(struct btrfs_trans_handle *trans)
>>  
>>  		if (!test_range_bit(extent_ins, start, end,
>>  				    EXTENT_LOCKED, 0)) {
>> -			ret = __free_extent(trans, extent_root,
>> -					    start, end + 1 - start, 0,
>> +			ret = __free_extent(trans, start, end + 1 - start, 0,
>>  					    extent_root->root_key.objectid,
>>  					    extent_op->level, 0, 1);
>>  			kfree(extent_op);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
