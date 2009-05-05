From: Heinz-Josef Claes <hjclaes@web.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 5 May 2009 09:18:36 +0200
Message-ID: <20090505091836.9c60feb8.hjclaes@web.de>
References: <1240839448.26451.13.camel@think.oraclecorp.com>
	<20090428173251.GB7217@cip.informatik.uni-erlangen.de>
	<49F73FC9.3070607@partiallystapled.com>
	<49FEFBE6.40209@redhat.com>
	<49FEFE27.5090804@wpkg.org>
	<49FEFF9A.8060803@redhat.com>
	<20090504151518.GA13777@cip.informatik.uni-erlangen.de>
	<49FF11EE.2060404@redhat.com>
	<20090504162650.GD13777@cip.informatik.uni-erlangen.de>
	<49FF3DCD.40306@web.de>
	<3a7f57190905041429u14c16412rc25b10018a19abd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190905041429u14c16412rc25b10018a19abd6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 May 2009 07:29:45 +1000
Dmitri Nikulin <dnikulin@gmail.com> wrote:

> On Tue, May 5, 2009 at 5:11 AM, Heinz-Josef Claes <hjclaes@web.de> wrote:
> > Hi, during the last half year I thought a little bit about doing dedup for
> > my backup program: not only with fixed blocks (which is implemented), but
> > with moving blocks (with all offsets in a file: 1 byte, 2 byte, ...). That
> > means, I have to have *lots* of comparisions (size of file - blocksize).
> > Even it's not the same, it must be very fast and that's the same problem
> > like the one discussed here.
> >
> > My solution (not yet implemented) is as follows (hopefully I remember well):
> >
> > I calculate a checksum of 24 bit. (there can be another size)
> >
> > This means, I can have 2^24 different checksums.
> >
> > Therefore, I hold a bit verctor of 0,5 GB in memory (I hope I remember well,
> > I'm just in a hotel and have no calculator): one bit for each possibility.
> > This verctor is initialized with zeros.
> >
> > For each calculated checksum of a block, I set the according bit in the bit
> > vector.
> >
> > It's very fast, to check if a block with a special checksum exists in the
> > filesystem (backup for me) by checking the appropriate bit in the bit
> > vector.
> >
> > If it doesn't exist, it's a new block
> >
> > If it exists, there need to be a separate 'real' check if it's really the
> > same block (which is slow, but's that's happening <<1% of the time).
> 
> Which means you have to refer to each block in some unique way from
> the bit vector, making it a block pointer vector instead. That's only
> 64 times more expensive for a 64 bit offset...
> 
It was not the idea to have a pointer vector, only a bit vector. A pointer vector would be too big to hold it in RAM. Therefore, I need access to the disk after using the more exact md5sum (I wanted to use). The bitvector is only needed to have a very quick decision for most of the cases (speedup).
But I have no idea if it fits to this use case. I'm not a filesystem developer ;-)

> Since the overwhelming majority of combinations will never appear in
> practice, you are much better served with a self-sizing data structure
> like a hash map or even a binary tree, or a hash map with each bucket
> being a binary tree, etc... You can use any sized hash and it won't
> affect the number of nodes you have to store. You can trade off to CPU
> or RAM easily as required, just by selecting an appropriate data
> structure. A bit vector and especially a pointer vector have extremely
> bad "any" case RAM requirements because even if you're deduping a mere
> 10 blocks you're still allocating and initialising 2^24 offsets. The
> least you could do is adaptively switch to a more efficient data
> structure if you see the number of blocks is low enough.
> 
> -- 
> Dmitri Nikulin
> 
> Centre for Synchrotron Science
> Monash University
> Victoria 3800, Australia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Heinz-Josef Claes <hjclaes@web.de>
