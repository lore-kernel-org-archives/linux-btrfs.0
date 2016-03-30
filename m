Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32732 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758319AbcC3Aex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 20:34:53 -0400
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAOcd+r0kVY2odm_rzNUMf3MGVCaRh8aDnHiY+Eo3ceKOLNXSyA@mail.gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FB1F26.3030807@cn.fujitsu.com>
Date: Wed, 30 Mar 2016 08:34:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAOcd+r0kVY2odm_rzNUMf3MGVCaRh8aDnHiY+Eo3ceKOLNXSyA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Alex Lyakas wrote on 2016/03/29 19:22 +0200:
> Greetings Qu Wenruo,
>
> I have reviewed the dedup patchset found in the github account you
> mentioned. I have several questions. Please note that by all means I
> am not criticizing your design or code. I just want to make sure that
> my understanding of the code is proper.

It's OK to criticize the design or code, and that's how review works.

>
> 1) You mentioned in several emails that at some point byte-to-byte
> comparison is to be performed. However, I do not see this in the code.
> It seems that generic_search() only looks for the hash value match. If
> there is a match, it goes ahead and adds a delayed ref.

I mentioned byte-to-byte comparison as, "not to be implemented in any 
time soon".

Considering the lack of facility to read out extent contents without any 
inode structure, it's not going to be done in any time soon.

>
> 2) If btrfs_dedupe_search() does not find a match, we unlock the dedup
> mutex and proceed with the normal COW. What happens if there are
> several IO streams to different files writing an identical block, but
> we don't have such block in our dedup DB? Then all
> btrfs_dedupe_search() calls will not find a match, so all streams will
> allocate space for their block (which are all identical). At some
> point, they will call insert_reserved_file_extent() and will call
> btrfs_dedupe_add(). Since there is a global mutex, the first stream
> will insert the dedup hash entries into the DB, and all other streams
> will find that such hash entry already exists. So the end result is
> that we have the hash entry in the DB, but still we have multiple
> copies of the same block allocated, due to timing issues. Is this
> correct?

That's right, and that's also unavoidable for the hash initializing stage.

>
> 3) generic_search() competes with __btrfs_free_extent(). Meaning that
> generic_search() wants to add a delayed ref to an existing extent,
> whereas __btrfs_free_extent() wants to delete an entry from the dedup
> DB. The race is resolved as follows:
> - generic_search attempts to lock the delayed ref head
> - if it succeeds to lock, then __btrfs_free_extent() is not running
> right now. So we can add a delayed ref. Later, when delayed ref head
> will be run, it will figure out what needs to be done (free the extent
> or not)
> - if we fail to lock, then there is a delayed ref processing for this
> bytenr. We drop all locks and redo the search from the top. If
> __btrfs_free_extent() has deleted the dedup hash meanwhile, we will
> not find it, and proceed with normal COW.
> Is my understanding correct?

Yes that's correct.

>
> I have also few nitpicks on the code, will reply to relevant patches.

Feel free to comment.

Thanks,
Qu
>
> Thanks for doing this work,
> Alex.
>
>
>
> On Tue, Mar 22, 2016 at 3:35 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux.git wang_dedupe_20160322
>>
>> This updated version of inband de-duplication has the following features:
>> 1) ONE unified dedup framework.
>>     Most of its code is hidden quietly in dedup.c and export the minimal
>>     interfaces for its caller.
>>     Reviewer and further developer would benefit from the unified
>>     framework.
>>
>> 2) TWO different back-end with different trade-off
>>     One is the improved version of previous Fujitsu in-memory only dedup.
>>     The other one is enhanced dedup implementation from Liu Bo.
>>     Changed its tree structure to handle bytenr -> hash search for
>>     deleting hash, without the hideous data backref hack.
>>
>> 3) Support compression with dedupe
>>     Now dedupe can work with compression.
>>     Means that, a dedupe miss case can be compressed, and dedupe hit case
>>     can also reuse compressed file extents.
>>
>> 4) Ioctl interface with persist dedup status
>>     Advised by David, now we use ioctl to enable/disable dedup.
>>
>>     And we now have dedup status, recorded in the first item of dedup
>>     tree.
>>     Just like quota, once enabled, no extra ioctl is needed for next
>>     mount.
>>
>> 5) Ability to disable dedup for given dirs/files
>>     It works just like the compression prop method, by adding a new
>>     xattr.
>>
>> TODO:
>> 1) Add extent-by-extent comparison for faster but more conflicting algorithm
>>     Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
>>     CPU may even be a bottleneck other than IO.
>>     But for faster hash, it will definitely cause conflicts, so we need
>>     extent comparison before we introduce new dedup algorithm.
>>
>> 2) Misc end-user related helpers
>>     Like handy and easy to implement dedup rate report.
>>     And method to query in-memory hash size for those "non-exist" users who
>>     want to use 'dedup enable -l' option but didn't ever know how much
>>     RAM they have.
>>
>> Changelog:
>> v2:
>>    Totally reworked to handle multiple backends
>> v3:
>>    Fix a stupid but deadly on-disk backend bug
>>    Add handle for multiple hash on same bytenr corner case to fix abort
>>    trans error
>>    Increase dedup rate by enhancing delayed ref handler for both backend.
>>    Move dedup_add() to run_delayed_ref() time, to fix abort trans error.
>>    Increase dedup block size up limit to 8M.
>> v4:
>>    Add dedup prop for disabling dedup for given files/dirs.
>>    Merge inmem_search() and ondisk_search() into generic_search() to save
>>    some code
>>    Fix another delayed_ref related bug.
>>    Use the same mutex for both inmem and ondisk backend.
>>    Move dedup_add() back to btrfs_finish_ordered_io() to increase dedup
>>    rate.
>> v5:
>>    Reuse compress routine for much simpler dedup function.
>>    Slightly improved performance due to above modification.
>>    Fix race between dedup enable/disable
>>    Fix for false ENOSPC report
>> v6:
>>    Further enable/disable race window fix.
>>    Minor format change according to checkpatch.
>> v7:
>>    Fix one concurrency bug with balance.
>>    Slightly modify return value from -EINVAL to -EOPNOTSUPP for
>>    btrfs_dedup_ioctl() to allow progs to distinguish unsupported commands
>>    and wrong parameter.
>>    Rebased to integration-4.6.
>> v8:
>>    Rename 'dedup' to 'dedupe'.
>>    Add support to allow dedupe and compression work at the same time.
>>    Fix several balance related bugs. Special thanks to Satoru Takeuchi,
>>    who exposed most of them.
>>    Small dedupe hit case performance improvement.
>>
>> Qu Wenruo (12):
>>    btrfs: delayed-ref: Add support for increasing data ref under spinlock
>>    btrfs: dedupe: Inband in-memory only de-duplication implement
>>    btrfs: dedupe: Add basic tree structure for on-disk dedupe method
>>    btrfs: dedupe: Introduce interfaces to resume and cleanup dedupe info
>>    btrfs: dedupe: Add support for on-disk hash search
>>    btrfs: dedupe: Add support to delete hash for on-disk backend
>>    btrfs: dedupe: Add support for adding hash for on-disk backend
>>    btrfs: Fix a memory leak in inband dedupe hash
>>    btrfs: dedupe: Fix metadata balance error when dedupe is enabled
>>    btrfs: dedupe: Preparation for compress-dedupe co-work
>>    btrfs: relocation: Enhance error handling to avoid BUG_ON
>>    btrfs: dedupe: Fix a space cache delalloc bytes underflow bug
>>
>> Wang Xiaoguang (15):
>>    btrfs: dedupe: Introduce dedupe framework and its header
>>    btrfs: dedupe: Introduce function to initialize dedupe info
>>    btrfs: dedupe: Introduce function to add hash into in-memory tree
>>    btrfs: dedupe: Introduce function to remove hash from in-memory tree
>>    btrfs: dedupe: Introduce function to search for an existing hash
>>    btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
>>    btrfs: ordered-extent: Add support for dedupe
>>    btrfs: dedupe: Add ioctl for inband dedupelication
>>    btrfs: dedupe: add an inode nodedupe flag
>>    btrfs: dedupe: add a property handler for online dedupe
>>    btrfs: dedupe: add per-file online dedupe control
>>    btrfs: try more times to alloc metadata reserve space
>>    btrfs: dedupe: Fix a bug when running inband dedupe with balance
>>    btrfs: dedupe: Avoid submit IO for hash hit extent
>>    btrfs: dedupe: Add support for compression and dedpue
>>
>>   fs/btrfs/Makefile            |    2 +-
>>   fs/btrfs/ctree.h             |   78 ++-
>>   fs/btrfs/dedupe.c            | 1188 ++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/dedupe.h            |  181 +++++++
>>   fs/btrfs/delayed-ref.c       |   30 +-
>>   fs/btrfs/delayed-ref.h       |    8 +
>>   fs/btrfs/disk-io.c           |   28 +-
>>   fs/btrfs/disk-io.h           |    1 +
>>   fs/btrfs/extent-tree.c       |   49 +-
>>   fs/btrfs/inode.c             |  338 ++++++++++--
>>   fs/btrfs/ioctl.c             |   70 ++-
>>   fs/btrfs/ordered-data.c      |   49 +-
>>   fs/btrfs/ordered-data.h      |   16 +-
>>   fs/btrfs/props.c             |   41 ++
>>   fs/btrfs/relocation.c        |   41 +-
>>   fs/btrfs/sysfs.c             |    2 +
>>   include/trace/events/btrfs.h |    3 +-
>>   include/uapi/linux/btrfs.h   |   25 +-
>>   18 files changed, 2073 insertions(+), 77 deletions(-)
>>   create mode 100644 fs/btrfs/dedupe.c
>>   create mode 100644 fs/btrfs/dedupe.h
>>
>> --
>> 2.7.3
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


