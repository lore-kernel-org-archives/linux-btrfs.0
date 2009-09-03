From: Nick Piggin <npiggin@suse.de>
Subject: Re: btrfs failing fsx-linux
Date: Thu, 3 Sep 2009 09:10:11 +0200
Message-ID: <20090903071011.GA979@wotan.suse.de>
References: <20090818172641.GC30325@wotan.suse.de> <20090818175950.GA2348@localhost.localdomain> <20090902171450.GF28052@wotan.suse.de> <20090902190721.GA4043@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090902190721.GA4043@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 02, 2009 at 03:07:21PM -0400, Chris Mason wrote:
> On Wed, Sep 02, 2009 at 07:14:50PM +0200, Nick Piggin wrote:
> > On Tue, Aug 18, 2009 at 01:59:50PM -0400, Josef Bacik wrote:
> > > I'll take a look at this later today and see what I can come up with.  Thanks
> > > for reporting it.
> > 
> > Any progress with this? Were you able to reproduce?
> > 
> 
> I thought this was where the rb tree patch came from, sorry.  I'll try
> to reproduce.

Oh, I must not have been clear: I first hit the rbtree bug, then when
that was fixed, the same workload was eventually showing up fsx-linux
failures (but no more kernel crashes).

