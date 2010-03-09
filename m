From: Philip Love <Love_Phil@emc.com>
Subject: btrfs bug while defragmenting
Date: Tue, 9 Mar 2010 10:45:13 -0800
Message-ID: <D09C8589-EA52-4778-8B29-1B06B27292D0@emc.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had some 10gb files that I was using for random write testing (with cow enabled). I remount the fs with nodatacow, then ran btrfsctl to defragement the file. A BUG message appeared in the messages file. After a reboot btrfsck gave no errors.

Please let me know what extra information you need.
Thanks
Phil

Mar  9 10:12:25 sentryA kernel: [66771.230266] BUG: Bad page state in process btrfsctl  pfn:201575
Mar  9 10:12:25 sentryA kernel: [66771.230270] page:ffffea000704b198 flags:0040000000000000 count:-1608652401 mapcount:0 mapping:ffff88002e84b000 index:ffffc90002633d40
Mar  9 10:12:25 sentryA kernel: [66771.230274] Pid: 6734, comm: btrfsctl Not tainted 2.6.33-5-default #1
Mar  9 10:12:25 sentryA kernel: [66771.230276] Call Trace:
Mar  9 10:12:25 sentryA kernel: [66771.230283]  [<ffffffff810a2ddd>] bad_page+0x106/0x118
Mar  9 10:12:25 sentryA kernel: [66771.230287]  [<ffffffff810a4fb2>] get_page_from_freelist+0x49e/0x707
Mar  9 10:12:25 sentryA kernel: [66771.230291]  [<ffffffff810a542e>] __alloc_pages_nodemask+0x123/0x64d
Mar  9 10:12:25 sentryA kernel: [66771.230307]  [<ffffffffa0310c36>] ? extent_readpages+0x16e/0x197 [btrfs]
Mar  9 10:12:25 sentryA kernel: [66771.230313]  [<ffffffff81085d9a>] ? delayacct_end+0x78/0x83
Mar  9 10:12:25 sentryA kernel: [66771.230316]  [<ffffffff810c9210>] alloc_pages_current+0x96/0x9f
Mar  9 10:12:25 sentryA kernel: [66771.230320]  [<ffffffff8109f60e>] __page_cache_alloc+0x59/0x5d
Mar  9 10:12:25 sentryA kernel: [66771.230323]  [<ffffffff810a6e3a>] __do_page_cache_readahead+0x96/0x1a2
Mar  9 10:12:25 sentryA kernel: [66771.230327]  [<ffffffff810a6f62>] ra_submit+0x1c/0x20
Mar  9 10:12:25 sentryA kernel: [66771.230329]  [<ffffffff810a71f2>] ondemand_readahead+0x1b2/0x1c5
Mar  9 10:12:25 sentryA kernel: [66771.230333]  [<ffffffff810a72be>] page_cache_sync_readahead+0x17/0x19
Mar  9 10:12:25 sentryA kernel: [66771.230345]  [<ffffffffa02f71e1>] btrfs_force_ra+0x1c/0x25 [btrfs]
Mar  9 10:12:25 sentryA kernel: [66771.230357]  [<ffffffffa031a3a3>] btrfs_ioctl+0x558/0x959 [btrfs]
Mar  9 10:12:25 sentryA kernel: [66771.230361]  [<ffffffff810e26e4>] vfs_ioctl+0x2a/0x9e
Mar  9 10:12:25 sentryA kernel: [66771.230363]  [<ffffffff810e2c15>] do_vfs_ioctl+0x442/0x47f
Mar  9 10:12:25 sentryA kernel: [66771.230367]  [<ffffffff8119e5e7>] ? __up_read+0x9e/0xa7
Mar  9 10:12:25 sentryA kernel: [66771.230370]  [<ffffffff810568fb>] ? up_read+0x9/0xb
Mar  9 10:12:25 sentryA kernel: [66771.230373]  [<ffffffff810e2ca7>] sys_ioctl+0x55/0x77
Mar  9 10:12:29 sentryA kernel: [66771.230377]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b


