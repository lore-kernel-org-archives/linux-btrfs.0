Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33537 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750992AbdIMQpB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 12:45:01 -0400
Date: Wed, 13 Sep 2017 18:43:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: remove bio_flags which indicates a meta block
 of log-tree
Message-ID: <20170913164330.GQ29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170821215000.2987-1-bo.li.liu@oracle.com>
 <20170821215000.2987-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821215000.2987-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 03:50:00PM -0600, Liu Bo wrote:
> Since both committing transaction and writing log-tree are doing
> plugging on metadata IO, we can unify to use %sync_writers to benefit
> both cases, instead of checking bio_flags while writing meta blocks of
> log-tree.
> 
> This removes the bio_flags related stuff for writing log-tree.

I'm not sure if this preserves the intentions introduced in
de0022b9da616b95ea5, as it's meant to do the checksums synchronously
(without offloading to other threads), if it's for the tree-log. So now
it depends on the sync_writers count to do that, while with the bio flag
it was independent.

The sync_writers is per-inode, while the bio flag is from the
submit_bio hook, so it's per-context.
