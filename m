Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389081AbeHAOlb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 10:41:31 -0400
Date: Wed, 1 Aug 2018 14:55:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: extent-tree.c: Remove unused
 __btrfs_free_block_rsv()
Message-ID: <20180801125546.GD3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1532572743.git.misono.tomohiro@jp.fujitsu.com>
 <01829a36-c358-e71a-4281-be8eeb8f8302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01829a36-c358-e71a-4281-be8eeb8f8302@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2018 at 11:40:54AM +0900, Misono Tomohiro wrote:
> There is no user of this function.
> 
> This is forgotten to get removed in commit a575ceeb1338
> ("Btrfs: get rid of unused orphan infrastructure").
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Added to misc-next, thanks.
