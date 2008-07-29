From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] initial version of reference cache
Date: Tue, 29 Jul 2008 00:25:25 +0000
Message-ID: <1217291125.7572.110.camel@think.oraclecorp.com>
References: <21782573.1217014155193.JavaMail.oracle@acsmt304.oracle.com>
	 <1217257799.7572.103.camel@think.oraclecorp.com>
	 <f058a9c30807280952m2386aad4pa8a08ffaf930c370@mail.gmail.com>
	 <f058a9c30807280953k6cac85a1i9bc10bf41cdb23d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30807280953k6cac85a1i9bc10bf41cdb23d7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-28 at 17:53 +0100, Miguel Sousa Filipe wrote:
> Hi all,
> 
> On Mon, Jul 28, 2008 at 4:09 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > Yan and I are hammering this out a little, I've attached my current
> > patches.
> >
> > I was seeing cache misses after long stress runs, which I think is
> > coming from references on the higher levels of the tree making us skip
> > some leaves while dropping the transaction that added them.
> >
> > My new version using a single cache per root, and should avoid these
> > misses.
> 
> Just curious, what is the cache size and or eviction policy?
> Is it LFU or LRU, fifo, something custom? Would ARC be a good policy
> for this purpose?
> 

Since this is a cache of the extents pointers in a COW block, things are
only written once, and these items are only read once most of the time.
So, we don't need anything fancy, just a direct access list that we can
use to pull off really old things.

In this case, it is just a list head.

-chris


