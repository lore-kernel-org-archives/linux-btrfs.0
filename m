Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-108-0-197-17.lsanca.fios.verizon.net ([108.0.197.17]:41340
	"EHLO orca4.orcaware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3CFRPg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 12:15:36 -0500
Message-ID: <51377985.603@orcaware.com>
Date: Wed, 06 Mar 2013 09:14:45 -0800
From: Blair Zajac <blair@orcaware.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: enhance superblock checks
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/06/2013 07:56 AM, David Sterba wrote:
> The superblock checksum is not verified upon mount. <awkward silence>
>
> Add that check and also reorder existing checks to a more logical
> order.
>
> Current mkfs.btrfs does not calculate the correct checksum of
> super_block and thus a freshly created filesytem will fail to mount when
> this patch is applied.
>
> First transaction commit calculates correct superblock checksum and
> saves it to disk.

> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7d84651..d5c710c 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -354,6 +354,42 @@ out:
>   }
>
>   /*
> + * Return 0 if the superblock checksum type matches the checksum value of that
> + * alghorithm. Pass the raw disk superblock data.

I'm not familiar with the review policy on this list, but here's a minor 
one:

s/alghorithm/algorithm/

Blair


