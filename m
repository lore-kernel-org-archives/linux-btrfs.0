Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbcHRMhn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Aug 2016 08:37:43 -0400
Date: Thu, 18 Aug 2016 14:36:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: clarify do_chunk_alloc()'s return value
Message-ID: <20160818123641.GC16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469670123-19839-1-git-send-email-bo.li.liu@oracle.com>
 <1469815790-13511-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469815790-13511-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2016 at 11:09:50AM -0700, Liu Bo wrote:
> Function start_transaction() can return ERR_PTR(1) when flush is
> BTRFS_RESERVE_FLUSH_LIMIT, so the call graph is
> 
> start_transaction (return ERR_PTR(1))
>   -> btrfs_block_rsv_add (return 1)
>      -> reserve_metadata_bytes (return 1)
>         -> flush_space (return 1)
>            -> do_chunk_alloc  (return 1)
> 
> With BTRFS_RESERVE_FLUSH_LIMIT, if flush_space is already on the
> flush_state of ALLOC_CHUNK and it successfully allocates a new
> chunk, then instead of trying to reserve space again,
> reserve_metadata_bytes returns 1 immediately.
> 
> Eventually the callers who call start_transaction() usually just
> do the IS_ERR() check which ERR_PTR(1) can pass, then it'll get
> a panic when dereferencing a pointer which is ERR_PTR(1).
> 
> The following patch fixes the above problem.
> "btrfs: flush_space: treat return value of do_chunk_alloc properly"
> https://patchwork.kernel.org/patch/7778651/
> 
> This add comments to clarify do_chunk_alloc()'s return value.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Patch queued, thanks.
