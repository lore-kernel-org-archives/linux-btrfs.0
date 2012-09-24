Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51162 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab2IXS6L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 14:58:11 -0400
Date: Mon, 24 Sep 2012 14:58:08 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Arne Jansen <sensille@gmx.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not async metadata csums if we have hardware
 crc32c
Message-ID: <20120924185808.GO4630@shiny>
References: <1348510264-5781-1-git-send-email-jbacik@fusionio.com>
 <5060A428.80302@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5060A428.80302@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 12:19:20PM -0600, Arne Jansen wrote:
> On 09/24/12 20:11, Josef Bacik wrote:
> > The reason we offload csumming is because it is CPU intensive, except it is
> > not on modern intel CPUs.  So check to see if we support hardware crc32c,
> > and if we do just do the csumming in our current threads context.  Otherwise
> > we can farm it off.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/disk-io.c |   17 +++++++++++++++++
> >  1 files changed, 17 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index dcaf556..830b9af 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/migrate.h>
> >  #include <linux/ratelimit.h>
> >  #include <asm/unaligned.h>
> > +#include <asm/cpufeature.h>
> >  #include "compat.h"
> >  #include "ctree.h"
> >  #include "disk-io.h"
> > @@ -880,6 +881,22 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
> >  	}
> >  
> >  	/*
> > +	 * Pretty sure I'm going to hell for this.  If our CPU can do crc32cs in
> > +	 * the hardware then there is no reason to do the csum stuff
> > +	 * asynchronously, it will be faster to do it inline, so test to see if
> > +	 * our CPU can do hardware crc32c and if it can just do the csum in our
> > +	 * threads context.
> > +	 */
> > +#ifdef CONFIG_X86
> > +	if (cpu_has_xmm4_2) {
> > +		printk(KERN_ERR "doing it the fast way\n");
> 
> You'll probably go to hell for the printk...

;)

Testing with dd on my recent intel box, I can hardware crc32c at
1.3GB/s.  Anything beyond that and you really want more cpus jumping
into the mix.

I wanted to use this test for data crcs too, but I suppose the helpers
only really hurt for the synchronous IO.

-chris
