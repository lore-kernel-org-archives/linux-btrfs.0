Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:26666 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3HWJkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 05:40:33 -0400
Message-ID: <52172E0E.2000402@giantdisaster.de>
Date: Fri, 23 Aug 2013 11:40:30 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't allow the replace procedure on read only
 filesystems
References: <1376931073-25320-1-git-send-email-sbehrens@giantdisaster.de> <5217073A.5020609@cn.fujitsu.com>
In-Reply-To: <5217073A.5020609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 23 Aug 2013 14:54:50 +0800, Wang Shilong wrote:
> Hey Stefan,
> 
> On 08/20/2013 12:51 AM, Stefan Behrens wrote:
>> If you start the replace procedure on a read only filesystem, at
>> the end the procedure fails to write the updated dev_items to the
>> chunk tree. The problem is that this error is not indicated except
>> for a WARN_ON(). If the user now thinks that everything was done
>> as expected and destroys the source device (with mkfs or with a
>> hammer). The next mount fails with "failed to read chunk root" and
>> the filesystem is gone.
>>
>> This commit adds code to fail the attempt to start the replace
>> procedure if the filesystem is mounted read-only.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> Cc: <stable@vger.kernel.org> # 3.10+
>> ---
>>  fs/btrfs/ioctl.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 3e36626..bf42d41 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3653,6 +3653,9 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
>>  
>>  	switch (p->cmd) {
>>  	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
>> +		if (root->fs_info->sb->s_flags & MS_RDONLY)
>> +			return -EROFS;
>> +
> 
> This is not really safe. Considering：
> 
> Task 1					Task2				
> |--->sb->s_flags & MS_RDONLY		
> 
> 	 				Remount filesyste RO
> 
> |--->do replace operations
> 
> For the above case, we will continue to do device replace while the filesystem is READONLY.
> and i think mnt_want_file() will be a right choice.

You are right that a window for a race condition remains and that this
is therefore not a correct solution.

The problem that I have with surrounding the long running replace
procedure with mnt_want_write_file/mnt_drop_write_file is that I am
unable to remount read-only during this time. remount read-only usually
suspends the replace operation, but with mnt_want_write_file it fails
and the Btrfs remount code is not called.
This would be a problem if some (non-Btrfs-replace-aware) software tries
to remount the filesystem read-only.

Therefore I still think that the quick & dirty read-only check that I
added is the better solution.

This happens when mnt_want_write_file() is used:
# btrfs replace start /dev/sdi /dev/sde /mnt2
# mount -o remount,ro /dev/sdi /mnt2
mount: you must specify the filesystem type
# echo $?
32
# btrfs replace cancel /mnt2
# mount -o remount,ro /dev/sdi /mnt2
# echo $?
0

