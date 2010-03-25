From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V3 17/18] Btrfs: Full direct I/O and AIO read implementation.
Date: Thu, 25 Mar 2010 10:41:19 +0100
Message-ID: <20100325094119.GJ20695@one.firstfloor.org>
References: <4BA6E563.4090206@gmail.com> <87sk7r60zw.fsf@basil.nowhere.org> <4BA93530.4080303@gmail.com> <20100324023711.GC20695@one.firstfloor.org> <4BAAD397.8060408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BAAD397.8060408@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 24, 2010 at 11:08:07PM -0400, jim owens wrote:
> Andi Kleen wrote:
> > > On Tue, Mar 23, 2010 at 05:40:00PM -0400, jim owens wrote:
> >> >> Andi Kleen wrote:
> >> >>
> >> >> With checksums enabled, uncompressed reads aligned on the 4k block
> >> >> are classic direct IO to user memory except at EOF.
> > > 
> > > Hmm, but what happens if the user modifies the memory in parallel?
> > > Would spurious checksum failures be reported then?
> 
> It does put a warning in the log but it does not fail the read
> because I circumvent that by doing the failed-checksum-retry as
> a buffered read and retest.  The checksum passes and we copy
> the data to the user memory (where they can then trash it again).

Ok. That will work I guess.


> I was going to put a comment about that but felt my comment
> density was already over the btrfs style guide limit.  :) 

Hehe.

> 
> > > Same for writing I guess (data end up on disk with wrong checksum)?
> 
> Well we don't have any code done yet for writing and that was
> just one interesting challenge that needed to be solved.
> 
> > > Those both would seem like serious flaws to me.
> 
> Agree, so the write design needs to prevent bad checksums.

How? Do you have a plan for that?

> 
> Read is already correct and if people do not want a log warning
> that the application is misbehaving that can be eliminated.

I guess if it's strictly rate limitted it might be ok.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
