Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933479AbeE1QNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:47 -0400
Date: Mon, 28 May 2018 14:16:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop unused space_info parameter from
 create_space_info
Message-ID: <20180528121625.GV6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180528063027.4527-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180528063027.4527-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 02:30:27PM +0800, Lu Fengqi wrote:
> Since commit dc2d3005d27d ("btrfs: remove dead create_space_info
> calls"), there is only one caller btrfs_init_space_info. However, it
> doesn't need create_space_info to return space_info at all.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to 4.18 queue, thanks.
