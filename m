Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387851AbeHGSeV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 14:34:21 -0400
Date: Tue, 7 Aug 2018 18:19:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, gujx@cn.fujitsu.com
Subject: Re: [PATCH 2/5] btrfs: use a separate variable to store the
 num_bytes of the qgroup_reserve
Message-ID: <20180807161912.GO3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
 <20180804131057.9967-3-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180804131057.9967-3-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 04, 2018 at 09:10:54PM +0800, Lu Fengqi wrote:
> After btrfs_qgroup_reserve_meta_prealloc(), num_bytes will be assigned
> again by btrfs_calc_trans_metadata_size(). Therefore, once block_rsv
> fails, we cannot properly free the num_bytes of the previous
> qgroup_reserve.

This does not look like a trivial cleanup at all. There was an unused
parameter, removed in c4c129db5da8f070147f175 ("btrfs: drop unused
parameter qgroup_reserved"), that introduced the bug.  This was in this
rc1 so it's a regression and I'll consider pushing it to the 4.18 final.
