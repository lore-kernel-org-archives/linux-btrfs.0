Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59942 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228AbaGBI50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 04:57:26 -0400
Message-ID: <53B3C9B1.3020404@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 16:58:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Harald Hoyer <harald@redhat.com>, Chris Mason <clm@fb.com>,
        <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <20140701153240.GL1553@twin.jikos.cz> <53B2E371.6030504@fb.com> <53B3BBD3.4070004@redhat.com>
In-Reply-To: <53B3BBD3.4070004@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes 
with different ro/rw options"
From: Harald Hoyer <harald@redhat.com>
To: Chris Mason <clm@fb.com>, dsterba@suse.cz, Qu Wenruo 
<quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年07月02日 15:59
> On 01.07.2014 18:36, Chris Mason wrote:
>> On 07/01/2014 11:32 AM, David Sterba wrote:
>>> (adding Harald to CC)
>>>
>>> On Tue, Jul 01, 2014 at 05:30:01PM +0800, Qu Wenruo wrote:
>>>> This reverts commit 0723a0473fb48a1c93b113a28665b64ce5faf35a.
>>>> This commit has the following problem:
>>>> 1) Break the ro mount rule.
>>>> When users mount the whole btrfs ro, it is still possible to mount
>>>> subvol rw and change the contents. Which make the whole fs ro mount
>>>> non-sense.
>>> The proposed usecase was to allow mounting subvolumes with different
>>> ro/rw flags, and this makes sense to me (provided that the whole
>>> filesystem is mounted rw).
>>>
>>> Anything else seems to lead to all the internal problems you point
>>> below. I'm not even sure if mounting the first subvolume 'ro' should
>>> imply that the whole filesystem is ro or not.
>>>
>>>> 2) Cause whole btrfs ro/rw mount change fails.
>>>> When mount a subvol ro first, when you can't mount the whole fs mounted
>>>> rw. This is due to the check in btrfs_mount() which returns -EBUSY,
>>>> which is OK for single fs to prevent mount fs ro in one mount point and
>>>> mount the same fs rw in other mount point.
>>>> Step to reproduce:
>>>> mount -o subvol=subv,ro /dev/sda6 /mnt/btrfs
>>>> mount -o rw /dev/sda6 /mnt/btrfs	<-this will fail
>>> Yeah, so first ro means whole filesystem is ro.
>>>
>>>> 3) Kernel warn in vfs.
>>>> When mount the whole fs ro, and mount a subvol ro, kernel warning will
>>>> show in fs/sync.c complaining s_umount rwsem is not locked.
>>>> Since this remount is not called by VFS, so s_mounts rwsem is not
>>>> correctly locked.
>>> That's serious.
>> Agreed, we'll pull this out until we get a better handle on things.
>> Thanks for spending time on it.
>>
>> -chris
>>
> My patch was initially only a request for comments:
> - patch pointed out the problem
> - provided a possible solution/workaround
> - even has "FIXME" in the code :)
>
> So, what I was hoping, that somebody else with more VFS knowledge than me would
> step up and come up with a sane solution.
>
> Pull it out, if the patch causes problems, but _please_ think about the problem
> and come up with a solution, so that "mount -a" works with a normal fstab.
Personally, the main points to implement the feature are the following:
1) ro/rw logical (how ro and rw works)
IMO, any subvol can't be mounted rw if any of its parent is mounted ro 
would be good enough.
So whole btrfs ro mount will not allow any rw subvol mount,
and rw subvol will allow child subvol mounted as ro.

For me, the logical thing is not a problem.

2) subvol umount (real hard part to implement)
If we choose 1) logical, then we must store the rw/ro mount option will 
the subvolid when mount
and clear rw/ro mount option when *umounting the subvol*.

Mounting part can be easily done in fs/btrfs/super.c:get_default_root(), 
but the problem is that
when umount, we have no hook or callback to imform btrfs the subvol 
umount( I hope I was wrong).

It would be quite nice if someone has some good idea about this problem.

Thanks,
Qu
