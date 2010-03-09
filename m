From: Philip Love <love_phil@emc.com>
Subject: Re: btrfs bug while defragmenting
Date: Tue, 9 Mar 2010 12:25:45 -0800
Message-ID: <D45A73CF-84B9-4814-970F-4CA4B66AE957@emc.com>
References: <D09C8589-EA52-4778-8B29-1B06B27292D0@emc.com> <20100309192516.GQ15485@think> <B908B307-41C6-4F40-BD6B-451FDD32EF8B@emc.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B908B307-41C6-4F40-BD6B-451FDD32EF8B@emc.com>
List-ID: <linux-btrfs.vger.kernel.org>


> I reproduced it again. The fs is idle apart from the defragment.
> 
> mount -o nodatacow /dev/sdc1 backend
> btrfsctl -d /mnt/backend/phil/i2
> 
This time I just mounted normally, please let me know what additional debug info you need.
Thanks
Phil


mount /dev/sdc1 /mnt/backend
btrfsctl -d /mnt/backend/phil/i2

Mar  9 12:20:31 sentryA kernel: [  825.831962] Btrfs loaded
Mar  9 12:20:31 sentryA kernel: [  825.832473] device fsid 7c44381c3f903d28-e68bbb009cd0dfa2 devid 1 transid 917 /dev/sdc1
Mar  9 12:21:27 sentryA sshd[3693]: Accepted keyboard-interactive/pam for phil from 128.222.177.177 port 34776 ssh2
Mar  9 12:22:01 sentryA kernel: [  916.058338] BUG: Bad page state in process btrfsctl  pfn:27d407
Mar  9 12:22:01 sentryA kernel: [  916.058342] page:ffffea0008b66188 flags:0040000000000000 count:0 mapcount:0 mapping:ffffffffa01
d798f index:0
Mar  9 12:22:01 sentryA kernel: [  916.058346] Pid: 3673, comm: btrfsctl Not tainted 2.6.33-5-default #1
Mar  9 12:22:01 sentryA kernel: [  916.058348] Call Trace:
Mar  9 12:22:01 sentryA kernel: [  916.058355]  [<ffffffff810a2ddd>] bad_page+0x106/0x118
Mar  9 12:22:01 sentryA kernel: [  916.058359]  [<ffffffff810a4fb2>] get_page_from_freelist+0x49e/0x707
Mar  9 12:22:01 sentryA kernel: [  916.058363]  [<ffffffff810a542e>] __alloc_pages_nodemask+0x123/0x64d
Mar  9 12:22:01 sentryA kernel: [  916.058368]  [<ffffffff81024aa2>] ? enqueue_task+0x5b/0x66
Mar  9 12:22:01 sentryA kernel: [  916.058372]  [<ffffffff81029c3e>] ? task_rq_lock+0x39/0x6b
Mar  9 12:22:01 sentryA kernel: [  916.058376]  [<ffffffff8119cb0c>] ? prop_fraction_single+0x3c/0x5e
Mar  9 12:22:01 sentryA kernel: [  916.058380]  [<ffffffff810c9210>] alloc_pages_current+0x96/0x9f
Mar  9 12:22:01 sentryA kernel: [  916.058384]  [<ffffffff8109f60e>] __page_cache_alloc+0x59/0x5d
Mar  9 12:22:01 sentryA kernel: [  916.058387]  [<ffffffff810a6e3a>] __do_page_cache_readahead+0x96/0x1a2
Mar  9 12:22:01 sentryA kernel: [  916.058390]  [<ffffffff810a6f62>] ra_submit+0x1c/0x20
Mar  9 12:22:01 sentryA kernel: [  916.058393]  [<ffffffff810a71f2>] ondemand_readahead+0x1b2/0x1c5
Mar  9 12:22:01 sentryA kernel: [  916.058396]  [<ffffffff810a72be>] page_cache_sync_readahead+0x17/0x19
Mar  9 12:22:01 sentryA kernel: [  916.058412]  [<ffffffffa02f01e1>] btrfs_force_ra+0x1c/0x25 [btrfs]
Mar  9 12:22:01 sentryA kernel: [  916.058424]  [<ffffffffa03133a3>] btrfs_ioctl+0x558/0x959 [btrfs]
Mar  9 12:22:01 sentryA kernel: [  916.058428]  [<ffffffff810e26e4>] vfs_ioctl+0x2a/0x9e
Mar  9 12:22:01 sentryA kernel: [  916.058431]  [<ffffffff810e2c15>] do_vfs_ioctl+0x442/0x47f
Mar  9 12:22:01 sentryA kernel: [  916.058434]  [<ffffffff8119e5e7>] ? __up_read+0x9e/0xa7
Mar  9 12:22:01 sentryA kernel: [  916.058437]  [<ffffffff810568fb>] ? up_read+0x9/0xb
Mar  9 12:22:01 sentryA kernel: [  916.058440]  [<ffffffff810e2ca7>] sys_ioctl+0x55/0x77
Mar  9 12:22:01 sentryA kernel: [  916.058444]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b



