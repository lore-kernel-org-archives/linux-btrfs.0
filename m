From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 4/5] Btrfs: Add readonly snapshots support
Date: Fri, 10 Dec 2010 14:43:56 +0800
Message-ID: <4D01CC2C.8030602@cn.fujitsu.com>
References: <4D009CD2.3060805@cn.fujitsu.com> <4D009D28.3060509@cn.fujitsu.com> <201012092034.11019.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012092034.11019.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

>> +#define BTRFS_ROOT_SNAP_RDONLY	(1ULL << 0)
>> +
>>  struct btrfs_root_item {
>>  	struct btrfs_inode_item inode;
>>  	__le64 generation;
>> @@ -1116,6 +1118,7 @@ struct btrfs_root {
>>  	int defrag_running;
>>  	char *name;
>>  	int in_sysfs;
>> +	bool readonly;
> 
> Does make sense to store the same information in two places ?
> If we have access to root->readonly, we have also access to "root-
>> root_item.flags". Because we need the latter, we can get rid of the former.
> 
> 
> We can replace a test like
> 
> 	if(root->readonly) 
> 
> with
> 
> 	if(root->root_item.flags & BTRFS_ROOT_SNAP_RDONLY)
> 
> Or better we can create a two macros like:
> 
> #define btrfs_root_readonly(x) ((x)->root_item.flags & BTRFS_ROOT_SNAP_RDONLY)
> #define btrfs_root_set_readonly(x, ro) 					    \
> 	do{ 	(x)->root_item.flags = 					    \
> 			((x)->root_item.flags & ~BTRFS_ROOT_SNAP_RDONLY) |  \
> 			(ro ? BTRFS_ROOT_SNAP_RDONLY : 0 ); 		    \
> 	}while(0)
> 
> 

Makes sense.

(except that inline functions are preferable)

> Sorry for to be too late for this kind of suggestion. But I think that this 
> optimization may help to avoid misalignment between the two variables (see my 
> reply in the next patch).
> [...]
