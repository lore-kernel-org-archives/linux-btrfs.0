Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38149 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751178AbdK3SBC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 13:01:02 -0500
Date: Thu, 30 Nov 2017 18:59:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH][v2] btrfs: don't bug_on with enomem in __clear_state_bit
Message-ID: <20171130175902.GO3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1510326820-17865-1-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510326820-17865-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 10, 2017 at 10:13:40AM -0500, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Since we're allocating under atomic we could every easily enomem, so if
> that's the case and we can block then loop around and try to allocate
> the prealloc not under a lock.
> 
> We also saw this happen during try_to_release_page in production, in
> which case it's completely valid to return ENOMEM so we can tell
> try_to_release_page that we can't release this page.

Have you audited that all direct and indirect callers of
__clear_extent_bit handle the errors? Because they do not. The only case
that seem to understand ENOMEM failures of __clear_extent_bit is
try_release_extent_state.

Almost anything else that calls __clear_extent_bit, clear_extent_bit and
other simple wrappers do not check the value and would happily continue.

> @@ -673,7 +677,15 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  
>  	if (state->start < start) {
>  		prealloc = alloc_extent_state_atomic(prealloc);
> -		BUG_ON(!prealloc);
> +		if (!prealloc) {
> +			if (gfpflags_allow_blocking(mask)) {
> +				need_prealloc = true;
> +				spin_unlock(&tree->lock);
> +				goto again;
> +			}
> +			err = -ENOMEM;

The retry logic is good, but until ENOMEM is properly handled
everywhere, the safest thing is to move the BUG_ON here.
