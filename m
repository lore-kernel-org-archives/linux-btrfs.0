From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 13:49:43 -0400
Message-ID: <1224611383.27474.140.camel@think.oraclecorp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <1224597580.27474.93.camel@think.oraclecorp.com>
	 <20081021182710.a12f4914.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021182710.a12f4914.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-10-21 at 18:27 +0200, Stephan von Krawczynski wrote:

> > > 2. general requirements
> > >     - fs errors without file/dir names are useless
> > >     - errors in parts of the fs are no reason for a fs to go offline as a whole
> > 
> > These two are in progress.  Btrfs won't always be able to give a file
> > and directory name, but it will be able to give something that can be
> > turned into a file or directory name.  You don't want important
> > diagnostic messages delayed by name lookup.
> 
> That's a point I really never understood. Why is it non-trivial for a fs to
> know what file or dir (name) it is currently working on?

The name lives in block A, but you might find a corruption while
processing block B.  Block A might not be in ram anymore, or it might be
in ram but locked by another process.

On top of all of that, when we print errors it's because things haven't
gone well.  They are deep inside of various parts of the filesystem, and
we might not be able to take the required locks or read from the disk in
order to find the name of the thing we're operating on.

> > 
> > >     - mounting must not delay the system startup significantly
> > 
> > Mounts are fast
> > 
> > >     - resizing during runtime (up and down)
> > 
> > Resize is done
> > 
> > >     - parallel mounts (very important!)
> > >       (two or more hosts mount the same fs concurrently for reading and
> > >       writing)
> > 
> > As Jim and Andi have said, parallel mounts are not in the feature list
> > for Btrfs.  Network filesystems will provide these features.
> 
> Can you explain what "network filesystems" stands for in this statement,
> please name two or three examples.
> 
NFS (done) CRFS (under development), maybe ceph as well which is also
under development.

> > >     - journaling
> > 
> > Btrfs doesn't journal.  The tree logging code is close, it provides
> > optimized fsync and O_SYNC operations.  The same basic structures could
> > be used for remote replication.
> > 
> > >     - versioning (file and dir)
> > 
> > >From a data structure point of view, version control is fairly easy.
> > >From a user interface and policy point of view, it gets difficult very
> > quickly.  Aside from snapshotting, version control is outside the scope
> > of btrfs.
> > 
> > There are lots of good version control systems available, I'd suggest
> > you use them instead.
> 
> To me versioning sounds like a not-so-easy-to-implement feature. Nevertheless
> I trust your experience. If a basic implementation is possible and not too
> complex, why deny a feature? 
> 

In general I think snapshotting solves enough of the problem for most of
the people most of the time.  I'd love for Btrfs to be the perfect FS,
but I'm afraid everyone has a different definition of perfect.

Storing multiple versions of something is pretty easy.  Making a usable
interface around those versions is the hard part, especially because you
need groups of files to be versioned together in atomic groups
(something that looks a lot like a snapshot).

Versioning is solved in userspace.  We would never be able to implement
everything that git or mercurial can do inside the filesystem.

> > >     - undelete (file and dir)
> > 
> > Undelete is easy
> 
> Yes, we hear and say that all the time, name one linux fs doing it, please.
> 

The fact that nobody is doing it is not a good argument for why it
should be done ;)  Undelete is a policy decision about what to do with
files as they are removed.  I'd much rather see it implemented above the
filesystems instead of individually in each filesystem.

This doesn't mean I'll never code it, it just means it won't get
implemented directly inside of Btrfs.  In comparison with all of the
other features pending, undelete is pretty far down on the list.

> > but I think best done at a layer above the FS.
> 
> Before we got into the linux community we used n.vell netware. Undelete has
> been there since about the first day. More then ten years later (nowadays) it
> is still missing in linux. I really do suggest to provide _some_ solution and
> _then_ lets talk about the _better_ solution.
> 
> > >     - snapshots
> > 
> > Done
> > 
> > >     - run into hd errors more than once for the same file (as an option)
> > 
> > Sorry, I'm not sure what you mean here.
> 
> If your hd is going dead you often find out that touching broken files takes
> ages. If the fs finds out a file is corrupt because the device has errors it
> could just flag the file as broken and not re-read the same error a thousand
> times more. Obviously you want that as an option, because there can be good
> reasons for re-reading dead files...

I really agree that we want to avoid beating on a dead drive.

Btrfs will record some error information about the drive so it can
decide what to do with failures.  But, remembering that sector #12345768
is bad doesn't help much.  When the drive returned the IO error it
remapped the sector and the next write will probably succeed.

> 
> > >     - map out dead blocks
> > >       (and of course display of the currently mapped out list)
> > 
> > I agree with Jim on this one.  Drives remap dead sectors, and when they
> > stop remapping them, the drive should be replaced.
> 
> If your life depends on it, would you use one rope or two to secure yourself?
> 

Btrfs will keep the dead drive around as a fallback for sectors that
fail on the other mirrors when data is being rebuilt.  Beyond that,
we'll expect you to toss the bad drive once the rebuild has finished.

There's an interesting paper about how netapp puts the drive into rehab
and is able to avoid service calls by rewriting the bad sectors and
checking them over.  That's a little ways off for Btrfs.

> > 
> > >     - no size limitations (more or less)
> > >     - performant handling of large numbers of files inside single dirs
> > >       (to check that use > 100.000 files in a dir, understand that it is
> > >       no good idea to spread inode-blocks over the whole hd because of seek
> > >       times)
> > 
> > Everyone has different ideas on "large" numbers of files inside a single
> > dir.  The directory indexing done by btrfs can easily handle 100,000
> 
> The story is not really about if it can but how fast it can. You know that
> most time is spent in seeks these days. If you have 100000 blocks to read
> right across the whole disk for scanning through a dir (fstat every file) you
> will see quite a difference to a situation where the relevant data can be read
> within few (or zero) seeks. Its a question of fs layout on the disk.
> 

Yes, btrfs already performs well in this workload.

-chris


