From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: allow cloning ranges within the same file
Date: Wed, 01 Feb 2012 17:34:21 +0800
Message-ID: <4F29071D.7020609@cn.fujitsu.com>
References: <4F265F78.1010806@cn.fujitsu.com> <4F26693F.2010705@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F26693F.2010705@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

>> It's safe and easy to do so, provided the ranges don't overlap.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c |   23 ++++++++++++++++-------
>>  1 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 0b06a5c..8fcd671 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2223,8 +2223,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>  	 *   decompress into destination's address_space (the file offset
>>  	 *   may change, so source mapping won't do), then recompress (or
>>  	 *   otherwise reinsert) a subrange.
>> -	 * - allow ranges within the same file to be cloned (provided
>> -	 *   they don't overlap)?
>>  	 */
>>  
>>  	/* the destination must be opened for writing */
>> @@ -2247,8 +2245,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>  	src = src_file->f_dentry->d_inode;
>>  
>>  	ret = -EINVAL;
>> -	if (src == inode)
>> -		goto out_fput;
>>  
>>  	/* the src must be open for reading */
>>  	if (!(src_file->f_mode & FMODE_READ))
>> @@ -2282,9 +2278,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>  	if (inode < src) {
>>  		mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
>>  		mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
>> -	} else {
>> +	} else if (inode > src) {
>>  		mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
>>  		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
>> +	} else {
>> +		mutex_lock(&inode->i_mutex);
>>  	}
>>  
>>  	/* determine range to clone */
>> @@ -2302,6 +2300,13 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>  	    !IS_ALIGNED(destoff, bs))
>>  		goto out_unlock;
>>  
>> +	/*
>> +	 * allow ranges within the same file to be cloned only if
>> +	 * they don't overlap
>> +	 */
>> +	if (src == inode && !(off + len <= destoff || destoff + len <= off))
>             ^^^^^^^^^^^^
> ... this check isn't sufficient. Two different inodes can reference the
> same data extent and we must prevent overlap cloning there as well.
> 

Could you be more elaborate on this? I don't know what's the problem
you're refering to.
