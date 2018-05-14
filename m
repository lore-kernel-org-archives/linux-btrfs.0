Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57444 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752302AbeENOlm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 10:41:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5395FABE1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 14:41:41 +0000 (UTC)
Subject: Re: [PATCH v3 2/3] btrfs: add barriers to btrfs_sync_log before
 log_commit_wait wakeups
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1526300425.git.dsterba@suse.com>
 <2ec424615f932b017d587ba4b58af94f48f9b0ea.1526300425.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c68d24f1-cc48-4692-2ff9-e7fe948a88e5@suse.com>
Date: Mon, 14 May 2018 17:41:39 +0300
MIME-Version: 1.0
In-Reply-To: <2ec424615f932b017d587ba4b58af94f48f9b0ea.1526300425.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.05.2018 15:23, David Sterba wrote:
> Currently the code assumes that there's an implied barrier by the
> sequence of code preceding the wakeup, namely the mutex unlock.
> 
> As Nikolay pointed out:
> 
> I think this is wrong (not your code) but the original assumption that
> the RELEASE semantics provided by mutex_unlock is sufficient.
> According to memory-barriers.txt:
> 
> Section 'LOCK ACQUISITION FUNCTIONS' states:
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
> ---
> 
> To be on the safe side, add the barriers. The synchronization logic
> around log using the mutexes and several other threads does not make it
> easy to reason for/against the barrier.
> 
> CC: Nikolay Borisov <nborisov@suse.com>
> Link: https://lkml.kernel.org/r/6ee068d8-1a69-3728-00d1-d86293d43c9f@suse.com
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---

Apart from what I said initially which prompted introducing this patch I
can't say anything else. I think the fsync code is in dire need of being
rewritten/simplified.

But in so far as the newly introduced barriers are concerned:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>  fs/btrfs/tree-log.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 43758e30aa7a..fa5b3dc5f4d5 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3116,8 +3116,11 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	mutex_unlock(&log_root_tree->log_mutex);
>  
>  	/*
> -	 * The barrier before waitqueue_active is implied by mutex_unlock
> +	 * The barrier before waitqueue_active is needed so all the updates
> +	 * above are seen by the woken threads. It might not be necessary, but
> +	 * proving that seems to be hard.
>  	 */
> +	smp_mb();
>  	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
>  		wake_up(&log_root_tree->log_commit_wait[index2]);
>  out:
> @@ -3128,8 +3131,11 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	mutex_unlock(&root->log_mutex);
>  
>  	/*
> -	 * The barrier before waitqueue_active is implied by mutex_unlock
> +	 * The barrier before waitqueue_active is needed so all the updates
> +	 * above are seen by the woken threads. It might not be necessary, but
> +	 * proving that seems to be hard.
>  	 */
> +	smp_mb();
>  	if (waitqueue_active(&root->log_commit_wait[index1]))
>  		wake_up(&root->log_commit_wait[index1]);
>  	return ret;
> 
