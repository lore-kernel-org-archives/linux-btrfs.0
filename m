Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:36230 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753934AbeCGTAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 14:00:31 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 1/2] btrfs: Add unprivileged subvolume search ioctl
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
 <62ce1ddf-a7cd-f770-b4c8-5d47b8d4d31d@jp.fujitsu.com>
 <4de7f3e0-49c3-4fb8-8e66-b7829bf7dc5d@libero.it>
 <e72916b4-9261-b9d9-ab25-e3d38e46fe3b@jp.fujitsu.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <ed9dcb59-d958-02d1-fc2a-7c80a37684d8@inwind.it>
Date: Wed, 7 Mar 2018 20:00:27 +0100
MIME-Version: 1.0
In-Reply-To: <e72916b4-9261-b9d9-ab25-e3d38e46fe3b@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/07/2018 01:40 AM, Misono, Tomohiro wrote:
> On 2018/03/07 5:29, Goffredo Baroncelli wrote:
>> On 03/06/2018 09:30 AM, Misono, Tomohiro wrote:
>>> Add new unprivileged ioctl (BTRFS_IOC_GET_SUBVOL_INFO) which searches
>>> and returns only subvolume related item (ROOT_ITEM/ROOT_BACKREF/ROOT_REF)
>>> from root tree. The arguments of this ioctl are the same as treesearch
>>> ioctl and can be used like treesearch ioctl.
>>
>> Is it a pro ? The treesearch ioctl is tightly coupled to the btrfs internal structure, this means that if we would change the btrfs internal structure, we have to update all the clients of this api. For the treesearch it is an acceptable compromise between flexibility and speed of developing. But for a more specialized API, I think that it would make sense to provide a less coupled api to the internal structure.
> 
> Thanks for the comments.
> 
> The reason I choose the same api is just to minimize the code change in btrfs-progs.
> For tree search part, it works just switching the ioctl number from BTRFS_IOC_TREE_SEARCH
> to BTRFS_IOC_GET_SUBVOL_INFO in list_subvol_search()[1].
> 
> [1] https://marc.info/?l=linux-btrfs&m=152032537911218&w=2

I suggest to avoid this approach. An API is forever; we already have a "root-only" one which is quite unfriendly and error prone; I think that we should put all the energies to make a better one. 

I think that the major weaknesses of this api are:
- it exports the the data in "le" format  (see struct btrfs_root_item as example); 
- it requires the user to increase the key for the next ioctl call. This could be doable in the kernel space before returning
- this ioctl exports both the ROOT_BACKREF and ROOT_ITEM info. Why not make two separate (simplers) ioctl(s) ?

>>
>> Below some comments
[...]

>>> +	if ((key->objectid == BTRFS_FS_TREE_OBJECTID ||
>>> +		(key->objectid >= BTRFS_FIRST_FREE_OBJECTID &&
>>> +		 key->objectid <= BTRFS_LAST_FREE_OBJECTID)) &&
>>> +	    key->type >= BTRFS_ROOT_ITEM_KEY &&
>>> +	    key->type <= BTRFS_ROOT_BACKREF_KEY)
>>
>> Why returning all the range [BTRFS_ROOT_ITEM_KEY...BTRFS_ROOT_BACKREF_KEY]. It would be sufficient to return only
>>
>>   +	    (key->type == BTRFS_ROOT_ITEM_KEY ||
>>   +	     key->type == BTRFS_ROOT_BACKREF_KEY))
> 
> Sorry, it is a mistake, I mean "key->type <= BTRFS_ROOTREF_KEY".
> Although btrfs-progs only uses BTRFS_ROOT_BACKREF_KEY, I notice libbtrfs 
> uses BTRFS_ROOT_REF_KEY instead. So, I think it is better to return both
> ROOT_BACKREF_KEY and ROOT_REF_KEY. I will fix this in v2.
> 

I was referring to the '>=' and '<=' instead of '=='. If another type is added in the middle, it would be returned. I find it a bit error prone.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
