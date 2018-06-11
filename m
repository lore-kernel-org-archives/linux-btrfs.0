Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56815 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933579AbeFKRk6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 13:40:58 -0400
Date: Mon, 11 Jun 2018 19:38:05 +0200
From: David Sterba <dsterba@suse.cz>
To: syzbot <syzbot+abf707d7ccbb3244f34e@syzkaller.appspotmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        linux-btrfs@vger.kernel.org
Subject: Re: KASAN: use-after-free Read in getname_kernel
Message-ID: <20180611173805.wx2varcyneqrvvsp@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <00000000000037c4d2056e5740c3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <00000000000037c4d2056e5740c3@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 10, 2018 at 10:45:02PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    3ca24ce9ff76 Merge branch 'proc-cmdline'
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ed37d7800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=314f2150f36c16ca
> dashboard link: https://syzkaller.appspot.com/bug?extid=abf707d7ccbb3244f34e
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+abf707d7ccbb3244f34e@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in memcpy include/linux/string.h:345 [inline]
> BUG: KASAN: use-after-free in getname_kernel+0x123/0x370 fs/namei.c:241
> Read of size 11 at addr ffff8801d8053310 by task syz-executor5/15925
> 
> CPU: 0 PID: 15925 Comm: syz-executor5 Not tainted 4.17.0+ #94
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>  print_address_description+0x6c/0x20b mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
>  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
>  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
>  memcpy+0x23/0x50 mm/kasan/kasan.c:302
>  memcpy include/linux/string.h:345 [inline]
>  getname_kernel+0x123/0x370 fs/namei.c:241
>  kern_path+0x1e/0x40 fs/namei.c:2410
>  lookup_bdev+0xfa/0x240 fs/block_dev.c:2084
>  blkdev_get_by_path+0x1f/0xe0 fs/block_dev.c:1687
>  btrfs_get_bdev_and_sb+0x38/0x300 fs/btrfs/volumes.c:392
>  btrfs_open_one_device fs/btrfs/volumes.c:695 [inline]
>  open_fs_devices+0x6a5/0xc60 fs/btrfs/volumes.c:1112
>  btrfs_open_devices+0xc0/0xd0 fs/btrfs/volumes.c:1155

I think it's another manifestation of the bug syzbot reported against
btrfs_open_devices

https://lkml.kernel.org/r/000000000000832e70056df8fb38@google.com

Currently proposed fix is to revert
542c5908abfe84f7b4c1717492ecc92ea0ea328d, that's going to be merged post
rc1.
