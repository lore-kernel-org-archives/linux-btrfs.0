Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D085AC43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 19:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92AD820833
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 19:21:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92AD820833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbeIZBaX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 21:30:23 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52811 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbeIZBaX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 21:30:23 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1862228AbeIYTUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 21:20:46 +0200
Date:   Tue, 25 Sep 2018 21:20:46 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 9/9] btrfs: Add RAID 6 recovery for a btrfs filesystem.
Message-ID: <20180925192046.GE30715@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-10-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180919184040.22540-10-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 19, 2018 at 08:40:40PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Add the RAID 6 recovery, in order to use a RAID 6 filesystem even if some
> disks (up to two) are missing. This code use the md RAID 6 code already
> present in grub.
>
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  grub-core/fs/btrfs.c | 54 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 48 insertions(+), 6 deletions(-)
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index 55a7eeffc..400cd56b6 100644
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
> @@ -705,11 +706,36 @@ rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
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
> @@ -787,6 +813,15 @@ raid56_read_retry (struct grub_btrfs_data *data,
>        ret = GRUB_ERR_READ_ERROR;
>        goto cleanup;
>      }
> +  else if (failed_devices > 2 && (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID6))
> +    {
> +      grub_dprintf ("btrfs",
> +		    "not enough disks for raid6: total %" PRIuGRUB_UINT64_T
> +		    ", missing %" PRIuGRUB_UINT64_T "\n",
> +		    nstripes, failed_devices);
> +      ret = GRUB_ERR_READ_ERROR;
> +      goto cleanup;
> +    }
>    else
>      grub_dprintf ("btrfs",
>  		  "enough disks for RAID 5 rebuilding: total %"
> @@ -797,7 +832,7 @@ raid56_read_retry (struct grub_btrfs_data *data,
>    if (chunk_type & GRUB_BTRFS_CHUNK_TYPE_RAID5)
>      rebuild_raid5 (buf, buffers, nstripes, csize);
>    else
> -    grub_dprintf ("btrfs", "called rebuild_raid6(), NOT IMPLEMENTED\n");
> +    rebuild_raid6 (buffers, nstripes, csize, parities_pos, buf, stripen);
>
>   cleanup:
>    if (buffers)
> @@ -886,9 +921,11 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
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
> @@ -1015,6 +1052,8 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	       *  - stripe_offset is the disk offset,
>  	       *  - csize is the "potential" data to read. It will be reduced to
>  	       *    size if the latter is smaller.
> +	       *  - parities_pos is the position of the parity inside a row (

s/inside/in/

> +	       *    2 for P1, 3 for P2...)
>  	       */
>  	      block_nr = grub_divmod64 (off, chunk_stripe_length, &low);
>
> @@ -1030,6 +1069,9 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	       */
>  	      grub_divmod64 (high + stripen, nstripes, &stripen);
>
> +	      grub_divmod64 (high + nstripes - nparities, nstripes,
> +			     &parities_pos);

I think that this math requires a bit of explanation in the comment
before grub_divmod64(). Especially I am interested in why high +
nstripes - nparities works as expected.

Daniel
