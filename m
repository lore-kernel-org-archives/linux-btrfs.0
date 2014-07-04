Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60279 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbaGDB1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 21:27:11 -0400
Message-ID: <53B6032D.6090207@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 09:28:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com> <53B594E7.9070500@inwind.it>
In-Reply-To: <53B594E7.9070500@inwind.it>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes 
with different ro/rw options"
From: Goffredo Baroncelli <kreijack@inwind.it>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年07月04日 01:37
> On 07/03/2014 02:28 AM, Qu Wenruo wrote:
>> -------- Original Message --------
>> Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with different ro/rw options"
>> From: Goffredo Baroncelli <kreijack@libero.it>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
>> Date: 2014年07月03日 01:48
>>> On 07/01/2014 11:30 AM, Qu Wenruo wrote:
>>>> This commit has the following problem:
>>>> 1) Break the ro mount rule.
>>>> When users mount the whole btrfs ro, it is still possible to mount
>>>> subvol rw and change the contents. Which make the whole fs ro mount
>>>> non-sense.
>>> Where is the problem ? I see an use case when I want a conservative default: mount all ro except some subvolumes.
>>>
>>> In any case it is not a security problem because if the user has the capability to mount a subvolume, also he has the capability to remount,rw the whole filesystem.
>>>
>>>
>>>
>> Not security problem but behavior not consistent.
>> If user mount the whole disk ro, he or she want the fs read only and nothing will change in it.
>> If you mount a subvol rw, then the whole disk ro expectation is broken. Things will change even the whole
>> disk is readonly.
> Sorry for bother you again, but there is a thing not clear to me:
>
> If
>
>      # mount -o subvolid=5,ro /dev/sda1 /mnt/root
>      # mount -o subvol=subvolname,rw /dev/sda1 /mnt/subvolname
>
> I suppose that
>
>      # touch /mnt/root/touch-test 		# 1
>
> fails, and
>
>      # touch /mnt/subvolname/touch-test		# 2
>
> succeeded. I understood correctly ?
Your understanding is right and that is current behavior.

But that should not be the correct behavior.

If you mount fs_tree ro, btrfs should ensure the whole fs_tree(including 
all the subvolumes) ro.
Or the whole fs_tree is not restricted readonly since you can modify 
contents inside the rw subvolume,
and it's part of the fs_tree.(partly ro and partly rw status)

IMO the perfect logical should be like the following:
1) ro mounted subvolume will force all the children subvolumes only ro 
mountable

subvol 5 (mounted ro /)
├── subvol 257 (mounted rw /mnt/btrfrs)
So above mounted should not be allowed.

But the following mount should be OK:
subvol 5 (mounted rw /)
├── subvol 257 (mounted ro /mnt/btrfrs)

2) ro mounted subvolume will not be modified even through the rw mounted 
parent subvolume.

Only this will ensure restricted ro mount option.

If anyone has any other ideas about it, I'm happy to listen.

Thanks,
Qu
>   If so this behaviour seems to me correctly.
> Different is after mounting the subvolume "subvolumename", also the whole filesystem results rw (eg: #1 succeeded).
>
> G.Baroncelli
>
>
>
>
>
>> The problem also happens when a parent subvol is mounted rw but child subvol is mounted ro.
>> User can still modify the child subvol through parent subvol, still broke the readonly rule.
>>
>> Thanks,
>> Qu
>>
>

