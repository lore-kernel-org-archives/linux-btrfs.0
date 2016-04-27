Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbcD0WaG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 18:30:06 -0400
Date: Thu, 28 Apr 2016 00:29:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: track transid for delayed ref flushing
Message-ID: <20160427222951.GO29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460410660-17430-1-git-send-email-jbacik@fb.com>
 <20160427135938.pczv7f4ulrvwehqp@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160427135938.pczv7f4ulrvwehqp@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 09:59:38AM -0400, Chris Mason wrote:
> > @@ -2854,9 +2855,16 @@ static void delayed_ref_async_start(struct btrfs_work *work)
> >  
> >  	async = container_of(work, struct async_delayed_refs, work);
> >  
> > -	trans = btrfs_join_transaction(async->root);
> > +	trans = btrfs_attach_transaction(async->root);
> >  	if (IS_ERR(trans)) {
> > -		async->error = PTR_ERR(trans);
> > +		if (PTR_ERR(trans) != -ENOENT)
> > +			async->error = PTR_ERR(trans);
> > +		goto done;
> > +	}
> 
> This ends up deadlocking because btrfs_attach_transaction waits in ways
> that join does not.  The differences between these two are really
> subtle, and we manage to make this mistake every year or so.
> 
> Subject: [PATCH] btrfs: fix deadlock in delayed_ref_async_start
> 
> "Btrfs: track transid for delayed ref flushing" was deadlocking on
> btrfs_attach_transaction because its not safe to call from the async
> delayed ref start code.  This commit brings back btrfs_join_transaction
> instead and checks for a blocked commit.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Chris Mason <clm@fb.com>

This patch seems to be an incremental but I don't see the original patch
from Josef merged anywhere (I haven't picked it to for-next yet), are
you going to commit both?
