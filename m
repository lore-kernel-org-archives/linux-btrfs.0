Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbbIYU4Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 16:56:24 -0400
Date: Fri, 25 Sep 2015 22:55:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH 3/4] btrfs-progs: Introduce better superblock check.
Message-ID: <20150925205526.GS11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1431508536-7275-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431508536-7275-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 05:15:35PM +0800, Qu Wenruo wrote:
> Now btrfs-progs will have much more restrict superblock check based on
> kernel superblock check.
> 
> This should at least provide some hostile crafted image to crash command
> like btrfsck.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied with some changes.

> +/* Just to save some space */
> +#define pr_err(fmt, args...)	(fprintf(stderr, fmt, ##args))

fprintf(stderr, ...)

> +	/*
> +	 * Hint to catch really bogus numbers, bitflips or so
> +	 */
> +	if (btrfs_super_num_devices(sb) > (1UL << 31)) {
> +		pr_err("ERROR: suspicious number of devices: %llu\n",
> +			btrfs_super_num_devices(sb));
> +		return -EIO;

This is supposed to be only a warning.

> +	}
> +
