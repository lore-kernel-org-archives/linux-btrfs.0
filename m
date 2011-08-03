From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] btrfs send and receive
Date: Wed, 03 Aug 2011 22:43:26 +0200
Message-ID: <1335149.9cmILjyzSG@venice>
References: <4E369A80.9030307@jan-o-sch.net> <2611416.qFuztk21pN@venice> <4E396388.7040809@jan-o-sch.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E396388.7040809@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 03 August, 2011 17:04:40 Jan Schmidt wrote:
> On 02.08.2011 19:42, Goffredo Baroncelli wrote:
> >> Furthermore, receiving should not need kernel support at all (except for
> >> an optional interface to create a file with a certain inode, we'll see).
> >> Thus, replicating metadata corruptions should be very unlikely.
> > 
> > I think that for receiving we can have three level, which may represent
> > three level in the develop:
> > 
> > 1) we store the information as a pax|tar|git|... file format. Then is the
> > user that can expand this file when needed. I think that in case of
> > backup this is more useful than having a full filesystem. No help from
> > kernel required.
> > 
> > 2) we expand the stream in files; so the final results would be a
> > filesystem.
> How would you test your stream from 1) if you can't unpack it?

If we are able to store the information in a standard format (like tar), we 
are able to unpack when we need.

The difference between the point 1 and 2 is  that for the point #1 is not 
required to develop the "extraction side". This doesn't means that we *must 
not* develop, this means that we *may* delay the develop of the extraction 
side, and having something really useful. 

The point 2) requires to develop an extraction tool (the "btrfs receive" 
command),  which would be able to handle further metadata like the "parent 
relationship" which you refer below.

I think that the extraction would be like:

sender> hello "receiver", which snapshot do you have ?
receiver> hello "sender", I have snapshot A, B ,D
sender> ok, I have the snapshot B and C, so I will send you the delta from 
               snapshot B, which is the latest in common.
sender> send data .....

This is far away from a simple tar (or pax or git...) file format.

> 
> > 2.1) as above but preserving the inode number (small help from kernel
> > required, may be file-system independent also)
> 
> I would skip that and add it as an extention, later.
> 
> > 2.2) as above but preserving the COW properties: if we update an already
> > snapshotted file, btrfs store the original one and the modified data. The
> > same would be in the destination filesystem: if exists the previous file
> > snapshot, in the filesystem is COW-ed the file updating only the "new
> > data". (help from kernel side. I don't know if it is possible to adapt
> > this strategy for other filesystem than BTRFS)
> 
> Again, I'd rather gather those information (possibly with help from the
> kernel) when generating the stream. This is what I answered and tried to
> explain by example in my mail yesterday. Please tell me which part was
> unclear and I'll try to explain better.

I am talking *only* about the receiving. How we gather these information is 
not (for the moment) in discussion

> 
> With the algorithm outlined yesterday, you don't need any kernel support
> when receiving, so it should be adaptable by any filesystem that
> supports snapshots.

Right

> 
> > 3) extracting from the source filesystem the btree structure, and
> > injecting in the btrfs filesystem this structure. I think that this has
> > the best performance, both in terms of CPU-power and in bandwidth. Full
> > kernel support required.
> 
> This is like a diff-aware dd, or did I get you wrong? If it is: do you
> really think we need it? What for?

I cited it only as "brainstorm" approach. The only gain is its space efficency.

> 
> >> One more thing to add: We have to make sure our stream doesn't get
> >> corrupted. So if the file format we're choosing does not include it, we
> >> should keep in mind to add something ourselves.
> > 
> > The best would be using the BTRFS checksum.
> 
> Sounds interesting. How would you add a btrfs checksum to a stream file
> (no matter what format we'll use)? And how would you verify it?

I think that btrfs already store a checksum per block basis. When we send the 
stream we could get this information from btrfs and send together. This only 
to avoid to recalculate a checksum. Pay attention that I think that btrfs 
stores the checksum only for the data, and not for the full files. What I means 
is that if a file is cow-ed, btrfs store the original data and only the data 
updated, then store the checksum for the original file and the checksum for the 
data updated. It don't store the checksum for the full file updated. This means 
that if we try to rebuild the file applying a delta we don't have a checksum of 
the full file to compare.

> 
> >> I'll try to make a plan how it could be implemented with git, so that we
> >> have something we can compare.
> > 
> > I suggest to give a look to the fast-import/export format, which is "de
> > facto" standard about sharing information between the new CVS system.
> 
> Thanks for the hint, I will include that in my considerations.
> 
> >>> In terms of transmitting snapshot details, I always assumed we would
> >>> need a snapshot tool that added extra metadata about parent
> >>> relationships on the snapshots.  I didn't want to enforce this in the
> >>> metadata on disk, but I have no problems with saying the send/receive
> >>> tool requires extra metadata to tell us about parents.
> >> 
> >> Oh, right. That's something that might not only need kernel support for
> >> "send" to determine a parent, but also a new key representing a
> >> snapshot's parent relationship information.
> > 
> > I think that this information already exists. In fact every snapshot has a
> > reference to the original data, on the basis of which it is possible to
> > obtain the snapshot's parent relationship information.
> 
> How can that be done? I don't see such a link.

Give a look at

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Backref_walking_utilities

but I have to admit that the real state is different from what I (wrlongly) 
understood of the btrfs internal.


> 
> > However we need to be sure that when we send the "delta" between two
> > snapshot to the receiver side, the receiver side:
> > 1) has a copy of the previous snapshot
> > 2) this copy is in sync to the original one
> > 
> > I think (please Chris confirm that) that we can check this with the
> > subvolume id and the generation-no of every snapshot, which should be
> > unique.
> uuid + generation was my suggestion as well, should be unique, yes.
> 
> -Jan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
