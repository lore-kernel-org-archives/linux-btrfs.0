From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V3 17/18] Btrfs: Full direct I/O and AIO read implementation.
Date: Wed, 24 Mar 2010 03:37:11 +0100
Message-ID: <20100324023711.GC20695@one.firstfloor.org>
References: <4BA6E563.4090206@gmail.com> <87sk7r60zw.fsf@basil.nowhere.org> <4BA93530.4080303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BA93530.4080303@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 23, 2010 at 05:40:00PM -0400, jim owens wrote:
> Andi Kleen wrote:
> 
> > One thing that stroke me while reading is that, except for the out of line no data
> > checksum case, this isn't real classical zero copy direct IO because
> > you always have to copy through some buffer.
> 
> Uh no, unless I really messed up or don't understand what you mean.

No I misread the code: you don't set temp_pages in that path. 

> 
> Uncompressed data with no checksums only buffers on an error or EOF. 
> 
> With checksums enabled, uncompressed reads aligned on the 4k block
> are classic direct IO to user memory except at EOF.

Hmm, but what happens if the user modifies the memory in parallel?
Would spurious checksum failures be reported then?

Same for writing I guess (data end up on disk with wrong checksum)?

Those both would seem like serious flaws to me.

> > Is there any particular reason this wasn't done? Was it because
> > of aio?
> > 
> > I know the page cache currently doesn't support that today, but
> > presumably it wouldn't be too hard to add.
> 
> The only reason I did not do something like that is:

Ok.

> 1) I did not want to disturb the page cache with throw-away pages.
> 2) "uncached IO" makes it even less like classic direct IO.
> 3) Writing that page cache code might not be simpler.
4) aio support (although It would be cool if someone finally did
proper aio page cache code)

> As further argument against "uncached IO", Chris sent a very simple
> patch up to read into page cache then purge it for btrfs direct IO
> reads and it was NACKed.

I see.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
