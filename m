From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Wed, 15 Jul 2009 16:16:58 -0400
Message-ID: <20090715201658.GC23967@think>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Woodhouse <dwmw2@infradead.org>, linux-btrfs@vger.kernel.org,
	neilb@suse.de, linux-raid@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2009 at 12:23:47PM -0700, Dan Williams wrote:
> On Mon, Jul 13, 2009 at 7:11 AM, David Woodhouse<dwmw2@infradead.org> wrote:
> > We'll want to use these in btrfs too.
> >
> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> Do you suspect that btrfs will also want to perform these operations
> asynchronously?  I am preparing an updated release of the raid6
> offload patch kit, but the previous WIP release can be browsed at:

The short answer is that we'll definitely want to use the async code
where it is available.  Btrfs is already wired up to hand off CPU
intensive parts of IO submission (compression, checksumming) to helper
threads.  There's some extra ordering so that we can have N threads
checksumming but still send down the actual bios in the proper order.

Once the btrfs raid5/6 is working well, I'll wire it into the helper
threads as well.  Are the raid offload engines fast enough that we won't
want the helper threads when they are available?

-chris
