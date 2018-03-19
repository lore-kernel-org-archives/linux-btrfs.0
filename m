Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:10747 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755096AbeCSGLI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 02:11:08 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id A87D8AC00C5
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 15:11:01 +0900 (JST)
Subject: Re: [RFC PATCH v2 3/8] btrfs-progs: sub list: Add helper function
 which checks the permission for tree search ioctl
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
 <d5bbc64b-0b04-b223-bf84-de9f3bcb86e0@jp.fujitsu.com>
 <fbeaa2fe-bc94-180f-066e-0b1defd350f2@libero.it>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <6b8da9ed-af36-ee8a-461d-754592b79caa@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 15:10:55 +0900
MIME-Version: 1.0
In-Reply-To: <fbeaa2fe-bc94-180f-066e-0b1defd350f2@libero.it>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/17 22:23, Goffredo Baroncelli wrote:
> On 03/15/2018 09:13 AM, Misono, Tomohiro wrote:
>> This is a preparetion work to allow normal user to call
>> "subvolume list/show".
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> ---
>>  btrfs-list.c | 33 +++++++++++++++++++++++++++++++++
>>  btrfs-list.h |  1 +
>>  2 files changed, 34 insertions(+)
>>
>> diff --git a/btrfs-list.c b/btrfs-list.c
>> index 50e5ce5f..88689a9d 100644
>> --- a/btrfs-list.c
>> +++ b/btrfs-list.c
>> @@ -958,6 +958,39 @@ out:
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Check the permission for tree search ioctl by searching a key
>> + * which alwasys exists
>> + */
>> +int check_perm_for_tree_search(int fd)
>> +{
> 
> In what this is different from '(getuid() == 0)' ? 
> Which would be the cases where an error different from EPERM would be returned (other than the filesystem is not a BTRFS one )?
> 
> I am not against to this kind of function. However with this implementation is not clear its behavior:
> - does it check if the user has enough privileges to perform a BTRFS_IOC_TREE_SEARCH
> or 
> - does it check if BTRFS_IOC_TREE_SEARCH might return some error ?
> 
> If the former, I would put this function into utils.[hc] checking only the [e]uid of the user. If the latter the name is confusing...

The reason I wrote this function is that the permission for BTRFS_IOC_TREE_SEARCH is
CAP_SYS_ADMIN and might not equal uid == 0.

However, it seems that get_euid() is simple and enough for btrfs-progs, so I will
use it instead of this function in next version.

Thanks,
Tomohiro Misono

> 
>> +	struct btrfs_ioctl_search_args args;
>> +	struct btrfs_ioctl_search_key *sk = &args.key;
>> +	int ret;
>> +
>> +	memset(&args, 0, sizeof(args));
>> +	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
>> +	sk->min_objectid = BTRFS_EXTENT_TREE_OBJECTID;
>> +	sk->max_objectid = BTRFS_EXTENT_TREE_OBJECTID;
>> +	sk->min_type = BTRFS_ROOT_ITEM_KEY;
>> +	sk->max_type = BTRFS_ROOT_ITEM_KEY;
>> +	sk->min_offset = 0;
>> +	sk->max_offset = (u64)-1;
>> +	sk->min_transid = 0;
>> +	sk->max_transid = (u64)-1;
>> +	sk->nr_items = 1;
>> +	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>> +
>> +	if (!ret)
>> +		ret = 1;
>> +	else if (ret < 0 && errno == EPERM)
>> +		ret = 0;
>> +	else
>> +		ret = -errno;
>> +
>> +	return ret;
>> +}
>> +
>>  static int list_subvol_search(int fd, struct root_lookup *root_lookup)
>>  {
>>  	int ret;
>> diff --git a/btrfs-list.h b/btrfs-list.h
>> index 6e5fc778..6225311d 100644
>> --- a/btrfs-list.h
>> +++ b/btrfs-list.h
>> @@ -176,5 +176,6 @@ char *btrfs_list_path_for_root(int fd, u64 root);
>>  int btrfs_list_get_path_rootid(int fd, u64 *treeid);
>>  int btrfs_get_subvol(int fd, struct root_info *the_ri);
>>  int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri);
>> +int check_perm_for_tree_search(int fd);
>>  
>>  #endif
>>
> 
> 

