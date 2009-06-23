From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Phoronix article slaming BTRFS
Date: Tue, 23 Jun 2009 11:17:34 -0400
Message-ID: <20090623151734.GB4379@think>
References: <loom.20090623T024010-331@post.gmane.org> <20090623144123.GB19276@think> <20090623145358.GA700@cumulus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Ramsey <MikeJRamsey@comcast.net>, linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090623145358.GA700@cumulus>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2009 at 04:53:59PM +0200, Sander wrote:
> Chris Mason wrote (ao):
> > Jens Axboe tried to reproduce the phoronix results on his ocz drive,
> > and generally found that each run was slower than the last regardless
> > of which mount options were used. This isn't entirely surprising, but
> > it did make it very difficult to nail down good or bad performance.
> 
> The performance should stabilize within a handful max fills I believe?
> 
> There should be a moment where things don't get more complicated for the
> controller I thought.

That's the idea, but every device is different, and they are very
complex.  Especially for write performance, tuning is a long and complex
process...a simple benchmark run where you do three tries and average
them isn't going to give you a great picture of drive performance.

-chris

