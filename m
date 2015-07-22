Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:21712 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbbGVF1F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 01:27:05 -0400
Date: Wed, 22 Jul 2015 15:27:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/311: Disable dmesg check
Message-ID: <20150722052700.GY3902@dastard>
References: <1437109003-2357-1-git-send-email-chandan@linux.vnet.ibm.com>
 <55ACEFC4.9040502@fb.com>
 <20150720221220.GU7943@dastard>
 <8410729.YTcdQ5sv7i@localhost.localdomain>
 <20150722000105.GX3902@dastard>
 <55AEE5D3.6020509@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55AEE5D3.6020509@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 21, 2015 at 08:37:39PM -0400, Josef Bacik wrote:
> On 07/21/2015 08:01 PM, Dave Chinner wrote:
> >On Tue, Jul 21, 2015 at 04:03:17PM +0530, Chandan Rajendra wrote:
> >>On Tuesday 21 Jul 2015 08:12:20 Dave Chinner wrote:
> >>>On Mon, Jul 20, 2015 at 08:55:32AM -0400, Josef Bacik wrote:
> >>>>On 07/19/2015 07:54 PM, Dave Chinner wrote:
> >>>>>On Fri, Jul 17, 2015 at 05:10:50PM +0530, Chandan Rajendra wrote:
> >>>>>>On Friday 17 Jul 2015 06:16:02 Brian Foster wrote:
> >>>>>>>On Fri, Jul 17, 2015 at 12:56:43AM -0400, Chandan Rajendra wrote:
> >>>>>>>>When running generic/311 on Btrfs' subpagesize-blocksize patchset (on
> >>>>>>>>ppc64
> >>>>>>>>with 4k sectorsize and 16k node/leaf size) I noticed the following
> >>>>>>>>call
> >>>>>>>>trace,
> >>>>>>>>
> >>>>>>>>BTRFS (device dm-0): parent transid verify failed on 29720576 wanted
> >>>>>>>>160
> >>>>>>>>found 158 BTRFS (device dm-0): parent transid verify failed on
> >>>>>>>>29720576
> >>>>>>>>wanted 160 found 158 BTRFS: Transaction aborted (error -5)
> >>>>>>>>
> >>>>>>>>WARNING: at /root/repos/linux/fs/btrfs/super.c:260
> >>>>>>>>Modules linked in:
> >>>>>>>>CPU: 3 PID: 30769 Comm: umount Tainted: G        W    L
> >>>>>>>>4.0.0-rc5-11671-g8b82e73e #63 task: c000000079aaddb0 ti:
> >>>>>>>>c000000079a48000
> >>>>>>>>task.ti: c000000079a48000 NIP: c000000000499aa0 LR: c000000000499a9c
> >>>>>>>>CTR:
> >>>>>>>>c000000000779630
> >>>>>>>>REGS: c000000079a4b480 TRAP: 0700   Tainted: G        W   L
> >>>>>>>>(4.0.0-rc5-11671-g8b82e73e) MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI>
> >>>>>>>>CR: 28008828  XER: 20000000 CFAR: c000000000a23914 SOFTE: 1
> >>>>>>>>GPR00: c000000000499a9c c000000079a4b700 c00000000103bdf8
> >>>>>>>>0000000000000025
> >>>>>>>>GPR04: 0000000000000001 0000000000000502 c00000000107e918
> >>>>>>>>0000000000000cda
> >>>>>>>>GPR08: 0000000000000007 0000000000000007 0000000000000001
> >>>>>>>>c0000000010f5044
> >>>>>>>>GPR12: 0000000028008822 c00000000fdc0d80 0000000020000000
> >>>>>>>>0000000010152e00
> >>>>>>>>GPR16: 0000010002979380 0000000010140724 0000000000000000
> >>>>>>>>0000000000000000
> >>>>>>>>GPR20: ffffffffffffffff 0000000000000000 0000000000000000
> >>>>>>>>0000000000000000
> >>>>>>>>GPR24: c0000000151f61a8 0000000000000000 c000000055e5e800
> >>>>>>>>c000000000aac270
> >>>>>>>>GPR28: 00000000000004a4 fffffffffffffffb c000000055e5e800
> >>>>>>>>c0000000679204d0
> >>>>>>>>NIP [c000000000499aa0] .__btrfs_abort_transaction+0x180/0x190
> >>>>>>>>LR [c000000000499a9c] .__btrfs_abort_transaction+0x17c/0x190
> >>>>>>>>Call Trace:
> >>>>>>>>[c000000079a4b700] [c000000000499a9c]
> >>>>>>>>.__btrfs_abort_transaction+0x17c/0x190 (unreliable) [c000000079a4b7a0]
> >>>>>>>>[c000000000541678] .__btrfs_run_delayed_items+0xe8/0x220
> >>>>>>>>[c000000079a4b850] [c0000000004d5b3c]
> >>>>>>>>.btrfs_commit_transaction+0x37c/0xca0 [c000000079a4b960]
> >>>>>>>>[c00000000049824c] .btrfs_sync_fs+0x6c/0x1a0
> >>>>>>>>[c000000079a4ba00] [c000000000255270] .sync_filesystem+0xd0/0x100
> >>>>>>>>[c000000079a4ba80] [c000000000218070]
> >>>>>>>>.generic_shutdown_super+0x40/0x170
> >>>>>>>>[c000000079a4bb10] [c000000000218598] .kill_anon_super+0x18/0x30
> >>>>>>>>[c000000079a4bb90] [c000000000498418] .btrfs_kill_super+0x18/0xc0
> >>>>>>>>[c000000079a4bc10] [c000000000218ac8]
> >>>>>>>>.deactivate_locked_super+0x98/0xe0
> >>>>>>>>[c000000079a4bc90] [c00000000023e744] .cleanup_mnt+0x54/0xa0
> >>>>>>>>[c000000079a4bd10] [c0000000000b7d14] .task_work_run+0x114/0x150
> >>>>>>>>[c000000079a4bdb0] [c000000000015f84] .do_notify_resume+0x74/0x80
> >>>>>>>>[c000000079a4be30] [c000000000009838] .ret_from_except_lite+0x64/0x68
> >>>>>>>>Instruction dump:
> >>>>>>>>ebc1fff0 ebe1fff8 4bfffb28 60000000 3ce2ffcd 38e7e818 4bffffbc
> >>>>>>>>3c62ffd2
> >>>>>>>>7fa4eb78 3863b808 48589e1d 60000000 <0fe00000> 4bfffedc 60000000
> >>>>>>>>60000000
> >>>>>>>>BTRFS: error (device dm-0) in __btrfs_run_delayed_items:1188: errno=-5
> >>>>>>>>IO
> >>>>>>>>failure
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>The call trace is seen when executing _run_test() for the 8th time.
> >>>>>>>>The above trace is actually a false-positive failure as indicated
> >>>>>>>>below,
> >>>>>>>>
> >>>>>>>>  fsync-tester
> >>>>>>>>
> >>>>>>>>    fsync(fd)
> >>>>>>>>    Write delayed inode item to fs tree
> >>>>>>>>
> >>>>>>>>      (assume transid to be 160)
> >>>>>>>>      (assume tree block to start at logical address 29720576)
> >>>>>>>>
> >>>>>>>>  md5sum $testfile
> >>>>>>>>
> >>>>>>>>    This causes a delayed inode to be added
> >>>>>>>>
> >>>>>>>>  Load flakey table
> >>>>>>>>
> >>>>>>>>    i.e. drop writes that are initiated from now onwards
> >>>>>>>>
> >>>>>>>>  Unmount filesystem
> >>>>>>>>
> >>>>>>>>    btrfs_sync_fs is invoked
> >>>>>>>>
> >>>>>>>>      Write 29720576 metadata block to disk
> >>>>>>>>      free_extent_buffer(29720576)
> >>>>>>>>
> >>>>>>>>        release_extent_buffer(29720576)
> >>>>>>>>
> >>>>>>>>    Start writing delayed inode
> >>>>>>>>
> >>>>>>>>      Traverse the fs tree
> >>>>>>>>
> >>>>>>>>        (assume the parent tree block of 29720576 is still in memory)
> >>>>>>>>        When reading 29720576 from disk, parent's blkptr will have
> >>>>>>>>        generation
> >>>>>>>>        set to 160. But the on-disk tree block will have an older
> >>>>>>>>        generation (say, 158). Transid verification fails and hence
> >>>>>>>>        the
> >>>>>>>>        transaction gets aborted
> >>>>>>>>
> >>>>>>>>The test only cares about the FS instance before the unmount
> >>>>>>>>operation (i.e. the synced FS). Hence to get the test to pass, ignore
> >>>>>>>>the
> >>>>>>>>false-positive trace that could be generated.
> >>>>>>>>
> >>>>>>>>Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> >>>>>>>>---
> >>>>>>>>
> >>>>>>>>  tests/generic/311 | 2 ++
> >>>>>>>>  1 file changed, 2 insertions(+)
> >>>>>>>>
> >>>>>>>>diff --git a/tests/generic/311 b/tests/generic/311
> >>>>>>>>index d21b6eb..cd6391d 100755
> >>>>>>>>--- a/tests/generic/311
> >>>>>>>>+++ b/tests/generic/311
> >>>>>>>>@@ -64,6 +64,8 @@ _require_xfs_io_command "falloc"
> >>>>>>>>
> >>>>>>>>  [ -x $here/src/fsync-tester ] || _notrun "fsync-tester not built"
> >>>>>>>>
> >>>>>>>>+_disable_dmesg_check
> >>>>>>>>+
> >>>>>>>
> >>>>>>>Hmm, I don't think this is something we'd want to do unconditionally.
> >>>>>>>E.g., if something hits the logs for xfs or ext4, we probably want to
> >>>>>>>hear about it.
> >>>>>>
> >>>>>>Sorry, I forgot that I was dealing with generic tests. I agree with what
> >>>>>>you say.
> >>>>>>
> >>>>>>>Perhaps check that the fs is btrfs and possibly the fs params are such
> >>>>>>>that the known warning occurs..? I'd defer to the btrfs folks on how
> >>>>>>>best to check that, so long as it doesn't affect other fs'.
> >>>>>>
> >>>>>>The above trace is independent of any Btrfs parameters. Its just that it
> >>>>>>was easily reproducible on ppc64 with the subpagesize-blocksize
> >>>>>>patchset applied. So IMHO disabling call trace check when testing Btrfs
> >>>>>>filesystem is the way to go. But again, as you said, we can wait for
> >>>>>>comments from other Btrfs devs.
> >>>>>
> >>>>>As a general principle, we don't disable warnings/errors in tests
> >>>>>just to make tests pass.  The bug in the code being tested should be
> >>>>>fixed so the warning/error is not generated. If you do not want
> >>>>>to see the error, then expung the test from your
> >>>>>subpagesize-blocksize test runs.
> >>>>
> >>>>The same problem would happen if you did echo 3>
> >>>>/proc/sys/vm/drop_caches right after dropping writes before doing
> >>>>the unmount.
> >>>
> >>>Nice, you have multiple ways of reproducing the problem....
> >>
> >>Dave, Apologies if I am sounding repetitive. The call trace that is showing up
> >>when executing the test isn't indicating a failure in Btrfs' code. Its a
> >>result of,
> >>
> >>1. Perform fsync(fd).
> >>2. Load dm-flakey.
> >>    i.e. drop writes from now onwards.
> >>3. Write a dirty metadata btree block to disk.
> >>    The data however doesn't reach the disk. The corresponding block on disk
> >>    still has old data.
> >
> >What needs to be written? The fsync should have written everything
> >that was needed to give a consistent filesystem on disk after a
> >unmount/mount cycle.
> >
> >>4. Evict the btree block from memory.
> >
> >... then removing the dirty objects from memory (!!!!!)...
> >
> >>5. Read the btree block from disk.
> >>    Verification of the btree block read from the disk fails since the
> >>    transaction id expected from the btree block is different from the one
> >>    stored in the parent btree block. This causes the transaction to be aborted
> >>    and hence a call trace gets printed.
> >
> >.... and failing later because the on-disk metadata is stale due to
> >the earlier write failure and subsequent dirty memory object
> >eviction..
> >
> >> From the above we see that there is no issue in Btrfs. The code in fact is
> >>doing the right thing by aborting the transaction. Unfortunately the test
> >>notices the call trace in dmesg and gets marked as a failure.
> >
> >[...]
> >
> >>IMHO the problem lies in the test i.e. the test assumes that a btree block
> >>that was written to the disk after dm-flakey was loaded (with write operations
> >>being dropped) would never be evicted from memory and re-read again.
> >
> >The test is making a pretty valid assumption - a fundamental
> >principle in filesystem design: never free dirty objects cached in
> >memory until it they are safe on disk and marked clean by IO
> >completion.  i.e. freeing dirty in-memory metadata objects that have
> >not been written back will *always* result in a corrupt filesystem
> >structure on disk that will be tripped over on the next cold read of
> >the metadata.
> >
> >The elephant in the room: btrfs is a COW filesystem. How does it end
> >up with a stale metadata pointer in the btree when the last write of
> >the COW update is to change the superblock to point at the new,
> >completely written, consistent-on-disk btree?
> >
> >And if btrfs is allowing inconsistent btrees to be seen on disk
> >(which should never happen with COW), why is that a problem of the
> >test (ie. the messenger) rather than the filesystem?
> >
> >Josef, Chris, is this really how btrfs handles metadata write
> >failures? This handling of errors seems like a design flaw rather
> >than a desireable behaviour to me....
> >
> 
> Jeeze you are cranky Dave, lets think about what this test is doing.

Do you really see anything above that indicates I'm cranky? I'm just
following the logic as i read it, reaching a conclusion and the
saying "this doesn't sound right - can an expert please confirm I've
got this right?".  Last thing I expected was to be shouted at and
treated like an idiot.

BTW, you'll know when I'm cranky - swearing is a real good
indication that I'm pissed off at something or someone.

> write shit to fs
> fsync said shit
> drop all writes from this point onwards
> unmount file system
> 
> This test is to verify that "said shit" is on disk after an fsync.
> The "drop all writes from this point onwards" does this silently.
> We assume when the device told us that any writes that we did
> completed successfully that they actually completed successfully.

Sorry, I forgot it dm-flakey didn't return errors. My mistake - I
don't look at dm-flakey very often as the tests don't fail on XFS
very often.

BTW, doesn't such an obviously ludicrous mistake (in hindsight)
indicate to you that I simply forgot how dm-flakey behaves? I make
mistakes all the time; don't you forget how things work after not
looking at them for months at a time?

i.e.  asking "have you forgotten that dm-flakey completes writes
without errors?" would have been a much better reply than ranting,
shouting, swearing and treating people like they are idiots.

> In Chandan's case his metadata is being evicted from memory so it
> has to be read back during this point _after_ the drop all writes
> stuff.

At last - a clear explanation of the root cause.  The patch
description makes no mention of read after memory reclaim, and you
only described the problem caused by dropping caches as a "race"
without actually explaining what the race was.

The above two lines is such a simple, obvious description of the
problem that is clear to most fs developers. If the patch had the
above description, then I don't think anyone would have
misunderstood it. However, it was completely obfuscated by
lots of nitty, gritty details about confusing btrfs symptoms and
behaviour and so left us needing to try to understand what btrfs
is doing or not doing.

A better description of the problem would have saved a lot of time
(and the rest of us from an unnecessary shouty rant).

> This is part of the reason for dm-log-writes, to solve this kind of
> shitty situation that dm-flakey introduces.

Which you've also never explained in any of the dm-log-write patches
you've posted in the past.  IOWs, get the dm-log-writes support code
reviewed and fix the dm-flakey tests to use it so this problem goes
away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
