Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:45502 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937229AbcJVPUn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Oct 2016 11:20:43 -0400
Date: Sat, 22 Oct 2016 11:20:33 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
References: <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 21, 2016 at 04:02:45PM -0400, Dave Jones wrote:

 >  > It could be worth trying this, too:
 >  > 
 >  > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=174531fef4e8
 >  > 
 >  > It occurred to me that the current code is a little bit fragile.
 > 
 > It's been nearly 24hrs with the above changes, and it's been pretty much
 > silent the whole time.
 > 
 > The only thing of note over that time period has been a btrfs lockdep
 > warning that's been around for a while, and occasional btrfs checksum
 > failures, which I've been seeing for a while, but seem to have gotten
 > worse since 4.8.
 > 
 > I'm pretty confident in the disk being ok in this machine, so I think
 > the checksum warnings are bogus.  Chris suggested they may be the result
 > of memory corruption, but there's little else going on.

The only interesting thing last nights run was this..

BUG: Bad page state in process kworker/u8:1  pfn:4e2b70
page:ffffea00138adc00 count:0 mapcount:0 mapping:ffff88046e9fc2e0 index:0xdf0
flags: 0x400000000000000c(referenced|uptodate)
page dumped because: non-NULL mapping
CPU: 3 PID: 24234 Comm: kworker/u8:1 Not tainted 4.9.0-rc1-think+ #11 
Workqueue: writeback wb_workfn (flush-btrfs-2)
 ffffc90001f97828
 ffffffff8130d07c
 ffffea00138adc00
 ffffffff819ff524
 ffffc90001f97850
 ffffffff8115117f
 0000000000000000
 ffffea00138adc00
 400000000000000c
 ffffc90001f97860
 ffffffff8115123a
 ffffc90001f978a8
Call Trace:
 [<ffffffff8130d07c>] dump_stack+0x4f/0x73
 [<ffffffff8115117f>] bad_page+0xbf/0x120
 [<ffffffff8115123a>] free_pages_check_bad+0x5a/0x70
 [<ffffffff81153b38>] free_hot_cold_page+0x248/0x290
 [<ffffffff81153e3b>] free_hot_cold_page_list+0x2b/0x50
 [<ffffffff8115c84d>] release_pages+0x2bd/0x350
 [<ffffffff8115dd82>] __pagevec_release+0x22/0x30
 [<ffffffffa009cd4e>] extent_write_cache_pages.isra.48.constprop.63+0x32e/0x400 [btrfs]
 [<ffffffffa009d199>] extent_writepages+0x49/0x60 [btrfs]
 [<ffffffffa007d840>] ? btrfs_releasepage+0x40/0x40 [btrfs]
 [<ffffffffa007a993>] btrfs_writepages+0x23/0x30 [btrfs]
 [<ffffffff8115af6c>] do_writepages+0x1c/0x30
 [<ffffffff811f6d33>] __writeback_single_inode+0x33/0x180
 [<ffffffff811f7528>] writeback_sb_inodes+0x2a8/0x5b0
 [<ffffffff811f78bd>] __writeback_inodes_wb+0x8d/0xc0
 [<ffffffff811f7b73>] wb_writeback+0x1e3/0x1f0
 [<ffffffff811f80b2>] wb_workfn+0xd2/0x280
 [<ffffffff81090875>] process_one_work+0x1d5/0x490
 [<ffffffff81090815>] ? process_one_work+0x175/0x490
 [<ffffffff81090b79>] worker_thread+0x49/0x490
 [<ffffffff81090b30>] ? process_one_work+0x490/0x490
 [<ffffffff81095cee>] kthread+0xee/0x110
 [<ffffffff81095c00>] ? kthread_park+0x60/0x60
 [<ffffffff81790bd2>] ret_from_fork+0x22/0x30

