From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 05 Jan 2011 17:42:42 +0000
Message-ID: <4D24AD92.4070107@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294245410-4739-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:

> Basically I think online dedup is huge waste of time and completely useless.

I couldn't disagree more. First, let's consider what is the 
general-purpose use-case of data deduplication. What are the resource 
requirements to perform it? How do these resource requirements differ 
between online and offline?

The only sane way to keep track of hashes of existing blocks is using an 
index. Searches through an index containing evenly distributed data 
(such as hashes) is pretty fast (log(N)), and this has to be done 
regardless of whether the dedupe is online or offline. It also goes 
without saying that all the blocks being deduplicated need to be hashed, 
and the cost of this is also the same whether the block is hashes online 
or offline.

Let's look at the relative merits:

1a) Offline
We have to copy the entire data set. This means we are using the full 
amount of disk writes that the data set size dictates. Do we do the 
hashing of current blocks at this point to create the indexes? Or do we 
defer it until some later time?

Doing it at the point of writes is cheaper - we already have the data in 
RAM and we can calculate the hashes as we are writing each block. 
Performance implications of this are fairly analogous to the parity RAID 
RMW performance issue - to achieve decent performance you have to write 
the parity at the same time as the rest of the stripe, otherwise you 
have to read the part of the stripe you didn't write, before calculating 
the checksum.

So by doing the hash indexing offline, the total amount of disk I/O 
required effectively doubles, and the amount of CPU spent on doing the 
hashing is in no way reduced.

How is this in any way advantageous?

1b) Online
As we are writing the data, we calculate the hashes for each block. (See 
1a for argument of why I believe this is saner and cheaper than doing it 
offline.) Since we already have these hashes, we can do a look-up in the 
hash-index, and either write out the block as is (if that hash isn't 
already in the index) or simply write the pointer to an existing 
suitable block (if it already exists). This saves us writing out that 
block - fewer writes to the disk, not to mention we don't later have to 
re-read the block to dedupe it.

So in this case, instead of write-read-relink of the offline scenario, 
we simply do relink on duplicate blocks.

There is another reason to favour the online option due to it's lower 
write stress - SSDs. Why hammer the SSD with totally unnecessary writes?

The _only_ reason to defer deduping is that hashing costs CPU time. But 
the chances are that a modern CPU core can churn out MD5 and/or SHA256 
hashes faster than a modern mechanical disk can keep up. A 15,000rpm 
disk can theoretically handle 250 IOPS. A modern CPU can handle 
considerably more than 250 block hashings per second. You could argue 
that this changes in cases of sequential I/O on big files, but a 1.86GHz 
GHz Core2 can churn through 111MB/s of SHA256, which even SSDs will 
struggle to keep up with.

I don't think that the realtime performance argument withstands scrutiny.

> You are going to want to do different things with different data.  For example,
> for a mailserver you are going to want to have very small blocksizes, but for
> say a virtualization image store you are going to want much larger blocksizes.
> And lets not get into heterogeneous environments, those just get much too
> complicated.

In terms of deduplication, IMO it should really all be uniform, 
transparent, and block based. In terms of specifying which subtrees to 
dedupe, that should really be a per subdirectory hereditary attribute, 
kind of like compression was supposed to work with chattr +c in the past.

> So my solution is batched dedup, where a user just runs this
> command and it dedups everything at this point.  This avoids the very costly
> overhead of having to hash and lookup for duplicate extents online and lets us
> be _much_ more flexible about what we want to deduplicate and how we want to do
> it.

I don't see that it adds any flexibility compared to the hereditary 
deduping attribute. I also don't see that it is any cheaper. It's 
actually more expensive, according to the reasoning above.

As an aside, zfs and lessfs both do online deduping, presumably for a 
good reason.

Then again, for a lot of use-cases there are perhaps better ways to 
achieve the targed goal than deduping on FS level, e.g. snapshotting or 
something like fl-cow:
http://www.xmailserver.org/flcow.html

Personally, I would still like to see a fl-cow like solution that 
actually preserves the inode numbers of duplicate files while providing 
COW functionality that breaks this unity (and inode number identity) 
upon writes, specifically because it saves page cache (only have to 
cache one copy) and in case of DLLs on chroot style virtualization 
(OpenVZ, Vserver, LXC) means that identical DLLs in all the guests are 
all mapped into the same memory, thus yielding massive memory savings on 
machines with a lot of VMs.

Gordan
