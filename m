Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934502AbeEILwr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 07:52:47 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DBF24ADD5
        for <linux-btrfs@vger.kernel.org>; Wed,  9 May 2018 11:52:45 +0000 (UTC)
Date: Wed, 9 May 2018 13:50:08 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: convert: fix support for e2fsprogs <
 1.42
Message-ID: <20180509115008.GT6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525099028-11737-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525099028-11737-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 10:37:06AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit 324d4c1857a (btrfs-progs: convert: Add larger device support)
> introduced new dependencies on the 64-bit API provided by e2fsprogs.
> That API was introduced in v1.42 (along with bigalloc).
> 
> This patch maps the following to their equivalents in e2fsprogs < 1.42.
> - ext2fs_get_block_bitmap_range2
> - ext2fs_inode_data_blocks2
> - ext2fs_read_ext_attr2
> 
> Since we need to detect and define EXT2_FLAG_64BITS for compatibilty
> anyway, it makes sense to use that to detect the older e2fsprogs instead
> of defining a new flag ourselves.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

1-3 applied, thanks.
