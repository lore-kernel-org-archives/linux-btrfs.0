Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752211AbeDKPdK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 11:33:10 -0400
Date: Wed, 11 Apr 2018 17:30:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, calestyo@scientia.net
Subject: Re: [PATCH v2 1/2] btrfs-progs: Rename OPEN_CTREE_FS_PARTIAL to
 OPEN_CTREE_TEMPORARY_SUPER
Message-ID: <20180411153039.GD21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180411072936.12915-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180411072936.12915-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 03:29:35PM +0800, Qu Wenruo wrote:
> The old flag OPEN_CTREE_FS_PARTIAL is in fact quite easy to be confused
> with OPEN_CTREE_PARTIAL, which allow btrfs-progs to open damaged
> filesystem (like corrupted extent/csum tree).
> 
> However OPEN_CTREE_FS_PARTIAL, unlike its name, is just allowing
> btrfs-progs to open fs with temporary superblocks (which only has 6
> basic trees on SINGLE meta/sys chunks).
> 
> The usage of FS_PARTIAL is really confusing here.
> 
> So rename OPEN_CTREE_FS_PARTIAL to OPEN_CTREE_TEMPORARY_SUPER, and add
> extra comment for its behavior.
> Also rename BTRFS_MAGIC_PARTIAL to BTRFS_MAGIC_TEMPORARY to keep the
> naming consistent.
> 
> And with above comment, the usage of FS_PARTIAL in dump-tree is
> obviously incorrect, fix it.
> 
> Fixes: 8698a2b9ba89 ("btrfs-progs: Allow inspect dump-tree to show specified tree block even some tree roots are corrupted")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks. I got a few compilation errors where
BTRFS_MAGIC_PARTIAL was not updated, but that's trivial to fix.
