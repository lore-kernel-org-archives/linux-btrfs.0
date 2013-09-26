Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41767 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3IZMkl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 08:40:41 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7718C7C068E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Sep 2013 06:40:41 -0600 (MDT)
Date: Thu, 26 Sep 2013 08:40:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <walken@google.com>, <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
        <peter@hurleysoftware.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Btrfs: stop caching thread if extetn_commit_sem is
 contended
Message-ID: <20130926124039.GG18681@localhost.localdomain>
References: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
 <1379605688-987-2-git-send-email-jbacik@fusionio.com>
 <20130920051247.GC1486@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130920051247.GC1486@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 20, 2013 at 07:12:47AM +0200, Ingo Molnar wrote:
> 
> * Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > We can starve out the transaction commit with a bunch of caching threads 
> > all running at the same time.  This is because we will only drop the 
> > extent_commit_sem if we need_resched(), which isn't likely to happen 
> > since we will be reading a lot from the disk so have already 
> > schedule()'ed plenty.  Alex observed that he could starve out a 
> > transaction commit for up to a minute with 32 caching threads all 
> > running at once.  This will allow us to drop the extent_commit_sem to 
> > allow the transaction commit to swap the commit_root out and then all 
> > the cachers will start back up.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/extent-tree.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index cfb3cf7..cc074c34 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -442,7 +442,8 @@ next:
> >  			if (ret)
> >  				break;
> >  
> > -			if (need_resched()) {
> > +			if (need_resched() ||
> > +			    rwsem_is_contended(&fs_info->extent_commit_sem)) {
> >  				caching_ctl->progress = last;
> >  				btrfs_release_path(path);
> >  				up_read(&fs_info->extent_commit_sem);
> 
> So, just to fill in what happens in this loop:
> 
> 				mutex_unlock(&caching_ctl->mutex);
> 				cond_resched();
> 				goto again;
> 
> where 'again:' takes caching_ctl->mutex and fs_info->extent_commit_sem 
> again:
> 
> 	again:
> 	        mutex_lock(&caching_ctl->mutex);
> 		/* need to make sure the commit_root doesn't disappear */
> 		down_read(&fs_info->extent_commit_sem);
> 
> So, if I'm reading the code correct, there can be a fair amount of 
> concurrency here: there may be multiple 'caching kthreads' per filesystem 
> active, while there's one fs_info->extent_commit_sem per filesystem 
> AFAICS.
> 
> So, what happens if there are a lot of CPUs all busy holding the 
> ->extent_commit_sem rwsem read-locked and a writer arrives? They'd all 
> rush to try to release the fs_info->extent_commit_sem, and they'd block in 
> the down_read() because there's a writer waiting.
> 
> So there's a guarantee of forward progress. This should answer akpm's 
> concern I think.
> 
> If this analysis is correct then:
> 
>   Acked-by: Ingo Molnar <mingo@kernel.org>
> 

Yup this is correct, thank you, I'll add your ack'ed by to the next iteration.

Josef
