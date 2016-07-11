Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238AbcGKKw1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 06:52:27 -0400
Date: Mon, 11 Jul 2016 12:52:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [RESEND PATCH] btrfs: Fix slab accounting flags
Message-ID: <20160711105239.GW13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1468185141-20253-1-git-send-email-n.borisov.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468185141-20253-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 12:12:21AM +0300, Nikolay Borisov wrote:
> BTRFS is using a variety of slab caches to satisfy internal needs.
> Those slab caches are always allocated with the SLAB_RECLAIM_ACCOUNT,
> meaning allocations from the caches are going to be accounted as
> SReclaimable. At the same time btrfs is not registering any shrinkers
> whatsoever, thus preventing memory from the slabs to be shrunk. This
> means those caches are not in fact reclaimable.
> 
> To fix this remove the SLAB_RECLAIM_ACCOUNT on all caches apart from the
> inode cache, since this one is being freed by the generic VFS super_block
> shrinker. Also set the transaction related caches as SLAB_TEMPORARY,
> to better document the lifetime of the objects (it just translates
> to SLAB_RECLAIM_ACCOUNT).
> 
> Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
> Reviewed-by: David Sterba <dsterba@suse.com>

FYI, patch is queued for 4.8.
