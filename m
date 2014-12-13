Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7070 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966327AbaLMKAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 05:00:24 -0500
Message-ID: <548C0D92.2030608@cn.fujitsu.com>
Date: Sat, 13 Dec 2014 17:57:38 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, <1i5t5.duncan@cox.net>, <rwhite@pobox.com>,
        <lists@colorremedies.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Btrfs: get more accurate output in df command.
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com> <548B2D34.9060509@inwind.it>
In-Reply-To: <548B2D34.9060509@inwind.it>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2014 02:00 AM, Goffredo Baroncelli wrote:
> On 12/11/2014 09:31 AM, Dongsheng Yang wrote:
>> When function btrfs_statfs() calculate the tatol size of fs, it is calculating
>> the total size of disks and then dividing it by a factor. But in some usecase,
>> the result is not good to user.
> I am checking it; to me it seems a good improvement. However
> I noticed that df now doesn't seem to report anymore the space consumed
> by the meta-data chunk; eg:
>
> # I have two disks of 5GB each
> $ sudo ~/mkfs.btrfs -f -m raid1 -d raid1 /dev/vgtest/disk /dev/vgtest/disk1
>
> $ df -h /mnt/btrfs1/
> Filesystem               Size  Used Avail Use% Mounted on
> /dev/mapper/vgtest-disk  5.0G  1.1G  4.0G  21% /mnt/btrfs1
>
> $ sudo btrfs fi show
> Label: none  uuid: 884414c6-9374-40af-a5be-3949cdf6ad0b
> 	Total devices 2 FS bytes used 640.00KB
> 	devid    2 size 5.00GB used 2.01GB path /dev/dm-1
> 	devid    1 size 5.00GB used 2.03GB path /dev/dm-0
>
> $ sudo ./btrfs fi df /mnt/btrfs1/
> Data, RAID1: total=1.00GiB, used=512.00KiB
> Data, single: total=8.00MiB, used=0.00B
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=1.00GiB, used=112.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=16.00MiB, used=0.00B
>
> In this case the filesystem is empty (it was a new filesystem !). However a
> 1G metadata chunk was already allocated. This is the reasons why the free
> space is only 4Gb.

Actually, in the original btrfs_statfs(), the space in metadata chunk 
was also not be considered
as available. But you will get 5G in this case with original 
btrfs_statfs() because there is a bug
in it. As I use another implementation to calculate the @available in df 
command, I did not
mention this problem. I can describe it as below.

In original btrfs_statfs(), we only consider the free space in data 
chunk as available.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
         list_for_each_entry_rcu(found, head, list) {
                 if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
                         int i;

                         total_free_data += found->disk_total - 
found->disk_used;
 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
In the later, we will add the total_free_data to @available in output of df.
         buf->f_bavail = total_free_data;
BUT:
     This is incorrect! It should be:
       buf->f_bavail = div_u64(total_free_data, factor);
That said this bug will add one more (data_chunk_disk_total - 
data_chunk_disk_used = 1G)
to @available by mistake. Unfortunately, the free space in 
metadata_chunk is also 1G.

Then we will get 5G in this case you provided here.

Conclusion:
     Even in the original btrfs_statfs(), the free space in metadata is 
also considered as not available.
But one bug in it make it to be misunderstood. My new btrfs_statfs() 
still consider the free space
in metadata as not available, furthermore, I add it into @used.
>
> On my system the ratio metadata/data is 234MB/8.82GB = ~3%, so ignoring the
> metadata chunk from the free space may not be a big problem.
>
>
>
>
>
>> Example:
>> 	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>> 	# mount /dev/vdf1 /mnt
>> 	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>> 	# df -h /mnt
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>> 	# btrfs fi show /dev/vdf1
>> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
>> 	Total devices 2 FS bytes used 1001.53MiB
>> 	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
>> 	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
>> a. df -h should report Size as 2GiB rather than as 3GiB.
>> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.
>>
>> b. df -h should report Avail as 0.97GiB or less, rather than as 1.3GiB.
>>      1.85           (the capacity of the allocated chunk)
>>     -1.018          (the file stored)
>>     +(2-1.85=0.15)  (the residual capacity of the disks
>>                      considering a raid1 fs)
>>     ---------------
>> =   0.97
>>
>> This patch drops the factor at all and calculate the size observable to
>> user without considering which raid level the data is in and what's the
>> size exactly in disk.
>> After this patch applied:
>> 	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>> 	# mount /dev/vdf1 /mnt
>> 	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>> 	# df -h /mnt
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/vdf1       2.0G  1.3G  713M  66% /mnt
>> 	# df /mnt
>> Filesystem     1K-blocks    Used Available Use% Mounted on
>> /dev/vdf1        2097152 1359424    729536  66% /mnt
>> 	# btrfs fi show /dev/vdf1
>> Label: none  uuid: e98c1321-645f-4457-b20d-4f41dc1cf2f4
>> 	Total devices 2 FS bytes used 1001.55MiB
>> 	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
>> 	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
>> a). The @Size is 2G as we expected.
>> b). @Available is 700M = 1.85G - 1.3G + (2G - 1.85G).
>> c). @Used is changed to 1.3G rather than 1018M as above. Because
>>      this patch do not treat the free space in metadata chunk
>>      and system chunk as available to user. It's true, user can
>>      not use these space to store data, then it should not be
>>      thought as available. At the same time, it will make the
>>      @Used + @Available == @Size as possible to user.
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>> Changelog:
>>          v1 -> v2:
>>                  a. account the total_bytes in medadata chunk and
>>                     system chunk as used to user.
>>                  b. set data_stripes to the correct value in RAID0.
>>
>>   fs/btrfs/extent-tree.c | 13 ++----------
>>   fs/btrfs/super.c       | 56 ++++++++++++++++++++++----------------------------
>>   2 files changed, 26 insertions(+), 43 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index a84e00d..9954d60 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8571,7 +8571,6 @@ static u64 __btrfs_get_ro_block_group_free_space(struct list_head *groups_list)
>>   {
>>   	struct btrfs_block_group_cache *block_group;
>>   	u64 free_bytes = 0;
>> -	int factor;
>>   
>>   	list_for_each_entry(block_group, groups_list, list) {
>>   		spin_lock(&block_group->lock);
>> @@ -8581,16 +8580,8 @@ static u64 __btrfs_get_ro_block_group_free_space(struct list_head *groups_list)
>>   			continue;
>>   		}
>>   
>> -		if (block_group->flags & (BTRFS_BLOCK_GROUP_RAID1 |
>> -					  BTRFS_BLOCK_GROUP_RAID10 |
>> -					  BTRFS_BLOCK_GROUP_DUP))
>> -			factor = 2;
>> -		else
>> -			factor = 1;
>> -
>> -		free_bytes += (block_group->key.offset -
>> -			       btrfs_block_group_used(&block_group->item)) *
>> -			       factor;
>> +		free_bytes += block_group->key.offset -
>> +			      btrfs_block_group_used(&block_group->item);
>>   
>>   		spin_unlock(&block_group->lock);
>>   	}
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 54bd91e..40f41a2 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1641,6 +1641,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>>   	u64 used_space;
>>   	u64 min_stripe_size;
>>   	int min_stripes = 1, num_stripes = 1;
>> +	/* How many stripes used to store data, without considering mirrors. */
>> +	int data_stripes = 1;
>>   	int i = 0, nr_devices;
>>   	int ret;
>>   
>> @@ -1657,12 +1659,15 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>>   	if (type & BTRFS_BLOCK_GROUP_RAID0) {
>>   		min_stripes = 2;
>>   		num_stripes = nr_devices;
>> +		data_stripes = num_stripes;
>>   	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
>>   		min_stripes = 2;
>>   		num_stripes = 2;
>> +		data_stripes = 1;
>>   	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
>>   		min_stripes = 4;
>>   		num_stripes = 4;
>> +		data_stripes = 2;
>>   	}
>>   
>>   	if (type & BTRFS_BLOCK_GROUP_DUP)
>> @@ -1733,14 +1738,17 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>>   	i = nr_devices - 1;
>>   	avail_space = 0;
>>   	while (nr_devices >= min_stripes) {
>> -		if (num_stripes > nr_devices)
>> +		if (num_stripes > nr_devices) {
>>   			num_stripes = nr_devices;
>> +			if (type & BTRFS_BLOCK_GROUP_RAID0)
>> +				data_stripes = num_stripes;
>> +		}
>>   
>>   		if (devices_info[i].max_avail >= min_stripe_size) {
>>   			int j;
>>   			u64 alloc_size;
>>   
>> -			avail_space += devices_info[i].max_avail * num_stripes;
>> +			avail_space += devices_info[i].max_avail * data_stripes;
>>   			alloc_size = devices_info[i].max_avail;
>>   			for (j = i + 1 - num_stripes; j <= i; j++)
>>   				devices_info[j].max_avail -= alloc_size;
>> @@ -1772,15 +1780,13 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>>   static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>>   {
>>   	struct btrfs_fs_info *fs_info = btrfs_sb(dentry->d_sb);
>> -	struct btrfs_super_block *disk_super = fs_info->super_copy;
>>   	struct list_head *head = &fs_info->space_info;
>>   	struct btrfs_space_info *found;
>>   	u64 total_used = 0;
>> +	u64 total_alloc = 0;
>>   	u64 total_free_data = 0;
>>   	int bits = dentry->d_sb->s_blocksize_bits;
>>   	__be32 *fsid = (__be32 *)fs_info->fsid;
>> -	unsigned factor = 1;
>> -	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
>>   	int ret;
>>   
>>   	/*
>> @@ -1792,38 +1798,20 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>>   	rcu_read_lock();
>>   	list_for_each_entry_rcu(found, head, list) {
>>   		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
>> -			int i;
>> -
>> -			total_free_data += found->disk_total - found->disk_used;
>> +			total_free_data += found->total_bytes - found->bytes_used;
>>   			total_free_data -=
>>   				btrfs_account_ro_block_groups_free_space(found);
>> -
>> -			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
>> -				if (!list_empty(&found->block_groups[i])) {
>> -					switch (i) {
>> -					case BTRFS_RAID_DUP:
>> -					case BTRFS_RAID_RAID1:
>> -					case BTRFS_RAID_RAID10:
>> -						factor = 2;
>> -					}
>> -				}
>> -			}
>> +			total_used += found->bytes_used;
>> +		} else {
>> +			/* For metadata and system, we treat the total_bytes as
>> +			 * not available to file data. So show it as Used in df.
>> +			 **/
>> +			total_used += found->total_bytes;
>>   		}
>> -
>> -		total_used += found->disk_used;
>> +		total_alloc += found->total_bytes;
>>   	}
>> -
>>   	rcu_read_unlock();
>>   
>> -	buf->f_blocks = div_u64(btrfs_super_total_bytes(disk_super), factor);
>> -	buf->f_blocks >>= bits;
>> -	buf->f_bfree = buf->f_blocks - (div_u64(total_used, factor) >> bits);
>> -
>> -	/* Account global block reserve as used, it's in logical size already */
>> -	spin_lock(&block_rsv->lock);
>> -	buf->f_bfree -= block_rsv->size >> bits;
>> -	spin_unlock(&block_rsv->lock);
>> -
>>   	buf->f_bavail = total_free_data;
>>   	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
>>   	if (ret) {
>> @@ -1831,8 +1819,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>>   		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>>   		return ret;
>>   	}
>> -	buf->f_bavail += div_u64(total_free_data, factor);
>> +	buf->f_bavail += total_free_data;
>>   	buf->f_bavail = buf->f_bavail >> bits;
>> +	buf->f_blocks = total_alloc + total_free_data;
>> +	buf->f_blocks >>= bits;
>> +	buf->f_bfree = buf->f_blocks - (total_used >> bits);
>> +
>>   	mutex_unlock(&fs_info->chunk_mutex);
>>   	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>>   
>>
>

