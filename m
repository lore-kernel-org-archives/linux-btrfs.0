Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbeGPMg1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 08:36:27 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E41A7ADC8
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 12:09:17 +0000 (UTC)
Date: Mon, 16 Jul 2018 14:09:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Rewrite retry logic in do_chunk_alloc
Message-ID: <20180716120912.GD3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180416185321.GW21272@twin.jikos.cz>
 <1524036477-23203-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524036477-23203-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 10:27:57AM +0300, Nikolay Borisov wrote:
> do_chunk_alloc implements logic to detect whether there is currently
> pending chunk allocation  (by means of space_info->chunk_alloc being
> set) and if so it loops around to the 'again' label. Additionally,
> based on the state of the space_info (e.g. whether it's full or not)
> and the return value of should_alloc_chunk() it decides whether this
> is a "hard" error (ENOSPC) or we can just return 0.
> 
> This patch refactors all of this:
> 
> 1. Put order to the scattered ifs handling the various cases in an
> easy-to-read if {} else if{} branches. This makes clear the various
> cases we are interested in handling.
> 
> 2. Call should_alloc_chunk only once and use the result in the
> if/else if constructs. All of this is done under space_info->lock, so
> even before multiple calls of should_alloc_chunk were unnecessary.
> 
> 3. Rewrite the "do {} while()" loop currently implemented via label
> into an explicit loop construct.
> 
> 4. Move the mutex locking for the case where the caller is the one doing the 
> allocation. For the case where the caller needs to wait a concurrent allocation, 
> introduce a pair of mutex_lock/mutex_unlock to act as a barrier and reword the 
> comment. 
> 
> 5. Switch local vars to bool type where pertinent.
> 
> All in all this shouldn't introduce any functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
