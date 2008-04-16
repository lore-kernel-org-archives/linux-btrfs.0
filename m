From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 14:04:03 -0400
Message-ID: <200804161404.04202.chris.mason@oracle.com>
References: <200804161134.19237.chris.mason@oracle.com> <200804161254.09414.chris.mason@oracle.com> <87fxtlitle.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87fxtlitle.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 16 April 2008, Andi Kleen wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> > On Wednesday 16 April 2008, Andi Kleen wrote:
> >> Chris Mason <chris.mason@oracle.com> writes:
> >> > The async work queues include code to checksum data pages without the
> >> > FS mutex
> >>
> >> Are they able to distribute work to other cores?
> >
> > Yes, it just uses a workqueue.
>
> Unfortunately work queues don't do that by default currently. They
> tend to process on the current CPU only.

Well, I see multiple work queue threads using CPU time, but I haven't spent 
much time optimizing it.  There's definitely room for improvement.

>
> > The current implemention is pretty simple, it
> > surely could be more effective at spreading the work around.
> >
> > I'm testing a variant that only tosses over to the async queue for
> > pdflush, inline reclaim should stay inline.
>
> Longer term I would hope that write checksum will be basically free by
> doing csum-copy at write() time. The only problem is just where to store
> the checksum between the write and the final IO? There's no space in
> struct page.

At write time is easier (except for mmap) because I can toss the csum directly 
into the btree inside btrfs_file_write.  The current code avoids that 
complexity and does it all at writeout.

One advantage to the current code is that I'm able to optimize tree searches 
away but checksumming a bunch of pages at a time.  Multiple pages worth of 
checksums get stored in a single btree item, so at least for btree operations 
the current code is fairly optimal.

>
> The same could be also done for read() but that might be a little more
> tricky because it would require delayed error reporting and it might
> be difficult to do this for partial blocks?

Yeah, it doesn't quite fit with how the kernel does reads.  For now it is much 
easier if the retry-other-mirror operation happens long before copy_to_user.

-chris

