From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/2]btrfs: add two ioctls to do metadata readahead
Date: Mon, 19 Jul 2010 23:58:05 -0400
Message-ID: <20100720035805.GA18049@infradead.org>
References: <1279094536.1528.93.camel@sli10-desk.sh.intel.com>
 <20100719080354.GA12808@infradead.org>
 <4C445A81.5010808@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Shaohua Li <shaohua.li@intel.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C445A81.5010808@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 19, 2010 at 07:00:33AM -0700, Arjan van de Ven wrote:
> On 7/19/2010 1:03 AM, Christoph Hellwig wrote:
> >This seems like iteration 66 of the ill fated mobling readahead crap.
> 
> I think you need to actually look at what this patch does before
> rendering this judgment; something you apparently have not done.

Thanks a lot for the attack, but of course I have.  It's the same stupid
idea of throwing almost generic code into filesystems that you previous
attempt did.  It's completely generic code for checking what pages are
in-memory (plus constaints) and then force read-ahead on them again.
The only filesystems specific bit is which address_space to select.  The
whole apporach is also useful to extN / xfs / etc if you allow it on
any address_space.

