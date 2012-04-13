From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix regression in scrub path resolving
Date: Fri, 13 Apr 2012 12:00:31 -0400
Message-ID: <20120413160031.GA15549@shiny>
References: <1334329095-26326-1-git-send-email-list.btrfs@jan-o-sch.net>
 <20120413152559.GA30525@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, stable@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120413152559.GA30525@kroah.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2012 at 08:25:59AM -0700, Greg KH wrote:
> On Fri, Apr 13, 2012 at 04:58:15PM +0200, Jan Schmidt wrote:
> > commit 7a3ae2f8c8c8432e65467b7fc84d5deab04061a0 upstream.
> > 
> > In commit 4692cf58 (Linux 3.3) we introduced new backref walking code for
> > btrfs. This assumes we're searching live roots, which requires a transaction
> > context. While scrubbing, however, we must not join a transaction because
> > this could deadlock with the commit path:
> > 
> > Can be exploited by corrupting data in btrfs (e.g. btrfs-corrupt-block) and
> > then starting a scrub job (btrfs scrub). This will find the corrupt block
> > and resolve the file paths affected. If that happens while btrfs is about to
> > commit its transaction, a deadlock occurs: The scrub process prevents the
> > commit from completing, while the path resolving code joins a transaction
> > which blocks until the current transaction completes.
> > 
> > Additionally, what scrub really wants to do is resolving a logical address
> > in the commit root it's currently checking. This patch adds support for
> > logical to path resolving on commit roots and makes scrub use that.
> > 
> > Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> > Signed-off-by: Chris Mason <chris.mason@oracle.com>
> > ---
> > 
> > I know, it's quite big for a stable patch. Anyway, it fixes a 3.3 regression
> > and should therefore be included in the next 3.3-stable release. Tested on
> > top of Linux 3.3.1.
> 
> I'll include it if Chris gives his ack for it.
> 
> Chris?

Ack ;)

-chris
