Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:64874 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751526AbeCTBnE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 21:43:04 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id B724BAC00A2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 10:42:55 +0900 (JST)
Subject: Re: [RFC PATCH v3 5/7] btrfs-progs: sub list: Allow normal user to
 call "subvolume list/show"
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
 <124532ad-d4c9-de0f-a277-b8a7dd571fad@jp.fujitsu.com>
 <2f420cf6-4f70-c573-ef7e-6ebf94152370@libero.it>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <a00576f7-6c26-623d-8f8d-b199212def94@jp.fujitsu.com>
Date: Tue, 20 Mar 2018 10:41:29 +0900
MIME-Version: 1.0
In-Reply-To: <2f420cf6-4f70-c573-ef7e-6ebf94152370@libero.it>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 2018/03/20 2:09, Goffredo Baroncelli wrote:
> On 03/19/2018 08:32 AM, Misono, Tomohiro wrote
[snip]
>>  static void print_subvolume_column(struct root_info *subv,
>>  				   enum btrfs_list_column_enum column)
>>  {
>> @@ -1492,19 +1800,33 @@ next:
>>  static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
>>  			const char *path)
>>  {
>> +	uid_t uid;
>>  	int ret;
>>  
>> -	ret = list_subvol_search(fd, root_lookup);
>> -	if (ret) {
>> -		error("can't perform the search: %m");
>> -		return ret;
>> +	uid = geteuid();
>> +	if (!uid) {
> 
> A minor tip: I think uid == 0 is better here, because we should check that uid is root

ok, thanks.

> 
>> +		ret = list_subvol_search(fd, root_lookup);
>> +		if (ret) {
>> +			error("can't perform the search: %s", strerror(-ret));
>> +			return ret;
>> +		}
>> +		/*
>> +		 * now we have an rbtree full of root_info objects, but we
>> +		 * need to fill in their path names within the subvol that
>> +		 * is referencing each one.
>> +		 */
>> +		ret = list_subvol_fill_paths(fd, root_lookup);
>> +	} else {
>> +		ret = list_subvol_user(fd, root_lookup, path);
>> +		if (ret) {
>> +			if (ret == -ENOTTY)
>> +error("can't perform the search: Operation by non-privileged user is not supported by this kernel.");
>> +			else
>> +				error("can't perform the search: %s",
>> +						    strerror(-ret));
>> +		}
> 
> Sorry for noticing that only now: which is the reason to not using the new api also in "root" case? I know that the behavior is a bit different, so my question is: it is possible to extend the new ioctls to support also the old behavior in the root case? So we could get rid of the "tree search" ioctl, using it only for the old kernel

It is not possible to provide the same functionality for root by current implementation of ioctl.

Currently all three ioctls returns the information of subvolume which contains the fd's inode.
This is because to prevent a user from getting arbitrary subvolume information in the filesystem.

So, in order to work "sub list" with these new ioctls , we need to do:
1. open the path
2. call GET_SUBVOL_INFO to get the subvolume info of opened path.
3. call GET_SUBVOL_ROOTREF to get the list of child subvolume id.
4. call INO_LOOKUP_USER to check if a user can really access the (parent directory of) child subvolume and construct the path.
5. for each accessible child subvolume, repeat 1-5. 

Therefore there is no way to search subvolumes outside of mount point if the default subvolume
has been changed and cannot be used as an alternative of tree search ioctl for root.

If we pass a subvolid to be searched as an argument (allowing for root only), it is possible to use
these ioctls to replace tree search ioctl. However, this means the behavior of ioctl is different from
root and normal user. Is it a good thing? Also, the number of ioctl call certainly increases since 
GET_SUBVOL_INFO/SUBVOL_ROOTREF needs to be called for each subvolume while tree search returns multiple
information at once. I'd like to know others' opinions.

