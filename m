Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbeHQQde (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 12:33:34 -0400
Date: Fri, 17 Aug 2018 15:29:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: remove a useless return statement in
 btrfs_block_rsv_add
Message-ID: <20180817132957.GU24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
 <20180804131057.9967-5-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180804131057.9967-5-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 04, 2018 at 09:10:56PM +0800, Lu Fengqi wrote:
> Since ret must be 0 here, don't have to return separately in advance.
> 
> No functional change.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Added to misc-next too, the change is fairly trivial so I was pondering
about code readability impacts, but it's ok.
