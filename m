Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61176 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab3IZMnd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 08:43:33 -0400
Date: Thu, 26 Sep 2013 14:43:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, walken@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, peter@hurleysoftware.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] Btrfs: stop caching thread if extetn_commit_sem is
 contended
Message-ID: <20130926124329.GA32314@gmail.com>
References: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
 <1379605688-987-2-git-send-email-jbacik@fusionio.com>
 <20130920051247.GC1486@gmail.com>
 <20130926124039.GG18681@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130926124039.GG18681@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


* Josef Bacik <jbacik@fusionio.com> wrote:

> On Fri, Sep 20, 2013 at 07:12:47AM +0200, Ingo Molnar wrote:
> > 
> > * Josef Bacik <jbacik@fusionio.com> wrote:
> > 
> > > We can starve out the transaction commit with a bunch of caching threads 
> > > all running at the same time.  This is because we will only drop the 
> > > extent_commit_sem if we need_resched(), which isn't likely to happen 
> > > since we will be reading a lot from the disk so have already 
> > > schedule()'ed plenty.  Alex observed that he could starve out a 
> > > transaction commit for up to a minute with 32 caching threads all 
> > > running at once.  This will allow us to drop the extent_commit_sem to 
> > > allow the transaction commit to swap the commit_root out and then all 
> > > the cachers will start back up.  Thanks,
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > > ---
> > >  fs/btrfs/extent-tree.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > index cfb3cf7..cc074c34 100644
> > > --- a/fs/btrfs/extent-tree.c
> > > +++ b/fs/btrfs/extent-tree.c
> > > @@ -442,7 +442,8 @@ next:
> > >  			if (ret)
> > >  				break;
> > >  
> > > -			if (need_resched()) {
> > > +			if (need_resched() ||
> > > +			    rwsem_is_contended(&fs_info->extent_commit_sem)) {
> > >  				caching_ctl->progress = last;
> > >  				btrfs_release_path(path);
> > >  				up_read(&fs_info->extent_commit_sem);
> > 
> > So, just to fill in what happens in this loop:
> > 
> > 				mutex_unlock(&caching_ctl->mutex);
> > 				cond_resched();
> > 				goto again;
> > 
> > where 'again:' takes caching_ctl->mutex and fs_info->extent_commit_sem 
> > again:
> > 
> > 	again:
> > 	        mutex_lock(&caching_ctl->mutex);
> > 		/* need to make sure the commit_root doesn't disappear */
> > 		down_read(&fs_info->extent_commit_sem);
> > 
> > So, if I'm reading the code correct, there can be a fair amount of 
> > concurrency here: there may be multiple 'caching kthreads' per filesystem 
> > active, while there's one fs_info->extent_commit_sem per filesystem 
> > AFAICS.
> > 
> > So, what happens if there are a lot of CPUs all busy holding the 
> > ->extent_commit_sem rwsem read-locked and a writer arrives? They'd all 
> > rush to try to release the fs_info->extent_commit_sem, and they'd block in 
> > the down_read() because there's a writer waiting.
> > 
> > So there's a guarantee of forward progress. This should answer akpm's 
> > concern I think.
> > 
> > If this analysis is correct then:
> > 
> >   Acked-by: Ingo Molnar <mingo@kernel.org>
> > 
> 
> Yup this is correct, thank you, I'll add your ack'ed by to the next 
> iteration.

You might also want to stick the explanation into the changelog - it 
wasn't really obvious to someone not versed in btrfs internals.

Thanks,

	Ingo
