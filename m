From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] rewrite btrfs_readdir()
Date: Mon, 18 Aug 2008 15:24:49 -0400
Message-ID: <1219087489.14063.24.camel@think.oraclecorp.com>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218979817.3184.296.camel@pmac.infradead.org>
	 <1218982640.3184.307.camel@pmac.infradead.org>
	 <1218989400.3184.315.camel@pmac.infradead.org>
	 <1219085216.14063.9.camel@think.oraclecorp.com>
	 <1219086483.3184.403.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219086483.3184.403.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 20:08 +0100, David Woodhouse wrote:
> On Mon, 2008-08-18 at 14:46 -0400, Chris Mason wrote:
> > It can happen today for the tree of tree roots (directory of
> > subvolumes and named snapshots).  It happens when the name hashes
> > collide.  For real directories we use the sequence number index
> > instead of the name hash index, so it normally won't happen.
> 
> Ok, that's fine then. I've removed the WARN_ON() from the patch in my
> git tree. This is what I have outstanding for you at
> git://git.infradead.org/users/dwmw2/btrfs-kernel-unstable:
> 

Ok, just to double check after rereading the thread, are there known
bugs in this stuff?  They look sane to me.

-chris


