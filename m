Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from boksu.net-space.pl ([185.15.1.105]:35574 "EHLO
        boksu.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754710AbeDWMCZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 08:02:25 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@boksu.net-space.pl)) by router-fw-old.local.net-space.pl
        id S1837282AbeDWLun (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:50:43 +0200
Date: Mon, 23 Apr 2018 13:50:43 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: kreijack@gmail.com
Cc: grub-devel@gnu.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Add support for BTRFS raid5/6 to GRUB
Message-ID: <20180423115043.GA4061@router-fw-old.local.net-space.pl>
References: <2708f56e-1dac-481e-af8a-d81066df8b42@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2708f56e-1dac-481e-af8a-d81066df8b42@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 09:57:40PM +0200, Goffredo Baroncelli wrote:
> Hi All,
>
> Below you can find a patch to add support for accessing files from
> grub in a RAID5/6 btrfs filesystem. This is a RFC because it is
> missing the support for recovery (i.e. if some devices are missed). In
> the next days (weeks ?) I will extend this patch to support also this
> case.
>
> Comments are welcome.

More or less LGTM. Just a nitpick below... I am happy to take full blown
patch into GRUB if it is ready.

> BR
> G.Baroncelli
>
>
> ---
>
> commit 8c80a1b7c913faf50f95c5c76b4666ed17685666
> Author: Goffredo Baroncelli <kreijack@inwind.it>
> Date:   Tue Apr 17 21:40:31 2018 +0200
>
>     Add initial support for btrfs raid5/6 chunk
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index be195448d..4c5632acb 100644
> --- a/grub-core/fs/btrfs.c
> +++ b/grub-core/fs/btrfs.c
> @@ -119,6 +119,8 @@ struct grub_btrfs_chunk_item
>  #define GRUB_BTRFS_CHUNK_TYPE_RAID1         0x10
>  #define GRUB_BTRFS_CHUNK_TYPE_DUPLICATED    0x20
>  #define GRUB_BTRFS_CHUNK_TYPE_RAID10        0x40
> +#define GRUB_BTRFS_CHUNK_TYPE_RAID5         0x80
> +#define GRUB_BTRFS_CHUNK_TYPE_RAID6        0x100
>    grub_uint8_t dummy2[0xc];
>    grub_uint16_t nstripes;
>    grub_uint16_t nsubstripes;
> @@ -764,6 +766,39 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	      stripe_offset = low + chunk_stripe_length
>  		* high;
>  	      csize = chunk_stripe_length - low;
> +	      break;
> +	    }
> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
> +	    {
> +	      grub_uint64_t nparities;
> +	      grub_uint64_t parity_pos;
> +	      grub_uint64_t stripe_nr, high;
> +	      grub_uint64_t low;
> +
> +	      redundancy = 1;	/* no redundancy for now */
> +
> +	      if (grub_le_to_cpu64 (chunk->type) & GRUB_BTRFS_CHUNK_TYPE_RAID5)
> +		{
> +		  grub_dprintf ("btrfs", "RAID5\n");
> +		  nparities = 1;
> +		}
> +	      else
> +		{
> +		  grub_dprintf ("btrfs", "RAID6\n");
> +		  nparities = 2;
> +		}
> +
> +	      stripe_nr = grub_divmod64 (off, chunk_stripe_length, &low);
> +
> +	      high = grub_divmod64 (stripe_nr, nstripes - nparities, &stripen);
> +	      grub_divmod64 (high+nstripes-nparities, nstripes, &parity_pos);
> +	      grub_divmod64 (parity_pos+nparities+stripen, nstripes, &stripen);

Missing spaces around "+" and "-".

Daniel
