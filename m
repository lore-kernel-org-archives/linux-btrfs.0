Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56607 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933479AbeCGQHX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 11:07:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 290ECACBE
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Mar 2018 16:07:22 +0000 (UTC)
Date: Wed, 7 Mar 2018 17:05:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Relax memory barrier in btrfs_tree_unlock
Message-ID: <20180307160501.GH23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518611846-26918-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518611846-26918-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 02:37:26PM +0200, Nikolay Borisov wrote:
> When performing an unlock on an extent buffer we'd like to order the
> decrement of extent_buffer::blocking_writers with waking up any
> waiters. In such situations it's sufficient to use smp_mb__after_atomic
> rather than the heavy smp_mb. On architectures where atomic operations
> are fully ordered (such as x86 or s390) unconditionally executing
> a heavyweight smp_mb instruction causes a severe hit to performance
> while bringin no improvements in terms of correctness.
> 
> The better thing is to use the appropriate smp_mb__after_atomic routine
> which will do the correct thing (invoke a full smp_mb or in the case
> of ordered atomics insert a compiler barrier). Put another way,
> an RMW atomic op + smp_load__after_atomic equals, in terms of
> semantics, to a full smp_mb. This ensures that none of the problems
> described in the accompanying comment of waitqueue_active occur.
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
