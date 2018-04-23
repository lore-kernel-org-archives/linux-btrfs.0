Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755184AbeDWOS4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 10:18:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3654ACF9
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:18:54 +0000 (UTC)
Date: Mon, 23 Apr 2018 16:16:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix wrong first_key parameter in replace_path
Message-ID: <20180423141622.GW21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180423093204.20943-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180423093204.20943-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 23, 2018 at 05:32:04PM +0800, Qu Wenruo wrote:
> Commit 581c1760415c ("btrfs: Validate child tree block's level and first
> key") introduced new @first_key parameter for read_tree_block(), however
> caller in replace_path() is parasing wrong key to read_tree_block().
> 
> It should use parameter @first_key other than @key.
> 
> Normally it won't expose problem as @key is normally initialzied to the
> same value of @first_key we expect.
> However in relocation recovery case, @key can be set to (0, 0, 0), and
> since no valid key in relocation tree can be (0, 0, 0), it will cause
> read_tree_block() to return -EUCLEAN and interrupt relocation recovery.
> 
> Fix it by setting @first_key correctly.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to next, thanks.
