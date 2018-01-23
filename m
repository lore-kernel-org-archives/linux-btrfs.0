Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752078AbeAWSdp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 13:33:45 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1C043AF85
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 18:33:44 +0000 (UTC)
Date: Tue, 23 Jan 2018 19:31:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 5/5] btrfs-progs: Remove unnecessary parameter for
 btrfs_add_block_group
Message-ID: <20180123183133.GP15713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180103071306.11500-1-wqu@suse.com>
 <20180103071306.11500-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180103071306.11500-6-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 03, 2018 at 03:13:06PM +0800, Qu Wenruo wrote:
> @chunk_objectid of btrfs_make_block_group() function is always fixed to
> BTRFS_FIRST_FREE_OBJECTID, so there is no need to pass it as parameter
> explicitly.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Can you please refresh this patch on top of current devel? There were
some merge conflicts due to other patches, the rest has been applied.
Thanks.
