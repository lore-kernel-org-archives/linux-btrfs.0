Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:44314 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945376AbcJaSzY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 14:55:24 -0400
Date: Mon, 31 Oct 2016 14:55:14 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
References: <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 07:47:51PM -0400, Dave Jones wrote:
 > On Wed, Oct 26, 2016 at 07:38:08PM -0400, Chris Mason wrote:
 >  
 >  > >-	hctx->queued++;
 >  > >-	data->hctx = hctx;
 >  > >-	data->ctx = ctx;
 >  > >+	data->hctx = alloc_data.hctx;
 >  > >+	data->ctx = alloc_data.ctx;
 >  > >+	data->hctx->queued++;
 >  > > 	return rq;
 >  > > }
 >  > 
 >  > This made it through an entire dbench 2048 run on btrfs.  My script has 
 >  > it running in a loop, but this is farther than I've gotten before.  
 >  > Looking great so far.
 > 
 > Fixed the splat during boot for me too.
 > Now the fun part, let's see if it fixed the 'weird shit' that Trinity
 > was stumbling on.

It took a while, but.. bad news.


BUG: Bad page state in process kworker/u8:12  pfn:4e0e39
page:ffffea0013838e40 count:0 mapcount:0 mapping:ffff8804a20310e0 index:0x100c
flags: 0x400000000000000c(referenced|uptodate)
page dumped because: non-NULL mapping
CPU: 3 PID: 1586 Comm: kworker/u8:12 Not tainted 4.9.0-rc3-think+ #1 
Workqueue: writeback wb_workfn
  (flush-btrfs-2)
 ffffc90000777828
 ffffffff8130d04c
 ffffea0013838e40
 ffffffff819ff654
 ffffc90000777850
 ffffffff81150e5f
 0000000000000000
 ffffea0013838e40
 400000000000000c
 ffffc90000777860
 ffffffff81150f1a
 ffffc900007778a8
Call Trace:
 [<ffffffff8130d04c>] dump_stack+0x4f/0x73
 [<ffffffff81150e5f>] bad_page+0xbf/0x120
 [<ffffffff81150f1a>] free_pages_check_bad+0x5a/0x70
 [<ffffffff81153818>] free_hot_cold_page+0x248/0x290
 [<ffffffff81153b1b>] free_hot_cold_page_list+0x2b/0x50
 [<ffffffff8115c52d>] release_pages+0x2bd/0x350
 [<ffffffff8115da62>] __pagevec_release+0x22/0x30
 [<ffffffffa00a0d4e>] extent_write_cache_pages.isra.48.constprop.63+0x32e/0x400 [btrfs]
 [<ffffffffa00a1199>] extent_writepages+0x49/0x60 [btrfs]
 [<ffffffffa0081840>] ? btrfs_releasepage+0x40/0x40 [btrfs]
 [<ffffffffa007e993>] btrfs_writepages+0x23/0x30 [btrfs]
 [<ffffffff8115ac4c>] do_writepages+0x1c/0x30
 [<ffffffff811f69f3>] __writeback_single_inode+0x33/0x180
 [<ffffffff811f71e8>] writeback_sb_inodes+0x2a8/0x5b0
 [<ffffffff811f757d>] __writeback_inodes_wb+0x8d/0xc0
 [<ffffffff811f7833>] wb_writeback+0x1e3/0x1f0
 [<ffffffff811f7d72>] wb_workfn+0xd2/0x280
 [<ffffffff810908d5>] process_one_work+0x1d5/0x490
 [<ffffffff81090875>] ? process_one_work+0x175/0x490
 [<ffffffff81090bd9>] worker_thread+0x49/0x490
 [<ffffffff81090b90>] ? process_one_work+0x490/0x490
 [<ffffffff81095d4e>] kthread+0xee/0x110
 [<ffffffff81095c60>] ? kthread_park+0x60/0x60
 [<ffffffff81790b12>] ret_from_fork+0x22/0x30



