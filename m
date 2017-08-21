Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753551AbdHUQbU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 12:31:20 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C58A5AD08
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 16:31:18 +0000 (UTC)
Date: Mon, 21 Aug 2017 18:29:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: remove superfluous chunk_tree argument from
 btrfs_alloc_dev_extent
Message-ID: <20170821162955.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818141402.GW2866@twin.jikos.cz>
 <1503068303-27545-1-git-send-email-nborisov@suse.com>
 <1503068303-27545-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503068303-27545-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 05:58:23PM +0300, Nikolay Borisov wrote:
> Currently this function is always called with the object id of the root key of
> the chunk_tree, which is always BTRFS_CHUNK_TREE_OBJECTID. So let's subsume it
> straight into the function itself. No functional change.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
