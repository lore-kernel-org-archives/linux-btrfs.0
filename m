From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 05 Jan 2011 20:29:30 -0500
Message-ID: <1294276285-sup-9136@think>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net>
Content-Type: text/plain; charset=UTF-8
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D24AD92.4070107@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Gordan Bobic's message of 2011-01-05 12:42:42 -0500:
> Josef Bacik wrote:
> 
> > Basically I think online dedup is huge waste of time and completely useless.
> 
> I couldn't disagree more. First, let's consider what is the 
> general-purpose use-case of data deduplication. What are the resource 
> requirements to perform it? How do these resource requirements differ 
> between online and offline?

I don't really agree with Josef that dedup is dumb, but I do think his
current approach is the most reasonable.  Dedup has a few very valid use
cases, which I think break down to:

1) backups
2) VM images.

The backup farm use case is the best candidate for dedup in general
because they are generally write once and hopefully read never.
Fragmentation for reading doesn't matter at all and we're really very
sure we're going to backup the same files over and over again.

But, it's also something that will be dramatically more efficient when
the backup server helps out.  The backup server knows two files have the
same name, same size and can guess with very high accuracy that they
will be the same.  So it is a very good candidate for Josef's offline
dedup because it can just do the dedup right after writing the file.

In the backup farm, whole files are very likely to be identical, which
again is very easy to optimize with Josef's approach.

Next is the VM images.  This is actually a much better workload for
online dedup, except for the part where our poor storage server would be
spending massive amounts of CPU deduping blocks for all the VMs on the
machine.  In this case the storage server doesn't know the
filenames, it just has bunches of blocks that are likely to be the same
across VMs.

So, it seems a bit silly to do this out of band, where we wander through
the FS and read a bunch of blocks in hopes of finding ones with the same
hash.

But, one of the things on our features-to-implement page is to wander
through the FS and read all the blocks from time to time.  We want to do
this in the background to make sure the bits haven't rotted on disk.  By
scrubbing from time to time we are able to make sure that when a disk
does die, other disks in the FS are likely to have a good copy.

So again, Josef's approach actually works very well.  His dedup util
could be the scrubbing util and we'll get two projects for the price of
one.

As for the security of hashes, we're unlikely to find a collision on a
sha256 that wasn't made maliciously.  If the system's data is
controlled and you're not worried about evil people putting files on
there, extra reads really aren't required.

But then again, extra reads are a good thing (see above about
scrubbing).  The complexity of the whole operation goes down
dramatically when we do the verifications because hash index corruptions
(this extent has this hash) will be found instead of blindly trusted.

None of this means that online dedup is out of the question, I just
think the offline stuff is a great way to start.

-chris
