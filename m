From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V4 0/4] Btrfs: batched discard support for btrfs
Date: Sun, 27 Mar 2011 21:39:26 -0400
Message-ID: <1301276330-sup-3755@think>
References: <1300962268-12774-1-git-send-email-lidongyang@novell.com> <1301249396-sup-1863@think> <1301275766-sup-2625@think>
Content-Type: text/plain; charset=UTF-8
Cc: Li Dongyang <lidongyang@novell.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1301275766-sup-2625@think>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-03-27 21:30:20 -0400:
> Excerpts from Chris Mason's message of 2011-03-27 14:10:46 -0400:
> > Excerpts from Li Dongyang's message of 2011-03-24 06:24:24 -0400:
> > > Dear list,
> > > This is V4 of batched discard support, now we will get full mapping of
> > > the free space on each device for RAID0/1/10/DUP instead of just a single
> > > stripe length, and tested with xfsstests 251, Thanks.
> > 
> > I've pushed this out into the for-linus branch, along with a full merge
> > to 2.6.39 current git.
> > 
> > Please take a look and make sure I've merged it correctly.
> 
> Hmmm, this was doing mod operations on 64 bit numbers, so it didn't
> compile at all on 32 bit machines.  I've fixed it up and pushed the
> result out to for-linus.  Please check the math ;)

BTW, I just rebased this so the incremental fix was before merging into
Linus' tree.

-chris

> 
> -chris
> 
> > 
> > Thanks!
> > 
> > -chris
> > 
> > > Changelog V4:
> > >     *make btrfs_map_block() return full mapping.
> > > Changelog V3:
> > >     *fix style problems.
> > >     *rebase to 2.6.38-rc7.
> > > Changelog V2:
> > >     *Check if we have devices support trim before trying to trim the fs, also adjust
> > >       minlen according to the discard_granularity.
> > >     *Update reserved extent calculations in btrfs_trim_block_group().
> > >     *Call cond_resched() without checking need_resched()
> > >     *Use bitmap_clear_bits() and unlink_free_space() instead of btrfs_remove_free_space(),
> > >       so we won't search the same extent for twice.
> > >     *Try harder in btrfs_discard_extent(), now we won't report errors
> > >      if it's not a EOPNOTSUPP.
> > >     *make sure the block group is cached before trimming it,or we'll see an empty caching
> > >      tree if the block group is not cached.
> > >     *Minor return value fix in btrfs_discard_block_group().
