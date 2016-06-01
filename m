Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbcFAWOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 18:14:17 -0400
Date: Wed, 1 Jun 2016 15:14:15 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v10 10/21] btrfs: try more times to alloc metadata
 reserve space
Message-ID: <20160601221415.GP7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-11-git-send-email-quwenruo@cn.fujitsu.com>
 <20160517132016.GQ511@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160517132016.GQ511@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 03:20:16PM +0200, David Sterba wrote:
> On Fri, Apr 01, 2016 at 02:35:01PM +0800, Qu Wenruo wrote:
> > @@ -5815,6 +5817,23 @@ out_fail:
> >  	}
> >  	if (delalloc_lock)
> >  		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
> > +	/*
> > +	 * The number of metadata bytes is calculated by the difference
> > +	 * between outstanding_extents and reserved_extents. Sometimes though
> > +	 * reserve_metadata_bytes() fails to reserve the wanted metadata bytes,
> > +	 * indeed it has already done some work to reclaim metadata space, hence
> > +	 * both outstanding_extents and reserved_extents would have changed and
> > +	 * the bytes we try to reserve would also has changed(may be smaller).
> > +	 * So here we try to reserve again. This is much useful for online
> > +	 * dedupe, which will easily eat almost all meta space.
> > +	 *
> > +	 * XXX: Indeed here 3 is arbitrarily choosed, it's a good workaround for
> > +	 * online dedupe, later we should find a better method to avoid dedupe
> > +	 * enospc issue.
> > +	 */
> > +	if (unlikely(ret == -ENOSPC && loops++ < 3))
> > +		goto again;
> > +
> 
> This does not seem right and needs to be addressed properly before I
> consider adding the patchset to for-next. I don't have idea how to fix
> it.

Agreed, and this sort of issue is a reason why I strongly feel we don't want
to merge this series piecemeal until we know that after everything is
complete, we can end up with a fully baked in-band dedupe implementation.

Luckily Qu says he's on it so if he posts a workable fix here my whole point
can become moot. Until then though this is exactly the type of 'fix later'
coding we need to be avoiding.
	--Mark

--
Mark Fasheh
