Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3096C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5622C2086E
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5622C2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbeIYVj4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:39:56 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52439 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729496AbeIYVj4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:39:56 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1861222AbeIYPbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:31:42 +0200
Date:   Tue, 25 Sep 2018 17:31:42 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/9] btrfs: Add support for reading a filesystem with a RAID 5 or RAID 6 profile.
Message-ID: <20180925153142.GA30715@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-2-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180919184040.22540-2-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 19, 2018 at 08:40:32PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  grub-core/fs/btrfs.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index be195448d..56c42746d 100644
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
> @@ -764,6 +766,70 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  	      stripe_offset = low + chunk_stripe_length
>  		* high;
>  	      csize = chunk_stripe_length - low;
> +	      break;
> +	    }
> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
> +	    {
> +	      grub_uint64_t nparities, block_nr, high, low;
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
> +	       * A RAID 6 layout consists of several blocks spread on the disks.
> +	       * The raid terminology is used to call all the blocks of a row
> +	       * "stripe". Unfortunately the BTRFS terminology confuses block

Stripe is data set or parity (parity stripe) on one disk. Block has
different meaning. Please stick to btrfs terminology and say it clearly
in the comment. And even add a link to btrfs wiki page to ease reading.

I think about this one:
  https://btrfs.wiki.kernel.org/index.php/Manpage/mkfs.btrfs#BLOCK_GROUPS.2C_CHUNKS.2C_RAID

> +	       * and stripe.

I do not think so. Or at least not so much...

> +	       *
> +	       *   Disk0  Disk1  Disk2  Disk3
> +	       *
> +	       *    A1     B1     P1     Q1
> +	       *    Q2     A2     B2     P2
> +	       *    P3     Q3     A3     B3
> +	       *  [...]
> +	       *
> +	       *  Note that the placement of the parities depends on row index.
> +	       *  In the code below:
> +	       *  - block_nr is the block number without the parities

Well, it seems to me that the btrfs code introduces confusion not the
spec itself. I would leave code as is but s/block number/stripe number/.

> +	       *    (A1 = 0, B1 = 1, A2 = 2, B2 = 3, ...),
> +	       *  - high is the row number (0 for A1...Q1, 1 for Q2...P2, ...),
> +	       *  - stripen is the disk number (0 for A1,Q2,P3, 1 for B1...),

s/disk number/disk number in a row/

> +	       *  - off is the logical address to read
> +	       *  - chunk_stripe_length is the size of a block (typically 64k),

s/a block/a stripe/

> +	       *  - nstripes is the number of disks,

s/number of disks/number of disks in a row/

I miss the description of nparities here...

> +	       *  - low is the offset of the data inside a stripe,
> +	       *  - stripe_offset is the disk offset,

s/the disk offset/the data offset in an array/?

> +	       *  - csize is the "potential" data to read. It will be reduced to
> +	       *    size if the latter is smaller.
> +	       */
> +	      block_nr = grub_divmod64 (off, chunk_stripe_length, &low);
> +
> +	      /*
> +	       * stripen is computed without the parities (0 for A1, A2, A3...
> +	       * 1 for B1, B2...).
> +	       */
> +	      high = grub_divmod64 (block_nr, nstripes - nparities, &stripen);

This is clear...

> +	      /*
> +	       * stripen is recomputed considering the parities (0 for A1, 1 for
> +	       * A2, 2 for A3....).
> +	       */
> +	      grub_divmod64 (high + stripen, nstripes, &stripen);

... but this looks strange... You add disk number to row number. Hmmm...
It looks that it works but this is not obvious at first sight. Could you
explain that?

> +	      stripe_offset = low + chunk_stripe_length * high;
> +	      csize = chunk_stripe_length - low;
> +
>  	      break;
>  	    }
>  	  default:

Daniel
