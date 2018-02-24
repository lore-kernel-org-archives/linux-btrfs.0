Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53695 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbeBXAQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 19:16:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83D50AE18
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 00:16:38 +0000 (UTC)
Date: Sat, 24 Feb 2018 01:14:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Relax memory barrier in btrfs_tree_unlock
Message-ID: <20180224001420.GU1469@twin.jikos.cz>
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

Have you measured this severe performance hit? There is an impact, but I
doubt you'll ever notice it in the profiles given where the
btrfs_tree_unlock appears.

> The better thing is to use the appropriate smp_mb__after_atomic routine
> which will do the correct thing (invoke a full smp_mb or in the case
> of ordered atomics insert a compiler barrier). Put another way,
> an RMW atomic op + smp_load__after_atomic equals, in terms of
> semantics, to a full smp_mb. This ensures that none of the problems
> described in the accompanying comment of waitqueue_active occur.
> No functional changes.

I tend to agree.
