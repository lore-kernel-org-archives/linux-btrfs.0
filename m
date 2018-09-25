Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42A3C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 19:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75356206B8
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 19:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75356206B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbeIZBUH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 21:20:07 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52778 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbeIZBUH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 21:20:07 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1871084AbeIYTKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 21:10:32 +0200
Date:   Tue, 25 Sep 2018 21:10:32 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 7/9] btrfs: Add support for recovery for a RAID 5 btrfs profiles.
Message-ID: <20180925191032.GD30715@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-8-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180919184040.22540-8-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 19, 2018 at 08:40:38PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Add support for recovery for a RAID 5 btrfs profile. In addition
> it is added some code as preparatory work for RAID 6 recovery code.
>
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  grub-core/fs/btrfs.c | 169 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 164 insertions(+), 5 deletions(-)
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index 5c1ebae77..55a7eeffc 100644
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
> @@ -665,6 +666,148 @@ btrfs_read_from_chunk (struct grub_btrfs_data *data,
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
> +  i = 0;
> +  while (buffers[i].data_is_valid && i < nstripes)
> +    ++i;

for (i = 0; buffers[i].data_is_valid && i < nstripes; i++);

> +  if (i == nstripes)
> +    {
> +      grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
> +      return;
> +    }
> +
> +  grub_dprintf ("btrfs", "rebuilding RAID 5 stripe #%" PRIuGRUB_UINT64_T "\n",
> +	        i);

One line here please.

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
> +    }

Hmmm... I think that this function can be simpler. You can drop first
while/for and "if (i == nstripes)". Then here:

if (first) {
  grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");

Am I right?

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
> +  grub_err_t ret = GRUB_ERR_NONE;

s/GRUB_ERR_NONE/GRUB_ERR_OUT_OF_MEMORY/ and then you can drop at
least two relevant assigments and some curly brackets. Of course
before cleanup label you have to add ret = GRUB_ERR_NONE.

> +  grub_uint64_t i, failed_devices;
> +
> +  buffers = grub_zalloc (sizeof(*buffers) * nstripes);
> +  if (!buffers)
> +    {
> +      ret = GRUB_ERR_OUT_OF_MEMORY;
> +      goto cleanup;
> +    }
> +
> +  for (i = 0; i < nstripes; i++)
> +    {
> +      buffers[i].buf = grub_zalloc (csize);
> +      if (!buffers[i].buf)
> +	{
> +	  ret = GRUB_ERR_OUT_OF_MEMORY;
> +	  goto cleanup;
> +	}
> +    }
> +
> +  for (failed_devices = 0, i = 0; i < nstripes; i++)
> +    {
> +      struct grub_btrfs_chunk_stripe *stripe;
> +      grub_disk_addr_t paddr;
> +      grub_device_t dev;
> +      grub_err_t err2;

s/err2/err/?

> +
> +      stripe = (struct grub_btrfs_chunk_stripe *) (chunk + 1);
> +      stripe += i;

Why not stripe = ((struct grub_btrfs_chunk_stripe *) (chunk + 1)) + i;?

Daniel
