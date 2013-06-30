Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54367 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3F3I3Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 04:29:16 -0400
Received: by mail-wi0-f179.google.com with SMTP id hj3so2157130wib.6
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 01:29:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r1smWp=r2GO6CY3sp2ggpaUkkBKuc9K+rye1kywg3Tfaw@mail.gmail.com>
References: <CAOcd+r1=aZ-jBcTxgmxU5BiFGCG_10c_vouK6OE=wmG6o8++3g@mail.gmail.com>
	<20130624162401.GJ4288@localhost.localdomain>
	<CAOcd+r3OA4TW6XKBW73uDWGBbQmgma=ZV1ULkH8P8OAVA63_nQ@mail.gmail.com>
	<CAOcd+r1smWp=r2GO6CY3sp2ggpaUkkBKuc9K+rye1kywg3Tfaw@mail.gmail.com>
Date: Sun, 30 Jun 2013 11:29:14 +0300
Message-ID: <CAOcd+r0kx7_vdSjRrr48bZRkDcr2Ryyoc3GXVNpXgwZf-SkO3g@mail.gmail.com>
Subject: Re: question about transaction-abort-related commits
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shyam Kaushik <shyam@zadarastorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Wed, Jun 26, 2013 at 5:16 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
> Hi Josef,
> Can you please help me with another question.
>
> I am looking at your patch:
> Btrfs: fix chunk allocation error handling
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0448748849ef7c593be40e2c1404f7974bd3aac6
>
> Here you changed the order of btrfs_make_block_group() vs
> btrfs_alloc_dev_extent(), because we could have allocated from the
> in-memory block group, before we have inserted the dev extent into a
> tree. However, with this fix, I hit the deadlock[1] of
> btrfs_alloc_dev_extent() that also wants to allocate a chunk and
> recursively calls do_chunk_alloc, but then is stuck on chunk_mutex.
>
> Was this patch:
> Btrfs: don't re-enter when allocating a chunk
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c6b305a89b1903d63652691ad5eb9f05aa0326b8
> introduced to fix this deadlock?

With these two patches ("Btrfs: fix chunk allocation error handling"
and "Btrfs: don't re-enter when allocating a chunk"), I am hitting
ENOSPC during metadata chunk allocation.

Upon entry into "do_chunk_alloc", I have only one METADATA block-group
as follows:
total_bytes=8388608
bytes_used=7938048
bytes_pinned=446464
bytes_reserved=4096
bytes_readonly=0
bytes_may_use=3362816

As we see bytes_used+bytes_pinned+bytes_reserved==total_bytes

What happens next is that within __btrfs_alloc_chunk():
- find_free_dev_extent() finds a free extent (metadata policy is SINGLE)
- btrfs_alloc_dev_extent() fails with ENOSPC

(btrfs_make_block_group() is called after btrfs_alloc_dev_extent()
with these patches).

What should be done in such situation, when there is not enough
METADATA to allocate a device extent item, but we still don't allow
allocating from the newly-created METADATA block group?

Thanks,
Alex.




>
> Thanks,
> Alex.
>
> [1]
> [<ffffffffa044e57d>] do_chunk_alloc+0x8d/0x510 [btrfs]
> [<ffffffffa04532ad>] find_free_extent+0x9cd/0xb90 [btrfs]
> [<ffffffffa0453510>] btrfs_reserve_extent+0xa0/0x1b0 [btrfs]
> [<ffffffffa0453bc9>] btrfs_alloc_free_block+0xf9/0x570 [btrfs]
> [<ffffffffa043d9e6>] __btrfs_cow_block+0x126/0x500 [btrfs]
> [<ffffffffa043dfba>] btrfs_cow_block+0x17a/0x230 [btrfs]
> [<ffffffffa04425b1>] btrfs_search_slot+0x381/0x820 [btrfs]
> [<ffffffffa044463c>] btrfs_insert_empty_items+0x7c/0x120 [btrfs]
> [<ffffffffa048f31b>] btrfs_alloc_dev_extent+0x9b/0x1c0 [btrfs]
> [<ffffffffa048f9ca>] __btrfs_alloc_chunk+0x58a/0x850 [btrfs]
> [<ffffffffa049239f>] btrfs_alloc_chunk+0xbf/0x160 [btrfs]
> [<ffffffffa044e81b>] do_chunk_alloc+0x32b/0x510 [btrfs]
> [<ffffffffa04532ad>] find_free_extent+0x9cd/0xb90 [btrfs]
> [<ffffffffa0453510>] btrfs_reserve_extent+0xa0/0x1b0 [btrfs]
> [<ffffffffa0453bc9>] btrfs_alloc_free_block+0xf9/0x570 [btrfs]
> [<ffffffffa043d9e6>] __btrfs_cow_block+0x126/0x500 [btrfs]
> [<ffffffffa043dfba>] btrfs_cow_block+0x17a/0x230 [btrfs]
> [<ffffffffa0441613>] push_leaf_right+0x133/0x1a0 [btrfs]
> [<ffffffffa0441d51>] split_leaf+0x5e1/0x770 [btrfs]
> [<ffffffffa04429b5>] btrfs_search_slot+0x785/0x820 [btrfs]
> [<ffffffffa0449c0e>] lookup_inline_extent_backref+0x8e/0x5b0 [btrfs]
> [<ffffffffa044a193>] insert_inline_extent_backref+0x63/0x130 [btrfs]
> [<ffffffffa044abaf>] __btrfs_inc_extent_ref+0x9f/0x240 [btrfs]
> [<ffffffffa0451841>] run_clustered_refs+0x971/0xd00 [btrfs]
> [<ffffffffa0455db0>] btrfs_run_delayed_refs+0xd0/0x330 [btrfs]
> [<ffffffffa0467a87>] __btrfs_end_transaction+0xf7/0x440 [btrfs]
> [<ffffffffa0467e20>] btrfs_end_transaction+0x10/0x20 [btrfs]
>
>
>
>
> On Mon, Jun 24, 2013 at 9:56 PM, Alex Lyakas
> <alex.btrfs@zadarastorage.com> wrote:
>>
>> Thanks for commenting Josef. I hope your head will get better:)
>> Actually, while re-looking at the code, I see that there are couple of
>> "goto cleanup;", before we ensure that all the writers have detached
>> from the committing transaction. So Liu's code is still needed, looks
>> like.
>>
>> Thanks,
>> Alex.
>>
>> On Mon, Jun 24, 2013 at 7:24 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>> > On Sun, Jun 23, 2013 at 09:52:14PM +0300, Alex Lyakas wrote:
>> >> Hello Josef, Liu,
>> >> I am reviewing commits in the mainline tree:
>> >>
>> >> e4a2bcaca9643e7430207810653222fc5187f2be Btrfs: if we aren't
>> >> committing just end the transaction if we error out
>> >> (call end_transaction() instead of goto cleanup_transaction) - Josef
>> >>
>> >> f094ac32aba3a51c00e970a2ea029339af2ca048 Btrfs: fix NULL pointer after
>> >> aborting a transaction
>> >> (wait until all writers detach, before setting running_transaction to
>> >> NULL) - Liu
>> >>
>> >> 66b6135b7cf741f6f44ba938b27583ea3b83bd12 Btrfs: avoid deadlock on
>> >> transaction waiting list
>> >> (check if transaction was already removed from the transactions list) -
>> >> Liu
>> >>
>> >> Josef, according to your fix, if the committer encounters a problem
>> >> early, it just doesn't commit. Instead it aborts the transaction
>> >> (possibly setting FS to read-only) and detaches from the transaction.
>> >> So if this was the only committer (e.g., the transaction_kthread),
>> >> then transaction commit will not happen at all. Is this what you
>> >> intended? So then the user will notice that FS went read-only, and she
>> >> will unmount the FS, and transaction will be cleaned up in
>> >> btrfs_error_commit_super()=>btrfs_cleanup_transaction(), and not in
>> >> cleanup_transaction() via btrfs_commit_transaction(). Is my
>> >> understanding correct?
>> >>
>> >> Liu, it looks like after having Josef's fix, the above two commits of
>> >> yours are not strictly needed, right? Because Josef's fix ensures that
>> >> only the "real" committer will call cleanup_transaction(), so at this
>> >> point there is only one writer attached to the transaction, which is
>> >> the committer itself (your fixes doesn't hurt though). Is that
>> >> correct?
>> >>
>> >
>> > I've looked at the patches and I'm going to say yes with the caveat that
>> > I
>> > stopped thinking about it when my head started hurting :).  Thanks,
>> >
>> > Josef
