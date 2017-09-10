Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41167 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdIJBdp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 21:33:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dqr7f-0002QF-H5
        for linux-btrfs@vger.kernel.org; Sun, 10 Sep 2017 03:33:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Regarding handling of file renames in Btrfs
Date: Sun, 10 Sep 2017 01:32:55 +0000 (UTC)
Message-ID: <pan$de6de$64057d35$2639f8a2$cdcf693f@cox.net>
References: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rohan Kadekodi posted on Sat, 09 Sep 2017 18:50:09 -0500 as excerpted:

> Hello,
> 
> I was trying to understand how file renames are handled in Btrfs. I read
> the code documentation, but had a problem understanding a few things.
> 
> During a file rename, btrfs_commit_transaction() is called which is
> because Btrfs has to commit the whole FS before storing the information
> related to the new renamed file. It has to commit the FS because a
> rename first does an unlink, which is not recorded in the btrfs_rename()
> transaction and so is not logged in the log tree. Is my understanding
> correct? If yes, my questions are as follows:

I'm not a dev, but am a btrfs user and list regular, and can try my hand 
at answering... and if I'm wrong, a dev's reply can correct my 
misconceptions as well. =:^)

> 1. What does committing the whole FS mean? Blktrace shows that there are
> 2  256KB writes, which are essentially writes to the data of the
> root directory of the file system (which I found out through
> btrfs-debug-tree). Is this equivalent to doing a shell sync, as the same
> block groups are written during a shell sync too? Also, does it imply
> that all the metadata held by the log tree is now checkpointed to the
> respective trees?

A btrfs commit is the equivalent of a *single* filesystem sync, yes.  The 
difference compared to the sync(1) command is that sync applies to all 
filesystems of all types, not just a single btrfs filesystem.  See also 
the btrfs filesystem sync command (btrfs-filesystem(8) manpage), which 
applies to a a single btrfs, but also triggers deleted subvolume cleanup.

But these are not writes to the /data/ of the root directory.  In btrfs, 
data and metadata are separated, and these are writes to the /metadata/ 
of the filesystem, including writing a new filesystem top-level (aka 
root) block and the superblock and its backups.

Yes, the log is synced too.

But regarding the log, in btrfs, because btrfs is atomic cow-based (copy-
on-write), at each commit the filesystem is designed to be entirely self-
consistent, with the result being that most actions don't need to be and 
are not logged.  At a crash and later remount, the filesystem as of the 
last atomically-written root-block state will be mounted, and anything 
being written at the time of the crash will either have been entirely 
written and committed (the top-level root tree block will have been 
updated to reflect it), or that update will not have happened yet, so the 
state of the filesystem will be that of the last root tree block commit, 
with newer in-process actions lost.

The btrfs log is an exception, a compromise in the interest of fsync 
speed.  The only thing it logs are fsyncs (filesyncs, as opposed to whole 
filesystem syncs) that would otherwise not return until the next commit 
(with commits on a 30-second timer by default), since the filesystem 
would otherwise be unable to guarantee that the fsync had been entirely 
written to permanent media and thus should survive a crash.  The log 
ensures the fsynced file's new data (if any) is written to its new 
location on the media (cow so new block location), updates the metadata 
(also cow so written to a new location), then logs the metadata update so 
it can be committed at log replay if necessary, and returns.  If a crash 
happens before the next full filesystem atomic commit, the fsync can be 
replayed from the log, thus satisfying the fsync guarantee without 
forcing a wait for a full atomic commit.  But once that full filesystem 
atomic commit happens (again, with a 30-second default timeout), all 
updates are now reflected in the new filesystem state as registered in 
the new root tree block, and the previous log is now dead/unreferenced on 
the media (because the new root block doesn't refer to it any longer, 
referring instead to a new log).

> 2. Why are there 2 complete writes to the data held by the root
> directory and not just 1? These writes are 256KB each, which is the size
> of the extent allocated to the root directory

I'm not sure on this one, hopefully a btrfs dev can clarify, but at a 
guess, you may be seeing writes to the superblock and its backup -- on a 
large enough filesystem there's two backups, but your filesystem may be 
small enough to have just one backup.

It's also possible you're seeing the new copy of the metadata tree being 
written out, then the root block and superblocks (and backups) being 
updated.

> 3. Why are the writes being done to the root directory of the file
> system / subvolume and not just the parent directory where the unlink
> happened?

Remember, everything's in trees, and updates are cowed, with updates at 
lower levels of the tree not reflected in the atomic state of the 
filesystem until they've recursed up the tree and a new root tree block 
is written, pointing at the new trees instead of the old ones, with the 
superblock and backups then updated to point at the new root tree block.

So nothing's local-only.  First, the old (meta)data along with any 
updates to it is written to a new location, then higher tree entries must 
be updated and written to new locations, all the way to the top.  Until 
that top entry is updated, the state of the filesystem reflects the old 
state, without any in-process changes -- it's as if your rename hasn't 
happened yet because the atomic filesystem state doesn't point to the 
newly written location yet.  Once the updates reach the top, the new 
state is reflected.

Of course with the fsync log being an exception, as mentioned above, but 
it too is renewed by the full filesystem commit, with the old log freed 
to be garbage-collected, and a new initially empty log pointed at by the 
newly written root block, which is in turn pointed at by the newly 
rewritten superblock and its backups.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

