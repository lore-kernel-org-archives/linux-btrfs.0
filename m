Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50311 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbeEIMAn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 08:00:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D507EAD69
        for <linux-btrfs@vger.kernel.org>; Wed,  9 May 2018 12:00:42 +0000 (UTC)
Date: Wed, 9 May 2018 13:58:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: Remove fs_info parameter from
 btrfs_leaf_free_space()
Message-ID: <20180509115805.GV6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180430031545.29891-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180430031545.29891-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 11:15:43AM +0800, Qu Wenruo wrote:
> For btrfs_leaf_free_space(), to get leaf data size, we have two way to
> get it:
> 
> 1) leaf->fs_info->nodesize
> 2) leaf->len
> 
> Anyway, we could get rid of @fs_info parameter for
> btrfs_leaf_free_space().
> And here we choose method 2), as it provides extra benefit to get leaf
> free space without initializing a real fs_info.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

1 and 2 applied, 3 has some comments, please resend.
