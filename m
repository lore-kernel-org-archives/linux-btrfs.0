From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch 0/2]btrfs: add two ioctls to do metadata readahead
Date: Mon, 19 Jul 2010 07:25:56 -0400
Message-ID: <20100719112556.GW8623@think>
References: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
 <20100719080354.GA12808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shaohua Li <shaohua.li@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100719080354.GA12808@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 19, 2010 at 04:03:54AM -0400, Christoph Hellwig wrote:
> This seems like iteration 66 of the ill fated mobling readahead crap.
> 
> Please go to linux-fsdevel to define a proper interface instead of
> your per-filesystem hacks.  I had hoped Arjan got it after the last big
> flameware, but it seems like you're only moving from one target to the
> next.
> 
> NACK in this current form.

Honestly I think its good to have some of these features in specific
filesystems at first.  Sure, it is easy to tell if they help in the lab
and during development, but why go through the pain of implementing them
in generic form until they have been through a broader test?

So the idea for the feature is fine with me, especially for something
like readahead which we can support forever by turning it into a noop if
there turns out to be a better idea.

-chris

