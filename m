Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57137 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757101AbaGAQgj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 12:36:39 -0400
Message-ID: <53B2E371.6030504@fb.com>
Date: Tue, 1 Jul 2014 12:36:01 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>, <harald@redhat.com>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <20140701153240.GL1553@twin.jikos.cz>
In-Reply-To: <20140701153240.GL1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2014 11:32 AM, David Sterba wrote:
> (adding Harald to CC)
> 
> On Tue, Jul 01, 2014 at 05:30:01PM +0800, Qu Wenruo wrote:
>> This reverts commit 0723a0473fb48a1c93b113a28665b64ce5faf35a.
>> This commit has the following problem:
>> 1) Break the ro mount rule.
>> When users mount the whole btrfs ro, it is still possible to mount
>> subvol rw and change the contents. Which make the whole fs ro mount
>> non-sense.
> 
> The proposed usecase was to allow mounting subvolumes with different
> ro/rw flags, and this makes sense to me (provided that the whole
> filesystem is mounted rw).
> 
> Anything else seems to lead to all the internal problems you point
> below. I'm not even sure if mounting the first subvolume 'ro' should
> imply that the whole filesystem is ro or not.
> 
>> 2) Cause whole btrfs ro/rw mount change fails.
>> When mount a subvol ro first, when you can't mount the whole fs mounted
>> rw. This is due to the check in btrfs_mount() which returns -EBUSY,
>> which is OK for single fs to prevent mount fs ro in one mount point and
>> mount the same fs rw in other mount point.
>> Step to reproduce:
>> mount -o subvol=subv,ro /dev/sda6 /mnt/btrfs
>> mount -o rw /dev/sda6 /mnt/btrfs	<-this will fail
> 
> Yeah, so first ro means whole filesystem is ro.
> 
>> 3) Kernel warn in vfs.
>> When mount the whole fs ro, and mount a subvol ro, kernel warning will
>> show in fs/sync.c complaining s_umount rwsem is not locked.
>> Since this remount is not called by VFS, so s_mounts rwsem is not
>> correctly locked.
> 
> That's serious.

Agreed, we'll pull this out until we get a better handle on things.
Thanks for spending time on it.

-chris
