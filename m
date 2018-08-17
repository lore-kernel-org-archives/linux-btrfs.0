Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45858 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727218AbeHQQSJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 12:18:09 -0400
Date: Fri, 17 Aug 2018 15:14:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fix qgroup_free wrong num_bytes in
 btrfs_subvolume_reserve_metadata()
Message-ID: <20180817131437.GT24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180809014604.1380-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180809014604.1380-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 09, 2018 at 09:46:04AM +0800, Lu Fengqi wrote:
> After btrfs_qgroup_reserve_meta_prealloc(), num_bytes will be assigned
> again by btrfs_calc_trans_metadata_size(). Once block_rsv fails, we can't
> properly free the num_bytes of the previous qgroup_reserve. Use a separate
> variable to store the num_bytes of the qgroup_reserve.
> 
> Delete the comment for the qgroup_reserved that does not exist and add a
> comment about use_global_rsv.
> 
> Fixes: c4c129db5da8 ("btrfs: drop unused parameter qgroup_reserved")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
