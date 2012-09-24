Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36381 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab2IXQdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 12:33:35 -0400
Date: Mon, 24 Sep 2012 18:33:26 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120924163326.GM14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
 <505C2E62.2000400@cn.fujitsu.com>
 <20120921152444.GV17430@twin.jikos.cz>
 <505EDC4A.1060709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505EDC4A.1060709@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 23, 2012 at 05:54:18PM +0800, Miao Xie wrote:
> >> @@ -2347,7 +2335,8 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> >>  	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
> >>  	chunk_used = btrfs_block_group_used(&cache->item);
> >>  
> >> -	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
> >> +	BUG_ON(bargs->usage < 0 || bargs->usage > 100);
> > 
> > otherwise it reliably crashes here
> 
> Sorry, I don't know why it will crash here if we input 0. I tried to input 0,
> and it worked well.

My oversight, sorry.

> I think the only case we must take into account is the users might input the wrong value (>100 or <0)
> on the old kernel, and it can be stored into the filesystem. If we mount this filesystem
> on the new kernel, some problems may happen.

So better avoid a BUG_ON.
