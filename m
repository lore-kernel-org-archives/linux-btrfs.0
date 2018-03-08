Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932104AbeCHQtm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 11:49:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1D64AF48
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 16:49:40 +0000 (UTC)
Date: Thu, 8 Mar 2018 17:47:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: replace waitqueue_actvie with cond_wake_up
Message-ID: <20180308164720.GP23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1520509627.git.dsterba@suse.com>
 <14c8d049b138f21bea1b378aae17b9a99d9dffe7.1520509627.git.dsterba@suse.com>
 <6ee068d8-1a69-3728-00d1-d86293d43c9f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6ee068d8-1a69-3728-00d1-d86293d43c9f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 02:19:28PM +0200, Nikolay Borisov wrote:
> > @@ -941,9 +941,7 @@ void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
> >  void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
> >  {
> >  	percpu_counter_sub(&fs_info->bio_counter, amount);
> > -
> > -	if (waitqueue_active(&fs_info->replace_wait))
> > -		wake_up(&fs_info->replace_wait);
> > +	cond_wake_up_nomb(&fs_info->replace_wait);
> 
> nit/offtopic:
> 
> I think here the code requires comments since we have 2 types of
> waiters for fs_info->replace_wait. One is dependent on the
> percpu_counter_sum (i.e. the btrfs_rm_dev_replace_blocked). And then
> there is another condition on the same wait entry - the
> btrfs_bio_counter_inc_blocked i.e:
> 
>  wait_event(fs_info->replace_wait,                               
>                            !test_bit(BTRFS_FS_STATE_DEV_REPLACING,              
>                                      &fs_info->fs_state)); 
> 
> geez, who would come up with such synchronization ... 

'git blame' is the right tool, I'm not a fan of the dev-replace locking
either.

> >  }
> >  
> >  void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
> > @@ -3092,11 +3086,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
> >  	atomic_set(&log_root_tree->log_commit[index2], 0);
> >  	mutex_unlock(&log_root_tree->log_mutex);
> >  
> > -	/*
> > -	 * The barrier before waitqueue_active is implied by mutex_unlock
> > -	 */
> > -	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
> > -		wake_up(&log_root_tree->log_commit_wait[index2]);
> > +	/* The barrier is implied by mutex_unlock */
> > +	cond_wake_up_nomb(&log_root_tree->log_commit_wait[index2]);
> 
> I think this is wrong (not your code) but the original assumption that 
> the RELEASE semantics provided by mutex_unlock is sufficient. 

That was added in 33a9eca7e4a4c2c17ae by me.

> According to memory-barriers.txt: 
> 
> Section 'LOCK ACQUISITION FUNCTIONS' states: 
> 
> 
>  (2) RELEASE operation implication:                                             
>                                                                                 
>      Memory operations issued before the RELEASE will be completed before the   
>      RELEASE operation has completed.                                           
>                                                                                 
>      Memory operations issued after the RELEASE *may* be completed before the     
>      RELEASE operation has completed.
> 
> (I've bolded the may portion)
> 
> The example given there: 
> 
> As an example, consider the following:                                          
>                                                                                 
>     *A = a;                                                                     
>     *B = b;                                                                     
>     ACQUIRE                                                                     
>     *C = c;                                                                     
>     *D = d;                                                                     
>     RELEASE                                                                     
>     *E = e;                                                                     
>     *F = f;                                                                     
>                                                                                 
> The following sequence of events is acceptable:                                 
>                                                                                 
>     ACQUIRE, {*F,*A}, *E, {*C,*D}, *B, RELEASE  
> 
> So if we assume that *C is modifying the flag which the waitqueue is checking, 
> and *E is the actual wakeup, then those accesses can be re-ordered...
> 
> IMHO this code should be considered broken...         

Maybe, but the code has to be taken as a whole, the log_mutex and
waiting does not follow a simple pattern that could be matched on the
barriers example. In this case I think that the log_commit_wait is
partially synchronized by the log_mutex and the bad scenario of missed
wakeup will not happen. We'll have either empty waiter queue, or the
waiters are blocked on the mutex (ie. the waitqueu is active and we'll
always have someone to wake). But this is an observation made after a
short time reading the code so there actually might be a tiny window
where some of the assumptions do not hold.

Point of the patch is to do the transformation to the helpers. If there
are bugs that could be obscured by the patch, I can postpone it until
the bugs are fixed.

> 
> 
> >  out:
> >  	mutex_lock(&root->log_mutex);
> >  	btrfs_remove_all_log_ctxs(root, index1, ret);
> > @@ -3104,11 +3095,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
> >  	atomic_set(&root->log_commit[index1], 0);
> >  	mutex_unlock(&root->log_mutex);
> >  
> > -	/*
> > -	 * The barrier before waitqueue_active is implied by mutex_unlock
> > -	 */
> > -	if (waitqueue_active(&root->log_commit_wait[index1]))
> > -		wake_up(&root->log_commit_wait[index1]);
> > +	/* The barrier is implied by mutex_unlock */
> > +	cond_wake_up_nomb(&root->log_commit_wait[index1]);
> 
> ditto.
> 
> >  	return ret;
> >  }
> >  
