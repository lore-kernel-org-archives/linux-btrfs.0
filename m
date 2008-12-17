From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 16:26:24 -0500
Message-ID: <1229549184.27170.88.camel@think.oraclecorp.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
	 <20081217115325.3312858a.akpm@linux-foundation.org>
	 <1229547485.27170.77.camel@think.oraclecorp.com>
	 <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
	sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-17 at 22:20 +0100, Kay Sievers wrote:
> On Wed, Dec 17, 2008 at 21:58, Chris Mason <chris.mason@oracle.com> wrote:
> > On Wed, 2008-12-17 at 11:53 -0800, Andrew Morton wrote:
> >
> > There are other bits and pieces like high speed front end caching
> > devices that would be difficult in MD/LVM, but since I don't have that
> > coded yet I suppose they don't really count...
> 
> Features like the very nice and useful directory-based snapshots would
> also not be possible with simple block-based multi-devices, right?

At least for btrfs, the snapshotting is independent from the
multi-device code, and you still get snapshotting on single device
filesystems.

-chris


