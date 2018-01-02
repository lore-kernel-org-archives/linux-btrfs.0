Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:31964 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751130AbeABBqP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jan 2018 20:46:15 -0500
Subject: Re: [PATCH v2 02/17] btrfs-progs: lowmem check: record returned
 errors after walk_down_tree_v2()
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-3-suy.fnst@cn.fujitsu.com>
 <d4013361-64e4-39be-3866-5baba6597669@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <078b49d6-3dff-0e87-9163-562fd87b1e7c@cn.fujitsu.com>
Date: Tue, 2 Jan 2018 09:50:30 +0800
MIME-Version: 1.0
In-Reply-To: <d4013361-64e4-39be-3866-5baba6597669@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/29/2017 07:17 PM, Nikolay Borisov wrote:
> 
> 
> On 20.12.2017 06:57, Su Yue wrote:
>> In lowmem mode with '--repair', check_chunks_and_extents_v2()
>> will fix accounting in block groups and clear the error
>> bit BG_ACCOUNTING_ERROR.
>> However, return value of check_btrfs_root() is 0 either 1 instead of
>> error bits.
>>
>> If extent tree is on error, lowmem repair always prints error and
>> returns nonzero value even the filesystem is fine after repair.
>>
>> So let @err contains bits after walk_down_tree_v2().
>>
>> Introduce FATAL_ERROR for lowmem mode to represents negative return
>> values since negative and positive can't not be mixed in bits operations.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   cmds-check.c | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 309ac9553b3a..ebede26cef01 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -134,6 +134,7 @@ struct data_backref {
>>   #define DIR_INDEX_MISMATCH      (1<<19) /* INODE_INDEX found but not match */
>>   #define DIR_COUNT_AGAIN         (1<<20) /* DIR isize should be recalculated */
>>   #define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting error */
>> +#define FATAL_ERROR             (1<<22) /* fatal bit for errno */
>>   
>>   static inline struct data_backref* to_data_backref(struct extent_backref *back)
>>   {
>> @@ -6556,7 +6557,7 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
>>    *                otherwise means check fs tree(s) items relationship and
>>    *		  @root MUST be a fs tree root.
>>    * Returns 0      represents OK.
>> - * Returns not 0  represents error.
>> + * Returns > 0    represents error bits.
>>    */
> 
> What about the code in 'if (!check_all)' branch, check_fs_first_inode
> can return a negative value, hence check_btrfs_root can return a
> negative value. A negative value can also be returned from
> btrfs_search_slot.
> 
> Clearly this patch needs to be thought out better
> 
OK, I will update it.
Thanks for review.
>>   static int check_btrfs_root(struct btrfs_trans_handle *trans,
>>   			    struct btrfs_root *root, unsigned int ext_ref,
>> @@ -6607,12 +6608,12 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
>>   	while (1) {
>>   		ret = walk_down_tree_v2(trans, root, &path, &level, &nrefs,
>>   					ext_ref, check_all);
>> -
>> -		err |= !!ret;
>> +		if (ret > 0)
>> +			err |= ret;
>>   
>>   		/* if ret is negative, walk shall stop */
>>   		if (ret < 0) {
>> -			ret = err;
>> +			ret = err | FATAL_ERROR;
>>   			break;
>>   		}
>>   
>> @@ -6636,12 +6637,12 @@ out:
>>    * @ext_ref:	the EXTENDED_IREF feature
>>    *
>>    * Return 0 if no error found.
>> - * Return <0 for error.
>> + * Return not 0 for error.
>>    */
>>   static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
>>   {
>>   	reset_cached_block_groups(root->fs_info);
>> -	return check_btrfs_root(NULL, root, ext_ref, 0);
>> +	return !!check_btrfs_root(NULL, root, ext_ref, 0);
>>   }
> 
> You make the function effectively boolean, make this explicit by
> changing its return value to bool. Also the name and the boolean return
> makes the function REALLY confusing. I.e when should we return true or
> false? As it stands it return "false" on success and "true" otherwise,
> this is a mess...
> 
> 
>>   
>>   /*
>>
> 
> 


