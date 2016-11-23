Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:56400 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932984AbcKWTeb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 14:34:31 -0500
Date: Wed, 23 Nov 2016 14:34:19 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
References: <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161031194454.GA49877@clm-mbp.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 01:44:55PM -0600, Chris Mason wrote:
 > On Mon, Oct 31, 2016 at 12:35:16PM -0700, Linus Torvalds wrote:
 > >On Mon, Oct 31, 2016 at 11:55 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
 > >>
 > >> BUG: Bad page state in process kworker/u8:12  pfn:4e0e39
 > >> page:ffffea0013838e40 count:0 mapcount:0 mapping:ffff8804a20310e0 index:0x100c
 > >> flags: 0x400000000000000c(referenced|uptodate)
 > >> page dumped because: non-NULL mapping
 > >
 > >Hmm. So this seems to be btrfs-specific, right?
 > >
 > >I searched for all your "non-NULL mapping" cases, and they all seem to
 > >have basically the same call trace, with some work thread doing
 > >writeback and going through btrfs_writepages().
 > >
 > >Sounds like it's a race with either fallocate hole-punching or
 > >truncate. I'm not seeing it, but I suspect it's btrfs, since DaveJ
 > >clearly ran other filesystems too but I am not seeing this backtrace
 > >for anything else.
 > 
 > Agreed, I think this is a separate bug, almost certainly btrfs specific.  
 > I'll work with Dave on a better reproducer.

Ok, let's try this..
Here's the usual dump, from the current tree:


[  317.689216] BUG: Bad page state in process kworker/u8:8  pfn:4d8fd4
[  317.702235] page:ffffea001363f500 count:0 mapcount:0 mapping:ffff8804eef8e0e0 index:0x29
[  317.718068] flags: 0x400000000000000c(referenced|uptodate)
[  317.731086] page dumped because: non-NULL mapping
[  317.744118] CPU: 3 PID: 1558 Comm: kworker/u8:8 Not tainted 4.9.0-rc6-think+ #1 
[  317.770404] Workqueue: writeback wb_workfn
[  317.783490]  (flush-btrfs-3)
[  317.783581]  ffffc90000ff3798
[  317.796651]  ffffffff813b69bc
[  317.796742]  ffffea001363f500
[  317.796798]  ffffffff81c474ee
[  317.796854]  ffffc90000ff37c0
[  317.809910]  ffffffff811b30c4
[  317.810001]  0000000000000000
[  317.810055]  ffffea001363f500
[  317.810112]  0000000000000003
[  317.823230]  ffffc90000ff37d0
[  317.823320]  ffffffff811b318f
[  317.823376]  ffffc90000ff3818
[  317.823431] Call Trace:
[  317.836645]  [<ffffffff813b69bc>] dump_stack+0x4f/0x73
[  317.850063]  [<ffffffff811b30c4>] bad_page+0xc4/0x130
[  317.863426]  [<ffffffff811b318f>] free_pages_check_bad+0x5f/0x70
[  317.876805]  [<ffffffff811b61f5>] free_hot_cold_page+0x305/0x3b0
[  317.890132]  [<ffffffff811b660e>] free_hot_cold_page_list+0x7e/0x170
[  317.903410]  [<ffffffff811c08b7>] release_pages+0x2e7/0x3a0
[  317.916600]  [<ffffffff811c2067>] __pagevec_release+0x27/0x40
[  317.929817]  [<ffffffffa00b0a55>] extent_write_cache_pages.isra.44.constprop.59+0x355/0x430 [btrfs]
[  317.943073]  [<ffffffffa00b0fcd>] extent_writepages+0x5d/0x90 [btrfs]
[  317.956033]  [<ffffffffa008ea60>] ? btrfs_releasepage+0x40/0x40 [btrfs]
[  317.968902]  [<ffffffffa008b6a8>] btrfs_writepages+0x28/0x30 [btrfs]
[  317.981744]  [<ffffffff811be6d1>] do_writepages+0x21/0x30
[  317.994524]  [<ffffffff812727cf>] __writeback_single_inode+0x7f/0x6e0
[  318.007333]  [<ffffffff81894cc1>] ? _raw_spin_unlock+0x31/0x50
[  318.020090]  [<ffffffff8127356d>] writeback_sb_inodes+0x31d/0x6c0
[  318.032844]  [<ffffffff812739a2>] __writeback_inodes_wb+0x92/0xc0
[  318.045623]  [<ffffffff81273e97>] wb_writeback+0x3f7/0x530
[  318.058304]  [<ffffffff81274a38>] wb_workfn+0x148/0x620
[  318.070949]  [<ffffffff810a4b54>] ? process_one_work+0x194/0x690
[  318.083549]  [<ffffffff812748f5>] ? wb_workfn+0x5/0x620
[  318.096160]  [<ffffffff810a4bf2>] process_one_work+0x232/0x690
[  318.108722]  [<ffffffff810a4b54>] ? process_one_work+0x194/0x690
[  318.121225]  [<ffffffff810a509e>] worker_thread+0x4e/0x490
[  318.133680]  [<ffffffff810a5050>] ? process_one_work+0x690/0x690
[  318.146126]  [<ffffffff810a5050>] ? process_one_work+0x690/0x690
[  318.158507]  [<ffffffff810aa7e2>] kthread+0x102/0x120
[  318.170880]  [<ffffffff810aa6e0>] ? kthread_park+0x60/0x60
[  318.183254]  [<ffffffff81895822>] ret_from_fork+0x22/0x30


This time, I managed to get my ftrace magic working, so we have this
trace from just before this happened. Does this shed any light ?

https://codemonkey.org.uk/junk/trace.txt

(note that some of the spinlock/rcu calls will be missing here. I chose
to add them to ftrace's exclude list because they dominate the trace
buffer so much, especially in debug builds)

	Dave

