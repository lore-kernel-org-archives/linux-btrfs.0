Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37323 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdCNMm4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 08:42:56 -0400
Date: Tue, 14 Mar 2017 13:42:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: add file item tracepoint
Message-ID: <20170314124218.GY14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1488595287-3247-1-git-send-email-bo.li.liu@oracle.com>
 <1489172988-15547-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1489172988-15547-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 10, 2017 at 11:09:48AM -0800, Liu Bo wrote:
> While debugging truncate problems, I found that these tracepoints could
> help us quickly know what went wrong.
> 
> Two sets of tracepoints are created to track regular/prealloc file item
> and inline file item respectively, I put inline as a separate one since
> what inline file items cares about are way less than the regular one.
> 
> This adds four tracepoints:
> - btrfs_get_extent_show_fi_regular
> - btrfs_get_extent_show_fi_inline
> - btrfs_truncate_show_fi_regular
> - btrfs_truncate_show_fi_inline
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> +	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l, struct btrfs_file_extent_item *fi, u64 start),

The 80-chars per line rule still applies, I've fixed them.
