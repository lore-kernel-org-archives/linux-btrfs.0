Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932466AbeFUFXj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 01:23:39 -0400
Subject: Re: [PATCH 34/34] btrfs: Remove fs_info from convert_extent_item_v0
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
 <1529498956-4241-35-git-send-email-nborisov@suse.com>
 <a082fe46-56a4-1bd3-bd69-bbb580c8fe0f@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a83a9b63-0289-0b5b-e841-c313069c4f25@suse.com>
Date: Thu, 21 Jun 2018 08:23:36 +0300
MIME-Version: 1.0
In-Reply-To: <a082fe46-56a4-1bd3-bd69-bbb580c8fe0f@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.06.2018 05:05, Qu Wenruo wrote:
> 
> 
> On 2018年06月20日 20:49, Nikolay Borisov wrote:
>> It can be referenced from trans since the function is always called
>> within a transaction
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index c3c3e6f3b72c..9c0e15b057a0 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -1038,10 +1038,10 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
>>  
>>  #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
> 
> Do we really need to update this code?
> 
> V0 extent tree is already deprecated, maybe it's a good time to remove
> them now?

I did it for the sake of consistency. David said in the past that
actually removing the v0 code might be what we want to do. I don't have
strong preferences either way.

> 
> Thanks,
> Qu
> 
>>  static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
>> -				  struct btrfs_fs_info *fs_info,
>>  				  struct btrfs_path *path,
>>  				  u64 owner, u32 extra_size)
>>  {
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>>  	struct btrfs_root *root = fs_info->extent_root;
>>  	struct btrfs_extent_item *item;
>>  	struct btrfs_extent_item_v0 *ei0;
>> @@ -1682,8 +1682,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
>>  			err = -ENOENT;
>>  			goto out;
>>  		}
>> -		ret = convert_extent_item_v0(trans, fs_info, path, owner,
>> -					     extra_size);
>> +		ret = convert_extent_item_v0(trans, path, owner, extra_size);
>>  		if (ret < 0) {
>>  			err = ret;
>>  			goto out;
>> @@ -2384,7 +2383,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
>>  	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
>>  #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
>>  	if (item_size < sizeof(*ei)) {
>> -		ret = convert_extent_item_v0(trans, fs_info, path, (u64)-1, 0);
>> +		ret = convert_extent_item_v0(trans, path, (u64)-1, 0);
>>  		if (ret < 0) {
>>  			err = ret;
>>  			goto out;
>> @@ -6937,8 +6936,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>>  #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
>>  	if (item_size < sizeof(*ei)) {
>>  		BUG_ON(found_extent || extent_slot != path->slots[0]);
>> -		ret = convert_extent_item_v0(trans, info, path, owner_objectid,
>> -					     0);
>> +		ret = convert_extent_item_v0(trans, path, owner_objectid, 0);
>>  		if (ret < 0) {
>>  			btrfs_abort_transaction(trans, ret);
>>  			goto out;
>>
> 
