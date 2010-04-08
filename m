From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Poor performance with qemu
Date: Thu, 8 Apr 2010 11:32:04 -0400
Message-ID: <20100408153204.GA24502@infradead.org>
References: <201003281718.03699.diegocg@gmail.com> <20100330125623.GB13190@think> <4BBDEF09.70306@redhat.com> <20100408152615.GI1400@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, Avi Kivity <avi@redhat.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408152615.GI1400@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 11:26:15AM -0400, Chris Mason wrote:
> With O_DIRECT the writeback rates are very reasonable.  I'll work up a
> way to pass the barrier down from the guest to btrfs to force logging of
> updated metadata when required.

Barriers are implemented in the guest kernel using queue drains and
cache flush commands.  Qemu maps the cache flush to fdatasync.

> > >Once the O_DIRECT read patch is in, you can switch to that, or tell qemu
> > >to use a writeback cache instead.
> > 
> > Even with writeback qemu will issue a lot of fsyncs.
> 
> Oh, I didn't see that when I was testing, when does it fsync?

When the guest issues a barrier (and it's actually a fdatasync)

