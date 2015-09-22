Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbbIVOev (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:34:51 -0400
Date: Tue, 22 Sep 2015 16:33:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: use btrfs_raid_array in
 btrfs_reduce_alloc_profile
Message-ID: <20150922143355.GK12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442322310.git.zhaolei@cn.fujitsu.com>
 <ba0f699bf154843d8fb3456156457b297197c749.1442322310.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ba0f699bf154843d8fb3456156457b297197c749.1442322310.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 15, 2015 at 09:08:08PM +0800, Zhao Lei wrote:
> btrfs_raid_array[] holds attributes of all raid types.
> 
> Use btrfs_raid_array[].devs_min is best way for request
> in btrfs_reduce_alloc_profile(), instead of use complex
> condition of each raid types.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
