Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42819 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbeCIQx6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 11:53:58 -0500
Date: Fri, 9 Mar 2018 17:51:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, peteryuchuang@gmail.com
Subject: Re: [PATCH 1/4] btrfs-progs: Limit inline extent below page size
Message-ID: <20180309165136.GZ23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301024747.26192-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180301024747.26192-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2018 at 10:47:44AM +0800, Qu Wenruo wrote:
> Kernel doesn't support to drop extent inside an inlined extent.
> And kernel tends to limit inline extent just below sectorsize, so also
> limit it in btrfs-progs.
> 
> This fixes unexpected -EOPNOTSUPP error from __btrfs_drop_extents() on
> converted btrfs.
> 
> Fixes: 806528b8755f ("Add Yan Zheng's ext3->btrfs conversion program")
> Reported-by: Peter Y. Chuang <peteryuchuang@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This patch breaks test fsck/020-extent-ref-cases for image
inline_regular_coexist.img .
