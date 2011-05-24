From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v1 2/5] btrfs: state information for readahead
Date: Tue, 24 May 2011 08:48:16 +0200
Message-ID: <4DDB54B0.6040100@gmx.net>
References: <cover.1306154794.git.sensille@gmx.net> <43c351ed5260538ec63c6799d5fd3eac8916d2b7.1306154794.git.sensille@gmx.net> <4DDC9220.7070303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDC9220.7070303@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 25.05.2011 07:22, liubo wrote:
> On 05/23/2011 08:59 AM, Arne Jansen wrote:
>> Add state information for readahead to btrfs_fs_info and btrfs_device
>>
>> Signed-off-by: Arne Jansen <sensille@gmx.net>
>> ---
>>  fs/btrfs/ctree.h   |    4 ++++
>>  fs/btrfs/disk-io.c |    4 ++++
>>  fs/btrfs/volumes.c |    8 ++++++++
>>  fs/btrfs/volumes.h |    8 ++++++++
>>  4 files changed, 24 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 2e61fe1..4a33e30 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1079,6 +1079,10 @@ struct btrfs_fs_info {
>>  
>>  	/* filesystem state */
>>  	u64 fs_state;
>> +
>> +	/* readahead tree */
>> +	spinlock_t reada_lock;
>> +	struct radix_tree_root reada_tree;
>>  };
>>  
>>  /*
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 7753eb9..3d4f9c5 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1803,6 +1803,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
>>  	fs_info->max_inline = 8192 * 1024;
>>  	fs_info->metadata_ratio = 0;
>>  
>> +	/* readahead state */
>> +	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS);
>> +	spin_lock_init(&fs_info->reada_lock);
>> +
>>  	fs_info->thread_pool_size = min_t(unsigned long,
>>  					  num_online_cpus() + 2, 8);
>>  
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 8b9fb8c..800e670 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -396,6 +396,14 @@ static noinline int device_list_add(const char *path,
>>  		}
>>  		INIT_LIST_HEAD(&device->dev_alloc_list);
>>  
>> +		/* init readahead state */
>> +		spin_lock_init(&device->reada_lock);
>> +		device->reada_curr_zone = NULL;
>> +		atomic_set(&device->reada_in_flight, 0);
>> +		device->reada_next = 0;
>> +		INIT_RADIX_TREE(&device->reada_zones, GFP_NOFS);
>> +		INIT_RADIX_TREE(&device->reada_extents, GFP_NOFS);
>> +
>>  		mutex_lock(&fs_devices->device_list_mutex);
>>  		list_add(&device->dev_list, &fs_devices->devices);
>>  		mutex_unlock(&fs_devices->device_list_mutex);
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index cc2eada..33acd4e 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -86,6 +86,14 @@ struct btrfs_device {
>>  	u8 uuid[BTRFS_UUID_SIZE];
>>  
>>  	struct btrfs_work work;
>> +
>> +	/* readahead state */
>> +	spinlock_t reada_lock;
>> +	atomic_t reada_in_flight;
>> +	u64 reada_next;
>> +	struct reada_zone *reada_curr_zone;
> 
> struct reada_zone has not been defined yet...

well, it's just a pointer, so no problem here. Of course this series
is just split for readability, though if applied incrementally each
version compiles.
Thanks for looking at these :)

Arne

> 
> thanks,
> liubo
> 
>> +	struct radix_tree_root reada_zones;
>> +	struct radix_tree_root reada_extents;
>>  };
>>  
>>  struct btrfs_fs_devices {
> 

