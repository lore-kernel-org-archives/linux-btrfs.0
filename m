Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759109Ab2JYB7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 21:59:37 -0400
Message-ID: <50889D1D.2050609@cn.fujitsu.com>
Date: Thu, 25 Oct 2012 09:59:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: don't check the permission of the subvolume
 which we want to delete
References: <50853040.1030404@cn.fujitsu.com> <50857BA2.90403@gmail.com>
In-Reply-To: <50857BA2.90403@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 22 Oct 2012 19:00:18 +0200, Goffredo Baroncelli wrote:
> On 2012-10-22 13:38, Miao Xie wrote:
>> Step to reproduce:
>>  # mkfs.btrfs <disk>
>>  # mount -o user_subvol_rm_allowed <disk> <mnt>
>>  # mkdir <mnt>/dir0
>>  # chmod 777 <mnt>/dir0
>>  # btrfs sub snap <mnt> <mnt>/dir0/snap0
>>  # su -c "btrfs sub del <mnt>/dir0/snap0" -s /bin/bash nobody
>>  ERROR: cannot delete '<mnt>/dir0/snap0' - Permission denied
>>
>> This is because we checked the permission of the subvolume that we want to
>> delete, and found the user - nobody have no WRITE permission of this subvolume.
>>
>> I think we need not check the permission of the subvolume we want to delete,
>> because we have the right to clean up the directory since we have WRITE and
>> EXECUTE permission, just like rmdir command.
> 
> I think that removing a subvolume is a bit different than removing a
> directory.
> With "user_subvol_rm_allowed" allow an ordinary user to remove  things
> that an plain "rm -rf" is not allowed.
> 
> For example if inside a directories tree there is a directory with
> permission 700 (uid==root) an ordinary user is not able to remove this
> directory.
> Instead with the subvolumes (and the flag user_subvol_rm_allowed) an
> ordinary user would be allowed to do it.
> As mitigation it is required that user has WX permission on subvolume.
> IIRC this is what we discussed at time.
> 
> See the thread "[PATCH] Btrfs: allow subvol deletion by unprivileged
> user with -o user_subvol_rm_allowed"
> 
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06525.html

I don't think this mitigation is reasonable, it will make the user be
confused. As I said in another mail:

>> I don't think we can identify "btrfs sub del" with "rm -rf", because "rm -rf"
>> will check the permission of the parent directory of each file/directory which
>> is going to be deleted, but "btrfs sub del" doesn't do it, it will see all the
>> file/directory in the subvolume as one, so I think it seems like a special
>> "rmdir".

So I think we needn't the permission of the subvolume which is going to be deleted.

Thanks
Miao

> 
> 
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index f5a2e6c..29fb07c 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2062,10 +2062,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>>  		if (root == dest)
>>  			goto out_dput;
>>  
>> -		err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
>> -		if (err)
>> -			goto out_dput;
>> -
>>  		/* check if subvolume may be deleted by a non-root user */
>>  		err = btrfs_may_delete(dir, dentry, 1);
>>  		if (err)
> 
> 


