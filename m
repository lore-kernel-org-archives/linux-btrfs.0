Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52801 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbaFSJqr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 05:46:47 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so1994124wgg.8
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 02:46:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53553172.9030309@fb.com>
References: <53553172.9030309@fb.com>
Date: Thu, 19 Jun 2014 12:46:46 +0300
Message-ID: <CAOcd+r3BQJQ61P3FfwyA8_QT5Ov_F3iktf86A_a5gra-6JeQUw@mail.gmail.com>
Subject: Re: Snapshot aware defrag and qgroups thoughts
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
thanks for the detailed description of how the extent tree works!
When I was digging through that in the past, I made some slides to
remember all the call chains. Maybe somebody finds that useful to
accompany your notes.
https://drive.google.com/file/d/0ByBy89zr3kJNNmM5OG5wXzQ3LUE/edit?usp=sharing

Thanks,
Alex.


On Mon, Apr 21, 2014 at 5:55 PM, Josef Bacik <jbacik@fb.com> wrote:
> We have a big problem, but it involves a lot of moving parts, so I'm going
> to
> explain all of the parts, and then the problem, and then what I am doing to
> fix
> the problem.  I want you guys to check my work to make sure I'm not missing
> something so when I come back from paternity leave in a few weeks I can just
> sit
> down and finish this work out.
>
> ===== Extent refs =======
>
> This is basically how extent refs work.  You have either
>
> key.objectid = bytenr;
> key.type = BTRFS_EXTENT_ITEM_KEY;
> key.offset = length;
>
> or you have
>
> key.objectid = bytenr;
> key.type = BTRFS_METADATA_ITEM_KEY;
> key.offset = level of the metadata block;
>
> in the case of skinny metadata.  Then you have the extent item which
> describes
> the number of refs and such, followed by 1 or more inline refs.  All you
> need
> to know for this problem is how I'm going to describe them.  What I call a
> "normal ref" or a "full ref" is a reference that has the actual root
> information
> in the ref.  What I call a "shared ref" is one where we only know the tree
> block
> that owns the particular ref.  So how does this work in practice?
>
> 1) Normal allocation - metadata:  We allocate a tree block as we add new
> items
> to a tree.  We know that this root owns this tree block so we create a
> normal
> ref with the root objectid in the extent ref.  We also set the owner of the
> block itself to our objectid.  This is important to keep in mind.
>
> 2) Normal allocaiton - data: We allocate some data for a given fs tree and
> we
> add a extent ref with the root objectid of the tree we are in, the inode
> number
> and the logical offset into the inode for this inode.
>
> 3) Splitting a data extent: We write to the middle of an existing extent.
> We
> will split this extent into two BTRFS_EXTENT_DATA_KEY items and the increase
> the
> ref count of the original extent by 1.  This means we look up the extent ref
> for
> root->objectid, inode number and the _original_ inode offset.  We don't
> create
> another extent ref, this is important to keep in mind.
>
> ===== btrfs_copy_root/update_ref_for_cow/btrfs_inc_ref/btrfs_dec_ref =====
>
> But Josef, didn't you say there were shared refs?  Why yes I did, but I need
> to
> explain it in context of the people who actually do the dirty work. We'll
> start
> with the easy case
>
> 1) btrfs_copy_root - where snapshots start:  When we make a snapshot we call
> this function, which allocates a completely new block with a new root
> objectid
> and then memcpy's the original root we are snapshotting.  Then we call
> btrfs_inc_ref on our new buffer, which will walk all items in that buffer
> and
> add a new normal ref to each of those blocks for our new root.  This is only
> at
> the level below the new root, nothing below that point.
>
> 2) btrfs_inc_ref/btrfs_dec_ref - how we deal with snapshots: These guys are
> responsible for dealing with the particular action we want to make on our
> given
> buffer.  So if we are free'ing our buffer, we need to drop any refs it has
> to
> the blocks it points to.  For level > 0 this means modifying refs for all of
> the
> tree blocks it points to.  For level == 0 this means modifying refs for any
> data
> extents the leaf may point to.
>
> 3) update_ref_for_cow - this is where the magic happens:  This has a few
> different modes of operation, but every operation means we check to see if
> the
> block is shared, which is we see if we have been snapshotted and if we have
> been
> see if this block has changed since we snapshotted.  If it is shared then we
> look up the extent refs and the flags.  If not then we carry on. From here
> we
> have a few options.
>
> 3a) Not shared: Don't do anything, we can do our normal cow operations and
> carry
> on.
>
> 3b) Shared and cowing from the owning root: This is where the
> btrfs_header_owner() is important.  If we owned this block and it is shared
> then
> we know that any of the upper levels won't have a normal ref to anything
> underneath this block, so we need to add a shared ref for anything this
> block
> points to.  So the first thing we do is btrfs_inc_ref(), but we set the full
> backref flag.  This means that when we add refs for everything this block
> points
> to we don't use a root objectid, we use the bytenr of this block. Then we
> set
> BTRFS_BLOCK_FLAG_FULL_BACKREF for the extent flags for this give block.
>
> 3c) Shared and cowing from not the owning root: So if we are cowing down
> from
> the snapshot we need to make sure that any block we own completely ourselves
> has
> normal refs for any blocks it points to.  So we cow down and hit a shared
> block
> that we aren't the owner of, so we do btrfs_inc_ref() for our block and
> don't
> set full_backref so we get a normal ref on everything this block points to
> with
> our actual root objectid.
>
> 3d) Last ref but has FULL_BACKREF set: The last time we cow a block that was
> converted to a full backref from 3b.  This is where we call btrfs_inc_ref()
> without full_backref set so we get our normal root objectid ref added, and
> then
> we call btrfs_dec_ref() with full_backref set so that we remove the shared
> ref
> for this block since it is about to be deleted.
>
> ===== Delayed refs ======
>
> In order to make sure we don't recursively update the extent tree for every
> modification as we cow down a tree we have delayed refs.  Every time we
> modify
> the ref count of an extent (allocate, inc ref, free) we allocate a delayed
> ref
> with the information about that ref.  So every call to btrfs_inc_ref,
> btrfs_dec_ref, btrfs_allocate_tree_bloc, btrfs_alloc_reserved_file_extent,
> btrfs_free_extent all ends up allocating a delayed ref.  The nice thing
> about
> this is it can keep us from actually modifying the extent tree.  If we cow a
> block to free items and then subsequently free that block we can avoid
> touching
> the extent tree altogether for this.
>
> PROBLEM: For qgroups we needed a way to have a coherent view of the extent
> tree
> at a given time, which is where our sequence numbers come in.  Each delayed
> ref
> new gets a sequence number, and a different sequence number means we can't
> do
> this in-memory merging right away like we used to.  Now instead we have
> btrfs_merge_delayed_refs, which works pretty well, but is O(n) for the
> number
> of delayed refs we have for a given extent.  Usually this is a small number,
> but
> there is one key area this isn't true, which is snapshot aware defrag.
>
> ====== Snapshot aware defrag =====
>
> This has a couple of problems with it, but the problem that relates to this
> email is that we can have many many updates for one extent.  So remember how
> we
> will add an extent ref every time we split an extent?  Imagine writing a
> 128mb
> extent and then overwriting every other block.  That is going to end up with
> 32768 file extents all pointing to the same extent.  Now snapshot this fs 5
> thousand times, now you have 163,840,000 extents you are going to be
> updating
> when you defrag this range.  How this then ends up is you have that many
> delayed
> refs outstanding at the end of your defrag operation, that is if you are
> lucky
> enough to not OOM.  This is because of the sequence numbers, we can't merge
> them
> until we actually go to run them.  So now you've made it to actually calling
> btrfs_merge_delayed_refs, and then you wonder why your box just livelocked
> for
> 10 seconds for no apparent reason.  With out the sequence numbers we would
> have
> merged each of these operations as we added them, so when we finished the
> defrag
> operation we'd have 5000 delayed refs each with a -32768 count for the
> freeing
> of the fragmented extent.
>
> Now obviously 1 part of this fix is to do one root at a time so we aren't
> queueing up N number of snapshots worth of delayed refs, but that still
> leaves
> the actual number of extents we have, which is why we need to kill/mitigate
> the
> pain of the sequence numbers.
>
> ======= Qgroups =======
>
> I'm starting over with the qgroup accounting because it simply needs to
> operate
> without as much dependance on the sequence numbers.  So here is how it is
> going
> to work
>
> 1) Create a delayed ref sort of scheme for quota operations.  This lets us
> process things in bulk without having to worry about weird locking and such.
>
> 2) Only create these quota operations when we modify the actual refs.  Part
> of
> the problem with the current work is that it tries to figure out what quota
> stuff is going to be used based on delayed refs.  These updates could end up
> being chucked, which will screw up our counts.  So instead only add a qgroup
> action when we add the first ref for that root objectid or remove the last
> ref
> for that root objectid.  This will mean adding stuff to the actual ref
> modifying
> stuff in extent-tree.c.  I have this part pretty well nailed down in my
> qgroup-work branch in btrfs-next.
>
> 3) Create qgroup operations in update_ref_for_cow.  One of the tricky parts
> of
> killing sequence numbers is that we can completely lose extent ref
> operations
> that we really do care about.  So say we snapshot, which means we convert
> all of
> the referenced space in the original root to not exclusive and add it to the
> referenced count of the snapshot.  If we rm -rf on that snapshot we will cow
> down only to free the leaf, which means that the delayed ref will get
> dropped.
> This will cause us to lose the qgroup action because we only account for
> real
> ref modificatoins to the tree, and so we won't convert this space back to
> exclusive space for the original tree.  So what we need to do here is add a
> qgroup operation saying that we are converting shared space to exclusive
> space
> with the cow and then set a flag on the extent buffer so we know that we
> have
> an outstanding convert operation.  When this convert operation runs we
> simply
> look the extent buffer up and clear the flag.  If we try to free the tree
> block
> before then we make sure to add a real qgroup operation.
>
> 4) The tricky part is data because we have implied refs, that is refs to
> data
> with no real way to know other than to lookup all of it's parents. We will
> still need sequence numbers in a way for this case, but way differently than
> what we have now.  We only care about knowing about a given point in time
> previous to this special case.  The special case is when we remove what
> looks
> like the last ref for this extent for this root but there are still
> outstanding
> refs on the extent.  This case we need to lookup the backrefs to make sure
> there
> isn't an implied ref from our root to this data block.  This is the point at
> which we increment the sequence number.  So what happens is you have a whole
> bunch of delayed refs with the same sequence number, and then we hit this
> case
> and inc the sequence number, and you have a whole bunch of delayed refs with
> the
> new sequence number.  You still have to post-process merge to make sure, but
> you are far more likely to merge everything in real-time since you are only
> changing the sequence number every once and a while instead of for every new
> sequence number.  Then you lookup the backrefs for everything that happened
> up
> until but not after your sequence number to see if you had an implied ref
> for
> the data.
>
> ==== Conclusion =====
>
> I realize this is a lot of information, but I'm not the only one working in
> this
> area at the moment so I thought it was important to get it all on paper so
> we're
> all on the same page.  Please let me know if you have questions or
> suggestions,
> Like I said I'm on paternity leave so theres going to be a lag time for my
> responses.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
