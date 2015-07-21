Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37084 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbbGUOLx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 10:11:53 -0400
Received: by wibud3 with SMTP id ud3so128951523wib.0
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 07:11:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150713170234.GB17513@ret.masoncoding.com>
References: <D9085F65B8B44087B5F6144AC9356BBB@alyakaslap>
	<CAL3q7H6Escicg5PWCd4gw_88TXTEWznqBKRGES0f0gzTU-=HeQ@mail.gmail.com>
	<CAOcd+r3x3vprnMLFzhX4XBt12dq26DCBmHLiDz-z9YvVOKx-Ww@mail.gmail.com>
	<20150713170234.GB17513@ret.masoncoding.com>
Date: Tue, 21 Jul 2015 16:11:51 +0200
Message-ID: <CAOcd+r0z2cyNMkGLvzr8WfW7u5syvqM+cf=eZbtc9qaLv7Vk3Q@mail.gmail.com>
Subject: Re: question about should_cow_block() and BTRFS_HEADER_FLAG_WRITTEN
From: Alex Lyakas <alex@zadarastorage.com>
To: Chris Mason <clm@fb.com>, Alex Lyakas <alex@zadarastorage.com>,
        Filipe Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Shyam Kaushik <shyam@zadarastorage.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe, Chris,

I did more profiling work, and I want to writeup some of the things I
noticed. Hopefully it has some value for the community.

# btrfs_transaction.dirty_pages:
This "extent_io_tree" includes every eb created by
btrfs_init_new_buffer (this is the only function that adds dirty
extents there). But sometimes such eb is marked back as clean
(clean_tree_block), but is not removed from
btrfs_transaction.dirty_pages. So I think
btrfs_write_and_wait_transaction triggers a writeout for such ebs as
well, although they are not marked as dirty, so probably this won't do
anything. I don't know if this may cause any issue.

# btrfs_fs_info.dirty_metadata_bytes
This accounts dirty metadata per filesystem, not per particular
transaction. Because we may have transaction X in
btrfs_write_and_wait_transaction, and transaction X+1 creating dirty
ebs. This is probably intended.

# btrfs_init_new_buffer
I was trying to account exact amount of dirty ebs per transaction.
Obviously, any such dirty eb would be always created by this function.
And I was trying to compare the amount of ebs created by this function
vs the amount of ebs written out by write_one_eb.
I am aware that a particular eb can be freed in the same transaction
via btrfs_free_tree_block() either pinning it, or directly dropping it
back to the free-space cache. I am also aware that delayed references
may cancel one another, and run_one_delayed_ref() may pin the eb
without doing any extent tree update. I am also aware about VM
writeback happening via btree_writepages, thus requiring to re-COW
some of the ebs.
Still the total amount of metadata written by a particular transaction
is less than the total amount of ebs created by btrfs_init_new_buffer,
taking into account all the cases I mentioned above. I guess that
clean_tree_block() is the culprit, but I am not sure what happens to
such "cleaned" eb. It just remains in btree_inode page cache? Or it is
freed by some path I an unaware of?

# should_cow_block() + BTRFS_HEADER_FLAG_WRITTEN causing a re-COW of a
tree block
Chris, you mention that btrfs should be skipping memory pressure
writeback if there is not much dirty metadata. I guess you mean
BTRFS_DIRTY_METADATA_THRESH checked in btree_writepages, and also
skipping "for_kupdate" writeback. Grepping through kernel sources, I
see that btree_writepages should never see for_reclaim bit set,
because for that the btree_inode needs to provide the "writepage"
callback, but it only provides "writepages". (for_reclaim is set by
vmscan.c::pageout and migrate.c::writeout, which both require
"writepage" if I am seeing correctly).
So except for explicit writeback requests, btree_writepages should see
only the "for_background" writeback, which is mostly controlled by
dirty_background_ratio/dirty_background_bytes as I understand (not by
memory pressure).
Anyways, I disabled the WB_SYNC_NONE fully, and indeed was not seeing
any re-COWs. But on the other hand, I had few OOM panics, when dirty
metadata grew to several GBs.

# global_block_rsv and update_global_block_rsv
I don't fully understand what calc_global_metadata_size() is trying to
do, But I think once metadata size is above couple of GBs, then
update_global_block_rsv will always refill global_block_rsv back to
512Mb, as it does:
block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
and then bumps up "reserved" to "size".
As a result, should_end_transaction() will tell us that we need to
start a commit when we grab half of that, i.e., 256MB or more, from
global_block_rsv. This seems very reasonable, as we really don't want
to have more dirty metadata than that in a single transaction.
However, we might call update_global_block_rsv() on different
occasions, and every such call will bump it back to 512MB. So for
example, we create a new data block group, and then
btrfs_make_block_group will call update_global_block_rsv, allowing us
to dirty more metadata before we commit.
This seems a bit strange, why we are bumping it back and suddenly
allowing more updates to come in?

# run_delayed_refs by the commit thread
I see that the current spirit is that when somebody detaches from a
transaction by btrfs_end_transaction, we don't want to delay it for
too long.
So even if must_run_delayed_refs==1, we will run at most 32 delayed refs:
cur = max_t(unsigned long, cur, 32)
As a result, when we trigger a commit we might have tens of thousands
of delayed refs, to be run by the commit thread. The commit thread
calls
btrfs_run_delayed_refs several times, before it reaches the critical
section (TRANS_STATE_COMMIT_DOING), where we don't allow anybody to
join it.

Profiling these run_delayed_refs calls shows that they are slow due to:
- we need to read the extent tree blocks from disk[1] in order to
update the extent tree (read_extent_buffer_pages), and there is only
one thread reading them sequentially (the commit thread).
- before we get to the critical section of the commit, we can have
other threads also running delayed refs, so the commit thread needs to
compete on tree-block
locks with them (and they hold the locks because they also read tree
blocks from disk as it seems)

So my question is shouldn't we be much more aggressive in
__btrfs_end_transaction, running delayed refs several times and
checking trans->delayed_ref_updates after each run, and return only if
this number is zero or small enough.
This way when we trigger a commit, it will not have a lot of delayed
refs to run, it will get very quickly to the critical section, pass it
hopefully very quickly (get to TRANS_STATE_UNBLOCKED), and then we can
open a new transaction while the previous is doing
btrfs_write_and_wait_transaction.
That's what I wanted to ask.

Thanks!
Alex.


[1] In my case, btrfs metadata is ~10GBs and the machine has 8GB of
RAM. Due to this we need to read a lot of ebs from disk, as they are
not in the page cache. Also need to keep in mind that every COW of eb
requires a new slot in the page cache, because we index by "bytenr"
that we receive from the free-space cache, which is a "logical"
coordinate by which EXTENT_ITEMs are sorted in the extent tree.



On Mon, Jul 13, 2015 at 7:02 PM, Chris Mason <clm@fb.com> wrote:
> On Mon, Jul 13, 2015 at 06:55:29PM +0200, Alex Lyakas wrote:
>> Filipe,
>> Thanks for the explanation. Those reasons were not so obvious for me.
>>
>> Would it make sense not to COW the block in case-1, if we are mounted
>> with "notreelog"? Or, perhaps, to check that the block does not belong
>> to a log tree?
>>
>
> Hi Alex,
>
> The crc rules are the most important, we have to make sure the block
> isn't changed while it is in flight.  Also, think about something like
> this:
>
> transaction write block A, puts pointer to it in the btree, generation Y
>
> <hard disk properly completes the IO>
>
> transaction rewrites block A, same generation Y
>
> <hard disk drops the IO on the floor and never does it>
>
> Later on, we try to read block A again.  We find it has the correct crc
> and the correct generation number, but the contents are actually wrong.
>
>> The second case is more difficult. One problem is that
>> BTRFS_HEADER_FLAG_WRITTEN flag ends up on disk. So if we write a block
>> due to memory pressure (this is what I see happening), we complete the
>> writeback, release the extent buffer, and pages are evicted from the
>> page cache of btree_inode. After some time we read the block again
>> (because we want to modify it in the same transaction), but its header
>> is already marked as BTRFS_HEADER_FLAG_WRITTEN on disk. Even though at
>> this point it should be safe to avoid COW, we will re-COW.
>>
>> Would it make sense to have some runtime-only mechanism to lock-out
>> the write-back for an eb? I.e., if we know that eb is not under
>> writeback, and writeback is locked out from starting, we can redirty
>> the block without COW. Then we allow the writeback to start when it
>> wants to.
>>
>> In one of my test runs, btrfs had 6.4GB of metadata (before
>> raid-induced overhead), but during a particular transaction total of
>> 10GB of metadata (again, before raid-induced overhead) was written to
>> disk. (Thisis  total of all ebs having
>> header->generation==curr_transid, not only during commit of the
>> transaction). This particular run was with "notreelog".
>>
>> Machine had 8GB of RAM. Linux allows the btree_inode to grow its
>> page-cache upto ~6.9GB (judging by btree_inode->i_mapping->nrpages).
>> But even though the used amount of metadata is less than that, this
>> re-COW'ing of already-COW'ed blocks seems to cause page-cache
>> trashing...
>
> Interesting.  We've addressed this in the past with changes to the
> writepage(s) callback for the btree, basically skipping memory pressure
> related writeback if there isn't that much dirty.  There is a lot of
> room to improve those decisions, like preferring to write leaves over
> nodes, especially full leaves that are not likely to change again.
>
> -chris
