Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757532AbdELOHl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 10:07:41 -0400
Date: Fri, 12 May 2017 16:07:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH] btrfs: Convert fs_info->free_chunk_space to atomic64_t
Message-ID: <20170512140721.GH27439@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1494483466-22342-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1494483466-22342-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 11, 2017 at 09:17:46AM +0300, Nikolay Borisov wrote:
> The ->free_chunk_space variable is used to track the unallocated space and
> access to it is protected by a spinlock, which is not used for anything else.

In the past, the spinlock protected a larger critical section where the
overcommit was calculated. This is not true anymore and the bare counter
has been left. So yes, from that POV it's ok to switch it to the atomic.

The spinlock-protected increment is valid in some cases where the
overhead on atomics is higher, compared to uncontended lock (ie. rare
updates).

For architectures where the bare type can be updated atomically we could
even avoid atomicX_t if the code semantics allows that. For 64bit types
it's ok on x86_64, for 32bit we'd need preemption workarounds (similar
to what inode::i_size does).

So, I'm fine with switching to the atomic64_t, I don't see it used in
performance critical code.

Reviewed-by: David Sterba <dsterba@suse.com>
