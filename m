Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932842AbdLSGWu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 01:22:50 -0500
Subject: Re: [PATCH] btrfs: Fix memory leak on multiple mounts
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1513591426-2349-1-git-send-email-nborisov@suse.com>
 <37bc650d-a3d9-f626-7670-2550a0eb4c64@suse.com>
 <9e3a2939-833a-8fef-1097-0fa8578fcf1d@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <87af5f39-53db-4e51-9695-3d389bece59a@suse.com>
Date: Tue, 19 Dec 2017 08:22:48 +0200
MIME-Version: 1.0
In-Reply-To: <9e3a2939-833a-8fef-1097-0fa8578fcf1d@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.12.2017 08:05, Misono, Tomohiro wrote:
> Hello, 
> 
> On 2017/12/18 19:06, Nikolay Borisov wrote:
>>
>>
>> On 18.12.2017 12:03, Nikolay Borisov wrote:
>>> Currently if a mounted-btrfs instance is mounted for the 2nd time
>>> without first unmounting the first instance then we hit a memory leak
>>> in btrfs_mount_root due to the fs_info of the acquired superblock is
>>> different than the newly allocated fs info. Fix this by specifically
>>> checking if the fs_info instance of the newly acquired superblock is
>>> the same as ours and free it if not.
>>>
>>> Reproducer:
>>>
>>> mount /dev/vdc /media/scratch
>>> mount /dev/vdc /media/scratch2 <- memory leak hit
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>
>> This one fixes:
>>
>> 4da82a9e60a1 btrfs: add btrfs_mount_root() and new file_system_type
>>
>> Which seems to be in for-next only.
> 
> The patch doesn't change the logic here (same as current btrfs_mount()).
> 
>>
>>> ---
>>>  fs/btrfs/super.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>> index e57eb6e70278..ea3bca85be44 100644
>>> --- a/fs/btrfs/super.c
>>> +++ b/fs/btrfs/super.c
>>> @@ -1612,7 +1612,11 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>>>  		goto error_sec_opts;
>>>  	}
>>>  
>>> -	fs_info = btrfs_sb(s);
>>> +	if (btrfs_sb(s) != fs_info) {
>>> +		free_fs_info(fs_info);
>>> +		fs_info = btrfs_sb(s);
>>> +	}
>>> +
>>>  	error = setup_security_options(fs_info, s, &new_sec_opts);
>>>  	if (error) {
>>>  		deactivate_locked_super(s);
>>>
> 
> I'm not sure how the memory leak happens.
> Just above this line is:
> 
> ---
>  if (s->s_root) {
>    btrfs_close_devices(fs_devices);
>    free_fs_info(fs_info);
>    if ((flags ^ s->s_flags) & SB_RDONLY)
>      error = -EBUSY;
>  } else {
>    snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
>    btrfs_sb(s)->bdev_holder = fs_type;
>    error = btrfs_fill_super(s, fs_devices, data);
>  }
> ---
> 
> In the first mount, s->s_root is null and btrfs_fill_super() is called.
> On the other hand, in the second mount, s->s_root is not null and fs_info is freed there.
> 
> So, I think there is no memory leak in the current code, or am I missing something? 

Hm, you are right, I've missed that, so disregard this patch.
> 
> Regards,
> Tomohiro
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
