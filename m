Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30354 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3F1NHt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 09:07:49 -0400
Message-ID: <51CD8AA5.4050307@oracle.com>
Date: Fri, 28 Jun 2013 21:07:49 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        david@fromorbit.com
Subject: Re: [PATCH] btrfs: fix file truncation if FALLOC_FL_KEEP_SIZE is
 specified
References: <51CD1C08.40801@oracle.com> <20130628124100.GU4288@localhost.localdomain>
In-Reply-To: <20130628124100.GU4288@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/28/2013 08:41 PM, Josef Bacik wrote:

> On Fri, Jun 28, 2013 at 01:15:52PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Create a small file and fallocate it to a big size with
>> FALLOC_FL_KEEP_SIZE option, then truncate it back to the
>> small size again, the disk free space is not changed back
>> in this case. i.e,
>>
>> # dd if=/dev/zero of=/mnt/test bs=512 count=1
>> # ls -l /mnt
>> total 4
>> -rw-r--r-- 1 root root 512 Jun 28 11:35 test
>>
>> # df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> ....
>> /dev/sdb1       8.0G   56K  7.2G   1% /mnt
>>
>> # xfs_io -c 'falloc -k 512 5G' /mnt/test 
>> # ls -l /mnt/test
>> -rw-r--r-- 1 root root 512 Jun 28 11:35 /mnt/test
>>
>> # sync; df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> ....
>> /dev/sdb1       8.0G  5.1G  2.2G  70% /mnt
>>
>> # xfs_io -c 'truncate 512' /mnt/test
>> # sync; df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> ....
>> /dev/sdb1       8.0G  5.1G  2.2G  70% /mnt
>>
>> With this fix, the truncated up space is back as:
>> # sync; df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> ....
>> /dev/sdb1       8.0G   56K  7.2G   1% /mnt
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/btrfs/inode.c |    3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 4f9d16b..7e1a5ff 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4509,9 +4509,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>>  	int mask = attr->ia_valid;
>>  	int ret;
>>  
>> -	if (newsize == oldsize)
>> -		return 0;
>> -
>>  	/*
>>  	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
>>  	 * special case where we need to update the times despite not having
> 
> Cc'ing a few people on this since I'd like their opinion.  Looking at other fs's
> it looks like ext4 does the same thing we do and would leave the prealloc'ed
> space, but it appears that xfs will truncate it.  What do we think is the
> correct behavior?  I'm inclined to take this patch, but I'd like to have an
> xfstest made for it so other file systems can be made to be consistent, and I'd
> like to make sure we all agree what is the correct behavior before we wander
> down that road.  Thanks,

Looks Ext4 does the same thing to XFS in this case :), but OCFS2 does not.
I'd like to write a test case for xfstest if we reach an agreement.

Thanks,
-Jeff


