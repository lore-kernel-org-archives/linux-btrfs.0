Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751242AbeDEN6H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 09:58:07 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C5A22ACE5
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Apr 2018 13:58:06 +0000 (UTC)
Date: Thu, 5 Apr 2018 15:55:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix possible softlock on single core machines
Message-ID: <20180405135538.GB2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522914015-32534-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522914015-32534-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2018 at 10:40:15AM +0300, Nikolay Borisov wrote:
> do_chunk_alloc implements a loop checking whether there is a pending
> chunk allocation and if so causes the caller do loop. Generally this
> loop is executed only once, however testing with btrfs/072 on a
> single core vm machines uncovered an extreme case where the system
> could loop indefinitely. This is due to a missing cond_resched when
> loop which doesn't give a chance to the previous chunk allocator finish
> its job.
> 
> The fix is to simply add the missing cond_resched.
> 
> Fixes: 6d74119f1a3e ("Btrfs: avoid taking the chunk_mutex in do_chunk_alloc")

Does this commit really lead to the endless loop on UP? I don't see any
obvious connection.
