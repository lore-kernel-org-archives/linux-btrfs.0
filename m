Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:43910 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbcIIAvC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Sep 2016 20:51:02 -0400
Date: Thu, 8 Sep 2016 20:50:56 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: lockdep warning in btrfs in 4.8-rc3
Message-ID: <20160909005055.n6be4cvwvi7byk3j@codemonkey.org.uk>
References: <20160826233624.jao5mztbxhjikm7e@floor.thefacebook.com>
 <6a3eed93-fb4d-817a-6a59-7e7f91c8ea6d@de.ibm.com>
 <624b2c3a-5030-3f7f-70d6-4507308d785b@de.ibm.com>
 <d42383bb-399f-1794-3574-dc83c959b02b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d42383bb-399f-1794-3574-dc83c959b02b@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2016 at 08:58:48AM -0400, Chris Mason wrote:
 > On 09/08/2016 07:50 AM, Christian Borntraeger wrote:
 > > On 09/08/2016 01:48 PM, Christian Borntraeger wrote:
 > >> Chris,
 > >>
 > >> with 4.8-rc3 I get the following on an s390 box:
 > >
 > > Sorry for the noise, just saw the fix in your pull request.
 > >
 > 
 > The lockdep splat is still there, we'll need to annotate this one a little.

Here's another one (unrelated?) that I've not seen before today:

WARNING: CPU: 1 PID: 10664 at kernel/locking/lockdep.c:704 register_lock_class+0x33f/0x510
CPU: 1 PID: 10664 Comm: kworker/u8:5 Not tainted 4.8.0-rc5-think+ #2 
Workqueue: writeback wb_workfn (flush-btrfs-1)
 0000000000000097 00000000b97fbad3 ffff88013b8c3770 ffffffffa63d3ab1
 0000000000000000 0000000000000000 ffffffffa6bf1792 ffffffffa60df22f
 ffff88013b8c37b0 ffffffffa60897a0 000002c0b97fbad3 ffffffffa6bf1792
Call Trace:
 [<ffffffffa63d3ab1>] dump_stack+0x6c/0x9b
 [<ffffffffa60df22f>] ? register_lock_class+0x33f/0x510
 [<ffffffffa60897a0>] __warn+0x110/0x130
 [<ffffffffa608992c>] warn_slowpath_null+0x2c/0x40
 [<ffffffffa60df22f>] register_lock_class+0x33f/0x510
 [<ffffffffa639d9ce>] ? bio_add_page+0x7e/0x120
 [<ffffffffa60e082b>] __lock_acquire.isra.32+0x5b/0x8c0
 [<ffffffffa60e1438>] lock_acquire+0x58/0x70
 [<ffffffffc041c08a>] ? btrfs_try_tree_write_lock+0x4a/0xb0 [btrfs]
 [<ffffffffa69c5728>] _raw_write_lock+0x38/0x70
 [<ffffffffc041c08a>] ? btrfs_try_tree_write_lock+0x4a/0xb0 [btrfs]
 [<ffffffffc041c08a>] btrfs_try_tree_write_lock+0x4a/0xb0 [btrfs]
 [<ffffffffc03f25f8>] lock_extent_buffer_for_io+0x28/0x2e0 [btrfs]
 [<ffffffffc03fc261>] btree_write_cache_pages+0x231/0x550 [btrfs]
 [<ffffffffc03c0cf0>] ? btree_set_page_dirty+0x20/0x20 [btrfs]
 [<ffffffffc03c0d64>] btree_writepages+0x74/0x90 [btrfs]
 [<ffffffffa619eb6e>] do_writepages+0x3e/0x80
 [<ffffffffa6266ba2>] __writeback_single_inode+0x42/0x220
 [<ffffffffa6267601>] writeback_sb_inodes+0x351/0x730
 [<ffffffffa619aae1>] ? __wb_update_bandwidth+0x1c1/0x2b0
 [<ffffffffa6267cd8>] wb_writeback+0x138/0x2a0
 [<ffffffffa626854e>] wb_workfn+0x10e/0x340
 [<ffffffffa60e099f>] ? __lock_acquire.isra.32+0x1cf/0x8c0
 [<ffffffffa60aa05f>] process_one_work+0x24f/0x5d0
 [<ffffffffa60a9ff0>] ? process_one_work+0x1e0/0x5d0
 [<ffffffffa60aa433>] worker_thread+0x53/0x5b0
 [<ffffffffa60aa3e0>] ? process_one_work+0x5d0/0x5d0
 [<ffffffffa60b11a0>] kthread+0x120/0x140
 [<ffffffffa60b782a>] ? finish_task_switch+0x6a/0x200
 [<ffffffffa69c5d1f>] ret_from_fork+0x1f/0x40
 [<ffffffffa60b1080>] ? kthread_create_on_node+0x270/0x270
---[ end trace 7b39395c07435bf1 ]---


 700                         /*                            
 701                          * Huh! same key, different name? Did someone trample
 702                          * on some memory? We're most confused.
 703                          */                                     
 704                         WARN_ON_ONCE(class->name != lock->name); 

That seems kinda scary. There was a trinity run going on at the same time,
so this _might_ be a random scribble from something unrelated to btrfs,
but just in case..

IWBNI that code printed out both cases so I could see if this was
corruption or two unrelated keys. I'll make it do that in case it
happens again.

	Dave
