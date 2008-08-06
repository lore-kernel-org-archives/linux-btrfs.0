From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 16:43:04 -0400
Message-ID: <1218055384.15342.160.camel@think.oraclecorp.com>
References: <1218032511.15342.73.camel@think.oraclecorp.com>
	 <4899C64C.2040107@hp.com> <1218040611.15342.92.camel@think.oraclecorp.com>
	 <489A0B4E.6010809@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <489A0B4E.6010809@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-06 at 16:36 -0400, jim owens wrote:
> Chris Mason wrote:
> 
> > Josef's allocator fix is on the list because we currently fall over in
> > some workloads at 100% cpu time when the FS is 60% full.  The space
> > indexing is complex and strange, it just needs to be redone.
> 
> I don't understand.  Do you mean josef wants someone to fix
> multithreading or do you mean he is doing that as part of
> an allocator fix he is working on, or did you mean that
> his work is an exception and you really were not looking at
> doing any allocator changes?
> 

Josef is fixing the way the allocator indexes free space in ram.  This
is different from working on the threading, but I'm holding off on the
threading until after he is done.

> I see this in your 0.16 list:
> 
> > Better in-memory free space indexing (Josef)
> 
> but did not tie it to the allocator. Is that it?
> 
> and I'll add an area I missed before in the Development_timeline:
>    - Fallocate support (at least disk format level)
> as part of the allocator bundle-of-too-much-work :)

;) fallocate would be important as well.

-chris


