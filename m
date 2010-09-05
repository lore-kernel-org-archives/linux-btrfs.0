From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Btrfs-devel] [patch] O_DIRECT: fix the splitting up of
 contiguous I/O
Date: Sun, 5 Sep 2010 09:36:20 -0700
Message-ID: <20100905093620.d2eeb539.akpm@linux-foundation.org>
References: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com>
	<20100902142501.GA14932@infradead.org>
	<201009052256.12386.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	"btrfs-devel" <btrfs-devel@oss.oracle.com>,
	Andrew Morton <akpm@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201009052256.12386.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 5 Sep 2010 22:56:08 +1000 Chris Samuel <chris@csamuel.org> wrote:

> On Fri, 3 Sep 2010 12:25:01 am Christoph Hellwig wrote:
> 
> > Andrew, can you please send this on to Linus and -stable ASAP?
> > It's causing massive problems for our users.
> 
> Did this patch get dropped ? 

Nope.  I have it queued for 2.6.36 and -stable, will send it in soon. 
Everything is a bit lagged at present due to conferences, summer,
encroaching senility, etc.
