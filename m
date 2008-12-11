From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Btrfs trees for linux-next
Date: Wed, 10 Dec 2008 20:06:04 -0800
Message-ID: <20081210200604.8e190b0d.akpm@linux-foundation.org>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	<1228962896.21376.11.camel@think.oraclecorp.com>
	<20081211141436.030c2d65.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081211141436.030c2d65.sfr@canb.auug.org.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Dec 2008 14:14:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 10 Dec 2008 21:34:56 -0500 Chris Mason <chris.mason@oracle.com> wrote:
> >
> > Just an update, while I still have a long todo list and plenty of things
> > to fix in the code, these src trees have been updated with a disk format
> > I hope to maintain compatibility with from here on.  There are still
> > format changes planned, but should go in through the compat mechanisms
> > in the sources now.
> > 
> > The btrfs trees are still at 2.6.28-rc5, but I just tested against
> > linux-next without problems.
> 
> Do you think this is ready to be added to the end of linux-next, yet?  Or
> is this more -mm material?

I'd prefer that it go into linux-next in the usual fashion.  But the
first step is review..
