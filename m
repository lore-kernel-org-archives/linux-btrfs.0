Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53421 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbeBBQ1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 11:27:47 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0DA5EAD36
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:27:46 +0000 (UTC)
Date: Fri, 2 Feb 2018 17:25:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Streamline btrfs_delalloc_reserve_metadata
 initial operations
Message-ID: <20180202162533.GR18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515766865-13652-1-git-send-email-nborisov@suse.com>
 <20180130143441.GK19355@twin.jikos.cz>
 <cadd8981-4834-46ad-e8cc-6dff2ae13ab7@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cadd8981-4834-46ad-e8cc-6dff2ae13ab7@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 04:47:54PM +0200, Nikolay Borisov wrote:
> On 30.01.2018 16:34, David Sterba wrote:
> > On Fri, Jan 12, 2018 at 04:21:05PM +0200, Nikolay Borisov wrote:
> >> @@ -6062,19 +6062,19 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
> >>  	 * If we have a transaction open (can happen if we call truncate_block
> >>  	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
> >>  	 */
> >> +
> >>  	if (btrfs_is_free_space_inode(inode)) {
> >>  		flush = BTRFS_RESERVE_NO_FLUSH;
> >>  		delalloc_lock = false;
> >> -	} else if (current->journal_info) {
> >> -		flush = BTRFS_RESERVE_FLUSH_LIMIT;
> >> -	}
> >> +	} else {
> >> +		if (current->journal_info)
> >> +			flush = BTRFS_RESERVE_FLUSH_LIMIT;
> >>  
> >> -	if (flush != BTRFS_RESERVE_NO_FLUSH &&
> >> -	    btrfs_transaction_in_commit(fs_info))
> >> -		schedule_timeout(1);
> >> +		if (btrfs_transaction_in_commit(fs_info))
> >> +			schedule_timeout(1);
> >>  
> >> -	if (delalloc_lock)
> >>  		mutex_lock(&inode->delalloc_mutex);
> >> +	}
> > 
> > Squeezing the condition branches makes the code more readable, I have
> > only one objection and it's the mutex_lock. It IMHO looks better when
> > it's a separate branch as it pairs with the unlock:
> > 
> > if (delalloc_lock)
> > 	mutex_lock(...);
> > 
> > ...
> > 
> > if (delalloc_lock)
> > 	mutex_unlock(...);
> > 
> > In your version it's implied by the first if that checks
> > btrfs_is_free_space_inode and delalloc_lock is hidden there.
> > 
> 
> My line of thought when developing the patch was that delalloc is
> another level of indirection and. What I wanted to achieve in the end is
> to make it clear that delalloc_mutex really depends on whether we are
> reserving for the freespace inode or not.

Well, I almost overlooked the mutex on first top-down reading the code.
