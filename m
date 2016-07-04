Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbcGDMBB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 08:01:01 -0400
Date: Mon, 4 Jul 2016 14:01:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: fix allocation information output of
 block group types
Message-ID: <20160704120125.GD13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160701052625.7748-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160701052625.7748-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 01, 2016 at 01:26:25PM +0800, Wang Xiaoguang wrote:
> When cleanup_temp_chunks() removes block groups, it forgot to update
> mkfs_allocation accordingly, fix this.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Applied, thanks.
