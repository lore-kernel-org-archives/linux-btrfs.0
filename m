Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46322 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3AUSnU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 13:43:20 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so166442wgb.20
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 10:43:19 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Jan 2013 20:37:57 +0200
Message-ID: <CAOcd+r0_u_4c+vi9MgYVGyT7B1tm2uH5aroBOZZ62Z0HW_9xpw@mail.gmail.com>
Subject: btrfs_start_delalloc_inodes livelocks when creating snapshot under IO
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Miao Xie <miaox@cn.fujitsu.com>, Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings all,

I see the following issue during snap creation under IO:
Transaction commit calls btrfs_start_delalloc_inodes() that locks the
delalloc_inodes list, fetches the first inode, unlocks the list,
triggers btrfs_alloc_delalloc_work/btrfs_queue_worker for this inode
and then locks the list again. Then it checks the head of the list
again. In my case, this is always exactly the same inode. As a result,
this function allocates a huge amount of btrfs_delalloc_work
structures, and I start seeing OOM messages in the kernel log, killing
processes etc.

During that time this transaction commit is stuck, so, for example,
other requests to create snapshot (that must wait for this transaction
to commit first) get stuck. The transaction_kthread also gets stuck in
attempt to commit the transaction.

Is this an intended behavior? Shouldn't we ensure that every inode in
the delalloc list gets handled at most once? If the delalloc work is
processed asynchronously, maybe the delalloc list can be locked once
and traversed once?

Josef, I see in commit 996d282c7ff470f150a467eb4815b90159d04c47 that
you mention that "btrfs_start_delalloc_inodes will just walk the list
of delalloc inodes and start writing them out, but it doesn't splice
the list or anything so as long as somebody is doing work on the box
you could end up in this section _forever_." I guess I am hitting this
here also.

Miao, I tested the behavior before your commit
8ccf6f19b67f7e0921063cc309f4672a6afcb528 "Btrfs: make delalloc inodes
be flushed by multi-task", on kernel 3.6. I see same issue there as
well, but OOM doesn't happen, because before your change
btrfs_start_delalloc_inodes() was calling filemap_flush() directly.
But I see still that btrfs_start_delalloc_inodes() handles same inode
more than once, and in some cases never returns in 15 minutes or more,
delaying all other transactions. And snapshot creation gets stuck for
all this time.

(The stack I see on kernel 3.6 is like this:
[<ffffffff812f26c6>] get_request_wait+0xf6/0x1d0
[<ffffffff812f35df>] blk_queue_bio+0x7f/0x380
[<ffffffff812f0374>] generic_make_request.part.50+0x74/0xb0
[<ffffffff812f0788>] generic_make_request+0x68/0x70
[<ffffffff812f0815>] submit_bio+0x85/0x110
[<ffffffffa034ace5>] btrfs_map_bio+0x165/0x2f0 [btrfs]
[<ffffffffa032880f>] btrfs_submit_bio_hook+0x7f/0x170 [btrfs]
[<ffffffffa033b7da>] submit_one_bio+0x6a/0xa0 [btrfs]
[<ffffffffa033f8a4>] submit_extent_page.isra.34+0xe4/0x230 [btrfs]
[<ffffffffa034084c>] __extent_writepage+0x5ec/0x810 [btrfs]
[<ffffffffa0340d22>]
extent_write_cache_pages.isra.26.constprop.40+0x2b2/0x410 [btrfs]
[<ffffffffa03410c5>] extent_writepages+0x45/0x60 [btrfs]
[<ffffffffa0327178>] btrfs_writepages+0x28/0x30 [btrfs]
[<ffffffff81122b21>] do_writepages+0x21/0x40
[<ffffffff81118e5b>] __filemap_fdatawrite_range+0x5b/0x60
[<ffffffff8111982c>] filemap_flush+0x1c/0x20
[<ffffffffa0334289>] btrfs_start_delalloc_inodes+0xc9/0x1f0 [btrfs]
[<ffffffffa0324f5d>] btrfs_commit_transaction+0x44d/0xaf0 [btrfs]
[<ffffffffa035200d>] btrfs_mksubvol.isra.53+0x37d/0x440 [btrfs]
[<ffffffffa03521ca>] btrfs_ioctl_snap_create_transid+0xfa/0x190 [btrfs]
[<ffffffffa03523e3>] btrfs_ioctl_snap_create_v2+0x103/0x140 [btrfs]
[<ffffffffa03546cf>] btrfs_ioctl+0x80f/0x1bf0 [btrfs]
[<ffffffff8118a01a>] do_vfs_ioctl+0x8a/0x340
[<ffffffff8118a361>] sys_ioctl+0x91/0xa0
[<ffffffff81665c42>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

Somehow the request queue of the block device gets empty and the
transaction waits for a long time to allocate a request.)

Some details about my setup:
I am testing for-linus Chris's branch
I have one subvolume with 8 large files (10GB each).
I am running two fio processes (one per file, so only 2 out of 8 files
are involved) with 8 threads each like this:
fio --thread --directory=/btrfs/subvol1 --rw=randwrite --randrepeat=1
--fadvise_hint=0 --fallocate=posix --size=1000m --filesize=10737418240
--bsrange=512b-64k --scramble_buffers=1 --nrfiles=1 --overwrite=1
--ioengine=sync --filename=file-1 --name=job0 --name=job1 --name=job2
--name=job3 --name=job4 --name=job5 --name=job6 --name=job7
The files are preallocated with fallocate before the fio run.
Mount options: noatime,nodatasum,nodatacow,nospace_cache

Can somebody please advise on how to address this issue, and, if
possible, how to solve it on kernel 3.6.

Thanks,
Alex.
