Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:11951 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755200AbeCSG2d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 02:28:33 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id DFCEFAC01B9
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 15:28:25 +0900 (JST)
Subject: Re: [RFC PATCH v2 6/8] btrfs-progs: sub list: Allow normal user to
 call "subvolume list/show"
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
 <d02c973d-5ebc-46e4-f2a7-bd89da24e46d@jp.fujitsu.com>
 <d1839d67-2ab5-d07b-e459-318bdcd3bd16@libero.it>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <7076f505-adff-0bb2-7c91-a915a362eeb9@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 15:27:34 +0900
MIME-Version: 1.0
In-Reply-To: <d1839d67-2ab5-d07b-e459-318bdcd3bd16@libero.it>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/17 22:23, Goffredo Baroncelli wrote:
> On 03/15/2018 09:15 AM, Misono, Tomohiro wrote:
>> Allow normal user to call "subvolume list/show" by using 3 new
>> unprivileged ioctls (BTRFS_IOC_GET_SUBVOL_INFO,
>> BTRFS_IOC_GET_SUBVOL_ROOTREF and BTRFS_IOC_INO_LOOKUP_USER).
>>
>> Note that for root, "subvolume list" returns all the subvolume in the
>> filesystem by default, but for normal user, it returns subvolumes
>> which exist under the specified path (including the path itself).
> 
> I found the original "btrfs sub list" behavior quite confusing. I think that the problem is that the output is too technical. And the '-a' switch increase this confusion. May be that I am no smart enough :(
> 
> The "normal user behavior" seems to me more coherent. However I am not sure that this differences should be acceptable. In any case it should be tracked in the man page.
> 
> Time to add another command (something like "btrfs sub ls") with a more "human friendly" output ?

Yes, I'm also for to fix the output of "sub list" more user friendly (and the behavior of -a or -o).

However, there are other ongoing works to btrfs-progs which changes code base largely
(i.e libbtrfs and json output, and that is the part of reason this series is RFC as the
changes conflict especially for libbtrfs). So, I'd like to see these changes will be merged first. 

> 
>> The specified path itself is not needed to be a subvolume.
>> If the subvolume cannot be opened but the parent directory can be,
>> the information other than name or id would be zeroed out.
>>
>> Also, for normal user, snapshot filed of "subvolume show" just lists
>> the snapshots under the specified subvolume.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> ---
>>  btrfs-list.c     | 326 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  cmds-subvolume.c |  13 +++
>>  2 files changed, 332 insertions(+), 7 deletions(-)
>>
> 
> [....]
> 
>>  static void print_subvolume_column(struct root_info *subv,
>>  				   enum btrfs_list_column_enum column)
>>  {
>> @@ -1527,17 +1826,28 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
>>  {
>>  	int ret;
>>  
>> -	ret = list_subvol_search(fd, root_lookup);
>> -	if (ret) {
>> -		error("can't perform the search: %m");
>> -		return ret;
>> +	ret = check_perm_for_tree_search(fd);
>> +	if (ret < 0) {
>> +		error("can't check the permission for tree search: %s",
>> +				strerror(-ret));
>> +		return -1;
>>  	}
>>  
>>  	/*
>>  	 * now we have an rbtree full of root_info objects, but we need to fill
>>  	 * in their path names within the subvol that is referencing each one.
>>  	 */
>> -	ret = list_subvol_fill_paths(fd, root_lookup);
>> +	if (ret) {
>> +		ret = list_subvol_search(fd, root_lookup);
>> +		if (ret) {
>> +			error("can't perform the search: %s", strerror(-ret));
>> +			return ret;
>> +		}
>> +		ret = list_subvol_fill_paths(fd, root_lookup);
>> +	} else {
>> +		ret = list_subvol_user(fd, root_lookup, path);
>> +	}
>> +
>>  	return ret;
> 
> I think that the check above should be refined: if I run "btrfs sub list" patched in a kernel without patch I don't get any error and/or warning:
> 
> ghigo@venice:~/btrfs/btrfs-progs$ # kernel w/o patch; btrfs-progs w/patch
> ghigo@venice:~/btrfs/btrfs-progs$ ./btrfs sub list /
> ghigo@venice:~/btrfs/btrfs-progs$ # kernel w/o patch; btrfs-progs w/o patch
> ghigo@venice:~/btrfs/btrfs-progs$ btrfs sub list /
> ERROR: can't perform the search: Operation not permitted
> 
> I think that in both case an error should be raised

I will fix this in next version.

Thanks,
Tomohiro Misono

> 
> 
>>  }
>>  
>> @@ -1631,12 +1941,14 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path)
>>  		return ret;
>>  	}
>>  
>> +	ret = -ENOENT;
>>  	rbn = rb_first(&rl.root);
>>  	while(rbn) {
>>  		ri = rb_entry(rbn, struct root_info, rb_node);
>>  		rr = resolve_root(&rl, ri, root_id);
>> -		if (rr == -ENOENT) {
>> -			ret = -ENOENT;
>> +		if (rr == -ENOENT ||
>> +		    ri->root_id == BTRFS_FS_TREE_OBJECTID ||
>> +		    uuid_is_null(ri->uuid)) {
>>  			rbn = rb_next(rbn);
>>  			continue;
>>  		}
>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>> index faa10c5a..7a7c6f3b 100644
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
>> @@ -596,6 +596,19 @@ static int cmd_subvol_list(int argc, char **argv)
>>  		goto out;
>>  	}
>>  
>> +	ret = check_perm_for_tree_search(fd);
>> +	if (ret < 0) {
>> +		ret = -1;
>> +		error("can't check the permission for tree search: %s",
>> +				strerror(-ret));
>> +		goto out;
>> +	}
>> +	if (!ret && is_list_all) {
>> +		ret = -1;
>> +		error("only root can use -a option");
>> +		goto out;
>> +	}
>> +
>>  	if (flags)
>>  		btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_FLAGS,
>>  					flags);
>>
> 
> 

