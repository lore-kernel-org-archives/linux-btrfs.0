Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41866 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbcFVBw5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 21:52:57 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 0E9E341C0B81
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 09:48:43 +0800 (CST)
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
To: <linux-btrfs@vger.kernel.org>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <577f07dc-cf92-992b-3c9e-bfd2f321e416@cn.fujitsu.com>
Date: Wed, 22 Jun 2016 09:48:42 +0800
MIME-Version: 1.0
In-Reply-To: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the long-waited (simple and theoretical) performance test for 
dedupe.

Such result may be added to btrfs wiki page, as an advice for dedupe use 
case.

The full result can be check from google drive:
https://drive.google.com/file/d/0BxpkL3ehzX3pb05WT1lZSnRGbjA/view?usp=sharing

[Short Conclusion]
For high dedupe rate and easily compressible data,
if cpu cores >= 4, dedupe speed is on par with lzo compression,
and faster than default dd, about 35% faster.

if cpu == 2, lzo compression is faster than dedupe, but both faster than 
default dd.

For cpu == 1, lzo compression is on par with SAS HDD, while dedupe is 
slower than default dd.

[Test Platform]
The test platform is Fujitsu PRIMERGY RX300 S7.
CPU: Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz (2 nodes)
Memory: 32G, while limited to 8G in performace tests
Disk: 300G SAS HDDs with hardware RAID 5/6

[Test method]
Just do 40G buffered write into a new btrfs.
Since it's 5 times(in fact 7 times, since only 5.7G available memory) 
the total usable memory, flush will happen several times.

dd if=/dev/zero bs=1M count=40960 of=/mnt/btrfs/out

[Future plan]
More tests on less theoretical cases, like low-to-medium dedup rate.
Which may leads to slower performance than raw dd.

Considering lzo is already the fastest compression method btrfs provides 
yet, SHA512 should make dedupe even faster, faster than compression.

Also, current dedupe is splitting dealloc range into 512K segments 
first, then split into 128K (default dedupe size) and balance hash work 
into different CPUs, so for smaller dedupe block size, dedupe should be 
faster and take full usage of all CPUs.

Thanks,
Qu


At 06/15/2016 10:09 AM, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux.git wang_dedupe_20160524
>
> In this update, the patchset goes through another re-organization along
> with other fixes to address comments from community.
> 1) Move on-disk backend and dedupe props out of the patchset
>    Suggested by David.
>    There is still some discussion on the on-disk format.
>    And dedupe prop is still not 100% determined.
>
>    So it's better to focus on the current in-memory backend only, which
>    doesn't bring any on-disk format change.
>
>    Once the framework is done, new backends and props can be added more
>    easily.
>
> 2) Better enable/disable and buffered write race avoidance
>    Inspired by Mark.
>    Although in previous version, we didn't trigger it with our test
>    case, but if we manually add delay(5s) to __btrfs_buffered_write(),
>    it's possible to trigger disable and buffered write race.
>
>    The cause is, there is a windows between __btrfs_buffered_write() and
>    btrfs_dirty_pages().
>    In that window, sync_filesystem() can return very quickly since there
>    is no dirty page.
>    During that window, dedupe disable can happen and finish, and
>    buffered writer may access to the NULL pointer of dedupe info.
>
>    Now we use sb->s_writers.rw_sem to wait all current writers and block
>    further writers, then sync the fs, change dedupe status and finally
>    unblock writers. (Like freeze)
>    This provides clearer logical and code, and safer than previous
>    method, because there is no windows before we dirty pages.
>
> 3) Fix ENOSPC problem with better solution.
>    Pointed out by Josef.
>    The last 2 patches from Wang fixes ENOSPC problem, in a more
>    comprehensive method for delalloc metadata reservation.
>    Alone with small outstanding extents improvement, to co-operate with
>    tunable max extent size.
>
> Now the whole patchset will only add in-memory backend as a whole.
> No other backend nor prop.
> So we can focus on the framework itself.
>
> Next version will focus on ioctl interface modification suggested by
> David.
>
> Thanks,
> Qu
>
> Changelog:
> v2:
>   Totally reworked to handle multiple backends
> v3:
>   Fix a stupid but deadly on-disk backend bug
>   Add handle for multiple hash on same bytenr corner case to fix abort
>   trans error
>   Increase dedup rate by enhancing delayed ref handler for both backend.
>   Move dedup_add() to run_delayed_ref() time, to fix abort trans error.
>   Increase dedup block size up limit to 8M.
> v4:
>   Add dedup prop for disabling dedup for given files/dirs.
>   Merge inmem_search() and ondisk_search() into generic_search() to save
>   some code
>   Fix another delayed_ref related bug.
>   Use the same mutex for both inmem and ondisk backend.
>   Move dedup_add() back to btrfs_finish_ordered_io() to increase dedup
>   rate.
> v5:
>   Reuse compress routine for much simpler dedup function.
>   Slightly improved performance due to above modification.
>   Fix race between dedup enable/disable
>   Fix for false ENOSPC report
> v6:
>   Further enable/disable race window fix.
>   Minor format change according to checkpatch.
> v7:
>   Fix one concurrency bug with balance.
>   Slightly modify return value from -EINVAL to -EOPNOTSUPP for
>   btrfs_dedup_ioctl() to allow progs to distinguish unsupported commands
>   and wrong parameter.
>   Rebased to integration-4.6.
> v8:
>   Rename 'dedup' to 'dedupe'.
>   Add support to allow dedupe and compression work at the same time.
>   Fix several balance related bugs. Special thanks to Satoru Takeuchi,
>   who exposed most of them.
>   Small dedupe hit case performance improvement.
> v9:
>   Re-order the patchset to completely separate pure in-memory and any
>   on-disk format change.
>   Fold bug fixes into its original patch.
> v10:
>   Adding back missing bug fix patch.
>   Reduce on-disk item size.
>   Hide dedupe ioctl under CONFIG_BTRFS_DEBUG.
> v11:
>   Remove other backend and props support to focus on the framework and
>   in-memory backend. Suggested by David.
>   Better disable and buffered write race protection.
>   Comprehensive fix to dedupe metadata ENOSPC problem.
>
> Qu Wenruo (3):
>   btrfs: delayed-ref: Add support for increasing data ref under spinlock
>   btrfs: dedupe: Inband in-memory only de-duplication implement
>   btrfs: relocation: Enhance error handling to avoid BUG_ON
>
> Wang Xiaoguang (10):
>   btrfs: dedupe: Introduce dedupe framework and its header
>   btrfs: dedupe: Introduce function to initialize dedupe info
>   btrfs: dedupe: Introduce function to add hash into in-memory tree
>   btrfs: dedupe: Introduce function to remove hash from in-memory tree
>   btrfs: dedupe: Introduce function to search for an existing hash
>   btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
>   btrfs: ordered-extent: Add support for dedupe
>   btrfs: dedupe: Add ioctl for inband dedupelication
>   btrfs: improve inode's outstanding_extents computation
>   btrfs: dedupe: fix false ENOSPC
>
>  fs/btrfs/Makefile           |   2 +-
>  fs/btrfs/ctree.h            |  25 +-
>  fs/btrfs/dedupe.c           | 710 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/dedupe.h           | 210 +++++++++++++
>  fs/btrfs/delayed-ref.c      |  30 +-
>  fs/btrfs/delayed-ref.h      |   8 +
>  fs/btrfs/disk-io.c          |   4 +
>  fs/btrfs/extent-tree.c      |  83 +++++-
>  fs/btrfs/extent_io.c        |  63 +++-
>  fs/btrfs/extent_io.h        |  15 +-
>  fs/btrfs/file.c             |  26 +-
>  fs/btrfs/free-space-cache.c |   5 +-
>  fs/btrfs/inode-map.c        |   4 +-
>  fs/btrfs/inode.c            | 434 ++++++++++++++++++++++-----
>  fs/btrfs/ioctl.c            |  80 ++++-
>  fs/btrfs/ordered-data.c     |  46 ++-
>  fs/btrfs/ordered-data.h     |  14 +
>  fs/btrfs/relocation.c       |  46 ++-
>  fs/btrfs/sysfs.c            |   2 +
>  include/uapi/linux/btrfs.h  |  41 +++
>  20 files changed, 1701 insertions(+), 147 deletions(-)
>  create mode 100644 fs/btrfs/dedupe.c
>  create mode 100644 fs/btrfs/dedupe.h
>


