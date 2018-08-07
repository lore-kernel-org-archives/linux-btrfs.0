Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726419AbeHGSRv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 14:17:51 -0400
Date: Tue, 7 Aug 2018 18:02:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: switch update_size to bool in both of
 btrfs_block_rsv_migrate and btrfs_rsv_add_bytes
Message-ID: <20180807160246.GM3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
 <20180804131057.9967-4-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180804131057.9967-4-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 04, 2018 at 09:10:55PM +0800, Lu Fengqi wrote:
> Using true and false here is more semantic than using 0 and 1.
> 
> No functional change.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
