From: Theodore Tso <tytso@mit.edu>
Subject: Re: Btrfs v0.16 released
Date: Fri, 8 Aug 2008 21:19:05 -0400
Message-ID: <20080809011905.GB9967@mit.edu>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <20080808215625.GC9038@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080808215625.GC9038@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 08, 2008 at 11:56:25PM +0200, Andi Kleen wrote:
> > So, the mirroring turns a single large write into two large writes.
> > Definitely not free, but always a fixed cost.
> 
> Thanks for the explanation and the numbers. I see that's the advantage of 
> copy-on-write that you can actually always cluster the metadata together and 
> get always batched IO this way and then afford to do more of it. 
> 
> Still wondering what that will do to read seekiness.

In theory, if the elevator was smart enough, it could actually help
read seekiness; there are two copies of the metadata, and it shouldn't
matter which one is fetched.  So I could imagine a (hypothetical) read
request which says, "please give me the contents of block 4500 or
75000000 --- I don't care which, if the disk head is closer to one end
of the disk or another, use whichever one is most convenient".  Our
elevator algorithms are currently totally unable to deal with this
sort of request, and if SSD's are going to be coming on line as
quickly as some people are claiming, maybe it's not worth it to try to
implement that kind of thing, but at least in theory it's something
that could be done....

						- Ted
