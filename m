From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Fri, 02 Jan 2009 14:38:07 -0500
Message-ID: <1230925087.7538.41.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <20090103.013755.42849152.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090103.013755.42849152.ryusuke@osrg.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-01-03 at 01:37 +0900, Ryusuke Konishi wrote:
> Hi,
> On Wed, 31 Dec 2008 18:19:09 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > This has only btrfs as a module and would be the fastest way to see
> > the .c files.  btrfs doesn't have any changes outside of fs/Makefile and
> > fs/Kconfig

[ ... ]

> In addition, there seem to be well-separated reusable routines such as
> async-thread (enhanced workqueue) and extent_map.  Do you intend to
> move these into lib/ or so?

Sorry, looks like I hit send too soon that time.  The async-thread code
is very self contained, and was intended for generic use.  Pushing that
into lib is probably a good idea.

The extent_map and extent_buffer code was also intended for generic use.
It needs some love and care (making it work for blocksize != pagesize)
before I'd suggest moving it out of fs/btrfs.

-chris


