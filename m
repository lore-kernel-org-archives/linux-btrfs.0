Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3APOE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 09:04:59 -0500
Date: Wed, 16 Jan 2013 15:04:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: make raid attr array more readable
Message-ID: <20130116140456.GU20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50F68FFB.3050806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F68FFB.3050806@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 16, 2013 at 07:33:15PM +0800, Miao Xie wrote:
> As the title said, this patch just make raid attr array more readable.

Nice cleanup, thanks.

> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3492,13 +3492,48 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
>  }
>  
>  struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
> -	{ 1, 1, 2, 2, 2, 2 /* raid1 */ },

> +	[BTRFS_RAID_RAID1] = {
> +		.sub_stripes	= 1,
> +		.dev_stripes	= 1,
> +		.devs_max	= 2,

Unrelated, but I'm curious why is this set to 2 (and was before)? This
will give preference to the same 2 devices as long as there's space, so
the allocator will not spread the data over the device set. I'd expect
the same behaviour as in RAID10 profile here.

> +		.devs_min	= 2,
> +		.devs_increment	= 2,
> +		.ncopies	= 2,
> +	},

david
