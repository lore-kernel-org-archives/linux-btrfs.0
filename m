Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:64677 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbeCIBLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 20:11:00 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 31913AC04B1
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 10:10:49 +0900 (JST)
Subject: Re: [PATCH 1/2] btrfs: Add unprivileged subvolume search ioctl
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
 <62ce1ddf-a7cd-f770-b4c8-5d47b8d4d31d@jp.fujitsu.com>
 <4de7f3e0-49c3-4fb8-8e66-b7829bf7dc5d@libero.it>
 <e72916b4-9261-b9d9-ab25-e3d38e46fe3b@jp.fujitsu.com>
 <ed9dcb59-d958-02d1-fc2a-7c80a37684d8@inwind.it>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <bea70225-4364-600d-41ad-37fd7df64713@jp.fujitsu.com>
Date: Fri, 9 Mar 2018 10:10:42 +0900
MIME-Version: 1.0
In-Reply-To: <ed9dcb59-d958-02d1-fc2a-7c80a37684d8@inwind.it>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/03/08 4:00, Goffredo Baroncelli wrote:
> On 03/07/2018 01:40 AM, Misono, Tomohiro wrote:
>> On 2018/03/07 5:29, Goffredo Baroncelli wrote:
>>> On 03/06/2018 09:30 AM, Misono, Tomohiro wrote:
>>>> Add new unprivileged ioctl (BTRFS_IOC_GET_SUBVOL_INFO) which searches
>>>> and returns only subvolume related item (ROOT_ITEM/ROOT_BACKREF/ROOT_REF)
>>>> from root tree. The arguments of this ioctl are the same as treesearch
>>>> ioctl and can be used like treesearch ioctl.
>>>
>>> Is it a pro ? The treesearch ioctl is tightly coupled to the btrfs internal structure, this means that if we would change the btrfs internal structure, we have to update all the clients of this api. For the treesearch it is an acceptable compromise between flexibility and speed of developing. But for a more specialized API, I think that it would make sense to provide a less coupled api to the internal structure.
>>
>> Thanks for the comments.
>>
>> The reason I choose the same api is just to minimize the code change in btrfs-progs.
>> For tree search part, it works just switching the ioctl number from BTRFS_IOC_TREE_SEARCH
>> to BTRFS_IOC_GET_SUBVOL_INFO in list_subvol_search()[1].
>>
>> [1] https://marc.info/?l=linux-btrfs&m=152032537911218&w=2
> 
> I suggest to avoid this approach. An API is forever; we already have a "root-only" one which is quite unfriendly and error prone; I think that we should put all the energies to make a better one. 
> 
> I think that the major weaknesses of this api are:
> - it exports the the data in "le" format  (see struct btrfs_root_item as example); 
> - it requires the user to increase the key for the next ioctl call. This could be doable in the kernel space before returning
> - this ioctl exports both the ROOT_BACKREF and ROOT_ITEM info. Why not make two separate (simplers) ioctl(s) ?

I agree with you and will split this ioctl into two pats (one is for getting ROOT_ITEM and the other for ROOT_REF/BACKREF)
and make them to have user friendly apis.

> 
>>>
>>> Below some comments
> [...]
> 
>>>> +	if ((key->objectid == BTRFS_FS_TREE_OBJECTID ||
>>>> +		(key->objectid >= BTRFS_FIRST_FREE_OBJECTID &&
>>>> +		 key->objectid <= BTRFS_LAST_FREE_OBJECTID)) &&
>>>> +	    key->type >= BTRFS_ROOT_ITEM_KEY &&
>>>> +	    key->type <= BTRFS_ROOT_BACKREF_KEY)
>>>
>>> Why returning all the range [BTRFS_ROOT_ITEM_KEY...BTRFS_ROOT_BACKREF_KEY]. It would be sufficient to return only
>>>
>>>   +	    (key->type == BTRFS_ROOT_ITEM_KEY ||
>>>   +	     key->type == BTRFS_ROOT_BACKREF_KEY))
>>
>> Sorry, it is a mistake, I mean "key->type <= BTRFS_ROOTREF_KEY".
>> Although btrfs-progs only uses BTRFS_ROOT_BACKREF_KEY, I notice libbtrfs 
>> uses BTRFS_ROOT_REF_KEY instead. So, I think it is better to return both
>> ROOT_BACKREF_KEY and ROOT_REF_KEY. I will fix this in v2.
>>
> 
> I was referring to the '>=' and '<=' instead of '=='. If another type is added in the middle, it would be returned. I find it a bit error prone.

ok, I will change this. thanks.
Tomohiro Misono

> 
> BR
> G.Baroncelli
> 

