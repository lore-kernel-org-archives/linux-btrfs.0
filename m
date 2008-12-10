From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Selective Compression/Encryption
Date: Wed, 10 Dec 2008 08:45:50 -0500
Message-ID: <1228916750.11900.11.camel@think.oraclecorp.com>
References: <20081209145952.GA30494@tux64-03>
	 <1228840516.27601.10.camel@think.oraclecorp.com>
	 <200812091126.04044.des@condordes.net>  <493ED385.7000608@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Joshua J. Berry" <des@condordes.net>,
	Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <493ED385.7000608@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-09 at 15:22 -0500, jim owens wrote:
> Joshua J. Berry wrote:

[ storing compression flags ]

> > 
> > It seems like xattrs would be preferable to some btrfs-specific tunable, as 
> > programs like rsync or backup tools would be able to preserve (and restore) 
> > these bits with no extra work required.
> 
> I had the same thought... that many btrfs per-file tunables would
> be better implemented in xattrs (I've read christoph's earlier
> objections and hope to get around those issues).
> 
> I have been working on changing the xattr code with the first
> step getting it functioning properly when selinux is enabled
> so we can see just how costly btrfs xattrs are in actual use.

Not really on topic, but how are things broken today with selinux?

-chris


