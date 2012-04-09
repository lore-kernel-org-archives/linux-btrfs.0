From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Revert "Btrfs: increase the global block reserve
 estimates"
Date: Tue, 10 Apr 2012 00:40:08 +0200
Message-ID: <20120409224008.GB11041@twin.jikos.cz>
References: <1333928451-26468-1-git-send-email-dsterba@suse.cz>
 <4F823D44.5070200@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	stable@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F823D44.5070200@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 09:37:08AM +0800, Liu Bo wrote:
> The whole thing is about our overcommit stuff, that is,
> since we are not able to get _precise_ number of reservation right now, we usually
> reserve more than what we need.
> For this, we've done overcommit dance (thanks for Josef's work!) but it's still not
> enough for our reservation when we still have some disk space.
>
> I'm ok with this revert, but since we don't use up all the reserved space in most time,
> I assume the following can be an alternative, thanks,

Unfortunatelly the situation looks not good for 3.3 btrfs users, I'm
looking for something we know that somehow (ie like in 3.2) works and
are able to submit to the stable tree very soon. I'll definitelly test
your alternative and if Chris applies it during the -rc phase we'll have
more time to verify it or you/Josef fix it in another way.


thanks,
david
