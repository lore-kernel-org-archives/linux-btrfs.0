From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC] btrfs send and receive
Date: Wed, 03 Aug 2011 17:04:40 +0200
Message-ID: <4E396388.7040809@jan-o-sch.net>
References: <4E369A80.9030307@jan-o-sch.net> <1312298057-sup-3959@shiny> <4E381F70.4080102@jan-o-sch.net> <2611416.qFuztk21pN@venice>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2611416.qFuztk21pN@venice>
List-ID: <linux-btrfs.vger.kernel.org>

On 02.08.2011 19:42, Goffredo Baroncelli wrote:
>> Furthermore, receiving should not need kernel support at all (except for
>> an optional interface to create a file with a certain inode, we'll see).
>> Thus, replicating metadata corruptions should be very unlikely.
> 
> I think that for receiving we can have three level, which may represent three 
> level in the develop:
> 
> 1) we store the information as a pax|tar|git|... file format. Then is the user 
> that can expand this file when needed. I think that in case of backup this is 
> more useful than having a full filesystem. No help from kernel required.
> 
> 2) we expand the stream in files; so the final results would be a filesystem.

How would you test your stream from 1) if you can't unpack it?

> 2.1) as above but preserving the inode number (small help from kernel 
> required, may be file-system independent also)

I would skip that and add it as an extention, later.

> 2.2) as above but preserving the COW properties: if we update an already 
> snapshotted file, btrfs store the original one and the modified data. The same 
> would be in the destination filesystem: if exists the previous file snapshot, 
> in the filesystem is COW-ed the file updating only the "new data". (help from 
> kernel side. I don't know if it is possible to adapt this strategy for other 
> filesystem than BTRFS)

Again, I'd rather gather those information (possibly with help from the
kernel) when generating the stream. This is what I answered and tried to
explain by example in my mail yesterday. Please tell me which part was
unclear and I'll try to explain better.

With the algorithm outlined yesterday, you don't need any kernel support
when receiving, so it should be adaptable by any filesystem that
supports snapshots.

> 3) extracting from the source filesystem the btree structure, and injecting in 
> the btrfs filesystem this structure. I think that this has the best 
> performance, both in terms of CPU-power and in bandwidth. Full kernel support 
> required.

This is like a diff-aware dd, or did I get you wrong? If it is: do you
really think we need it? What for?

>> One more thing to add: We have to make sure our stream doesn't get
>> corrupted. So if the file format we're choosing does not include it, we
>> should keep in mind to add something ourselves.
> 
> The best would be using the BTRFS checksum.

Sounds interesting. How would you add a btrfs checksum to a stream file
(no matter what format we'll use)? And how would you verify it?

>> I'll try to make a plan how it could be implemented with git, so that we
>> have something we can compare.
> 
> I suggest to give a look to the fast-import/export format, which is "de facto" 
> standard about sharing information between the new CVS system.

Thanks for the hint, I will include that in my considerations.

>>> In terms of transmitting snapshot details, I always assumed we would
>>> need a snapshot tool that added extra metadata about parent
>>> relationships on the snapshots.  I didn't want to enforce this in the
>>> metadata on disk, but I have no problems with saying the send/receive
>>> tool requires extra metadata to tell us about parents.
>>
>> Oh, right. That's something that might not only need kernel support for
>> "send" to determine a parent, but also a new key representing a
>> snapshot's parent relationship information.
> 
> I think that this information already exists. In fact every snapshot has a 
> reference to the original data, on the basis of which it is possible to obtain 
> the snapshot's parent relationship information.

How can that be done? I don't see such a link.

> However we need to be sure that when we send the "delta" between two snapshot 
> to the receiver side, the receiver side:
> 1) has a copy of the previous snapshot
> 2) this copy is in sync to the original one
> 
> I think (please Chris confirm that) that we can check this with the subvolume 
> id and the generation-no of every snapshot, which should be unique.

uuid + generation was my suggestion as well, should be unique, yes.

-Jan

