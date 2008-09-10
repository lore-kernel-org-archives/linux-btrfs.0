From: Chris Mason <chris.mason@oracle.com>
Subject: Re: parity data
Date: Wed, 10 Sep 2008 08:59:29 -0400
Message-ID: <1221051569.29741.69.camel@think.oraclecorp.com>
References: <1220766185.20018.7.camel@telesto>
	 <1220885271.8537.31.camel@think.oraclecorp.com>
	 <1220921206.7953.32.camel@telesto>
	 <1220957012.29741.38.camel@think.oraclecorp.com>
	 <1221010326.14596.9.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1221010326.14596.9.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-09-09 at 19:32 -0600, Eric Anopolsky wrote:
> > > Let's say I have 4 100GB drives (2 fast ones and 2 slow ones). I've
> > > restricted a performance critical directory to the two fastest drives,
> > > currently totaling 100GB of performance critical data. The rest of the
> > > data on the system is striped.
> > > 
> > > How much free space do I have on the filesystem? 100GB (the amount of
> > > data I can store in the performance critical directory)? 200GB (the
> > > amount of data I can store outside the performance critical directory if
> > > the striping is guaranteed)? 300GB (the amount of data I can store
> > > outside the performance critical directory if the striping is best
> > > effort)?
> > > 
> > 
> > People already create these configurations, they just do it with
> > multiple filesystems.  And, when they want to resize the performance
> > critical section, it is a difficult (and often slow) operation.
> 
> I think I'm starting to get it. btrfs would have drive groups, and no
> file would have data on more than one drive group at once. That would
> make it possible to make meaningful statements about how much free disk
> space there is (per drive group). This is almost the same as having
> multiple filesystems, except files cannot be assigned to filesystems on
> an individual basis.

Yes, I think this is a fair statement.

>  So in a way, btrfs would be replacing some
> functionality of the VFS (mapping files to filesystems).

I think there are many different definitions of the VFS.  Mostly what
the VFS does is maintain the dentry and inode caches, and provide a
basic locking framework around most file/inode operations.  The VFS is
still doing all the mapping of files to filesystems, and the filesystem
is mapping files to disk blocks.

-chris


