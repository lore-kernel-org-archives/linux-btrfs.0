Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13763 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965686AbbBEAc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 19:32:28 -0500
Message-ID: <54D2BA19.3070800@cn.fujitsu.com>
Date: Thu, 5 Feb 2015 08:32:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaoxie@huawei.com>, <linux-btrfs@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RFC v6 6/9] vfs: Add sb_want_write() function to get vfsmount
 from a given sb.
References: <1423015855-27357-1-git-send-email-quwenruo@cn.fujitsu.com> <54D1D3B4.9060209@huawei.com>
In-Reply-To: <54D1D3B4.9060209@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RFC v6 6/9] vfs: Add sb_want_write() function to get 
vfsmount from a given sb.
From: Miao Xie <miaoxie@huawei.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: 2015年02月04日 16:09
> On Wed, 04 Feb 2015 10:10:55 +0800, Qu Wenruo wrote:
>> *** Please DON'T merge this patch, it's only for disscusion purpose ***
>>
>> There are sysfs interfaces in some fs, only btrfs yet, which will modify
>> on-disk data.
>> Unlike normal file operation routine we can use mnt_want_write_file() to
>> protect the operation, change through sysfs won't to be binded to any file
>> in the filesystem.
>>
>> So introduce new sb_want_write() to do the protection agains a super
>> block, which acts much like mnt_want_write() but will return success if
>> the super block is read-write.
>>
>> Since sysfs handler don't go through the normal vfsmount, so it won't
>> increase the refcount of and even we have sb_want_write() waiting sb to
>> be unfrozen, the fs can still be unmounted without problem.
>> Causing the modules unable to be removed and user can find out what's
>> wrong until
>>
>> To solve such problem, we have different strategies to solve it.
>> 1) Extra check on last instance umount of a sb
>> This is the method the patch uses.
>> This method seems valid enough, since we want to get write protection on
>> a sb, so it's OK for the sb if there is *ANY* mount instance.
>> Problem 1.1)
>> But lsof and other tools won't help if sb_want_write() on frozen fs cause
>> it unable to be unmounted.
>>
>> Problem 1.2)
>> When get namespace involved, things will get more complicated.
>> Like the following case:
>> 	Alice				|		Bob
>> Mount devA on /mnt1 in her ns		| Mount devA on /mnt2/ in his ns
>> freeze /mnt1				|
>> sb_want_write() (waiting)		|
>> umount /mnt1 (success since there is 	|
>> another mount instance)			|
>> 					| umount /mnt2 (fail since there
>> 					| is sb_want_write() waiting)
>>
>> So Alice can't thaw the fs since there is no mount point for it now.
>>
>> 2) Don't allow any umount of the sb if there is sb_want_write().
>> More aggressive one, purpose by Miao Xie.
>> Can't resolve problem 1.1) but will solve problem 1.2).
> This is one of the two methods that I told you, but not the one I recommended.
> What I wanted to recommend is that thaw the fs at the beginning of the
> sb kill process, and in sb_want_write(), we check if the sb is active or
> not after we pass sb_start_write, if the sb is not active, go back.
> (This way also is not so good, but better than the above one)
>
>> Although introduced new problem like the following:
>> 	Alice
>> Mount devA on /mnt1
>> freeze /mnt1
>> sb_want_write() (waiting)
>> mount devA on /mnt2 and /mnt3
>>
>> /mnt[123] all can't be unmounted, but new mount can still be created.
>>
>> 3) sb_want_write() doesn't make any sense and break VFS rules!
>> Action which will change on-disk data should not be tunable through sysfs,
>> and sb_want_write() things which by-pass all the VFS check is just evil.
>> And for btrfs, we already have the ioctl to set label, why bothering new
>> sysfs interface to do it again?
>>
>> Although I use method 1) to do it, I am still not certain about which is
>> method is the correct one.
>>
>> So any advise is welcomed.
>>
>> Thanks,
>> Qu
> [SNIP]
>
>> +/**
>> + * sb_want_write - get write acess to a super block
>> + * @sb: the superblock of the filesystem
>> + *
>> + * This tells the low-level filesystem that a write is about to be performed to
>> + * it, and makes sure that the writes are allowed (superblock is read-write,
>> + * filesystem is not frozen) before returning success.
>> + * When the write operation is finished, sb_drop_write() must be called.
>> + * This is much like mnt_want_write() as a refcount, but only needs
>> + * the superblock to be read-write.
>> + */
>> +int sb_want_write(struct super_block *sb)
>> +{
>> +	spin_lock(&sb->s_want_write_lock);
>> +	if (sb->s_want_write_block) {
>> +		spin_unlock(&sb->s_want_write_lock);
>> +		return -EBUSY;
>> +	}
>> +	sb->s_want_write_count++;
>> +	spin_unlock(&sb->s_want_write_lock);
Also, such behavior is the same as  rw_sem, so I'll also change it to 
rw_sem to use the existing
infrastructure in next version.

Thanks,
Qu
>> +
>> +	sb_start_write(sb);
>> +	if (sb->s_readonly_remount || sb->s_flags & MS_RDONLY) {
> If someone remount the fs to R/O here(after the check), we should not continue
> to change label/features. I think we need add some check in remount functions.
>
> Thanks
> Miao

