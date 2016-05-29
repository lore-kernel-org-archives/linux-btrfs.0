Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32956 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbcE2FRt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 01:17:49 -0400
Received: by mail-pf0-f194.google.com with SMTP id b124so17879402pfb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 May 2016 22:17:48 -0700 (PDT)
Subject: Re: [PATCH 3/5] Btrfs: self-tests: Support non-4k page size
To: dsterba@suse.cz, Feifei Xu <xufeifei@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org, steve.capper@linaro.org,
        chandan@mykolab.com, jbacik@fb.com, dsterba@suse.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>
 <201605270701.u4R6xPFu036351@mx0a-001b2d01.pphosted.com>
 <20160527192915.GX29147@twin.jikos.cz>
From: Fei Fei Xu <feifeixu.sh@gmail.com>
Message-ID: <574A7B6E.2020904@gmail.com>
Date: Sun, 29 May 2016 13:17:34 +0800
MIME-Version: 1.0
In-Reply-To: <20160527192915.GX29147@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2016/5/28 3:29, David Sterba wrote:
> On Fri, May 27, 2016 at 03:00:36PM +0800, Feifei Xu wrote:
>> self-tests code assumes 4k as the sectorsize and nodesize. This commit
>> enables the self-tests code to be executed on non-4k page sized
>> systems (e.g. ppc64).
>>
>> To test all possible sectorsizes, this commit adds a sectorsize
>> array. This commit executes the tests for all possible sectorsizes and
>> nodesizes.
>>
>> Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
>> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> ---
>>   fs/btrfs/ctree.c                       |   6 +-
>>   fs/btrfs/disk-io.c                     |   9 +-
>>   fs/btrfs/disk-io.h                     |   3 +-
>>   fs/btrfs/extent_io.c                   |  10 +-
>>   fs/btrfs/extent_io.h                   |   4 +-
>>   fs/btrfs/free-space-cache.c            |   2 +-
>>   fs/btrfs/super.c                       |  62 ++++--
>>   fs/btrfs/tests/btrfs-tests.c           |   6 +-
>>   fs/btrfs/tests/btrfs-tests.h           |  27 +--
>>   fs/btrfs/tests/extent-buffer-tests.c   |  13 +-
>>   fs/btrfs/tests/extent-io-tests.c       |  85 ++++----
>>   fs/btrfs/tests/free-space-tests.c      |  67 +++---
>>   fs/btrfs/tests/free-space-tree-tests.c |  30 +--
>>   fs/btrfs/tests/inode-tests.c           | 379 ++++++++++++++++++---------------
>>   fs/btrfs/tests/qgroup-tests.c          | 111 ++++++----
>>   15 files changed, 462 insertions(+), 352 deletions(-)
> The patch is quite big, please separate all changes that are not related
> to the 4096/sectorsize/PAGE_SIZE change, eg. adding missing "\n" to
> strings, replacement of constants with defines
OK.
>> @@ -1314,14 +1315,16 @@ static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
>>   
>>   #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>>   /* Should only be used by the testing infrastructure */
>> -struct btrfs_root *btrfs_alloc_dummy_root(void)
>> +struct btrfs_root *
>> +btrfs_alloc_dummy_root(u32 sectorsize, u32 nodesize)
> Please keep the style as-is, ie. return type and name on one line
>
>>   {
>>   	struct btrfs_root *root;
>>   
>>   	root = btrfs_alloc_root(NULL, GFP_KERNEL);
>>   	if (!root)
>>   		return ERR_PTR(-ENOMEM);
>> -	__setup_root(4096, 4096, 4096, root, NULL, 1);
>> +	__setup_root(nodesize, sectorsize, sectorsize, root, NULL,
> The 3rd parameter is stripesize, but we don't use it anywhere so
> sectorsize should be fine, just looks a bit strange.
>
>> +		BTRFS_ROOT_TREE_OBJECTID);
>>   	set_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state);
>>   	root->alloc_bytenr = 0;
>>   
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4714,16 +4714,16 @@ err:
>>   }
>>   
>>   struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>> -						u64 start)
>> +						u64 start, u32 alt_nodesize)
> This could be named 'nodesize'.
>
>>   {
>>   	unsigned long len;
>>   
>>   	if (!fs_info) {
>>   		/*
>>   		 * Called only from tests that don't always have a fs_info
>> -		 * available, but we know that nodesize is 4096
>> +		 * available
>>   		 */
>> -		len = 4096;
>> +		len = alt_nodesize;
>>   	} else {
>>   		len = fs_info->tree_root->nodesize;
>>   	}
>> @@ -4819,7 +4819,7 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
>>   
>>   #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>>   struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
>> -					       u64 start)
>> +					u64 start, u32 alt_nodesize)
> dtto
>
>>   {
>>   	struct extent_buffer *eb, *exists = NULL;
>>   	int ret;
>> @@ -4827,7 +4827,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
>>   	eb = find_extent_buffer(fs_info, start);
>>   	if (eb)
>>   		return eb;
>> -	eb = alloc_dummy_extent_buffer(fs_info, start);
>> +	eb = alloc_dummy_extent_buffer(fs_info, start, alt_nodesize);
>>   	if (!eb)
>>   		return NULL;
>>   	eb->fs_info = fs_info;
>>   		ctl->extents_thresh = 0;
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index bf71071..c97c250 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -2318,28 +2318,54 @@ static void btrfs_print_mod_info(void)
>>   
>>   static int btrfs_run_sanity_tests(void)
>>   {
>> -	int ret;
>> -
>> +	int ret, i;
>> +	u32 sectorsize, nodesize;
>> +	u32 test_sectorsize[] = {
>> +		PAGE_SIZE,
>> +	};
>>   	ret = btrfs_init_test_fs();
>>   	if (ret)
>>   		return ret;
>> +	for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
>> +		/* Validate sectorsize. */
>> +		sectorsize = test_sectorsize[i];
>> +		if (!is_power_of_2(sectorsize) || sectorsize < SZ_4K ||
>> +			sectorsize > PAGE_SIZE) {
>> +			continue;
>> +		}
>>   
>> -	ret = btrfs_test_free_space_cache();
>> -	if (ret)
>> -		goto out;
>> -	ret = btrfs_test_extent_buffer_operations();
>> -	if (ret)
>> -		goto out;
>> -	ret = btrfs_test_extent_io();
>> -	if (ret)
>> -		goto out;
>> -	ret = btrfs_test_inodes();
>> -	if (ret)
>> -		goto out;
>> -	ret = btrfs_test_qgroups();
>> -	if (ret)
>> -		goto out;
>> -	ret = btrfs_test_free_space_tree();
>> +		for (nodesize = sectorsize;
>> +		     nodesize <= BTRFS_MAX_METADATA_BLOCKSIZE;
>> +		     nodesize <<= 1) {
>> +			/* Validate nodesize.*/
>> +			if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
>> +				nodesize > SZ_64K){
> The whole if does not make sense, the values will always satisfy the
> conditions.
>
>> +				pr_info("Invalid nodesize %u\n", nodesize);
>> +				continue;
>> +			}
>> +			pr_info("Btrfs: Sanity tests sectorsize %u  nodesize %u\n",
>> +				sectorsize, nodesize);
> Please use the same wording as the 'test_msg' does (that we cannot use
> here).
>
>> +			ret = btrfs_test_free_space_cache(sectorsize, nodesize);
>> +			if (ret)
>> +				goto out;
>> +			ret = btrfs_test_extent_buffer_operations(sectorsize,
>> +				nodesize);
>> +			if (ret)
>> +				goto out;
>> +			ret = btrfs_test_extent_io(sectorsize, nodesize);
>> +			if (ret)
>> +				goto out;
>> +			ret = btrfs_test_inodes(sectorsize, nodesize);
>> +			if (ret)
>> +				goto out;
>> +			ret = btrfs_test_qgroups(sectorsize, nodesize);
>> +			if (ret)
>> +				goto out;
>> +			ret = btrfs_test_free_space_tree(sectorsize, nodesize);
>> +			if (ret)
>> +				goto out;
>> +		}
>> +	}
>>   out:
>>   	btrfs_destroy_test_fs();
>>   	return ret;
>> +		test_msg("Cache free space is not %u\n", sectorsize);
>>   		return -EINVAL;
>>   	}
>>   
>>   	offset = btrfs_find_space_for_alloc(cache,
>> -					    0, 4096, 0,
>> +					    0, sectorsize, 0,
>>   					    &max_extent_size);
>>   	if (offset != (SZ_128M + SZ_16M)) {
>> -		test_msg("Failed to allocate 4Kb from space cache, returned offset is: %llu\n",
>> -			 offset);
>> +		test_msg("Failed to allocate %u, returned offset:%llu\n",
> 		test_msg("Failed to allocate %u, returned offset: %llu\n",
>
>> +			 sectorsize, offset);
>>   		return -EINVAL;
>>   	}
>>   
>>   		return ret;
>>   	ret = check_num_extents_and_bitmaps(cache, 2, 1);
>>   	if (ret)
>> @@ -782,8 +788,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
>>   		return -ENOENT;
>>   	}
>>   
>> -	if (cache->free_space_ctl->free_space != (SZ_1M + 8192)) {
>> -		test_msg("Cache free space is not 1Mb + 8Kb\n");
>> +	if (cache->free_space_ctl->free_space != (SZ_1M + 2 * sectorsize)) {
>> +		test_msg("Cache free space is not 1Mb + %u\n", 2*sectorsize);
> 		test_msg("Cache free space is not 1Mb + %u\n", 2 * sectorsize);
>
> There are more instances of the pointed style issues, please fix all of
> them. As the changes do not affect functionality I'll add the paches to
> for-next, but I'm expecting a v2.
Thanks, I will send out v2 soon according to all above comments.

Thanks
Feifei
