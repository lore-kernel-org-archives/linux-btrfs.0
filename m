Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbcGLQBR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 12:01:17 -0400
Date: Tue, 12 Jul 2016 18:01:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: jbacik@fb.com, clm@fb.com, operations@siteground.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add ratelimiting to printing facility
Message-ID: <20160712160126.GD10595@suse.cz>
Reply-To: dsterba@suse.cz
References: <1468326012-15910-1-git-send-email-kernel@kyup.com>
 <20160712132044.GC10595@suse.cz>
 <5784F509.8040200@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5784F509.8040200@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2016 at 04:47:53PM +0300, Nikolay Borisov wrote:
> 
> 
> On 07/12/2016 04:20 PM, David Sterba wrote:
> > On Tue, Jul 12, 2016 at 03:20:12PM +0300, Nikolay Borisov wrote:
> >> Currently the btrfs printk infrastructure doesn't implement any
> >> kind of ratelimiting.
> > 
> > If you count the whole infrastructure, it does. See ctree.h and macros
> > ending with _rl (btrfs_err_rl), and should be used where the messages
> > are likely to flood. Otherwise I think "more is better" regarding
> > messages as this is helpful when debugging issues.
> 
> So I definitely didn't look at those. But now I have and it seems they
> implement more or less the same thing. Also, if I'm reading the code
> correctly, as it stands now using the _rl versions seem to be more
> flexible as the limits is going to be per-message rather than
> per-message class as it is in my proposal. So I'd rather move that
> particular csum related message to the _rl infrastructure.

Ok.

> >> Recently I came accross a case where due to
> >> FS corruption an excessive amount of printk caused the softlockup
> >> detector to trigger and reset the server. This patch aims to avoid
> >> two types of issue: 
> >>  * I want to avoid different levels of messages interefere with the
> >>  ratelimiting of oneanother so as to avoid a situation where a 
> >>  flood of INFO messages causes the ratelimit to trigger, 
> >>  potentially leading to supression of more important messages. 
> > 
> > Yeah, that's my concern as well. What if there's a burst of several
> > error messages that do not fit to the limit and some of them get
> > dropped.
> > 
> >>  * Avoid a flood of any type of messages rendering the machine 
> >>  unusable
> > 
> > While I'd rather set a per-message ratelimiting, it's possible that an
> > unexpected error will start flooding. So some sort of per-level limiting
> > could be implemented, as you propose, but I'd suggest to set the numbers
> > higher. That way it would still flood up to certain level but should
> > avoid the lockups.
> 
> Sure, I'm happy to set the limits higher and have it act as a safety
> net. But then again, what would make a sensible limit - 100 messages in
> 5 seconds seems reasonable but this is completely arbitrary. Any thoughts?

5 seconds "should be" enough for the system to do other work, and 100
messages could mean 5-8 kB of text. We're talking about a situation when
things are really bad, messages are likely to be duplicated so there
should be enough information captured by the time the ratelimiting kicks
in. So, let it be 100.
