From: "Erwin van Londen" <erwin.vanlonden@hds.com>
Subject: RE: btrfs for enterprise raid arrays
Date: Sun, 5 Apr 2009 17:29:44 -0700
Message-ID: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536CA3F@USSCCEVS102.corp.hds.com>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com> <1238764969.32764.16.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Cc: <linux-btrfs@vger.kernel.org>
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238764969.32764.16.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris,
 

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Chris Mason
> Sent: Saturday, 4 April 2009 12:23 AM
> To: Erwin van Londen
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: btrfs for enterprise raid arrays
> 
> On Thu, 2009-04-02 at 21:34 -0700, Erwin van Londen wrote:
> > Dear all,
> >
> > While going through the archived mailing list and crawling along the
> > wiki I didn't find any clues if there would be any optimizations in
> > Btrfs to make efficient use of functions and features that today
exist
> > on enterprise class storage arrays.
> >
> > One exception to that was the ssd option which I think can make a
> > improvement on read and write IO's however when attached to a
storage
> > array, from an OS perspective, it doesn't really matter since it
can't
> > look behind the array front-end interface anyhow(whether it FC/iSCSI
> > or any other).
> >
> > There are however more options that we could think of. Almost all
> > storage arrays these days have the capabilities to replicate volume
> > (or part of it in COW cases) either in the system or remotely. It
> > would be handy that if a Btrfs formatted volume could make use of
> > those features since this might offload a lot of the processing time
> > involved in maintaining these. The arrays already have optimized
code
> > to make these snapshots. I'm not saying we should step away from the
> > host based snapshots but integration would be very nice.
> 
> Storage based snapshotting would definitely be useful for replication
in
> btrfs, and in that case we could wire it up from userland.  Basically
> there is a point during commit where a storage snapshot could be taken
> and fully consistent.
> 
> Outside of replication though, I'm not sure exactly where storage
based
> snapshotting would come in.  It wouldn't really be compatible with the
> snapshots btrfs is already doing (but I'm always open to more ideas).

There is a Linux interface however I don't think it Open Source
(unfortunately) which runs from userland but directly "talks" to the
array to a so-called "command device". From a usability perspective you
could mount this snapshot/shadow image to a second server and process
data from there. (backups etc.)

> 
> > Furthermore some enterprise array have a feature that allows for
full
> > or partial staging data in cache. By this I mean when a volume
> > contains a certain amount of blocks you can define to have the first
X
> > number of blocks pre-staged in cache which enables you to have
> > extremely high IO rates on these first ones. An option related to
the
> > -ssd parameter could be to have a mount command say "mount -t btrfs
> > -ssd 0-10000" so Btrfs knows what to expect from the partial area
and
> > maybe can optimize the locality of frequently used blocks to
optimize
> > performance.
> 
> This would be very useful, although I would tend to export it to btrfs
> as a second lun.  My long term goal is to have code in btrfs that
> supports a super fast staging lun, which might be an ssd or cache
carved
> out of a high end array.

The problem with that is addressability especially if you have a
significant amount of volumes attached to a host and are using FC
multi-pathing tools underneath. From an administrative point of view
this will complicate things a lot. The option that I mentioned is
transparent to the admin and he only needs to get the number of blocks
added to the mount command or fstab.

Bear in mind that this method (staging in cache) is still a lot faster
that having flash drives since there is no back-end traffic going on.
All IO's only touch cache and front-end ports. As I said there is also
the option to put a full volume in cache however from a financial point
of view this will become expensive. That's one of the reasons why we
came up with the partial bit.

> >
> > Another thing is that some arrays have the capability to
> > "thin-provision" volumes. In the back-end on the physical layer the
> > array configures, let say, a 1 TB volume and virtually provisions
5TB
> > to the host. On writes it dynamically allocates more pages in the
pool
> > up to the 5TB point. Now if for some reason large holes occur on the
> > volume, maybe a couple of ISO images that have been deleted, what
> > normally happens is just some pointers in the inodes get deleted so
> > from an array perspective there is still data on those locations and
> > will never release those allocated blocks. New firmware/microcode
> > versions are able to reclaim that space if it sees a certain number
of
> > consecutive zero's and will reclaim that space to the volume pool.
Are
> > there any thoughts on writing a low-priority tread that zeros out
> > those "non-used" blocks?
> 
> Other people have replied about the trim commands, which btrfs can
issue
> on every block it frees.  But, another way to look at this is that
btrfs
> already is thinly provisioned.  When you add storage to btrfs, it
> allocates from that storage in 1GB chunks, and then hands those over
to
> the FS allocation code for more fine grained use.
> 
> It may make sense to talk about how that can fit in with your own thin
> provisioning.

The problem is that the arrays have to be pre-configured for volume
level allocation. Whether this is a normal volume or thin-provisioned
volume it doesn't matter. You're right if you say that if the array had
interface(s) so it would dynamically allocate blocks from those pools as
soon as btrfs addresses those that would be fantastic. Unfortunately
today that's not the case and it's one-way traffic. Not only from our
arrays but from other vendors as well. So a thin-provisioned volume
still presents a fixed number of block to the host although in the back
it will derive those blocks as soon they get "touched". After this those
blocks will be reserved for that volume from the pool unless something
tells the array to free it up. Currently it's only achievable, from an
array perspective, to release those pages if it sees a consecutive
number of zero's. I'm currently not aware that the array software
fulfills the trim commands but I can have a look around.  

> 
> > Given the scalability targets of Btrfs it will most likely be
heavily
> > used in the enterprise environment once it reaches a stable code
> > level. If we would be able to interface with these array based
> > features that would be very beneficial.
> >
> > Furthermore one question also pops to mind and that's when looking
at
> > the scalability of Btrfs and its targeted capacity levels I think we
> > will run into problems with the capabilities of the server hardware
> > itself. From what I can see now it will not be designed as a
> > distributed file-system with integrated distributed lock manager to
> > scale out over multiple nodes. (I know Oracle is working on a
similar
> > thing but this might get things more complicated than it already
is.)
> > This might impose some serious issues with recovery scenarios like
> > backup/restore since it will take quite some time to backup/restore
a
> > multi PB system when it resides on just 1 physical host even when
> > we're talking high end P-series, I25K's or Superdome class.
> 
> This is true.  Things like replication and failover are the best plans
> for it today.
> 
> Thanks for your interest, we're always looking for ways to better
> utilize high end storage features.

No problem. My interest is in the adoption level as well and given the
fact that large companies will be mostly utilizing these array's they
are the ones who will most benefit from a filesystem that gives them the
flexibility and robustness  that we're targeting for with btrfs.

> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
