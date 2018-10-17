Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC0FECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E2A5205F4
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E2A5205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbeJQWUC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 18:20:02 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:35980 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeJQWUC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 18:20:02 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1875848AbeJQOXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 16:23:10 +0200
Date:   Wed, 17 Oct 2018 16:23:10 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 9/9] btrfs: Add RAID 6 recovery for a btrfs filesystem.
Message-ID: <20181017142310.GD25306@router-fw-old.i.net-space.pl>
References: <20181011185103.23146-1-kreijack@libero.it> <20181011185103.23146-10-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011185103.23146-10-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 08:51:03PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Add the RAID 6 recovery, in order to use a RAID 6 filesystem even if some
> disks (up to two) are missing. This code use the md RAID 6 code already
> present in grub.
>
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  grub-core/fs/btrfs.c | 60 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 54 insertions(+), 6 deletions(-)
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index d066d54cc..d20ee09e4 100644
> --- a/grub-core/fs/btrfs.c
> +++ b/grub-core/fs/btrfs.c
> @@ -30,6 +30,7 @@
>  #include <grub/i18n.h>
>  #include <grub/btrfs.h>
>  #include <grub/crypto.h>
> +#include <grub/diskfilter.h>
>
>  GRUB_MOD_LICENSE ("GPLv3+");
>
> @@ -702,11 +703,36 @@ rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
>      }
>  }
>
> +static grub_err_t
> +raid6_recover_read_buffer (void *data, int disk_nr,
> +			   grub_uint64_t addr __attribute__ ((unused)),
> +			   void *dest, grub_size_t size)
> +{
> +    struct raid56_buffer *buffers = data;
> +
> +    if (!buffers[disk_nr].data_is_valid)
> +	return grub_errno = GRUB_ERR_READ_ERROR;
> +
> +    grub_memcpy(dest, buffers[disk_nr].buf, size);
> +
> +    return grub_errno = GRUB_ERR_NONE;
> +}
> +
> +static void
> +rebuild_raid6 (struct raid56_buffer *buffers, grub_uint64_t nstripes,
> +               grub_uint64_t csize, grub_uint64_t parities_pos, void *dest,
> +               grub_uint64_t stripen)
> +
> +{
> +  grub_raid6_recover_gen (buffers, nstripes, stripen, parities_pos,
> +                          dest, 0, csize, 0, raid6_recover_read_buffer);
> +}
> +
>  static grub_err_t
>  raid56_read_retry (struct grub_btrfs_data *data,
>  		   struct grub_btrfs_chunk_item *chunk,
> -		   grub_uint64_t stripe_offset,
> -		   grub_uint64_t csize, void *buf)
> +		   grub_uint64_t stripe_offset, grub_uint64_t stripen,
> +		   grub_uint64_t csize, void *buf, grub_uint64_t parities_pos)
>  {
>    struct raid56_buffer *buffers;
>    grub_uint64_t nstripes = grub_le_to_cpu16 (chunk->nstripes);
> @@ -779,6 +805,15 @@ raid56_read_retry (struct grub_btrfs_data *data,
>        ret = GRUB_ERR_READ_ERROR;
>        goto cleanup;
>      }
> +  else if (failed_devices > 2 && (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID6))
> +    {
> +      grub_dprintf ("btrfs",
> +		    "not enough disks for raid6: total %" PRIuGRUB_UINT64_T

s/not enough disks for raid6/not enough disks for RAID 6/

You are using "RAID 5" in earlier patch, so, please be consistent
and use "RAID 6" here.

> +		    ", missing %" PRIuGRUB_UINT64_T "\n",
> +		    nstripes, failed_devices);
> +      ret = GRUB_ERR_READ_ERROR;
> +      goto cleanup;
> +    }
>    else
>      grub_dprintf ("btrfs",
>  		  "enough disks for RAID 5 rebuilding: total %"
> @@ -789,7 +824,7 @@ raid56_read_retry (struct grub_btrfs_data *data,
>    if (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5)
>      rebuild_raid5 (buf, buffers, nstripes, csize);
>    else
> -    grub_dprintf ("btrfs", "called rebuild_raid6(), NOT IMPLEMENTED\n");
> +    rebuild_raid6 (buffers, nstripes, csize, parities_pos, buf, stripen);
>
>    ret = GRUB_ERR_NONE;
>   cleanup:
> @@ -879,9 +914,11 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	unsigned redundancy = 1;
>  	unsigned i, j;
>  	int is_raid56;
> +	grub_uint64_t parities_pos = 0;
>
> -	is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
> -		       GRUB_BTRFS_CHUNK_TYPE_RAID5);
> +        is_raid56 = !!(grub_le_to_cpu64 (chunk->type) &
> +		       (GRUB_BTRFS_CHUNK_TYPE_RAID5 |
> +		        GRUB_BTRFS_CHUNK_TYPE_RAID6));
>
>  	if (grub_le_to_cpu64 (chunk->size) <= off)
>  	  {
> @@ -1030,6 +1067,17 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	       */
>  	      grub_divmod64 (high + stripen, nstripes, &stripen);
>
> +	      /*
> +	       * parities_pos is equal to "(high - nparities) % nstripes"
> +	       * (see the diagram above).
> +	       * However "high - nparities" might be negative (eg when high
> +	       * == 0) leading to an incorrect computation.

However, "high - nparities" can be negative, eg. when high == 0,
leading to an incorrect results.

> +	       * Instead "high + nstripes - nparities" is always positive and
> +	       * in modulo nstripes is equal to "(high - nparities) % nstripes"

"high + nstripes - nparities" is always positive and modulo
nstripes is equal to "(high - nparities) % nstripes".

If you change above mentioned things you can retain my
  Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

Daniel
