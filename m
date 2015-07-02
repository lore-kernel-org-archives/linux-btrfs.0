Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbbGBOnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jul 2015 10:43:51 -0400
Date: Thu, 2 Jul 2015 16:43:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 11/18] btrfs: qgroup: Add new qgroup calculation
 function btrfs_qgroup_account_extents().
Message-ID: <20150702144349.GN726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1430274551-9277-12-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430274551-9277-12-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 29, 2015 at 10:29:04AM +0800, Qu Wenruo wrote:
> The new btrfs_qgroup_account_extents() function should be called in
> btrfs_commit_transaction() and it will update all the qgroup according
> to delayed_ref_root->dirty_extent_root.
> 
> The new function can handle both normal operation during
> commit_transaction() or in rescan in a unified method with clearer
> logic.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Also free ulist even quota is disabled to avoid possible memory leak.
> ---
>  fs/btrfs/extent-tree.h |   0

Surprise, this adds an empty file. What was the intention?
