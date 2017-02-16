Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47725 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932386AbdBPQln (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 11:41:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B29CDADC7
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Feb 2017 16:41:41 +0000 (UTC)
Date: Thu, 16 Feb 2017 17:41:12 +0100
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] btrfs: cleanup patches
Message-ID: <20170216164112.GT16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2017 at 04:28:26PM -0500, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Hi all -
> 
> Here's another around of cleanup patches.  The first 7 cleanup API
> blemishes with unused arguments and/or root -> fs_info conversion.  The
> last converts the pr_debug in btrfs_abort_transaction to use btrfs_debug.
> 
> -Jeff
> 
> Jeff Mahoney (8):
>   btrfs: pass fs_info to (more) routines that are only called with
>     extent_root
>   btrfs: flush_space always takes fs_info->fs_root
>   btrfs: convert btrfs_inc_block_group_ro to accept fs_info
>   btrfs: free-space-cache, clean up unnecessary root arguments
>   btrfs: btrfs_wait_cache_io_root doesn't use path argument
>   btrfs: btrfs_truncate_free_space_cache always allocates path
>   btrfs: drop unused extent_op arg from btrfs_add_delayed_data_ref
>   btrfs: use btrfs_debug instead of pr_debug in transaction abort

Thanks, added to 4.11 queue, with some minor fixups.
