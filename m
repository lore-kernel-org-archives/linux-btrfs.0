Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35710 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab3AXCOO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 21:14:14 -0500
Message-ID: <5100991B.6080601@cn.fujitsu.com>
Date: Thu, 24 Jan 2013 10:14:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: bo.li.liu@oracle.com, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
References: <50FE6E9C.2040803@cn.fujitsu.com> <20130122142414.GA15978@liubo> <50FF50EF.9010907@cn.fujitsu.com> <20130123035647.GB17162@liubo.jp.oracle.com> <50FF6AC1.6030602@cn.fujitsu.com> <20130123060618.GC17162@liubo.jp.oracle.com> <50FF8437.3010703@cn.fujitsu.com> <20130123081751.GF17162@liubo.jp.oracle.com> <50FFA633.1070101@cn.fujitsu.com> <20130123095132.GA31998@liubo.jp.oracle.com> <50FFB978.3060802@cn.fujitsu.com> <CAOcd+r3vjE6SksVaVRPp2b9c0wUyNtoC3xQNy5OZw-Bx7Pt5ww@mail.gmail.com>
In-Reply-To: <CAOcd+r3vjE6SksVaVRPp2b9c0wUyNtoC3xQNy5OZw-Bx7Pt5ww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 23 Jan 2013 19:02:30 +0200, Alex Lyakas wrote:
> Hi Miao,
> I have tested your patch, and the two discussed issues  (OOM and
> handling the same inode more than once) are solved with it.
> 
> However, snap creation under IO still takes 5-10 minutes for me.
> Basically, now the situation is similar to kernel 3.6, before your
> change to push the work to the flush workers. I see that flush worker
> is stuck in one of two stacks like this:
> 
> [<ffffffff81301f1d>] get_request+0x14d/0x330
> [<ffffffff813030a4>] blk_queue_bio+0x84/0x3b0
> [<ffffffff812ff9a7>] generic_make_request.part.55+0x77/0xb0
> [<ffffffff812fff48>] generic_make_request+0x68/0x70
> [<ffffffff812fffcb>] submit_bio+0x7b/0x160
> [<ffffffffa02fe76e>] submit_stripe_bio+0x5e/0x80 [btrfs]
> [<ffffffffa03050db>] btrfs_map_bio+0x1cb/0x420 [btrfs]
> [<ffffffffa02e1b14>] btrfs_submit_bio_hook+0xb4/0x1d0 [btrfs]
> [<ffffffffa02f5b1a>] submit_one_bio+0x6a/0xa0 [btrfs]
> [<ffffffffa02f99c4>] submit_extent_page.isra.38+0xe4/0x200 [btrfs]
> [<ffffffffa02fa83c>] __extent_writepage+0x5dc/0x750 [btrfs]
> [<ffffffffa02fac6a>]
> extent_write_cache_pages.isra.29.constprop.42+0x2ba/0x410 [btrfs]
> [<ffffffffa02fb00e>] extent_writepages+0x4e/0x70 [btrfs]
> [<ffffffffa02e0898>] btrfs_writepages+0x28/0x30 [btrfs]
> [<ffffffff81136510>] do_writepages+0x20/0x40
> [<ffffffff8112c341>] __filemap_fdatawrite_range+0x51/0x60
> [<ffffffff8112cc3c>] filemap_flush+0x1c/0x20
> [<ffffffffa02e416d>] btrfs_run_delalloc_work+0xad/0xe0 [btrfs]
> [<ffffffffa0308c1f>] worker_loop+0x16f/0x5d0 [btrfs]
> [<ffffffff8107ba50>] kthread+0xc0/0xd0
> [<ffffffff8169d66c>] ret_from_fork+0x7c/0xb0
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> or
> 
> [<ffffffff8112a58e>] sleep_on_page+0xe/0x20
> [<ffffffff8112a577>] __lock_page+0x67/0x70
> [<ffffffffa02fabe9>]
> extent_write_cache_pages.isra.29.constprop.42+0x239/0x410 [btrfs]
> [<ffffffffa02fb00e>] extent_writepages+0x4e/0x70 [btrfs]
> [<ffffffffa02e0898>] btrfs_writepages+0x28/0x30 [btrfs]
> [<ffffffff81136510>] do_writepages+0x20/0x40
> [<ffffffff8112c341>] __filemap_fdatawrite_range+0x51/0x60
> [<ffffffff8112cc3c>] filemap_flush+0x1c/0x20
> [<ffffffffa02e416d>] btrfs_run_delalloc_work+0xad/0xe0 [btrfs]
> [<ffffffffa0308c1f>] worker_loop+0x16f/0x5d0 [btrfs]
> [<ffffffff8107ba50>] kthread+0xc0/0xd0
> [<ffffffff8169d66c>] ret_from_fork+0x7c/0xb0
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> while btrfs_start_delalloc_inodes() waits for it to complete in the
> commit thread. Also for some reason, I have only one "flush_workers"
> thread, so switching to another thread does not improve for me.

it is because the number of the inodes is very few, so the worker don't
create new workers to deal with the new works. Maybe we can change
flush_workers->idle_thresh to improve this problem.

> Another operation that takes time (up to one minute) is
> btrfs_wait_ordered_extents(), which does similar thing by switching
> the work to the flush worker. In this case, the
> btrfs_start_ordered_extent() is stuck in stacks like follows:
> [<ffffffffa04e6fc5>] btrfs_start_ordered_extent+0x85/0x130 [btrfs]
> [<ffffffffa04e70e1>] btrfs_run_ordered_extent_work+0x71/0xd0 [btrfs]
> [<ffffffffa04facef>] worker_loop+0x16f/0x5d0 [btrfs]
> [<ffffffff8107ba50>] kthread+0xc0/0xd0
> [<ffffffff8169d66c>] ret_from_fork+0x7c/0xb0
> [<ffffffffffffffff>] 0xffffffffffffffff
> where it waits for BTRFS_ORDERED_COMPLETE.
> 
> I have several questions, on how to possibly address this issue:
> 
> - I see that btrfs_flush_all_pending_stuffs() is invoked at least
> twice during each transaction commit. It may be invoked more than
> twice if the do{ } while loop that waits for writes, performs more
> than one iteration. For me, each invocation takes a lot of time
> because of btrfs_start_delalloc_inodes() and
> btrfs_wait_ordered_extents(). Given the fixes you have made (handling
> each inode only once), is it still needed to call these functions
> several times during the same commit?

Calling it in the while loop is because we don't know how much time we need
to wait for the end of the other transaction handle, so we flush the delalloc
inodes instead of just waiting.

Maybe we need not call btrfs_wait_ordered_extents() in the while loop, just
call btrfs_start_delalloc_inodes() to start flush.

> - I see that during a commit without pending snapshots, these two
> functions are not invoked at all.
> 	if (flush_on_commit || snap_pending) {
> 		ret = btrfs_start_delalloc_inodes(root, 1);
> 		if (ret)
> 			return ret;
> 		btrfs_wait_ordered_extents(root, 1);
> 	}
> The FLUSHONCOMMIT mount option is normally *not set*, I see in the
> wiki that it is "Not needed with recent kernels, as it's the normal
> mode of operation. "
> Can you pls explain why the delalloc is needed when there is a pending
> snap, but not with a non-snap commit? Or pls point me to the code,
> where I can better understand what delalloc inode is and how it is
> related to FLUSHONCOMMIT or snapshot? Can you pls explain what the
> FLUSHONCOMMIT mount option is about?
> 
> I understand from your explanation that without flushing the delalloc,
> the data in the snap may be different from the subvolume data. But
> this may happen anyways, since the IO to the subvolume is not blocked
> during transaction commit (at least it doesn't look that it's
> blocked).

There are two cases that the data in the snap may be different from the
subvolume data without flushing the delalloc.

1st:
	User0
	write(fd, buf, len)
	create snap

2nd:
	User0				User1
	create snap
	  commit_transaction
					write(fd, buf, len)
	    create_pending_snapshot

For the 1st case, the user doesn't expect the data is different between source
subvolume and the snapshot.

For the 2nd case, it doesn't matter.

So in order to avoid the 1st case, we need flush the delalloc before snapshot
creation.

> - Is there something that user-space can do to avoid flushing the
> delalloc during snap-commit? For example, if the user-space stops the
> IO and does a normal commit, this will not call
> btrfs_start_delalloc_inodes(), but this should ensure that *some* data
> is safe on disk. Then the user-space triggers snap creation (which is
> another commit), and then resume the IO? Because without the ongoing
> IO, snap creation is very fast.

We can sync the fs before creating snapshot, in this way, we needn't flush
the delalloc while committing the transaction. But I don't think it is good
way. Because for the users, the page cache is transparent.

I have a idea to improve this problem:
- introduce per-subvolume delalloc inode list
- flush the delalloc inode list of the source subvolume in create_snapshot(),
  not flush it in commit_transaction(). In this way, we just flush once.
- don't do the delalloc flush in commit_transaction() if there are pending snapshots
- If FLUSHONCOMMIT is set, just call btrfs_start_delalloc_inodes() before while loop,
  and call btrfs_wait_ordered_extents() after the while loop.

How do you think about this idea?

Thanks
Miao

> Thanks for your help,
> Alex.
> 
> P.S.: As I am writing this email, snap creation is stuck for 30
> minutes, calling btrfs_flush_all_pending_stuffs() again and again....
> 
> 
> 
> 
> On Wed, Jan 23, 2013 at 12:20 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> On Wed, 23 Jan 2013 17:52:14 +0800, Liu Bo wrote:
>>> On Wed, Jan 23, 2013 at 04:58:27PM +0800, Miao Xie wrote:
>>>> On wed, 23 Jan 2013 16:17:53 +0800, Liu Bo wrote:
>>>>> On Wed, Jan 23, 2013 at 02:33:27PM +0800, Miao Xie wrote:
>>>>>> On wed, 23 Jan 2013 14:06:21 +0800, Liu Bo wrote:
>>>>>>> On Wed, Jan 23, 2013 at 12:44:49PM +0800, Miao Xie wrote:
>>>>>>>> No, we can't. The other tasks which flush the delalloc data may remove the inode
>>>>>>>> from the delalloc list/splice list. If we release the lock, we will meet the race
>>>>>>>> between list traversing and list_del().
>>>>>>>
>>>>>>> OK, then please merge patch 1 and 4 so that we can backport 1 less patch
>>>>>>> at least.
>>>>>>
>>>>>> I don't think we should merge these two patch because they do two different things - one
>>>>>> is bug fix, and the other is just a improvement, and this improvement changes the logic
>>>>>> of the code and might be argumentative for some developers. So 2 patches is  better than one,
>>>>>> I think.
>>>>>
>>>>> Sorry, this is right only when patch 1 really fixes the problem Alex reported.
>>>>>
>>>>> But the fact is
>>>>>
>>>>> 1)  patch 1 is not enough to fix the bug, it just fixes the OOM of
>>>>> allocating 'struct btrfs_delalloc_work' while the original OOM of allocating
>>>>> requests remains.  We can still get the same inode over and over again
>>>>> and then stuck in btrfs_start_delalloc_inodes() because we 'goto again' to
>>>>> make sure we flush all inodes listed in fs_info->delalloc_inodes.
>>>>>
>>>>> 2)  patch 4 fixes 1)'s problems by removing 'goto again'.
>>>>>
>>>>> Am I missing something?
>>>>
>>>> In fact, there are two different problems.
>>>> One is OOM bug. it is a serious problem and also is an regression, so we should fix it
>>>> as soon as possible.
>>>> The other one is that we may fetch the same inode again and again if someone write data
>>>> into it endlessly. This problem is not so urgent to deal with. and perhaps some developers
>>>> think it is not a problem, we should flush that inode since there are dirty pages in it.
>>>> So we need split it from the patch of the 1st problem.
>>>
>>> All right, I'm ok with this.
>>>
>>> But the TWO different problems are both due to fetching the same inode more
>>> than once, and the solutions are indeed same, "fetch every inode on
>>> the list just once", and they are in the same code.
>>
>> I forgot to say that the first problem can happen even though no task writes data into
>> the file after we start to flush the delalloc inodes.
>>
>> Thanks
>> Miao
>>
>>>
>>> It is definitely a bug/problem if any users complains about their box
>>> getting stuck.  It is KERNEL that should be blamed.
>>>
>>> thanks,
>>> liubo
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

