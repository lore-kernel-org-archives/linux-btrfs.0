Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58903 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751938AbeDXOr1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 10:47:27 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 987B3AF2D
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 14:47:25 +0000 (UTC)
Date: Tue, 24 Apr 2018 16:44:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: print-tree: Add locking status output for
 debug build
Message-ID: <20180424144452.GJ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424050313.32740-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180424050313.32740-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 01:03:13PM +0800, Qu Wenruo wrote:
> It's pretty handy if we can get debug output for locking status of an
> extent buffer, specially for race related debugging.
> 
> So add the following output for btrfs_print_tree() and
> btrfs_print_leaf():
> - refs
> - write_locks (as w:%d)
> - read_locks (as r:%d)
> - blocking_writers (as bw:%d)
> - blocking_readers (as br:%d)
> - spinning_writers (as sw:%d)
> - spinning_readers (as sr:%d)
> - lock_owner
> - current->pid

This is fine

> +	btrfs_info(eb->fs_info,

I'd rather make that btrfs_debug, but info is fine as long as it's under
CONFIG_BTRFS_DEBUG.

> +"refs %u lock(w:%u r:%u bw:%u br:%u sw:%u sr:%u) lock_owner %u current %u",

This is not :) but I'll fix that according to the above.

Reviewed-by: David Sterba <dsterba@suse.com>
