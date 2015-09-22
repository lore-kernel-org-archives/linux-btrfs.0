Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbbIVObG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:31:06 -0400
Date: Tue, 22 Sep 2015 16:30:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: use btrfs_raid_array for
 btrfs_get_num_tolerated_disk_barrier_failures()
Message-ID: <20150922143010.GJ12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442322310.git.zhaolei@cn.fujitsu.com>
 <bea5cae2134583da7c2f2e936cecc8d95c3b7baf.1442322310.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bea5cae2134583da7c2f2e936cecc8d95c3b7baf.1442322310.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 15, 2015 at 09:08:07PM +0800, Zhao Lei wrote:
> btrfs_raid_array[] is used to define all raid attributes, use it
> to get tolerated_failures in btrfs_get_num_tolerated_disk_barrier_failures(),
> instead of complex condition in function.
> 
> It can make code simple and auto-support other possible raid-type in
> future.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
