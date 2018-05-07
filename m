Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751912AbeEGPDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 11:03:25 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBAE2AE91
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 15:03:23 +0000 (UTC)
Date: Mon, 7 May 2018 17:00:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Allow trace_btrfs_qgroup_account_extent()
 to record its transid
Message-ID: <20180507150046.GC6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180503015902.26032-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180503015902.26032-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2018 at 09:59:02AM +0800, Qu Wenruo wrote:
> When debugging quota rescan race, some times btrfs rescan could account
> some old (committed) leaf and then re-account newly committed leaf
> in next generation.
> 
> This race needs extra transid to locate, so add @transid for
> trace_btrfs_qgroup_account_extent() for such debug.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
