Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7674FECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 13:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19751205F4
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 13:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19751205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbeJQVm0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 17:42:26 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:35905 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbeJQVm0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 17:42:26 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1875665AbeJQNqJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 15:46:09 +0200
Date:   Wed, 17 Oct 2018 15:46:09 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/9] btrfs: Add support for reading a filesystem with a RAID 5 or RAID 6 profile.
Message-ID: <20181017134609.GA25306@router-fw-old.i.net-space.pl>
References: <20181011185103.23146-1-kreijack@libero.it> <20181011185103.23146-2-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011185103.23146-2-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 08:50:55PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>

One nit pick below...

Otherwise you can add Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

> ---
>  grub-core/fs/btrfs.c | 73 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index be195448d..933a57d3b 100644
> --- a/grub-core/fs/btrfs.c
> +++ b/grub-core/fs/btrfs.c
> @@ -119,6 +119,8 @@ struct grub_btrfs_chunk_item
>  #define GRUB_BTRFS_CHUNK_TYPE_RAID1         0x10
>  #define GRUB_BTRFS_CHUNK_TYPE_DUPLICATED    0x20
>  #define GRUB_BTRFS_CHUNK_TYPE_RAID10        0x40
> +#define GRUB_BTRFS_CHUNK_TYPE_RAID5         0x80
> +#define GRUB_BTRFS_CHUNK_TYPE_RAID6         0x100
>    grub_uint8_t dummy2[0xc];
>    grub_uint16_t nstripes;
>    grub_uint16_t nsubstripes;
> @@ -764,6 +766,77 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	      stripe_offset = low + chunk_stripe_length
>  		* high;
>  	      csize = chunk_stripe_length - low;
> +	      break;
> +	    }
> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
> +	    {
> +	      grub_uint64_t nparities, stripe_nr, high, low;
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
> +	      /*
> +	       * RAID 6 layout consists of several stripes spread over
> +	       * the disks, e.g.:
> +	       *
> +	       *   Disk_0  Disk_1  Disk_2  Disk_3
> +	       *     A0      B0      P0      Q0
> +	       *     Q1      A1      B1      P1
> +	       *     P2      Q2      A2      B2
> +	       *
> +	       * Note: placement of the parities depend on row number.
> +	       *
> +	       * Pay attention that the btrfs terminology may differ from
> +	       * terminology used in other RAID implementations, e.g. LVM,
> +	       * dm or md. The main difference is that btrfs calls contiguous
> +	       * block of data on a given disk, e.g. A0, stripe instead of chunk.
> +	       *
> +	       * The variables listed below have following meaning:
> +	       *   - stripe_nr is the stripe number excluding the parities
> +	       *     (A0 = 0, B0 = 1, A1 = 2, B1 = 3, etc.),
> +	       *   - high is the row number (0 for A0...Q0, 1 for Q1...P1, etc.),
> +	       *   - stripen is the disk number in a row (0 for A0, Q1, P2,
> +	       *     1 for B0, A1, Q2, etc.),
> +	       *   - off is the logical address to read,
> +	       *   - chunk_stripe_length is the size of a stripe (typically 64 KiB),
> +	       *   - nstripes is the number of disks in a row,
> +	       *   - low is the offset of the data inside a stripe,
> +	       *   - stripe_offset is the data offset in an array,
> +	       *   - csize is the "potential" data to read; it will be reduced
> +	       *     to size if the latter is smaller,
> +	       *   - nparities is the number of parities (1 for RAID 5, 2 for
> +	       *     RAID 6); used only in RAID 5/6 code.
> +	       */
> +	      stripe_nr = grub_divmod64 (off, chunk_stripe_length, &low);
> +
> +	      /*
> +	       * stripen is computed without the parities
> +	       * (0 for A0, A1, A2, 1 for B0, B1, B2, etc.).
> +	       */
> +	      high = grub_divmod64 (stripe_nr, nstripes - nparities, &stripen);
> +
> +	      /*
> +	       * The stripes are spread over the disks. Every each row their
> +	       * positions are shifted by 1 place. So, the real disks number
> +	       * change. Hence, we have to take current row number modulo
> +	       * nstripes into account (0 for A0, 1 for A1, 2 for A2, etc.).

s/current row number modulo nstripes into account/into account current row number modulo nstripes/

Daniel
