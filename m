Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbaDNQ3U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 12:29:20 -0400
Date: Mon, 14 Apr 2014 18:29:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Force 'btrfs dev scan' not using old
 libblkid cache
Message-ID: <20140414162919.GO29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397115021-30426-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397115021-30426-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 10, 2014 at 03:30:21PM +0800, Qu Wenruo wrote:
> 'btrfs scan' uses libblkid to scan devices by default, and libblkid uses
> cache to reduce the probe.
> 
> But if operations below is done in less than 2 seconds(BLKID_PROBE_MIN),
> 'btrfs scan' will still use the uncorrect cache and scan on the deleted device.
> 0. /dev/sda[1-4] mounted on /mnt using single data/metadata
> 1. btrfs dev scan
> 2. btrfs dev del /dev/sda3 /mnt
> 3. btrfs dev scan
> 
> Since the cache made by step 1 is still validated, step 3 will use the
> cache and consider /dev/sda3 as a btrfs filesystem and try to scan it.
> But the superblock(at least the first one) is wiped and failed to scan,
> a error message, which can be avoided and is unneeded, is output.
> 
> This patch will force scan_for_btrfs() not to use cache to avoid the
> problem.

> --- a/utils.c
> +++ b/utils.c
> @@ -2057,7 +2057,8 @@ int btrfs_scan_lblkid(int update_kernel)
>  	blkid_cache cache = NULL;
>  	char path[PATH_MAX];
>  
> -	if (blkid_get_cache(&cache, 0) < 0) {
> +	/* No to use libblkid cache to avoid old data */
> +	if (blkid_get_cache(&cache, "/dev/null") < 0) {

This effectively avoid the blkid cache for all devices but the point of
blkid was to use it so repeated probes are not done.

I think it's not right to skip the whole cache because one entry may be
stale, more that we know which one and when.

We should rather explicitly invalidate the removed device after delete,
I don't what's the right way to do that. Maybe blkid_do_probe() or
blkid_gc_cache()
