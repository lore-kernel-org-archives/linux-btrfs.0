Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40571 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753571AbdK0Qsd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 11:48:33 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AFC46ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 16:48:31 +0000 (UTC)
Date: Mon, 27 Nov 2017 17:46:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: extent-tree: Make btrfs_inode_rsv_refill function
 static
Message-ID: <20171127164635.GD3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171117071419.14197-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171117071419.14197-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 17, 2017 at 03:14:19PM +0800, Qu Wenruo wrote:
> This function is no longer used outside of extent-tree.c.
> Make it static.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
