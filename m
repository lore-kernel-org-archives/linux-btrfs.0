Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:42178 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760808AbdLSGFj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 01:05:39 -0500
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1BF4CAC00FF
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 15:05:32 +0900 (JST)
Subject: Re: [PATCH] btrfs: Fix memory leak on multiple mounts
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1513591426-2349-1-git-send-email-nborisov@suse.com>
 <37bc650d-a3d9-f626-7670-2550a0eb4c64@suse.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <9e3a2939-833a-8fef-1097-0fa8578fcf1d@jp.fujitsu.com>
Date: Tue, 19 Dec 2017 15:05:04 +0900
MIME-Version: 1.0
In-Reply-To: <37bc650d-a3d9-f626-7670-2550a0eb4c64@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

On 2017/12/18 19:06, Nikolay Borisov wrote:
> 
> 
> On 18.12.2017 12:03, Nikolay Borisov wrote:
>> Currently if a mounted-btrfs instance is mounted for the 2nd time
>> without first unmounting the first instance then we hit a memory leak
>> in btrfs_mount_root due to the fs_info of the acquired superblock is
>> different than the newly allocated fs info. Fix this by specifically
>> checking if the fs_info instance of the newly acquired superblock is
>> the same as ours and free it if not.
>>
>> Reproducer:
>>
>> mount /dev/vdc /media/scratch
>> mount /dev/vdc /media/scratch2 <- memory leak hit
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> This one fixes:
> 
> 4da82a9e60a1 btrfs: add btrfs_mount_root() and new file_system_type
> 
> Which seems to be in for-next only.

The patch doesn't change the logic here (same as current btrfs_mount()).

> 
>> ---
>>  fs/btrfs/super.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index e57eb6e70278..ea3bca85be44 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1612,7 +1612,11 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>>  		goto error_sec_opts;
>>  	}
>>  
>> -	fs_info = btrfs_sb(s);
>> +	if (btrfs_sb(s) != fs_info) {
>> +		free_fs_info(fs_info);
>> +		fs_info = btrfs_sb(s);
>> +	}
>> +
>>  	error = setup_security_options(fs_info, s, &new_sec_opts);
>>  	if (error) {
>>  		deactivate_locked_super(s);
>>

I'm not sure how the memory leak happens.
Just above this line is:

---
 if (s->s_root) {
   btrfs_close_devices(fs_devices);
   free_fs_info(fs_info);
   if ((flags ^ s->s_flags) & SB_RDONLY)
     error = -EBUSY;
 } else {
   snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
   btrfs_sb(s)->bdev_holder = fs_type;
   error = btrfs_fill_super(s, fs_devices, data);
 }
---

In the first mount, s->s_root is null and btrfs_fill_super() is called.
On the other hand, in the second mount, s->s_root is not null and fs_info is freed there.

So, I think there is no memory leak in the current code, or am I missing something? 

Regards,
Tomohiro

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

