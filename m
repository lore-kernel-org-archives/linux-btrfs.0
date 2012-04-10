From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Revert "Btrfs: increase the global block reserve
 estimates"
Date: Tue, 10 Apr 2012 11:24:15 -0400
Message-ID: <20120410152415.GW29506@shiny>
References: <1333928451-26468-1-git-send-email-dsterba@suse.cz>
 <4F823D44.5070200@cn.fujitsu.com>
 <20120409224008.GB11041@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Liu Bo <liubo2009@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
	linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120409224008.GB11041@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 12:40:08AM +0200, David Sterba wrote:
> On Mon, Apr 09, 2012 at 09:37:08AM +0800, Liu Bo wrote:
> > The whole thing is about our overcommit stuff, that is,
> > since we are not able to get _precise_ number of reservation right now, we usually
> > reserve more than what we need.
> > For this, we've done overcommit dance (thanks for Josef's work!) but it's still not
> > enough for our reservation when we still have some disk space.
> >
> > I'm ok with this revert, but since we don't use up all the reserved space in most time,
> > I assume the following can be an alternative, thanks,
> 
> Unfortunatelly the situation looks not good for 3.3 btrfs users, I'm
> looking for something we know that somehow (ie like in 3.2) works and
> are able to submit to the stable tree very soon. I'll definitelly test
> your alternative and if Chris applies it during the -rc phase we'll have
> more time to verify it or you/Josef fix it in another way.

Lets do the alternative of reverting the patch and dropping the warning.
I've been trying to find a small and simple patch for that but I don't
think that's going to happen for a stable commit.

-chris

