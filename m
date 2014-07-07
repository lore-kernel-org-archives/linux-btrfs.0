Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43194 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752185AbaGGBpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 21:45:34 -0400
Message-ID: <53B9FBE4.6040300@cn.fujitsu.com>
Date: Mon, 7 Jul 2014 09:46:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com> <53B594E7.9070500@inwind.it> <53B6032D.6090207@cn.fujitsu.com> <53B6E744.1060204@inwind.it>
In-Reply-To: <53B6E744.1060204@inwind.it>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes 
with different ro/rw options"
From: Goffredo Baroncelli <kreijack@inwind.it>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年07月05日 01:41
> Hi Qu
> On 07/04/2014 03:28 AM, Qu Wenruo wrote:
>> -------- Original Message -------- Subject: Re: [RFC PATCH] Revert
>> "btrfs: allow mounting btrfs subvolumes with different ro/rw
>> options" From: Goffredo Baroncelli <kreijack@inwind.it> To: Qu Wenruo
>> <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org Date: 2014年07月
>> 04日 01:37
>>> On 07/03/2014 02:28 AM, Qu Wenruo wrote:
>>>> -------- Original Message -------- Subject: Re: [RFC PATCH]
>>>> Revert "btrfs: allow mounting btrfs subvolumes with different
>>>> ro/rw options" From: Goffredo Baroncelli <kreijack@libero.it> To:
>>>> Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
>>>> Date: 2014年07月03日 01:48
>>>>> On 07/01/2014 11:30 AM, Qu Wenruo wrote:
>>>>>> This commit has the following problem: 1) Break the ro mount
>>>>>> rule. When users mount the whole btrfs ro, it is still
>>>>>> possible to mount subvol rw and change the contents. Which
>>>>>> make the whole fs ro mount non-sense.
>>>>> Where is the problem ? I see an use case when I want a
>>>>> conservative default: mount all ro except some subvolumes.
>>>>>
>>>>> In any case it is not a security problem because if the user
>>>>> has the capability to mount a subvolume, also he has the
>>>>> capability to remount,rw the whole filesystem.
>>>>>
>>>>>
>>>>>
>>>> Not security problem but behavior not consistent. If user mount
>>>> the whole disk ro, he or she want the fs read only and nothing
>>>> will change in it. If you mount a subvol rw, then the whole disk
>>>> ro expectation is broken. Things will change even the whole disk
>>>> is readonly.
>>> Sorry for bother you again, but there is a thing not clear to me:
>>>
>>> If
>>>
>>> # mount -o subvolid=5,ro /dev/sda1 /mnt/root # mount -o
>>> subvol=subvolname,rw /dev/sda1 /mnt/subvolname
>>>
>>> I suppose that
>>>
>>> # touch /mnt/root/touch-test         # 1
>>>
>>> fails, and
>>>
>>> # touch /mnt/subvolname/touch-test        # 2
>>>
>>> succeeded. I understood correctly ?
>> Your understanding is right and that is current behavior.
>>
>> But that should not be the correct behavior.
>>
>> If you mount fs_tree ro, btrfs should ensure the whole
>> fs_tree(including all the subvolumes) ro. Or the whole fs_tree is not
>> restricted readonly since you can modify contents inside the rw
>> subvolume, and it's part of the fs_tree.(partly ro and partly rw
>> status)
>>
>> IMO the perfect logical should be like the following: 1) ro mounted
>> subvolume will force all the children subvolumes only ro mountable
>>
>> subvol 5 (mounted ro /) ├── subvol 257 (mounted rw /mnt/btrfrs) So
>> above mounted should not be allowed.
>>
>> But the following mount should be OK: subvol 5 (mounted rw /) ├──
>> subvol 257 (mounted ro /mnt/btrfrs)
>>
>> 2) ro mounted subvolume will not be modified even through the rw
>> mounted parent subvolume.
>>
>> Only this will ensure restricted ro mount option.
>>
>> If anyone has any other ideas about it, I'm happy to listen.
> Usually I mount both the subvolume as root filesystem and the root of the btrfs filesystem in a subdir . This allow me to perform action like snapshot of the root filesystem.
>
> So to me it seems reasonable to have different rw/ro status between btrfs root and btrfs subvolume. As use case think a system which hosts several guests in container. Each guest has its own subvolume as root filesystem. An user would mount the btrfs root RO in order to see all the subvolume but at the same time he avoids to change a file for error; when a guest has to be started, its root filesystem/subvolume can be mounted RW.
You caught me. Yes, the use case seems quite resonable since currently 
you need to mount btrfs to get the subvolume list
(the only offline method seems btrfs-debug-tree but end-users won't use 
it anyway)
and it's a good admin behavior to mount it ro if no need to write.
>
> On the other side, I understand that this could lead to an unexpected behaviour because with the other filesystem it is impossible to mount only a part as RW. In this BTRFS would be different.
>
> Following the "least surprise" principle, I prefer that the *mount* RO/RW flag acts globally: the filesystem has only one status. It is possible to change it only globally.
>
> In order to having a subvolumes with different RO/RW status we should rely on different flag. I have to point out that the subvolume has already the concept of read-only status.
>
> We could adopt the following rules:
> - if the filesystem is mounted RO then all the subvolumes (event the id=5) are RO
> - if a subvolume is marked RO, the it is RO
> - otherwise a subvolume is RW
I'm confused with rule 1. When mentionting 'mounted RO', you mean mount 
subvolume id=5 RO?
Also you mentioned that using differnt RO/RW flag independent from VFS 
RO/RW flags,
so it also makes me confused that when mentioning RO, did you mean VFS 
RO or new btrfs RO/RW flags?
>
> Moreover we can add further rules to inherit the subvolume RO/RW status at the creation time (even tough it makes sense only for the snapshot). We could use an xattr for that.
>
> Finally I would like to point out that relying on the relationship parent/child between the subvolumes is very dangerous. With the exception if the subvolid=5 which is the only root one, it is very easy to move up and down the subvolume. I have to point out this because I read on another email that someone likes the idea to having a RO subvolume because its parent is marked RO.
> But a subvolume may be mounted also by id and not by its path (and or name). So relying on the relationship parent/child would lead to break the "least surprise principle".
>
> My 2 ¢
> BR
> G.Baroncelli
Oh I forgot that user can mv subvolumes just like normal dirs. In this 
case it will certainly make ro/rw disaster if rely on the parent ro/rw 
status. :(

Thanks,
Qu
>
>> Thanks, Qu
>>> If so this behaviour seems to me correctly. Different is after
>>> mounting the subvolume "subvolumename", also the whole filesystem
>>> results rw (eg: #1 succeeded).
>>>
>>> G.Baroncelli
>>>
>>>
>>>
>>>
>>>
>>>> The problem also happens when a parent subvol is mounted rw but
>>>> child subvol is mounted ro. User can still modify the child
>>>> subvol through parent subvol, still broke the readonly rule.
>>>>
>>>> Thanks, Qu
>>>>
>>
>

