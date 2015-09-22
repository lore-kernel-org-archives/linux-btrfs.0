Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661AbbIVO3u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:29:50 -0400
Date: Tue, 22 Sep 2015 16:28:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Move btrfs_raid_array to public
Message-ID: <20150922142855.GI12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442322310.git.zhaolei@cn.fujitsu.com>
 <c57e679873ccc4026f6ba4122fabe05ed3b2564e.1442322310.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c57e679873ccc4026f6ba4122fabe05ed3b2564e.1442322310.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 15, 2015 at 09:08:06PM +0800, Zhao Lei wrote:
> This array is used to record attributes of each raid type,
> make it public, and many functions will benifit with this array.
> 
> For example, num_tolerated_disk_barrier_failures(), we can
> avoid complex conditions in this function, and get raid attribute
> simply by accessing above array.
> 
> It can also make code logic simple, reduce duplication code, and
> increase maintainability.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
