Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54311 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753214AbdHUPBH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 11:01:07 -0400
Date: Mon, 21 Aug 2017 16:59:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 6/7] Btrfs: remove BUG_ON in __add_tree_block
Message-ID: <20170821145942.GI2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
 <20170818211524.31325-7-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818211524.31325-7-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:15:23PM -0600, Liu Bo wrote:
> The BUG_ON() can be triggered when the caller is processing an invalid
> extent inline ref, e.g.
> 
> a shared data ref is offered instead of a extent data ref, such that
> it tries to find a non-exist tree block and then btrfs_search_slot
> returns 1 for no such item.
> 
> This replaces the BUG_ON() with a WARN() followed by calling
> btrfs_print_leaf() to show more details about what's going on and
> returning -EINVAL to upper callers.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
