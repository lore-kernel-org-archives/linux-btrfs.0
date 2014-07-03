Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7743 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbaGCB0u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 21:26:50 -0400
From: Chris Mason <clm@fb.com>
To: Harald Hoyer <harald@redhat.com>, "dsterba@suse.cz" <dsterba@suse.cz>,
        "Qu Wenruo" <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
Date: Thu, 3 Jul 2014 01:26:38 +0000
Message-ID: <CFDA29A4.5D86%clm@fb.com>
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140701153240.GL1553@twin.jikos.cz> <53B2E371.6030504@fb.com>
 <53B3BBD3.4070004@redhat.com>
In-Reply-To: <53B3BBD3.4070004@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/2/14, 3:59 AM, "Harald Hoyer" <harald@redhat.com> wrote:

>On 01.07.2014 18:36, Chris Mason wrote:
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
>>>
>>> The proposed usecase was to allow mounting subvolumes with different
>>> ro/rw flags, and this makes sense to me (provided that the whole
>>> filesystem is mounted rw).
>>>
>>> Anything else seems to lead to all the internal problems you point
>>> below. I'm not even sure if mounting the first subvolume 'ro' should
>>> imply that the whole filesystem is ro or not.
>>>
>>>> 2) Cause whole btrfs ro/rw mount change fails.
>>>> When mount a subvol ro first, when you can't mount the whole fs
>>>>mounted
>>>> rw. This is due to the check in btrfs_mount() which returns -EBUSY,
>>>> which is OK for single fs to prevent mount fs ro in one mount point
>>>>and
>>>> mount the same fs rw in other mount point.
>>>> Step to reproduce:
>>>> mount -o subvol=subv,ro /dev/sda6 /mnt/btrfs
>>>> mount -o rw /dev/sda6 /mnt/btrfs	<-this will fail
>>>
>>> Yeah, so first ro means whole filesystem is ro.
>>>
>>>> 3) Kernel warn in vfs.
>>>> When mount the whole fs ro, and mount a subvol ro, kernel warning will
>>>> show in fs/sync.c complaining s_umount rwsem is not locked.
>>>> Since this remount is not called by VFS, so s_mounts rwsem is not
>>>> correctly locked.
>>>
>>> That's serious.
>> 
>> Agreed, we'll pull this out until we get a better handle on things.
>> Thanks for spending time on it.
>> 
>> -chris
>> 
>
>My patch was initially only a request for comments:
>- patch pointed out the problem
>- provided a possible solution/workaround
>- even has "FIXME" in the code :)
>
>So, what I was hoping, that somebody else with more VFS knowledge than me
>would
>step up and come up with a sane solution.
>
>Pull it out, if the patch causes problems, but _please_ think about the
>problem
>and come up with a solution, so that "mount -a" works with a normal fstab.


Definitely, we don¹t want to drop this functionality over the long term.
The biggest problem here is the vfs warning.  Let me take another look and
see if I can get the locking right.

-chris

