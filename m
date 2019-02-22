Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB274C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 11:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B88C2075B
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 11:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550834044;
	bh=y66ayHQFsCF4NbUGp+UNFT7yRM3DxdCiGZyjhS0yyiM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=icYJsPFViQelpzUVDJadbjVCMhwSGITgIaaBRMDdTfVwf9EiywoIDnDI8HQQMGwNP
	 oDaGAotj1az9a0rdnwUVnimH4ac0WPu35bPouLY0qiuosJfw2Ze6MRIoF+v3PdY7p8
	 o8DW/ixbsv+R47NHaQWwetcs+sM3uw+j4NE2Nc/c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfBVLOD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfBVLOD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 06:14:03 -0500
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE7302075B
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 11:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550834040;
        bh=y66ayHQFsCF4NbUGp+UNFT7yRM3DxdCiGZyjhS0yyiM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=n0lB1rwPYyuS5rKUYcKqK4Eg4d/GcfjdaL6smJJRSWkbU8tOabfX39Vkmz2bc39lp
         2i5ceJAPSX54NQUjjD1+6l/X9s9qM57UfBYE5GpaXbJcmROXmx7wi8pDyFRnI7+yLD
         bxwdqFXLM3/drJE26h7Ixkq+xJPJlRbg36aj0Z58=
Received: by mail-vk1-f172.google.com with SMTP id l136so410512vke.2
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 03:14:00 -0800 (PST)
X-Gm-Message-State: AHQUAuYUhJrH8K5Zk78OhNJu9HheiQuk8pD7NOIw9B0qCS/CDy0Gx9zR
        iT4unL1+r2wuD/UsHVj3ceHss1yLXX+bWjiGYYs=
X-Google-Smtp-Source: AHgI3Ia65SbjBKiVSHy4CjbrA2IDWfCgQLAX7qzcQ7qV3BVuWLpoNCkxtngxAtT06t2+e2dKjFY8Wu1TCmHWoRnW8EM=
X-Received: by 2002:a1f:7f10:: with SMTP id o16mr1857892vki.31.1550834039699;
 Fri, 22 Feb 2019 03:13:59 -0800 (PST)
MIME-Version: 1.0
References: <20181212180559.15249-1-fdmanana@kernel.org> <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz> <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
 <20190220164140.GF9995@hungrycats.org> <CAL3q7H455MCpj_-5U=zUzD3Of7aLtG6R_tHdGhZ4Kj-393sWAg@mail.gmail.com>
 <20190220171708.GG9995@hungrycats.org>
In-Reply-To: <20190220171708.GG9995@hungrycats.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Fri, 22 Feb 2019 11:13:48 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7iqSEEyFaEtpRZw3cp613y+4k2Q8b4W7mweR3tZA05bQ@mail.gmail.com>
Message-ID: <CAL3q7H7iqSEEyFaEtpRZw3cp613y+4k2Q8b4W7mweR3tZA05bQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for deduplication
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 20, 2019 at 5:17 PM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On Wed, Feb 20, 2019 at 04:54:09PM +0000, Filipe Manana wrote:
> > On Wed, Feb 20, 2019 at 4:42 PM Zygo Blaxell
> > <ce3g8jdj@umail.furryterror.org> wrote:
> > >
> > > On Thu, Jan 31, 2019 at 04:39:22PM +0000, Filipe Manana wrote:
> > > > On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> > > > >
> > > > > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > > >
> > > > > > Checking if the destination root is read-only was being performed only for
> > > > > > clone operations. Make deduplication check it as well, as it does not make
> > > > > > sense to not do it, even if it is an operation that does not change the
> > > > > > file contents (such as defrag for example, which checks first if the root
> > > > > > is read-only).
> > > > >
> > > > > And this is also change in user-visible behaviour of dedupe, so this
> > > > > needs to be verified if it's not breaking existing tools.
> > > >
> > > > Have you had the chance to do such verification?
> > > >
> > > > This actually conflicts with send. Send does not expect a root/tree to
> > > > change, and with dedupe on read-only roots happening
> > > > in parallel with send is going to cause all sorts of unexpected and
> > > > undesired problems...
> > >
> > > This is a problem bees ran into.  There is a workaround in bees (called
> > > --workaround-btrfs-send) that avoids RO subvols as dedupe targets.
> > > As the name of the option implies, it works around problems in btrfs send.
> > >
> > > This kernel change makes the workaround mandatory now, as the default
> > > case (without workaround) will fail on every RO subvol even if that
> > > behavior is desired by the user.  That breaks an important use case on
> > > the receiving side of sends--to dedupe the received subvols together
> > > while also protecting them against modification on the target system
> > > with the RO flag--and preserving that use case is why the send workaround
> > > was optional (and not default) in bees.
> > >
> > > bees also won't handle the RO/RW/RO transition correctly, as it didn't
> > > seem like a sane thing to support at the time.  That is arguably something
> > > to be fixed in bees.
> > >
> > > > This is a problem introduced by dedupe ioctl when it landed, since
> > > > send existed for a longer time (when nothing else was
> > > > allowed to change read-only roots, including defrag).
> > >
> > > Is there a reason why incremental send can't simply be fixed?
> >
> > This is a problem that affects both incremental and non-incremental (full) send.
> >
> > > As far
> > > as I can tell, send is failing because of a runtime check that seems to
> > > be too strict; however, I haven't tried removing that check to see if
> > > it fixes the problem in send, or just hides the next problem.
> >
> > The problem is send was designed with the idea that read-only roots
> > don't ever change.
>
> ...except when they're snapshotted, balanced, or deduped (to list places
> where that assumption hasn't held so far).

Yes, we had bugs related to that (I fixed some of them). However, the
snapshotting ones [1, 2] happened to be easy to solve because only the
root node is COWed.
The one related to balance [3], which I only remember one and matches
the piece of code you pointed to (which I fixed long ago), actually
only solves
one problem, which was hitting a BUG_ON() (if the extent item was
changed by relocation we know no data changed and we can ignore the
change).
The other problem it doesn't solve is essentially the same problem
that a concurrent dedupe can cause, which I only realized some weeks
ago after noticing
dedup was allowed on RO roots (subvolumes/snapshots).

I'll explain below what problem it is.

>
> > The failures that can happen are many and unpredictable, from
> > occasionally failing with some error, to invalid memory accesses, use
> > after free problems, etc.
> > Essentially all caused by races when the nodes/leafs from the
> > read-only tree change while send is running.
>
> Maybe you can explain this further?  As far as I can tell, all of those
> are send bugs that should just be (and over the years have been) fixed.

So send was always lockless and transactionless, because it's a
potentially long running operation that could delay everything
else if it were not (specially if it held transactions open) and
because it needs to operate on a tree that never changes, so that it
always
sees a consistent state (often it needs to do multiple searches on a
tree for many different reasons). Well this second reason is actually
what
matters and the first reason is more a consequence of the second
reason. But well, the world is not perfect
and it seems that during the design/implementation stage of send,
balance and snapshotting of a snapshot being used by send were
forgotten.
Then after send came, dedupe came and because it allows to dedupe
against files in a RO tree, brought another way of being able to
modify a RO tree that can be in use by a concurrent send - this was
missed during the review process obviously, otherwise it would have
never allowed dedupe on RO trees or send would have been changed as
well to somehow work with a concurrent dedupe.

The big problem, for which I don't have a solution, is that dedupe and
balance COW entire paths, and not just the root node of a tree like
the snapshotting case.
For example while send is doing work with a leaf from a RO snapshot
tree, if that leaf is COWed, its extent is marked as free once
the transaction that COWed it is committed. That means that
immediately after that, the extent can be reused, allocated to some
other tree
leaf or node - while send is still using the respective in-memory
representation of the leaf, the extent buffer. So some other task will
be modifying the
extent buffer while send is using it as well - this is what brings
unexpected results that can result in crashes or, with luck, some
random failures that make
send return some error only. For a leaf we could just clone the extent
buffer while preventing transaction commits, and then allow them to
happen again after
cloning.

Now COWing a leaf also results in COWing its parent node, parent of
the parent, etc, all the way up to the root node (pointers need to be
changed in every parent). So if a node is COWed while send is using
it, and before it finishes using it the same extent gets reused for
another tree/node, send would
follow an incorrect path since now the node has different pointers or
it's in an undefined/inconsistent state due to the concurrent
modification. Creating a copy/clone of
the node while transaction commits are disabled is not an option,
since when using the copy, nodes below it might have been COWed and no
longer exist, so we are
accessing stale pointers.

Getting the extent of a node/leaf immediately reused after COWing it
and after its transaction is committed is not very common and happens
mostly when running close
to ENOSPC, plus the time spent processing a node/leaf by send is very
short. So this is effectively a hard to hit problem.

The bug fixes for the snapshotting of a RO snapshot work and are
simple because snapshotting only COWs the root of a tree, so we stop
transactions commits
temporarily, make a copy of the root for send to use and allow
transaction commits to happen again, while send is happy doing what it
has to using the cloned root
nodes - works because snapshotting doesn't COW any other nodes/leafs
of the tree, i.e., the pointers in the root node don't change.

>
> > I don't know what runtime check you are mentioning that is too strict.
>
> It's this one, in send.c:
>
>                         /*
>                          * We may have found an extent item that has changed
>                          * only its disk_bytenr field and the corresponding
>                          * inode item was not updated. This case happens due to
>                          * very specific timings during relocation when a leaf
>                          * that contains file extent items is COWed while
>                          * relocation is ongoing and its in the stage where it
>                          * updates data pointers. So when this happens we can
>                          * safely ignore it since we know it's the same extent,
>                          * but just at different logical and physical locations
>                          * (when an extent is fully replaced with a new one, we
>                          * know the generation number must have changed too,
>                          * since snapshot creation implies committing the current
>                          * transaction, and the inode item must have been updated
>                          * as well).
>                          * This replacement of the disk_bytenr happens at
>                          * relocation.c:replace_file_extents() through
>                          * relocation.c:btrfs_reloc_cow_block().
>                          */
>                         if (btrfs_file_extent_generation(leaf_l, ei_l) ==
>                             btrfs_file_extent_generation(leaf_r, ei_r) &&
>                             btrfs_file_extent_ram_bytes(leaf_l, ei_l) ==
>                             btrfs_file_extent_ram_bytes(leaf_r, ei_r) &&
>                             btrfs_file_extent_compression(leaf_l, ei_l) ==
>                             btrfs_file_extent_compression(leaf_r, ei_r) &&
>                             btrfs_file_extent_encryption(leaf_l, ei_l) ==
>                             btrfs_file_extent_encryption(leaf_r, ei_r) &&
>                             btrfs_file_extent_other_encoding(leaf_l, ei_l) ==
>                             btrfs_file_extent_other_encoding(leaf_r, ei_r) &&
>                             btrfs_file_extent_type(leaf_l, ei_l) ==
>                             btrfs_file_extent_type(leaf_r, ei_r) &&
>                             btrfs_file_extent_disk_bytenr(leaf_l, ei_l) !=
>                             btrfs_file_extent_disk_bytenr(leaf_r, ei_r) &&
>                             btrfs_file_extent_disk_num_bytes(leaf_l, ei_l) ==
>                             btrfs_file_extent_disk_num_bytes(leaf_r, ei_r) &&
>                             btrfs_file_extent_offset(leaf_l, ei_l) ==
>                             btrfs_file_extent_offset(leaf_r, ei_r) &&
>                             btrfs_file_extent_num_bytes(leaf_l, ei_l) ==
>                             btrfs_file_extent_num_bytes(leaf_r, ei_r))
>                                 return 0;
>                 }
>
>                 inconsistent_snapshot_error(sctx, result, "extent");
>                 return -EIO;
>
> This is the point where bees users report send failures.

That seems yo happen when dedupe is running in parallel with send.
That can be fixed by ignoring file extent items that changed without
the inode item having
changed as well (assuming this can only be caused by balance and
dedupe, and there's no other path for this).
When I added tjat check to fix a BUG_ON hit due to balance changing
file extent items (without updating inode items), I wasn't aware that
an ongoing dedupe could
cause the same problem (back then, when I added that check [3], I
thought that dedupe was like clone and would refuse to work on RO
subvolumes/snapshots).
However I don't see immediately how it's possible, since dedupe
updates file extent items (or inserts new ones) in the same
transaction where it updates the inode
item, so it's really weird how send would find the new/modified file
extent items from the commit root without seeing an update inode item
as well.

Btw, why weren't those reports reported to the btrfs mailing list?

However the bigger problem, mentioned above, I really don't have a
solution for it now, and it's far from being a trivial problem
(perhaps simply making send use read locks
for searches on the commit root would work). It can be caused by
either a concurrent dedupe or a concurrent balance (and hopefully
there's nothing else that can modify RO trees),
so a generic solution needs to be found. Preventing dedupe and send
from running in parallel, as you suggest in another reply, is
something I suggested too earlier in this thread.
Preventing balance and send running in parallel, well... it starts to get messy.

So not doing nothing for now, that is, not applying this patch to
disable dedupe on RO roots and wait for a better solution (best case,
for 5.2 merge window), is reasonable
and not something I'm against.
David, would you consider at least excluding it from 5.1 to allow for
a different solution to pop up for another merge window?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=be6821f82c3cc36e026f5afd10249988852b35ea
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f2f0b394b54e2b159ef969a0b5274e9bbf82ff2
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5e84fd8d0634d056248b67463b42f6c85896a19




>
> I don't really understand what that code is trying to achieve, though.
> If we are diffing two subvol trees then we should just send anything
> that's different--even if we occasionally send a few redundant extents
> because we happen to be sending during a balance, because that's better
> than bombing out completely.
>
> Or is the problem more like we lose our ei pointer in one of the subvols
> when the extent tree changes under it?  That would be harder to solve,
> it would have to keep releasing and reacquiring everything.
>
> > You can definitely do dedupe on a read-only root and after it finishes
> > do a send (either full or incremental), and it will work.
>
> If there's a way to make a subvol RW temporarily _without breaking
> incremental send from that subvol_ (i.e. without clearing the parent
> UUIDs, maybe also allowing only dedupe) then I have no objection.
>
> > > More details at:
> > >
> > >         https://github.com/Zygo/bees/issues/79#issuecomment-429039036
> > >
> > > > I understand it can break some applications, but adding other solution
> > > > such as preventing send and dedupe from running in parallel
> > > > (erroring out or block and wait for each other, etc) is going to be
> > > > really ugly. There's always the workaround for apps to set the
> > > > subvolume
> > > > to RW mode, do the dedupe, then switch it back to RO mode.
> > > >
> > > > Thanks.
