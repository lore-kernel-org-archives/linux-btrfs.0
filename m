From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 10:33:16 +0000
Message-ID: <4D259A6C.6010707@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <1294276285-sup-9136@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294276285-sup-9136@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Excerpts from Gordan Bobic's message of 2011-01-05 12:42:42 -0500:
>> Josef Bacik wrote:
>>
>>> Basically I think online dedup is huge waste of time and completely useless.
>> I couldn't disagree more. First, let's consider what is the 
>> general-purpose use-case of data deduplication. What are the resource 
>> requirements to perform it? How do these resource requirements differ 
>> between online and offline?
> 
> I don't really agree with Josef that dedup is dumb, but I do think his
> current approach is the most reasonable.  Dedup has a few very valid use
> cases, which I think break down to:
> 
> 1) backups
> 2) VM images.
> 
> The backup farm use case is the best candidate for dedup in general
> because they are generally write once and hopefully read never.
> Fragmentation for reading doesn't matter at all and we're really very
> sure we're going to backup the same files over and over again.
> 
> But, it's also something that will be dramatically more efficient when
> the backup server helps out.  The backup server knows two files have the
> same name, same size and can guess with very high accuracy that they
> will be the same.  So it is a very good candidate for Josef's offline
> dedup because it can just do the dedup right after writing the file.

File level deduplication in addition to block level would be great, no 
argument there. This can again be done more efficiently in-line, though, 
as the files come in.

> Next is the VM images.  This is actually a much better workload for
> online dedup, except for the part where our poor storage server would be
> spending massive amounts of CPU deduping blocks for all the VMs on the
> machine.  In this case the storage server doesn't know the
> filenames, it just has bunches of blocks that are likely to be the same
> across VMs.

I'm still unconvinced that deduping's major cost is CPU. I think in any 
real case it'll be disk I/O.

> So, it seems a bit silly to do this out of band, where we wander through
> the FS and read a bunch of blocks in hopes of finding ones with the same
> hash.

Except you can get this almost for free. How about this approach:

1) Store a decent size hash for each block (checksum for ECC - something 
like this already happens, it's just a question of what hashing 
algorithm to use)

2) Keep a (btree?) index of all known hashes (this doesn't happen at the 
moment, AFAIK, so this would be the bulk of the new cost for dedup).

Now there are 2 options:

3a) Offline - go through the index, find the blocks with duplicate 
hashes, relink the pointers to one of them and free the rest. There is 
no need to actually read/write any data unless we are doing full block 
compare, only metadata needs to be updated. The problem with this is 
that you would still have to do a full index scan of the index to find 
all the duplicates, unless there is a second index specifically listing 
the duplicate blocks (maintained at insertion time).

3b) Online - look up whether the hash for the current block is already 
in the index ( O(log(n)) ), and if it is, don't bother writing the data 
block, only add a pointer to the existing block. No need for a second 
index with duplicate blocks in this case, either.

> But, one of the things on our features-to-implement page is to wander
> through the FS and read all the blocks from time to time.  We want to do
> this in the background to make sure the bits haven't rotted on disk.  By
> scrubbing from time to time we are able to make sure that when a disk
> does die, other disks in the FS are likely to have a good copy.

Scrubbing the whole FS seems like an overly expensive way to do things 
and it also requires low-load times (which don't necessarily exist). How 
about scrubbing disk-by-disk, rather than the whole FS? If we keep 
checksums per block, then each disk can be checked for rot 
independently. It also means that if redundancy is used, the system 
doesn't end up anywhere nearly as crippled during the scrubbing as the 
requests can be served from other disks that are a part of that FS (e.g. 
the mirrored pair in RAID1, or the parity blocks in higher level RAIDs).

> So again, Josef's approach actually works very well.  His dedup util
> could be the scrubbing util and we'll get two projects for the price of
> one.

Indeed, the scrubber would potentially give deduping functionality for 
free, but I'm not convinced that having deduping depend on scrubbing is 
the way forward. This is where we get to multi-tier deduping again - 
perhaps have things markable for online or offline dedupe, as deemed 
more appropriate?

> As for the security of hashes, we're unlikely to find a collision on a
> sha256 that wasn't made maliciously.  If the system's data is
> controlled and you're not worried about evil people putting files on
> there, extra reads really aren't required.

If you manage to construct one maliciously that's pretty bad in itself, 
though. :)

> But then again, extra reads are a good thing (see above about
> scrubbing).

Only under very, very controlled conditions. This is supposed to be the 
"best" file system, not the slowest. :)

> The complexity of the whole operation goes down
> dramatically when we do the verifications because hash index corruptions
> (this extent has this hash) will be found instead of blindly trusted.

That is arguably an issue whatever you do, though. You have to trust 
that the data you get back off the disk is correct at least most of the 
time. Also, depending on what the extent of corruption is, you would 
potentially be able to spot it by having a hash out of order in the 
index (much cheaper, but says nothing about the integrity of the block 
itself).

> None of this means that online dedup is out of the question, I just
> think the offline stuff is a great way to start.


As I said, I'm not against offline dedupe for certain use cases, I'm 
merely saying that at a glance, overall, online dedup is more efficient.

Another point that was raised was about fragmentation. Thinking about 
it, there wouldn't be any extra fragmentation where complete files' 
worth of blocks were deduped. You'd end up with the blocks still laid 
out sequentially on the disk (assuming we don't deliberately pick a 
random instance of a block to link to but instead do something sensible).

Gordan
