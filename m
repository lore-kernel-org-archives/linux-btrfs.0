Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753119AbeC1Pez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 11:34:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2D83AAD5E
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Mar 2018 15:34:54 +0000 (UTC)
Date: Wed, 28 Mar 2018 17:32:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: tests/qgroup: Fix wrong tree backref level
Message-ID: <20180328153227.GN30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180327124419.28398-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180327124419.28398-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2018 at 08:44:18PM +0800, Qu Wenruo wrote:
> The extent tree of the test fs is like the following:
> 
>  BTRFS info (device (null)): leaf 16327509003777336587 total ptrs 1 free space 3919
>   item 0 key (4096 168 4096) itemoff 3944 itemsize 51
>           extent refs 1 gen 1 flags 2
>           tree block key (68719476736 0 0) level 1
>                                            ^^^^^^^
>           ref#0: tree block backref root 5
> 
> And it's using an empty tree for fs tree, so there is no way that its
> level can be 1.
> 
> For REAL (created by mkfs) fs tree backref with no skinny metadata, the
> result should look like:
> 
>  item 3 key (30408704 EXTENT_ITEM 4096) itemoff 3845 itemsize 51
>          refs 1 gen 4 flags TREE_BLOCK
>          tree block key (256 INODE_ITEM 0) level 0
>                                            ^^^^^^^
>          tree block backref root 5
> 
> Fix the level to 0, so it won't break later tree level checker.
> 
> Fixes: faa2dbf004e8 ("Btrfs: add sanity tests for new qgroup accounting code")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

So this is just a bug in the self-tests and does not have any other
impact, right?
