From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problem during implementing NFS support
Date: Mon, 21 Jul 2008 04:10:37 -0400
Message-ID: <20080721081037.GA24230@infradead.org>
References: <200807210041.10609.balajirrao@gmail.com> <1216572230.2475.106.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216572230.2475.106.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 20, 2008 at 09:43:50AM -0700, David Woodhouse wrote:
> The way GFS1 (and also XFS iirc) handles it is to build up a complete
> list of responses to readdir() in a buffer, drop the lock, and then
> iterate over that buffer calling filldir(). I don't much like that
> version either.

Yes.  My prefered mid-term solution would to simply lift that code from
XFS (where it's nicely isolated and all code is prefixed with hack_) to
nfsd so that local users don't aren't penalized for this.

OCFS2 also ran into this lately, so someone at Oracle might already
be working on it.  And ubifs will also run into it once it gets nfs
serving support..
