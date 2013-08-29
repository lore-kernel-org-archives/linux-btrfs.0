Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35532 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3H2Tzn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:55:43 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 250A09A06AA
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 13:55:43 -0600 (MDT)
Date: Thu, 29 Aug 2013 15:55:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Notify caching_thread()s to give up on extent_commit_sem
 when needed.
Message-ID: <20130829195540.GE10591@localhost.localdomain>
References: <CAOcd+r3zDtf3uNs5YOk=9LhGannN2WK-CpF0PQMdrnu58phBiw@mail.gmail.com>
 <20130829143831.GB10591@localhost.localdomain>
 <CAOcd+r1DoriTSRUiFB3sj3hu0cna9UyPA7G6qxCryrb0Rgo9qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1DoriTSRUiFB3sj3hu0cna9UyPA7G6qxCryrb0Rgo9qg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 10:09:29PM +0300, Alex Lyakas wrote:
> Hi Josef,
> 
> On Thu, Aug 29, 2013 at 5:38 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > On Thu, Aug 29, 2013 at 01:31:05PM +0300, Alex Lyakas wrote:
> >> caching_thread()s do all their work under read access to extent_commit_sem.
> >> They give up on this read access only when need_resched() tells them, or
> >> when they exit. As a result, somebody that wants a WRITE access to this sem,
> >> might wait for a long time. Especially this is problematic in
> >> cache_block_group(),
> >> which can be called on critical paths like find_free_extent() and in commit
> >> path via commit_cowonly_roots().
> >>
> >> This patch is an RFC, that attempts to fix this problem, by notifying the
> >> caching threads to give up on extent_commit_sem.
> >>
> >> On a system with a lot of metadata (~20Gb total metadata, ~10Gb extent tree),
> >> with increased number of caching_threads, commits were very slow,
> >> stuck in commit_cowonly_roots, due to this issue.
> >> With this patch, commits no longer get stuck in commit_cowonly_roots.
> >>
> >
> > But what kind of effect do you see on overall performance/runtime?  Honestly I'd
> > expect we'd spend more of our time waiting for the caching kthread to fill in
> > free space so we can make allocations than waiting on this lock contention.  I'd
> > like to see real numbers here to see what kind of effect this patch has on your
> > workload.  (I don't doubt it makes a difference, I'm just curious to see how big
> > of a difference it makes.)
> 
> Primarily for me it affects the commit thread right after mounting,
> when it spends time in the "critical part" of the commit, in which
> trans_no_join is set, i.e., it is not possible to start a new
> transaction. So all the new writers that want a transaction are
> delayed at this point.
> 
> Here are some numbers (and some more logs are in the attached file).
> 
> Filesystem has a good amount of metadata (btrfs-progs modified
> slightly to print exact byte values):
> root@dc:/home/zadara# btrfs fi df /btrfs/pool-00000002/
> Data: total=846116945920(788.01GB), used=842106667008(784.27GB)
> System: total=4194304(4.00MB), used=94208(92.00KB)
> Metadata: total=31146901504(29.01GB), used=25248698368(23.51GB)
> 
> original code, 2 caching workers, try 1
> Aug 29 13:41:22 dc kernel: [28381.203745] [17617][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_STARTED:439] FS[dm-119] txn[6627] COMMIT
> extwr:0 wr:1
> Aug 29 13:41:25 dc kernel: [28384.624838] [17617][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:519] FS[dm-119] txn[6627] COMMIT took
> 3421 ms committers=1 open=0ms blocked=3188ms
> Aug 29 13:41:25 dc kernel: [28384.624846] [17617][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:524] FS[dm-119] txn[6627] roo:0 rdr1:0
> cbg:0 rdr2:0
> Aug 29 13:41:25 dc kernel: [28384.624850] [17617][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:529] FS[dm-119] txn[6627] wc:0 wpc:0
> wew:0 fps:0
> Aug 29 13:41:25 dc kernel: [28384.624854] [17617][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:534] -FS[dm-119] txn[6627] ww:0 cs:0
> rdi:0 rdr3:0
> Aug 29 13:41:25 dc kernel: [28384.624858] [17617][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:538] -FS[dm-119] txn[6627] cfr:0
> ccr:2088 pec:1099
> Aug 29 13:41:25 dc kernel: [28384.624862] [17617][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:541] FS[dm-119] txn[6627] wrw:230 wrs:1
> 
> I have a breakdown of commit times here, to identify bottlenecks of
> the commit. Times are in ms.
> Names of phases are:
> 
> roo - btrfs_run_ordered_operations
> rdr1 - btrfs_run_delayed_refs (call 1)
> cbg - btrfs_create_pending_block_groups
> rdr2 - btrfs_run_delayed_refs (call 2)
> wc - wait_for_commit (if was needed)
> wpc - wair for previous commit (if was needed)
> wew - wait for "external writers to detach"
> fps - flush_all_pending_stuffs
> ww - wait for all the other writers to detach
> cs - create_pending_snapshots
> rdi - btrfs_run_delayed_items
> rdr3 - btrfs_run_delayed_refs (call 3)
> cfr - commit_fs_roots
> ccr - commit_cowonly_roots
> pec - btrfs_prepare_extent_commit
> wrw - btrfs_write_and_wait_transaction
> wrs - write_ctree_super
> 
> Two lines marked as "-" are the "critical part" of the commit.
> 
> 
> original code, 2 caching workers, try 2
> Aug 29 13:43:30 dc kernel: [28508.683625] [22490][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_STARTED:439] FS[dm-119] txn[6630] COMMIT
> extwr:0 wr:1
> Aug 29 13:43:31 dc kernel: [28510.569269] [22490][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:519] FS[dm-119] txn[6630] COMMIT took
> 1885 ms committers=1 open=0ms blocked=1550ms
> Aug 29 13:43:31 dc kernel: [28510.569276] [22490][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:524] FS[dm-119] txn[6630] roo:0 rdr1:0
> cbg:0 rdr2:0
> Aug 29 13:43:31 dc kernel: [28510.569281] [22490][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:529] FS[dm-119] txn[6630] wc:0 wpc:0
> wew:0 fps:0
> Aug 29 13:43:31 dc kernel: [28510.569285] [22490][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:534] -FS[dm-119] txn[6630] ww:0 cs:0
> rdi:0 rdr3:0
> Aug 29 13:43:31 dc kernel: [28510.569288] [22490][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:538] -FS[dm-119] txn[6630] cfr:0
> ccr:1550 pec:0
> Aug 29 13:43:31 dc kernel: [28510.569292] [22490][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:541] FS[dm-119] txn[6630] wrw:333 wrs:1
> 
> So you see that 1-2 secs are spent in "commit cowonly roots". Now the
> patched code, and here, I admit, difference is not so dramatic:
> 
> patched code, 2 caching workers, try 1
> Aug 29 14:08:19 dc kernel: [29997.819307] [24783][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_STARTED:439] FS[dm-119] txn[6642] COMMIT
> extwr:0 wr:1
> Aug 29 14:08:20 dc kernel: [29998.800342] [24783][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:519] FS[dm-119] txn[6642] COMMIT took
> 981 ms committers=1 open=0ms blocked=881ms
> Aug 29 14:08:20 dc kernel: [29998.800350] [24783][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:524] FS[dm-119] txn[6642] roo:0 rdr1:0
> cbg:0 rdr2:0
> Aug 29 14:08:20 dc kernel: [29998.800354] [24783][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:529] FS[dm-119] txn[6642] wc:0 wpc:0
> wew:0 fps:0
> Aug 29 14:08:20 dc kernel: [29998.800358] [24783][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:534] -FS[dm-119] txn[6642] ww:0 cs:0
> rdi:0 rdr3:0
> Aug 29 14:08:20 dc kernel: [29998.800362] [24783][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:538] -FS[dm-119] txn[6642] cfr:0 ccr:880
> pec:1
> Aug 29 14:08:20 dc kernel: [29998.800365] [24783][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:541] FS[dm-119] txn[6642] wrw:98 wrs:1
> 
> patched code, 2 caching workers, try 2
> Aug 29 14:09:18 dc kernel: [30057.375432] [24781][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_STARTED:439] FS[dm-119] txn[6645] COMMIT
> extwr:0 wr:1
> Aug 29 14:09:19 dc kernel: [30058.079811] [24781][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:519] FS[dm-119] txn[6645] COMMIT took
> 704 ms committers=1 open=0ms blocked=643ms
> Aug 29 14:09:19 dc kernel: [30058.079820] [24781][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:524] FS[dm-119] txn[6645] roo:0 rdr1:0
> cbg:0 rdr2:0
> Aug 29 14:09:19 dc kernel: [30058.079824] [24781][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:529] FS[dm-119] txn[6645] wc:0 wpc:0
> wew:0 fps:0
> Aug 29 14:09:19 dc kernel: [30058.079828] [24781][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:534] -FS[dm-119] txn[6645] ww:0 cs:0
> rdi:0 rdr3:0
> Aug 29 14:09:19 dc kernel: [30058.079832] [24781][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:538] -FS[dm-119] txn[6645] cfr:0 ccr:642
> pec:1
> Aug 29 14:09:19 dc kernel: [30058.079836] [24781][tx]btrfs
> [ZBTRFS_TXN_COMMIT_PHASE_DONE:541] FS[dm-119] txn[6645] wrw:59 wrs:0
> 
> but still there is some improvement of commit time.
> 

Ok so that's what I expected, a marginal improvement under normal conditions.

> Now I changed the number of caching workers to 32, to improve the time
> to load the metadata, otherwise it takes a lot of time for the FS to
> become responsive. Also I modified the code to start caching workers
> like this:
> btrfs_init_workers(&fs_info->caching_workers, "cache",
>                32, NULL/*async_helper*/);
> /* use low thresh to quickly spawn needed new threads */
> fs_info->caching_workers.idle_thresh = 2;
> 
> As I explained in my other email named "btrfs:async-thread:
> atomic_start_pending=1 is set, but it's too late", even with two
> caching threads, only one does all the job. So I don't pass the async
> helper (don't know if that's a correct thing to do).
> 

So does jacking the limit up to 32 help the load?  The old "only let 2 cachers
go at once" stuff was because we used to do the caching on the normal extent
tree, so we took locks and it killed performance.  But now that we use the
commit root there is really no reason to limit our caching threads, other than
the fact we'll be thrashing the disk by all of the threads reading so much.
I'll look at the other email you sent, I've not read it.  Thanks,

Josef
