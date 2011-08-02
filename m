From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: skip looking for delalloc if we don't have ->fill_delalloc
Date: Tue, 02 Aug 2011 09:43:43 +0800
Message-ID: <4E37564F.1040902@cn.fujitsu.com>
References: <1312215076-10329-1-git-send-email-josef@redhat.com> <4E3753AD.4010606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E3753AD.4010606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2011 09:32 AM, liubo wrote:
> On 08/02/2011 12:11 AM, Josef Bacik wrote:
>> We always look for delalloc bytes in our io_tree so we can fill in delalloc.
>> This is fine in most cases, but if we're writing out the btree_inode this is
>> just a superfluous tree search on the io_tree, and if we have a lot of metadata
>> dirty this could be an expensive check.  So instead check to see if our io_tree
>> has a ->fill_delalloc op, and if not don't even bother doing the lookup.
>> Thanks,
>>
>> Signed-off-by: Josef Bacik <josef@redhat.com>
>> ---
> 

sorry, I mixed the patch with others...

The patch is ok.

> With the patch,
> 
> mkfs.btrfs /dev/sda15
> mount /dev/sda15 /mnt/btrfs
> dd if=/dev/zero of=/mnt/btrfs/tmp bs=1G
> 
> then it comes the following bug:
> 
> Btrfs loaded
> device fsid 91d23288-d352-4346-979f-d6f93cac04a3 devid 1 transid 7 /dev/sda15
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/inode.c:1583!
> ...
> Call Trace:
>  [<ffffffffa05b00d8>] worker_loop+0x138/0x510 [btrfs]
>  [<ffffffffa05affa0>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
>  [<ffffffffa05affa0>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
>  [<ffffffff81074f06>] kthread+0x96/0xa0
>  [<ffffffff81467bf4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81074e70>] ? kthread_worker_fn+0x1a0/0x1a0
>  [<ffffffff81467bf0>] ? gs_change+0xb/0xb
> Code: e0 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f c9 c3 48 8b 7d b8 48 8d 4d c8 41 b8 50 00 00 00 4c 89 fa 4c 89 e6 e8 19 cf 01 00 eb bd <0f> 0b eb fe 48 89 df e8 1b 48 b6 e0 eb 9d 66 0f 1f 84 00 00 00 
> RIP  [<ffffffffa0587f59>] btrfs_writepage_fixup_worker+0x139/0x150 [btrfs]
>  RSP <ffff88000887bdd0>
> ---[ end trace 5089b598ce74fcfc ]---
> 
> thanks,
> liubo
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

