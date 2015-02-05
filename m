Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35864 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbbBEIbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 03:31:39 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] Allow btrfsck to reset csum of all tree blocks, AKA dangerous mode.
Date: Thu, 05 Feb 2015 09:31:36 +0100
Message-ID: <1898269.N3rJDqb6kZ@merkaba>
In-Reply-To: <54D2C8DE.1010006@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com> <4749287.qr2O8ff0qM@merkaba> <54D2C8DE.1010006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 5. Februar 2015, 09:35:26 schrieb Qu Wenruo:
> -------- Original Message --------
> Subject: Re: [PATCH 0/7] Allow btrfsck to reset csum of all tree blocks,
> AKA dangerous mode.
> From: Martin Steigerwald <martin@lichtvoll.de>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年02月04日 17:16
> 
> > Am Mittwoch, 4. Februar 2015, 15:16:44 schrieb Qu Wenruo:
> >> Btrfs's metadata csum is a good mechanism, keeping bit error away
> >> from
> >> sensitive kernel. But such mechanism will also be too sensitive, like
> >> bit error in csum bytes or low all zero bits in nodeptr.
> >> It's a trade using "error tolerance" for stable, and is reasonable
> >> for
> >> most cases since there is DUP/RAID1/5/6/10 duplication level.
> >> 
> >> But in some case, whatever for development purpose or despair user
> >> who
> >> can't tolerant all his/her inline data lost, or even crazy QA team
> >> hoping btrfs can survive heavy random bits bombing, there are some
> >> guys
> >> want to get rid of the csum protection and face the crucial raw data
> >> no
> >> matter what disaster may happen.
> >> 
> >> So, introduce the new '--dangerous' (or "destruction"/"debug" if you
> >> like) option for btrfsck to reset all csum of tree blocks.
> > 
> > I often wondered about this: AFAIK if you get a csum error BTRFS makes
> > this an input/output error. For being able to access the data in
> > place,
> > how about a "iwantmycorrupteddataback" mount option where BTRFS just
> > logs csum errors but allows one to access the files nonetheless.
> 
> The idea is good, but don't forget we have metadata(tree block) and
> data. For data, this is completely OK.
> But for metadata, this may be a disaster just like the --dangerous
> option.

Ah yes, so probably only do this for data or have an extra option for 
skipping csum on metadata for the really desparate, but then I´d really 
force read only to avoid corrupted causing more damage.

> > This could even
> > work together with remount. Maybe it would be good not to allow
> > writing to broken csum blocks, i.e. fail these with input/output
> > error.
> 
> Don't forget btrfs' COW write.
> So write into data shouldn't be a problem.(if COW is enabled).

Yes, but… it hides the corruption. Unless you have a snapshot if an 
application reads corrupted data and then writes it back, then you have no 
indication that the data was corrupted in the first time.

> > This way, the csum would not be automatically fixed, *but* one is able
> > to access the broken data, *while* knowing it is broken.
> > 
> > If that is possible already, I missed it.
> 
> Much as you considered, data csum can be rebuilt in btrfsck with
> --init-csum-tree option.
> Although not every user knows this feature and even less users know the
> correct timing using it.

I wonder about making a wiki page about recovery options with two parts:

1) Diagnosis. First find out what might be wrong.

2) Cure. Then decide which steps to try to recover.

And of cause an intro on best practice to only work on a copy of the copy 
for any in-place repair attempts.

I´d be willing to make such a page, provided I get enough hints on what to 
try when. I have some ideas myself, but I am not sure they are accurate :)

Thanks,
Martin


> 
> Thanks,
> Qu
> 
> >> The csum reseting have the following features:
> >> 1) Top to down level by level
> >> The csum resetting is done from tree to level 1, and only when all
> >> the
> >> csum of nodes in this level is reset and can pass read_tree_block()
> >> check, it will continue to next level.
> >> And all bytenr in nodeptr will be re-aligned, so bit error in the low
> >> 12 bits(4K sector size case) can also be repaired without pain.
> >> With this behavior, error in nodeptr has a chance not affecting its
> >> child.
> >> 
> >> 2) No Copy-on-write
> >> COW means we needs to have a valid extent tree, if extent tree is
> >> corrupted COW will only be a BUG_ON blocking us.
> >> So all the r/w in this dangerous mode will use no-cow write. That's
> >> why
> >> we export and slightly modified write_tree_block() to do no-cow tree
> >> block write with newly calculated csum.
> >> Since the write is not cowed, if it fails, it will also destroy the
> >> last hope for manual inspection.
> >> 
> >> Qu Wenruo (7):
> >>    btrfs-progs: Add btrfs_(prev/next)_tree_block() to keep search
> >>    result
> >>    
> >>      in     the same level of path->lowest_level.
> >>    
> >>    btrfs-progs: Introduce btrfs_next_slot() function to iterate to
> >>    next
> >>    
> >>        slot in given level.
> >>    
> >>    btrfs-progs: Allow btrfs_read_fs_root() to re-read the tree node.
> >>    btrfs-progs: Export write_tree_block() and allow it to do nocow
> >>    write.
> >> 
> >> btrfs-progs: Introduce new function reset_tree_block_csum() for later
> >> tree block csum reset.
> >> 
> >>    btrfs-progs: Introduce new function reset_(one_root/roots)_csum()
> >>    to
> >>    
> >>        reset one/all tree's csum in tree root.
> >>    
> >>    btrfs-progs: Introduce "--dangerous" option to reset all tree
> >>    block
> >>    
> >>       csum.
> >>   
> >>   cmds-check.c | 284
> >> 
> >> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++- ctree.c
> >> 
> >>   |  18 ++--
> >>   
> >>   ctree.h      |  25 +++++-
> >>   disk-io.c    |  55 +++++++++---
> >>   disk-io.h    |   3 +
> >>   5 files changed, 359 insertions(+), 26 deletions(-)

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
