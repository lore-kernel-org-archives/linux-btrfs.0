Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750811AbeCLSVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 14:21:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9ED0CADE1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Mar 2018 18:21:43 +0000 (UTC)
Date: Mon, 12 Mar 2018 19:19:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/4] btrfs-progs: mode-lowmem: Fix false alert about
 orphan inode
Message-ID: <20180312181921.GC32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180205064714.15659-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180205064714.15659-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 05, 2018 at 02:47:11PM +0800, Qu Wenruo wrote:
> Btrfs can delay inode deletion and in that case btrfs will unlink the
> victim inode from its parent dir, and insert a marker to info btrfs to
> delete it later.
> 
> In that case, such victim inode will have nlinks == 0, but is still
> completely valid.
> Original mode won't report such problem, but lowmem mode doesn't check
> the ORPHAN_ITEM key for such inode, and can report false alert like:
> ------
> ERROR: root 257 INODE[28891726] is orphan item
> ------
> 
> Fix such false alert by checking orphan item for inode whose nlink is 0.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

1-4 applied, thanks.
