Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:57356 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbcJPAmu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Oct 2016 20:42:50 -0400
Date: Sat, 15 Oct 2016 20:42:40 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs bio linked list corruption.
Message-ID: <20161016004240.hpstul32lb2f3u4g@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
 <20161012134717.n74tww5eywc7dqp7@codemonkey.org.uk>
 <20161012144012.7vvfehceoykswmun@codemonkey.org.uk>
 <fb1a1c38-1ed8-e0eb-740d-c34c1d6c18f4@fb.com>
 <20161013181622.qpi5puv6ivxvslnf@codemonkey.org.uk>
 <7b476728-75f8-e3d3-1261-b9b0d598ed10@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7b476728-75f8-e3d3-1261-b9b0d598ed10@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 05:18:46PM -0400, Chris Mason wrote:

 > >  > > .. and of course the first thing that happens is a completely different
 > >  > > btrfs trace..
 > >  > >
 > >  > >
 > >  > > WARNING: CPU: 1 PID: 21706 at fs/btrfs/transaction.c:489 start_transaction+0x40a/0x440 [btrfs]
 > >  > > CPU: 1 PID: 21706 Comm: trinity-c16 Not tainted 4.8.0-think+ #14
 > >  > >  ffffc900019076a8 ffffffffb731ff3c 0000000000000000 0000000000000000
 > >  > >  ffffc900019076e8 ffffffffb707a6c1 000001e9f5806ce0 ffff8804f74c4d98
 > >  > >  0000000000000801 ffff880501cfa2a8 000000000000008a 000000000000008a
 > >  >
 > >  > This isn't even IO.  Uuughhhh.  We're going to need a fast enough test
 > >  > that we can bisect.
 > >
 > > Progress...
 > > I've found that this combination of syscalls..
 > >
 > > ./trinity -C64 -q -l off -a64 --enable-fds=testfile -c fsync -c fsetxattr -c lremovexattr -c pwritev2
 > >
 > > hits one of these two bugs in a few minutes runtime.
 > >
 > > Just the xattr syscalls + fsync isn't enough, neither is just pwrite + fsync.
 > > Mix them together though, and something goes awry.
 > >
 > Hasn't triggered here yet.  I'll leave it running though.

The hits keep coming..

BUG: Bad page state in process kworker/u8:12  pfn:4988fa
page:ffffea0012623e80 count:0 mapcount:0 mapping:ffff8804450456e0 index:0x9

flags: 0x400000000000000c(referenced|uptodate)
page dumped because: non-NULL mapping
CPU: 2 PID: 1388 Comm: kworker/u8:12 Not tainted 4.8.0-think+ #18 
Workqueue: writeback wb_workfn
 (flush-btrfs-1)

 ffffc90000aef7e8
 ffffffff81320e7c
 ffffea0012623e80
 ffffffff819fe6ec

 ffffc90000aef810
 ffffffff81159b3f
 0000000000000000
 ffffea0012623e80

 400000000000000c
 ffffc90000aef820
 ffffffff81159bfa
 ffffc90000aef868

Call Trace:
 [<ffffffff81320e7c>] dump_stack+0x4f/0x73
 [<ffffffff81159b3f>] bad_page+0xbf/0x120
 [<ffffffff81159bfa>] free_pages_check_bad+0x5a/0x70
 [<ffffffff8115c0fb>] free_hot_cold_page+0x20b/0x270
 [<ffffffff8115c41b>] free_hot_cold_page_list+0x2b/0x50
 [<ffffffff81165062>] release_pages+0x2d2/0x380
 [<ffffffff811665d2>] __pagevec_release+0x22/0x30
 [<ffffffffa009f810>] extent_write_cache_pages.isra.48.constprop.63+0x350/0x430 [btrfs]
 [<ffffffff8133f487>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffff810c6999>] ? get_lock_stats+0x19/0x50
 [<ffffffffa009fce8>] extent_writepages+0x58/0x80 [btrfs]
 [<ffffffffa007f150>] ? btrfs_releasepage+0x40/0x40 [btrfs]
 [<ffffffffa007c0d3>] btrfs_writepages+0x23/0x30 [btrfs]
 [<ffffffff8116370c>] do_writepages+0x1c/0x30
 [<ffffffff81202d63>] __writeback_single_inode+0x33/0x180
 [<ffffffff8120357b>] writeback_sb_inodes+0x2cb/0x5d0
 [<ffffffff8120390d>] __writeback_inodes_wb+0x8d/0xc0
 [<ffffffff81203c03>] wb_writeback+0x203/0x210
 [<ffffffff81204197>] wb_workfn+0xe7/0x2a0
 [<ffffffff810c8b7f>] ? __lock_acquire.isra.32+0x1cf/0x8c0
 [<ffffffff8109458a>] process_one_work+0x1da/0x4b0
 [<ffffffff8109452a>] ? process_one_work+0x17a/0x4b0
 [<ffffffff810948a9>] worker_thread+0x49/0x490
 [<ffffffff81094860>] ? process_one_work+0x4b0/0x4b0
 [<ffffffff81094860>] ? process_one_work+0x4b0/0x4b0

