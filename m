Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38931 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbeA3OLc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 09:11:32 -0500
Date: Tue, 30 Jan 2018 15:09:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: tree-checker: Replace root parameter with fs_info
Message-ID: <20180130140919.GG19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180125065618.17501-1-wqu@suse.com>
 <20180126143105.ighlohekgjlh6uwq@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180126143105.ighlohekgjlh6uwq@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 26, 2018 at 09:31:06AM -0500, Josef Bacik wrote:
> On Thu, Jan 25, 2018 at 02:56:18PM +0800, Qu Wenruo wrote:
> > When inspecting the error message with real corruption, the "root=%llu"
> > always shows "1" (root tree), instead of correct owner.
> > 
> > The problem is that we are getting @root from page->mapping->host, which
> > points the same btree inode, so we will always get the same root.
> > 
> > This makes the root owner output meaningless, and harder to port
> > tree-checker to btrfs-progs.
> > 
> > So get rid of the false and meaningless @root parameter and replace it
> > with @fs_info.
> > To get the owner, we can only rely on btrfs_header_owner() now.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Added to next, thanks.
