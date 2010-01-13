From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add a "df" ioctl for btrfs
Date: Wed, 13 Jan 2010 08:33:41 -0500
Message-ID: <20100113133341.GA14746@localhost.localdomain>
References: <20100112202513.GA13414@localhost.localdomain> <20100113102503.GA6887@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100113102503.GA6887@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 05:25:03AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 12, 2010 at 03:25:13PM -0500, Josef Bacik wrote:
> > df is a very loaded question in btrfs.  This gives us a way to get the per-space
> > usage information so we can tell exactly what is in use where.  This will help
> > us figure out ENOSPC problems, and help users better understand where their disk
> > space is going.
> 
> Just as discussed before I think it's a really bad idea.  We always had
> df reporting inconsistencies due to the way metadata is managed, and
> btrfs isn't special in that way.
> 
> so, NACK

Right, this isn't changing how DF works, it just lets me get a better insight
into the fs if I need it.  It's very helpful to me to see how the fs is broken
up and whats in use for debugging ENOSPC things, as well as being nice to have
something to show users how their volume is being used.

Think of it more as a debugging thing than a replacement for df :).  Thanks,

Josef
