Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59682 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbcE2LGI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 07:06:08 -0400
Subject: Re: [PATCH v3 21/22] btrfs-progs: convert: Strictly avoid meta or
 system chunk allocation
To: bo.li.liu@oracle.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1454043812-7893-22-git-send-email-quwenruo@cn.fujitsu.com>
 <20160528033028.GD31255@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1c5ba73e-798b-c5dc-e539-1886cce324cf@gmx.com>
Date: Sun, 29 May 2016 19:05:44 +0800
MIME-Version: 1.0
In-Reply-To: <20160528033028.GD31255@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/28/2016 11:30 AM, Liu Bo wrote:
> On Fri, Jan 29, 2016 at 01:03:31PM +0800, Qu Wenruo wrote:
>> Before this patch, btrfs-convert only rely on large enough initial
>> system/metadata chunk size to ensure no newer system/meta chunk will be
>> created.
>>
>> But that's not safe enough. So add two new members in fs_info,
>> avoid_sys/meta_chunk_alloc flags to prevent any newer system or meta
>> chunks to be created before init_btrfs_v2().
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> ---
>>  btrfs-convert.c |  9 +++++++++
>>  ctree.h         |  3 +++
>>  extent-tree.c   | 10 ++++++++++
>>  3 files changed, 22 insertions(+)
>>
>> diff --git a/btrfs-convert.c b/btrfs-convert.c
>> index efa3b02..333f413 100644
>> --- a/btrfs-convert.c
>> +++ b/btrfs-convert.c
>> @@ -2322,6 +2322,13 @@ static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
>>  	struct btrfs_fs_info *fs_info = root->fs_info;
>>  	int ret;
>>
>> +	/*
>> +	 * Don't alloc any metadata/system chunk, as we don't want
>> +	 * any meta/sys chunk allcated before all data chunks are inserted.
>> +	 * Or we screw up the chunk layout just like the old implement.
>> +	 */
>
> I don't get this, with this patch set, we can allocate data from DATA chunk,
> allocate metadata from METADATA chunk, but then we're not allowed to allocate new chunks?
>
> Thanks,

For new convert, we are going through the following steps:
1) Create initial meta/sys chunks into unused space, manually
2) Open fs
3) Insert data chunks to covert all ext* used data
4) Do per inode copying

The whole patchset rely on a key assumption: All data chunks are already 
allocated to cover all ext* used data, so new chunk/extent allocation 
can follow the normal routine.

Before that, only chunks created in step 1) is completely safe, and new 
chunk allocation before step 3) are all unsafe, as the key assumption is 
not met yet.

So, unitl step 3), we must not allocate any new data/metadata chunks.

Thanks,
Qu
>
> -liubo
>> +	fs_info->avoid_sys_chunk_alloc = 1;
>> +	fs_info->avoid_meta_chunk_alloc = 1;
>>  	trans = btrfs_start_transaction(root, 1);
>>  	BUG_ON(!trans);
>>  	ret = btrfs_fix_block_accounting(trans, root);
>> @@ -2359,6 +2366,8 @@ static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
>>  		goto err;
>>
>>  	ret = btrfs_commit_transaction(trans, root);
>> +	fs_info->avoid_sys_chunk_alloc = 0;
>> +	fs_info->avoid_meta_chunk_alloc = 0;
>>  err:
>>  	return ret;
>>  }
>> diff --git a/ctree.h b/ctree.h
>> index 1443746..187bd27 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -1030,6 +1030,9 @@ struct btrfs_fs_info {
>>  	unsigned int quota_enabled:1;
>>  	unsigned int suppress_check_block_errors:1;
>>  	unsigned int ignore_fsid_mismatch:1;
>> +	unsigned int avoid_meta_chunk_alloc:1;
>> +	unsigned int avoid_sys_chunk_alloc:1;
>> +
>>
>>  	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
>>  				struct btrfs_root *root,
>> diff --git a/extent-tree.c b/extent-tree.c
>> index 93b1945..e7c61b1 100644
>> --- a/extent-tree.c
>> +++ b/extent-tree.c
>> @@ -1904,6 +1904,16 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>>  	    thresh)
>>  		return 0;
>>
>> +	/*
>> +	 * Avoid allocating given chunk type
>> +	 */
>> +	if (extent_root->fs_info->avoid_meta_chunk_alloc &&
>> +	    (flags & BTRFS_BLOCK_GROUP_METADATA))
>> +		return 0;
>> +	if (extent_root->fs_info->avoid_sys_chunk_alloc &&
>> +	    (flags & BTRFS_BLOCK_GROUP_SYSTEM))
>> +		return 0;
>> +
>>  	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes,
>>  	                        space_info->flags);
>>  	if (ret == -ENOSPC) {
>> --
>> 2.7.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
