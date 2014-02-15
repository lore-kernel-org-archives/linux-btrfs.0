Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:39226 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbaBORmw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 12:42:52 -0500
Date: Sat, 15 Feb 2014 18:42:49 +0100
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
Message-ID: <20140215184249.271bf02c@datenkhaos.de>
In-Reply-To: <52FE6E9F.4010906@fb.com>
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>
	<20140203192811.72866921@datenkhaos.de>
	<52F00538.3010505@fb.com>
	<20140203235334.791312d1@datenkhaos.de>
	<52F0F566.1090206@fb.com>
	<20140205091428.076fa15c@datenkhaos.de>
	<52F25D7B.90807@fb.com>
	<20140205183406.47023d24@datenkhaos.de>
	<52F28A69.8050804@fb.com>
	<20140205203023.535d6f96@datenkhaos.de>
	<52F292C7.7030701@fb.com>
	<20140205224250.7876dd16@datenkhaos.de>
	<52F2B151.70307@fb.com>
	<20140205235732.04263a51@datenkhaos.de>
	<52F3FC72.3020603@fb.com>
	<20140214202526.3199f6cc@datenkhaos.de>
	<52FE6E9F.4010906@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Feb 2014 14:29:35 -0500
Josef Bacik <jbacik@fb.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> On 02/14/2014 02:25 PM, Johannes Hirte wrote:
> > On Thu, 6 Feb 2014 16:19:46 -0500 Josef Bacik <jbacik@fb.com>
> > wrote:
> > 
> >> Ok so I thought I reproduced the problem but I just reproduced a 
> >> different problem.  Please undo any changes you've made and
> >> apply this patch and reproduce and then provide me with any debug
> >> output that gets spit out.  I'm sending this via thunderbird with
> >> 6 different extensions to make sure it comes out right so if it
> >> doesn't work let me know and I'll just paste it somewhere.
> >> Thanks,
> > 
> > Sorry for the long delay. Was to busy last week.
> > 
> 
> Ok perfect this is fixed by
> 
> [PATCH] Btrfs: don't loop forever if we can't run because of the tree
> mod log
> 
> and it went into -rc2 iirc, so give that a whirl and make sure it
> fixes your problem.  Thanks,

Yes, seems to be fixed now. I wasn't able to reproduce it anymore.

regards,
  Johannes
