From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] btrfs send and receive
Date: Tue, 02 Aug 2011 19:42:02 +0200
Message-ID: <2611416.qFuztk21pN@venice>
References: <4E369A80.9030307@jan-o-sch.net> <1312298057-sup-3959@shiny> <4E381F70.4080102@jan-o-sch.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E381F70.4080102@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

[...]
> 
> Furthermore, receiving should not need kernel support at all (except for
> an optional interface to create a file with a certain inode, we'll see).
> Thus, replicating metadata corruptions should be very unlikely.

I think that for receiving we can have three level, which may represent three 
level in the develop:

1) we store the information as a pax|tar|git|... file format. Then is the user 
that can expand this file when needed. I think that in case of backup this is 
more useful than having a full filesystem. No help from kernel required.

2) we expand the stream in files; so the final results would be a filesystem.
2.1) as above but preserving the inode number (small help from kernel 
required, may be file-system independent also)
2.2) as above but preserving the COW properties: if we update an already 
snapshotted file, btrfs store the original one and the modified data. The same 
would be in the destination filesystem: if exists the previous file snapshot, 
in the filesystem is COW-ed the file updating only the "new data". (help from 
kernel side. I don't know if it is possible to adapt this strategy for other 
filesystem than BTRFS)

3) extracting from the source filesystem the btree structure, and injecting in 
the btrfs filesystem this structure. I think that this has the best 
performance, both in terms of CPU-power and in bandwidth. Full kernel support 
required.


> One more thing to add: We have to make sure our stream doesn't get
> corrupted. So if the file format we're choosing does not include it, we
> should keep in mind to add something ourselves.

The best would be using the BTRFS checksum.

> 
> > In terms of formats, I came to similar conclusions a while ago about
> > cpio, tar and dar.  I haven't looked in detail at pax but don't have any
> > strong feelings against it.
> > 
> > But, I'll toss in an alternative.  Adapt the git pack files a little and
> > use them as the format.  There are a few reasons for this:
> > 
> > Git has a very strong developer community and is already being
> > hammered into use as a backup application.  You'll find a lot of
> > interested people to help out.
> > 
> > Git separates the contents from the metadata (names).  This makes it
> > naturally suited to describing snapshots and other features.  The big
> > exception is in large file handling, but you could extend the format to
> > describe filename,offset,len->sha instead of just filename->sha.
> 
> That sounds interesting. I haven't thought of git until now. It will
> lack the appealing feature to unpack without any special tools or a
> modified git client, I think. But I believe there are things that would
> get easier compared to pax.
> 
> I'll try to make a plan how it could be implemented with git, so that we
> have something we can compare.

I suggest to give a look to the fast-import/export format, which is "de facto" 
standard about sharing information between the new CVS system.

> 
> > This doesn't mean I'll reject a pax setup, it's just an alternative to
> > think about.  We should have the actual data transmission format pretty
> > well abstracted away so we can experiment with alternatives.
> 
> Yes, that would be nice. I'll keep that in mind. If both have their
> advantages, we might end up having one format in the first
> implementation and another one added later once the rest is working.
> 
> > In terms of transmitting snapshot details, I always assumed we would
> > need a snapshot tool that added extra metadata about parent
> > relationships on the snapshots.  I didn't want to enforce this in the
> > metadata on disk, but I have no problems with saying the send/receive
> > tool requires extra metadata to tell us about parents.
> 
> Oh, right. That's something that might not only need kernel support for
> "send" to determine a parent, but also a new key representing a
> snapshot's parent relationship information.

I think that this information already exists. In fact every snapshot has a 
reference to the original data, on the basis of which it is possible to obtain 
the snapshot's parent relationship information.

However we need to be sure that when we send the "delta" between two snapshot 
to the receiver side, the receiver side:
1) has a copy of the previous snapshot
2) this copy is in sync to the original one

I think (please Chris confirm that) that we can check this with the subvolume 
id and the generation-no of every snapshot, which should be unique.

> 
> I'll think that over, currently I tend to adding these relationship keys
> around btrfs_ioctl_snap_create soon, so we have at least some file
> systems in the wild that are ready for send and receive once it's done.
> 
> Thanks,
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
