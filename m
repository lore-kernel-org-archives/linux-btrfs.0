Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A345AECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9CE214C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:14:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A9CE214C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbeJQWKu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 18:10:50 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:35958 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbeJQWKu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 18:10:50 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1870014AbeJQOOO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 16:14:14 +0200
Date:   Wed, 17 Oct 2018 16:14:14 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 7/9] btrfs: Add support for recovery for a RAID 5 btrfs profiles.
Message-ID: <20181017141414.GC25306@router-fw-old.i.net-space.pl>
References: <20181011185103.23146-1-kreijack@libero.it> <20181011185103.23146-8-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011185103.23146-8-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 08:51:01PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Add support for recovery for a RAID 5 btrfs profile. In addition
> it is added some code as preparatory work for RAID 6 recovery code.
>
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  grub-core/fs/btrfs.c | 162 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 157 insertions(+), 5 deletions(-)
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index 899dc32b7..d066d54cc 100644
> --- a/grub-core/fs/btrfs.c
> +++ b/grub-core/fs/btrfs.c
> @@ -29,6 +29,7 @@
>  #include <minilzo.h>
>  #include <grub/i18n.h>
>  #include <grub/btrfs.h>
> +#include <grub/crypto.h>
>
>  GRUB_MOD_LICENSE ("GPLv3+");
>
> @@ -665,6 +666,141 @@ btrfs_read_from_chunk (struct grub_btrfs_data *data,
>      return err;
>  }
>
> +struct raid56_buffer {
> +  void *buf;
> +  int  data_is_valid;
> +};
> +
> +static void
> +rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
> +	       grub_uint64_t nstripes, grub_uint64_t csize)
> +{
> +  grub_uint64_t i;
> +  int first;
> +
> +  for(i = 0; buffers[i].data_is_valid && i < nstripes; i++);
> +
> +  if (i == nstripes)
> +    {
> +      grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
> +      return;
> +    }
> +
> +  grub_dprintf ("btrfs", "rebuilding RAID 5 stripe #%" PRIuGRUB_UINT64_T "\n", i);
> +
> +  for (i = 0, first = 1; i < nstripes; i++)
> +    {
> +      if (!buffers[i].data_is_valid)
> +	continue;
> +
> +      if (first) {
> +	grub_memcpy(dest, buffers[i].buf, csize);
> +	first = 0;
> +      } else
> +	grub_crypto_xor (dest, dest, buffers[i].buf, csize);
> +

Please drop this empty line.

> +    }
> +}
> +
> +static grub_err_t
> +raid56_read_retry (struct grub_btrfs_data *data,
> +		   struct grub_btrfs_chunk_item *chunk,
> +		   grub_uint64_t stripe_offset,
> +		   grub_uint64_t csize, void *buf)
> +{
> +  struct raid56_buffer *buffers;
> +  grub_uint64_t nstripes = grub_le_to_cpu16 (chunk->nstripes);
> +  grub_uint64_t chunk_type = grub_le_to_cpu64 (chunk->type);
> +  grub_err_t ret = GRUB_ERR_OUT_OF_MEMORY;
> +  grub_uint64_t i, failed_devices;
> +
> +  buffers = grub_zalloc (sizeof(*buffers) * nstripes);
> +  if (!buffers)
> +    goto cleanup;
> +
> +  for (i = 0; i < nstripes; i++)
> +    {
> +      buffers[i].buf = grub_zalloc (csize);
> +      if (!buffers[i].buf)
> +	goto cleanup;
> +    }
> +
> +  for (failed_devices = 0, i = 0; i < nstripes; i++)
> +    {
> +      struct grub_btrfs_chunk_stripe *stripe;
> +      grub_disk_addr_t paddr;
> +      grub_device_t dev;
> +      grub_err_t err;
> +
> +      /* after the struct grub_btrfs_chunk_item, there is an array of
> +         struct grub_btrfs_chunk_stripe */

/* Struct grub_btrfs_chunk_stripe lives behind struct grub_btrfs_chunk_item. */

> +      stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1) + i;
> +
> +      paddr = grub_le_to_cpu64 (stripe->offset) + stripe_offset;
> +      grub_dprintf ("btrfs", "reading paddr %" PRIxGRUB_UINT64_T
> +                    " from stripe ID %" PRIxGRUB_UINT64_T "\n", paddr,
> +                    stripe->device_id);
> +
> +      dev = find_device (data, stripe->device_id);
> +      if (!dev)
> +	{
> +	  buffers[i].data_is_valid = 0;
> +	  grub_dprintf ("btrfs", "stripe %" PRIuGRUB_UINT64_T " FAILED (dev ID %"
> +			PRIxGRUB_UINT64_T ")\n", i, stripe->device_id);
> +	  failed_devices++;
> +	  continue;
> +	}
> +
> +      err = grub_disk_read (dev->disk, paddr >> GRUB_DISK_SECTOR_BITS,
> +			    paddr & (GRUB_DISK_SECTOR_SIZE - 1),
> +			    csize, buffers[i].buf);
> +      if (err == GRUB_ERR_NONE)
> +	{
> +	  buffers[i].data_is_valid = 1;
> +	  grub_dprintf ("btrfs", "stripe %" PRIuGRUB_UINT64_T " Ok (dev ID %"

s/Ok/OK/

> +			PRIxGRUB_UINT64_T ")\n", i, stripe->device_id);
> +	}
> +      else
> +	{
> +	  buffers[i].data_is_valid = 0;
> +	  grub_dprintf ("btrfs", "stripe %" PRIuGRUB_UINT64_T
> +			" FAILED (dev ID %" PRIxGRUB_UINT64_T ")\n", i,
> +			stripe->device_id);
> +	  failed_devices++;
> +	}
> +    }
> +
> +  if (failed_devices > 1 && (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5))
> +    {
> +      grub_dprintf ("btrfs",
> +		    "not enough disks for RAID 5: total %" PRIuGRUB_UINT64_T
> +		    ", missing %" PRIuGRUB_UINT64_T "\n",
> +		    nstripes, failed_devices);
> +      ret = GRUB_ERR_READ_ERROR;
> +      goto cleanup;
> +    }
> +  else
> +    grub_dprintf ("btrfs",
> +		  "enough disks for RAID 5 rebuilding: total %"

s/enough disks for RAID 5 rebuilding/enough disks for RAID 5/

> +		  PRIuGRUB_UINT64_T ", missing %" PRIuGRUB_UINT64_T "\n",
> +		  nstripes, failed_devices);
> +
> +  /* if these are enough, try to rebuild the data */

/* We have enough disks. So, rebuild the data. */

> +  if (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5)
> +    rebuild_raid5 (buf, buffers, nstripes, csize);
> +  else
> +    grub_dprintf ("btrfs", "called rebuild_raid6(), NOT IMPLEMENTED\n");
> +
> +  ret = GRUB_ERR_NONE;
> + cleanup:
> +  if (buffers)
> +    for (i = 0; i < nstripes; i++)
> +	grub_free(buffers[i].buf);

Lack of space between function name and "(".

> +  grub_free(buffers);

Ditto.

> +  return ret;
> +}
> +
>  static grub_err_t
>  grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  			 void *buf, grub_size_t size, int recursion_depth)
> @@ -742,6 +878,10 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	grub_uint16_t nstripes;
>  	unsigned redundancy = 1;
>  	unsigned i, j;
> +	int is_raid56;
> +
> +	is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
> +		       GRUB_BTRFS_CHUNK_TYPE_RAID5);
>
>  	if (grub_le_to_cpu64 (chunk->size) <= off)
>  	  {
> @@ -921,17 +1061,29 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	    grub_dprintf ("btrfs", "reading laddr 0x%" PRIxGRUB_UINT64_T "\n",
>  			  addr);
>
> -	    for (i = 0; i < redundancy; i++)
> +	    if (!is_raid56)

Why not "if (is_raid56)"? I asked about that earlier. Please change
this if and of course code below. It will be much easier to read. And
you do not need curly brackets for for loop after else.

> +	      for (i = 0; i < redundancy; i++)
> +		{
> +		  err = btrfs_read_from_chunk (data, chunk, stripen,
> +					       stripe_offset,
> +					       i,     /* redundancy */
> +					       csize, buf);
> +		  if (!err)
> +		    break;
> +		  grub_errno = GRUB_ERR_NONE;
> +		}
> +	    else
>  	      {
>  		err = btrfs_read_from_chunk (data, chunk, stripen,
>  					     stripe_offset,
> -					     i,     /* redundancy */
> +					     0,     /* no mirror */
>  					     csize, buf);
> -		if (!err)
> -		  break;
>  		grub_errno = GRUB_ERR_NONE;
> +		if (err)
> +		  err = raid56_read_retry (data, chunk, stripe_offset,
> +					   csize, buf);
>  	      }
> -	    if (i != redundancy)
> +	    if (!err)
>  	      break;
>  	  }
>  	if (err)

Daniel
