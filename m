Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbcEaQvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 12:51:24 -0400
Date: Tue, 31 May 2016 18:50:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: convert: Fix a bug that makes convert
 asserts at scan time
Message-ID: <20160531165046.GL29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160531075113.24603-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160531075113.24603-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2016 at 03:51:13PM +0800, Qu Wenruo wrote:
> When a ext2 fs filled with a 57M file, it's possible that convert fails
> with assert in add_merge_cache_extent().
> 
> The problem is that the ext2 used space just takes some of the second
> superblock.
> And due to a bug in reserving superblock space, it corrupted used space
> tree and cause assert.
> 
> Fix in by doing better used space merging for case where superblock
> range is inside the ext2 used space.
> 
> Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

The reproduce seems easy, do you have an image or test script for that?
Pach applied.
