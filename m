Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48617 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933454AbcKGSVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 13:21:19 -0500
Date: Mon, 7 Nov 2016 19:21:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v14 02/15] btrfs: fix false enospc for compression
Message-ID: <20161107182115.GV12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161104013304.11365-1-quwenruo@cn.fujitsu.com>
 <20161104013304.11365-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161104013304.11365-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2016 at 09:32:51AM +0800, Qu Wenruo wrote:
>  int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
> -			      struct extent_state **cached_state, int dedupe);
> +			      struct extent_state **cached_state, int flag);

During a test merge I've noticed that the 'flag' gets assigned the
btrfs_metadata_reserve_type, please change this function accordingly,
and btrfs_metadata_reserve_type as well. Thanks.

>  int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
> -			    struct extent_state **cached_state);
> +			    struct extent_state **cached_state, int flag);

I'd recommend to separate the btrfs_metadata_reserve_type from "btrfs:
fix false enospc for compression", so we can merge it in advance.
