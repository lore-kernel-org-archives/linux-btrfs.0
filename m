Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbcHPOMp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 10:12:45 -0400
Date: Tue, 16 Aug 2016 16:11:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: eliminate some unnecessary
 btrfs_lookup_extent_info() calls in walk_down_tree()
Message-ID: <20160816141150.GN30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160816061757.9319-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160816061757.9319-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 16, 2016 at 02:17:57PM +0800, Wang Xiaoguang wrote:
> In walk_down_tree(), we may call btrfs_lookup_extent_info() for same tree
> block many times, obviously unnecessary. Here we define a simple struct to
> record whether we already have gotten tree block's refs:
>         struct node_refs {
>                 u64 bytenr[BTRFS_MAX_LEVEL];
>                 u64 refs[BTRFS_MAX_LEVEL];
>         };
> 
> I fill a disk partition with linux kernel source codes and use below
> test script to have performance test.
> 	#!/bin/bash
> 
> 	echo 3 > /proc/sys/vm/drop_caches
> 	for ((i = 0; i < 20; i++)); do
> 		time ./btrfsck  /dev/sdc5
> 	done 2>&1 | grep real | awk -F "[ms]" '{run_time += $2} END{print run_time / 20}'
> 
> Before this patch, it averagely took 0.8447s for every btrfsck execution,
> and with this patch, it averagely took 0.7807s.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Applied, thanks.
