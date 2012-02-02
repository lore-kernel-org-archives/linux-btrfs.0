From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs: allow cloning ranges within the same file
Date: Thu, 02 Feb 2012 22:07:20 +0100
Message-ID: <4F2AFB08.2040307@jan-o-sch.net>
References: <4F265F78.1010806@cn.fujitsu.com> <4F26693F.2010705@jan-o-sch.net> <4F29071D.7020609@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F29071D.7020609@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01.02.2012 10:34, Li Zefan wrote:
>>> It's safe and easy to do so, provided the ranges don't overlap.
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/ioctl.c |   23 ++++++++++++++++-------
>>>  1 files changed, 16 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 0b06a5c..8fcd671 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -2223,8 +2223,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>>  	 *   decompress into destination's address_space (the file offset
>>>  	 *   may change, so source mapping won't do), then recompress (or
>>>  	 *   otherwise reinsert) a subrange.
>>> -	 * - allow ranges within the same file to be cloned (provided
>>> -	 *   they don't overlap)?
>>>  	 */
>>>  
>>>  	/* the destination must be opened for writing */
>>> @@ -2247,8 +2245,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>>  	src = src_file->f_dentry->d_inode;
>>>  
>>>  	ret = -EINVAL;
>>> -	if (src == inode)
>>> -		goto out_fput;
>>>  
>>>  	/* the src must be open for reading */
>>>  	if (!(src_file->f_mode & FMODE_READ))
>>> @@ -2282,9 +2278,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>>  	if (inode < src) {
>>>  		mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
>>>  		mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
>>> -	} else {
>>> +	} else if (inode > src) {
>>>  		mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
>>>  		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
>>> +	} else {
>>> +		mutex_lock(&inode->i_mutex);
>>>  	}
>>>  
>>>  	/* determine range to clone */
>>> @@ -2302,6 +2300,13 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>>  	    !IS_ALIGNED(destoff, bs))
>>>  		goto out_unlock;
>>>  
>>> +	/*
>>> +	 * allow ranges within the same file to be cloned only if
>>> +	 * they don't overlap
>>> +	 */
>>> +	if (src == inode && !(off + len <= destoff || destoff + len <= off))
>>             ^^^^^^^^^^^^
>> ... this check isn't sufficient. Two different inodes can reference the
>> same data extent and we must prevent overlap cloning there as well.
>>
> 
> Could you be more elaborate on this? I don't know what's the problem
> you're refering to.

I'll try to rephrase:

Why do you disallow cloning ranges within the same file if they overlap?
For me, it would be because I've got fear of the headache that occurred
if I thought about cloning 80k at offset 16k to the offset 8k.

Original file, let's say, single extent, 128k in size
+-------------------------------------------------------+
|        |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|           |
+-------------------------------------------------------+
         ^                                  ^           ^
         16k                                96k         128k

What should happen when you clone the said x-range to offset 8k in the
same file? I think, we can find a solution for this and thus allow
cloning even overlapping ranges within the same file (perhaps at the
expense of a headache).

However, if there is no good (agreed) solution for this scenario, I'm
saying that we can't solve it for two files (inodes) both referring to
the above extent, either.

I'm not sure if my example is helping to illustrate my point. If not,
could you please give an example file with an example clone command with
overlapping ranges that you believe should fail with EINVAL? I could
make my point clearer when building on top of your example, I hope :-)

Thanks,
-Jan
