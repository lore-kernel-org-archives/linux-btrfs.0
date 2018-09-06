Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37798 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730253AbeIFUQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 16:16:27 -0400
Date: Thu, 6 Sep 2018 17:40:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: defrag: use btrfs_mod_outstanding_extents in
 cluster_pages_for_defrag
Message-ID: <20180906154005.GB24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180905030733.29720-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180905030733.29720-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 05, 2018 at 11:07:33AM +0800, Su Yue wrote:
> Since commit 8b62f87bad9c ("Btrfs: rework outstanding_extents"),
> manual operations of outstanding_extent in btrfs_inode are replaced by
> btrfs_mod_outstanding_extents().
> The one in cluster_pages_for_defrag seems to be lost, so replace it
> of btrfs_mod_outstanding_extents().
> 
> Fixes: 8b62f87bad9c ("Btrfs: rework outstanding_extents")
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
