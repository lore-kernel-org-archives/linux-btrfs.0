Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41225 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753333AbdESAMS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:12:18 -0400
Subject: Re: [PATCH RFC] vfs: add mount umount logs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20170518100804.25538-1-anand.jain@oracle.com>
 <20170518173947.GA4505@birch.djwong.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, quwenruo@cn.fujitsu.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cdc5185c-f69e-d296-99c8-b2af64d99833@oracle.com>
Date: Fri, 19 May 2017 08:17:55 +0800
MIME-Version: 1.0
In-Reply-To: <20170518173947.GA4505@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/19/2017 01:39 AM, Darrick J. Wong wrote:
> On Thu, May 18, 2017 at 06:08:04PM +0800, Anand Jain wrote:
>> By looking at the logs we should be able to know when was the FS
>> mounted and unmounted and the options used, so to help forensic
>> investigations.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> You may want to know that, during boot and shutdown this
>> adds roughly 25 lines more logs depending on the config, and it
>> logs even for non block device FS, such as proc, sysfs ..etc.
>> And blockdev FS only check will eliminate overlay as well, which
>> is kind of defeats the purpose.
>> Further, just to highlight if your test script involves mount and
>> umount, which probably all of fstests does, it will add logs when
>> FS is mounted and umounted.
>> Still IMO, these logs are useful for the end purpose as mentioned
>> above. Its for your feedback. Thanks.
>
> XFS already logs its own unmounts.

  Nice. as far as I know its only in XFS.

>  I prefer to let each filesystem log
> its own unmount, because then the mount/unmount messages also have the
> same prefix as all other messages coming from that filesystem driver.

  Ok. One nitpick though there are other mount types (remount, bind..),
  and subsequent mounts of the same FS and FS driver can't log them
  effectively.

>>  fs/namespace.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index b3b115bd4e1e..78375b6f8330 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -1686,6 +1686,8 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
>>  	struct mount *mnt;
>>  	int retval;
>>  	int lookup_flags = 0;
>> +	struct super_block *sb;
>> +	char umntlog[256] = {0};
>
> Kind of a lot of stack space...

   oh ok. Will fix it, if we are ok to add this change at namespace.c

Thanks, Anand


> --D
>
>>
>>  	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
>>  		return -EINVAL;
>> @@ -1711,7 +1713,15 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
>>  	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
>>  		goto dput_and_out;
>>
>> +	sb = mnt->mnt.mnt_sb;
>> +	snprintf(umntlog, sizeof(umntlog), "umount %s dev:%s flags:%d",
>> +		sb->s_type->name, sb->s_id, flags);
>> +
>>  	retval = do_umount(mnt, flags);
>> +
>> +	if (!retval)
>> +		printk(KERN_NOTICE "%s\n", umntlog);
>> +
>>  dput_and_out:
>>  	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
>>  	dput(path.dentry);
>> @@ -2833,6 +2843,11 @@ long do_mount(const char *dev_name, const char __user *dir_name,
>>  	else
>>  		retval = do_new_mount(&path, type_page, flags, mnt_flags,
>>  				      dev_name, data_page);
>> +
>> +	if (!retval)
>> +		printk(KERN_NOTICE "mount %s dev:%s dir:%pd flags:0x%lX opt:%s\n",
>> +			type_page, dev_name, path.dentry, flags, (char *)data_page);
>> +
>>  dput_out:
>>  	path_put(&path);
>>  	return retval;
>> --
>> 2.10.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
