From: Josef Bacik <josef@redhat.com>
Subject: Re: Possible race in btrfs
Date: Wed, 24 Mar 2010 09:47:26 -0400
Message-ID: <20100324094726.4ba8f77f@redhat.com>
References: <3d81e70e1003232120t14ba6eaw54f73c939bfab391@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Abhinav Duggal <abhinavduggal@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d81e70e1003232120t14ba6eaw54f73c939bfab391@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 24 Mar 2010 00:20:25 -0400
Abhinav Duggal <abhinavduggal@gmail.com> wrote:

> Hi all,
> It seems like there is a possible race on delalloc_bytes in  btrfs in
> kernel 2.6.33.Please examine this issue and let me know if this is a
> problem or not.The race could occur between stat system call and
> writeback kernel thread.
> The lines are
> fs/btrfs/inode.c 5422
> fs/btrfs/inode.c 1378
> 
> The stack traces are
> 
> For file line fs/btrfs/inode.c 5422
> 
>   btrfs_getattr+0x141/0x15e
>   vfs_getattr+0x47/0xf4
>   vfs_fstatat+0x43/0x5a
>   vfs_stat+0x16/0x18
>   sys_newstat+0x3d/0x75
>   system_call_fastpath+0x16/0x1b
> 
> And for file line fs/btrfs/inode.c 1378
> 
>   btrfs_clear_bit_hook+0xcc1/0x10f2
>   clear_state_bit+0x4db/0xa89
>   clear_extent_bit+0x9e1/0xc86
>   extent_clear_unlock_delalloc+0x8c/0x1d8
>   cow_file_range+0x1356/0x1432
>   run_delalloc_range+0x263/0x1702
>   __extent_writepage+0x2c4/0x15a8
>   extent_write_cache_pages.clone.0+0x211/0x33d
>   extent_writepages+0x243/0x260
>   btrfs_writepages+0x87/0x92
>   do_writepages+0x1c/0x25
>   writeback_single_inode+0xe2/0x24c
>   writeback_inodes_wb+0x374/0x48d
>   wb_writeback+0x121/0x1f6
>   wb_do_writeback+0x147/0x159
>   bdi_writeback_task+0x3a/0xaa
>   bdi_start_fn+0x63/0xc7
>   kthread+0x7a/0x82
>   kernel_thread_helper+0x4/0x10
> 
> The write to delalloc_bytes in  the function btrfs_clear_bit_hook is
> protected by the spin_lock delalloc_lock whereas the read is not.The
> write is not atomic so the read could return some old value.
> 
> I am not sure what would be the implication of this?Is it ok if stat
> system call returns some value which is not consistent with rest of
> the fields? If not then is it better to make this field as atomic_t?
> I am looking for data races in btrfs and I discovered this using some
> kind of dynamic analysis.
> Thanks a lot.
> 

Yeah you could race, but its getattr.  We could add the locking, but its a
global lock, and its just to tell the user how big the file is, so its not
terribly important.  I think it's worth the tradeoff for a little possible
inaccuracy vs. creating more lock contention.  Thanks,

Josef
