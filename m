From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 16:41:58 -0500
Message-ID: <1229550118.27170.103.camel@think.oraclecorp.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
	 <20081217115325.3312858a.akpm@linux-foundation.org>
	 <1229547485.27170.77.camel@think.oraclecorp.com>
	 <20081217212409.GB5000@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081217212409.GB5000@webber.adilger.int>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-17 at 14:24 -0700, Andreas Dilger wrote:

> I can't speak for btrfs, but I don't think multiple device access from
> the filesystem is a "layering violation" as some people comment.  It
> is
> just a different type of layering.  With ZFS there is a distinct layer
> that is handling the allocation, redundancy, and transactions (SPA,
> DMU)
> that is exporting an object interface, and the filesystem (ZPL, or
> future
> versions of Lustre) is built on top of that object interface.

Clean interfaces aren't really my best talent, but btrfs also layers
this out.  logical->physical mappings happen in a centralized function,
and all of the on disk structures use logical block numbers.

The only exception to that rule is the superblock offsets on the device.

-chris


