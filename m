Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751865AbeDQPnh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 11:43:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DDFB1AF74
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 15:43:35 +0000 (UTC)
Date: Tue, 17 Apr 2018 17:41:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix wrong btrfs_delalloc_release_extents parameter
Message-ID: <20180417154104.GF21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180417104358.16667-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180417104358.16667-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 06:43:58PM +0800, Qu Wenruo wrote:
> Commit 43b18595d660 ("btrfs: qgroup: Use separate meta reservation type
> for delalloc") merged into mainline is not the latest version submitted
> to mail list in Dec 2017.
> 
> It has a fatal wrong @qgroup_free parameter, which results increasing
> qgroup metadata pertrans reserved space, and causing a lot of early EDQUOT.
> 
> Fix it by applying the correct diff on top of current branch.
> 
> Fixes: 43b18595d660 ("btrfs: qgroup: Use separate meta reservation type for delalloc")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to 4.17 queue, thanks.
