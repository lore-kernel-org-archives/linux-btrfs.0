From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: Data-deduplication?
Date: Tue, 21 Oct 2008 16:33:05 -0400
Message-ID: <20081021203305.GA20992@shell>
References: <20081012020629.GA14615@bludgeon.org> <1223895734.7032.1.camel@think.oraclecorp.com> <20081016192501.GE16946@shell> <1224185449.6938.81.camel@think.oraclecorp.com> <20081017182404.GF16946@shell> <1224461791.27474.17.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ray Van Dolson <rayvd@bludgeon.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224461791.27474.17.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 19, 2008 at 08:16:31PM -0400, Chris Mason wrote:
> 
> I think I'll have to come back to this after getting ENOSPC to work at
> all ;)  You're right that reserved space can do wonders to dig us out of

:) Having been through this before, the ENOSPC accounting was
incredibly hard to get right.  It's at least worth thinking about the
edge cases while you're writing the first version, although you will
probably just have to throw one away no matter what.

> holes, it has to be reserved at a multiple of the number of procs that I
> allow into the transaction.
> 
> I should be able to go into an emergency one writer at a time theme as
> space gets really tight, but there are lots of missing pieces that
> haven't been coded yet in that area.

Makes sense.

I have the following "behave like I expect" rules for things that
often aren't right in the first version of a COW file system.

* If a write could succeed in the future without any user-level
  changes to the file system, then it will succeeed the first time. 

Basically, this is reflecting what happens when space used by the
previous version of the fs is freed after the next COW version is
written out.  A naive implementation of COW will fail the write if it
happens while enough other writes are outstanding, even if there would
be enough space after the other writes have been synced to disk and
the blocks from the old version are freed.  This means backing off to
the one-writer-at-a-time mode you are talking about.

* Rewriting metadata will always succeed.

Again, with naive COW, you can get into a state where doing a chmod()
on a file could end up returning ENOSPC.  Totally uncool.  Pretty much
just requires a little reserved space.

* Deletion will always succeed.

Again, reserved space, plus a little forethought in metadata design.
It is not automatically the case that your metadata will be designed
such that deletion will always result in more free space afterwards,
so it's worth a review pass just to be sure.

One thing I ran into before is that it's non-trivial to calculate
exactly how many blocks will need to be COW'd for even the tiniest
write.  Leaves split, directories grow another block, the inode block
has to be copied, the tree grows another level, you have to allocate a
new free space extent, etc., etc.  The worst case can be hundreds of
KB per 1-byte write.  Logically, you may only be writing a few bytes,
but they may require megabytes of free space to sync out to disk.
Very annoying.

-VAL
