From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:50:33 -0400
Message-ID: <1224683433.6448.36.camel@think.oraclecorp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <1224597580.27474.93.camel@think.oraclecorp.com>
	 <20081021182710.a12f4914.skraw@ithnet.com>
	 <1224611383.27474.140.camel@think.oraclecorp.com>
	 <20081022141906.f6529c6d.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081022141906.f6529c6d.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-22 at 14:19 +0200, Stephan von Krawczynski wrote:
> On Tue, 21 Oct 2008 13:49:43 -0400
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > On Tue, 2008-10-21 at 18:27 +0200, Stephan von Krawczynski wrote:
> > 
> > > > > 2. general requirements
> > > > >     - fs errors without file/dir names are useless
> > > > >     - errors in parts of the fs are no reason for a fs to go offline as a whole
> > > > 
> > > > These two are in progress.  Btrfs won't always be able to give a file
> > > > and directory name, but it will be able to give something that can be
> > > > turned into a file or directory name.  You don't want important
> > > > diagnostic messages delayed by name lookup.
> > > 
> > > That's a point I really never understood. Why is it non-trivial for a fs to
> > > know what file or dir (name) it is currently working on?
> > 
> > The name lives in block A, but you might find a corruption while
> > processing block B.  Block A might not be in ram anymore, or it might be
> > in ram but locked by another process.
> > 
> > On top of all of that, when we print errors it's because things haven't
> > gone well.  They are deep inside of various parts of the filesystem, and
> > we might not be able to take the required locks or read from the disk in
> > order to find the name of the thing we're operating on.
> 
> Ok, this is interesting. In another thread I was told parallel mounts are
> really complex and you cannot do good things in such an environment that you
> can do with single mount. Well, then, why don't we do it? All boxes I know
> have tons of RAM, but fs finds no place in RAM to put large parts (if not all)
> of the structural fs data including filenames?

I'm afraid it just isn't practical to keep all of the metadata in ram
all of the time.

>  Besides the simple fact that
> RAM is always faster than any known disk be it rotating or not, and that RAM
> is just there, whats the word for not doing it?
> 

People expect the OS to use the expensive ram for the data they use most
often.

> > > > >     - parallel mounts (very important!)
> > > > >       (two or more hosts mount the same fs concurrently for reading and
> > > > >       writing)
> > > > 
> > > > As Jim and Andi have said, parallel mounts are not in the feature list
> > > > for Btrfs.  Network filesystems will provide these features.
> > > 
> > > Can you explain what "network filesystems" stands for in this statement,
> > > please name two or three examples.
> > > 
> > NFS (done) CRFS (under development), maybe ceph as well which is also
> > under development.
> 
> NFS is a good example for a fs that never got redesigned for modern world. I
> hope it will, but currently it's like Model T on a highway.
> You have a NFS server with clients. Your NFS server dies, your backup server
> cannot take over the clients without them resetting their NFS-link (which
> means reboot to many applications) - no way.
> Besides that you still need another fs below NFS to bring your data onto some
> medium, which means you still have the problem how to create redundancy in
> your server architecture.
> 

As someone else replied, NFS is stateless, and they have made a large
number of design tradeoffs to stay that way.  So, your example above
isn't quite fair, it is one of the things the NFS protocol can handle
well.

With that said, CRFS is a network filesystem designed explicitly for
btrfs, and I have high hopes for it.

> > > > >     - versioning (file and dir)
> > > > 
> > > > >From a data structure point of view, version control is fairly easy.
> > > > >From a user interface and policy point of view, it gets difficult very
> > > > quickly.  Aside from snapshotting, version control is outside the scope
> > > > of btrfs.
> > > > 
> > > > There are lots of good version control systems available, I'd suggest
> > > > you use them instead.
> > > 
> > > To me versioning sounds like a not-so-easy-to-implement feature. Nevertheless
> > > I trust your experience. If a basic implementation is possible and not too
> > > complex, why deny a feature? 
> > > 
> > 
> > In general I think snapshotting solves enough of the problem for most of
> > the people most of the time.  I'd love for Btrfs to be the perfect FS,
> > but I'm afraid everyone has a different definition of perfect.
> > 
> > Storing multiple versions of something is pretty easy.  Making a usable
> > interface around those versions is the hard part, especially because you
> > need groups of files to be versioned together in atomic groups
> > (something that looks a lot like a snapshot).
> > 
> > Versioning is solved in userspace.  We would never be able to implement
> > everything that git or mercurial can do inside the filesystem.
> 
> Well, quite often the question is not about whole trees of data to be
> versioned. Even single (few) files or dirs can be of interest. And you want
> people to set up a complete user space monster to version three openoffice
> documents (only a rather flawed example of course)? 
> Lots of people need a basic solution, not the groundbreaking answer to all
> questions.
> 
One of the things that makes FS design so difficult is that people try
to solve lots of problems with filesystems.  Every feature we include is
a mixture of disk format, policy and userland interface that must be
tested in combination with all of the other features, and maintained
pretty much forever.

A big part of my job is to find the features that are sufficient to
justify the expense of starting from scratch, and to get things finished
within a reasonable amount of time.

Btrfs already has an ioctl to create a COW copy of a file (see the bcp
command in btrfs-progs).  This is enough for applications to do their
own single file versioning.

I understand this isn't the automatic system you would like for the use
case above, but I have to draw the line somewhere in terms of providing
the tools needed to implement features vs including all the features in
the FS.

A big part of why Btrfs is gaining ground today is that we're focusing
on finishing the features we have instead of adding the kitchen sink.
It is very hard to say no to interested users, but it's a reality of
actually bringing the software to market.

> > > If your hd is going dead you often find out that touching broken files takes
> > > ages. If the fs finds out a file is corrupt because the device has errors it
> > > could just flag the file as broken and not re-read the same error a thousand
> > > times more. Obviously you want that as an option, because there can be good
> > > reasons for re-reading dead files...
> > 
> > I really agree that we want to avoid beating on a dead drive.
> > 
> > Btrfs will record some error information about the drive so it can
> > decide what to do with failures.  But, remembering that sector #12345768
> > is bad doesn't help much.  When the drive returned the IO error it
> > remapped the sector and the next write will probably succeed.
> 
> Problem with probability is that software is pretty bad in judging. That's why
> my proposal was, lets do it and make it configurable for an admin that has a
> better idea of the current probability.
> 

Let me reword my answer ;).  The next write will always succeed unless
the drive is out of remapping sectors.  If the drive is out, it is only
good for reads and holding down paper on your desk.

This means we'll want to do a raid rebuild, which won't use that drive
unless something horrible has gone wrong.

> > > > >     - map out dead blocks
> > > > >       (and of course display of the currently mapped out list)
> > > > 
> > > > I agree with Jim on this one.  Drives remap dead sectors, and when they
> > > > stop remapping them, the drive should be replaced.
> > > 
> > > If your life depends on it, would you use one rope or two to secure yourself?
> > > 
> > 
> > Btrfs will keep the dead drive around as a fallback for sectors that
> > fail on the other mirrors when data is being rebuilt.  Beyond that,
> > we'll expect you to toss the bad drive once the rebuild has finished.
> > 
> > There's an interesting paper about how netapp puts the drive into rehab
> > and is able to avoid service calls by rewriting the bad sectors and
> > checking them over.  That's a little ways off for Btrfs.
> 
> It will become more interesting what remapping means in a world full of
> flash-disks. Does it mean a disk must be replaced when some or even lots of
> sectors are dead? 

Yes the disk must be replaced.  Our job here is not to provide people
with hope they can get to some of the data some of the time.  Our job is
to tell them a given component is bad and to have it replaced.

-chris


