Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaIXDdT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 23:33:19 -0400
Message-ID: <54223B76.1040908@redhat.com>
Date: Tue, 23 Sep 2014 22:33:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
CC: guaneryu@gmail.com
Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options internally
 to avoid losing security label.
References: <1411450808-14988-1-git-send-email-quwenruo@cn.fujitsu.com> <54216C70.6030206@fb.com> <5421C11D.2040201@redhat.com> <542210E5.7060509@cn.fujitsu.com>
In-Reply-To: <542210E5.7060509@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/23/14 7:31 PM, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options internally to avoid losing security label.
> From: Eric Sandeen <sandeen@redhat.com>
> To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
> Date: 2014年09月24日 02:51
>> On 9/23/14 7:49 AM, Chris Mason wrote:
>>> On 09/23/2014 01:40 AM, Qu Wenruo wrote:
>>>> [BUG]
>>>> Originally when mount btrfs with "-o subvol=" mount option, btrfs will
>>>> lose all security lable.
>>>> And if the btrfs fs is mounted somewhere else, due to the lost of
>>>> security lable, SELinux will refuse to mount since the same super block
>>>> is being mounted using different security lable.
>>>>
>>>> [REPRODUCER]
>>>> With SELinux enabled:
>>>>   #mkfs -t btrfs /dev/sda5
>>>>   #mount -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/btrfs
>>>>   #btrfs subvolume create /mnt/btrfs/subvol
>>>>   #mount -o subvol=subvol,context=system_u:object_r:nfs_t:s0 /dev/sda5
>>>>    /mnt/test
>>>>
>>>> kernel message:
>>>> SELinux: mount invalid.  Same superblock, different security settings
>>>> for (dev sda5, type btrfs)
>>>>
>>>> [REASON]
>>>> This happens because btrfs will call vfs_kern_mount() and then
>>>> mount_subtree() to handle subvolume name lookup.
>>>> First mount will cut off all the security lables and when it comes to
>>>> the second vfs_kern_mount(), it has no security label now.
>>>>
>>>> [FIX]
>>>> This patch will makes btrfs behavior much more like nfs,
>>>> which has the type flag FS_BINARY_MOUNTDATA,
>>>> making btrfs handles the security label internally.
>>>> So security label will be set in the real mount time and won't lose
>>>> label when use with "subvol=" mount option.
>>> Thanks for working on this.  Eric Sandeen (cc'd) was trying out
>>> something similar recently, so I want to make sure this doesn't conflict
>>> with his ideas.
>> My ideas didn't get very far.  ;)
>>
>> What I was after was a way for multiple subvolumes to have unique contexts.
>> It looks like this might do the trick, as long as they are mounted on a unique
>> mount point.
>>
>> Would this allow "subvolume create" to take a context, so that everything
>> under /mnt/btrfs/subvol/ has a unique subvol-wide context?
>>
>> thanks,
>> -Eric
> Did you mean the following situation?
> /dev/sdb default subvol(FS_TREE) mounted on /mnt/default with context A
> /dev/sdb subvol=subvol mounted on /mnt/subvol with context B
> 
> If that's your goal, I am afraid that my patch can't achieve it and even worse, will even forbid it. :(
> 
> SELinux doesn't allow same superblock mounted with different context, and the patch follows it.
> If SELinux is modified to allow same superblock different context, then my patch also needs to be modified.

oh, ok, I see.

I don't think that my "wish" should disallow your patch.

For the problem I was looking at, I think the only way forward would require
some significant selinux modification, and treating a subvol root essentially
like a superblock.

So ... don't let me slow you down, at least for now.  ;)

-Eric

