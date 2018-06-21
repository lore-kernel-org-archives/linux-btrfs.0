Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933399AbeFUQZN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 12:25:13 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3DC9AC55
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 16:25:11 +0000 (UTC)
Date: Thu, 21 Jun 2018 18:22:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Deduplicate extent_buffer init code
Message-ID: <20180621162221.GR24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1529320399-23235-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529320399-23235-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2018 at 02:13:19PM +0300, Nikolay Borisov wrote:
> When a new extent buffer is allocated there are a few mandatory fields
> which need to be set in order for the buffer to be sane: level,
> generation, bytenr, backref_rev, owner and FSID/UUID. Currently this
> is open coded in the callers of btrfs_alloc_tree_block, meaning it's
> fairly high in the abstraction hierarchy of operations. This patch
> solves this by simply moving this init code in btrfs_init_new_buffer,
> since this is the function which initializes a newly allocated
> extent buffer. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
