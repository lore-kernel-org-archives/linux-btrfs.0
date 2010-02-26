From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 16:08:53 -0500
Message-ID: <20100226210853.GM12841@think>
References: <20100226175927.GG12841@think>
 <20100226181157.50F73414B9@viridian.itc.virginia.edu>
 <20100226190915.GI12841@think>
 <201002262149.14718.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
	linux-btrfs@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002262149.14718.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 09:49:14PM +0100, Diego Calleja wrote:
> On Viernes, 26 de Febrero de 2010 20:09:15 Chris Mason escribi=F3:
> > My would be the super block, it is updated more often and so more l=
ikely
> > to get stuck in the array's cache.
>=20
> IIRC, this is exactly the same problem that ZFS users have been
> hitting. Some users got cheap disks that don't honour barriers
> correctly, so their uberblock didn't have the correct data.

This isn't new, XFS and reiserfs v3 have had problems as well.  But,
this is just my first suspect, Bill might be hitting something entirely
different.

> They developed an app that tries to rollback transactions to
> get the pool into a sane state...I guess that fsck will be able
> to do that at some point?

Yes, this is something that fsck will need to fix.  This corruption is
hardest because it involves the tree that maps all the other trees
(ugh).

The ioctl I'm working on for snapshot/subvol listing will make it easie=
r
to create a program to backup the chunk tree externally.

>=20
> Stupid question from someone who is not a fs dev...it's not possible
> to solve this issue by doing some sort of "superblock journaling"?
> Since there are several superblock copies you could:
>  -Modify a secondary superblock copy to point to the tree root block
>   that still has not been written to disk
>  -Write whatever tree root block has been COW'ed
>  -Modify the primary superblock
>=20
> So in case of these failures, mount code could look in the secondary
> superblock copy before failing. Since barriers are not being honoured=
,
> there's still a possibility that the tree root blocks would be writte=
n
> before the secondary superblock block that was submitted before, but
> that problem would be much harder to hit I guess. But maybe the fs co=
de
> can not know where the tree root blocks are going to be written befor=
e
> writting them, and hence it can't generate a valid superblock?
>=20
> Sorry if all this has not sense at all, I'm just wondering if there's
> a way to solve these drive issues without any kind of recovery tools

The problem is that with a writeback cache, any write is likely
to be missed on power failures.  journalling in general requires some
notion of being able to wait for block A to be on disk before you write
block B, and that's difficult to do when the disk lies about what is
really there ;)

To make things especially difficult, you can't really just roll back to
an older state.  Internally the filesystem does something like this:

allocate a bunch of blocks
free a bunch of blocks

commit

reuse blocks that were freed

Basically once that commit is on disk, we're allowed to (and likely to)
start writing over blocks that were freed in the earlier transaction.
If you try to roll back to the state at the start of that transaction
many of those blocks won't have the same data they did before.

Now, the size of the corruption might be smaller in the rolled back
transaction than in the main transaction or it might be much worse.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
