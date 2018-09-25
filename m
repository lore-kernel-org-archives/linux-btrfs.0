Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AE7C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 17:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3FF20676
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 17:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD3FF20676
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbeIYXiR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 19:38:17 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52630 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbeIYXiQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 19:38:16 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1862235AbeIYR3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 19:29:31 +0200
Date:   Tue, 25 Sep 2018 19:29:31 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not found.
Message-ID: <20180925172931.GC30715@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-5-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180919184040.22540-5-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 19, 2018 at 08:40:35PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> If a device is not found, do not return immediately but
> record this failure by storing NULL in data->devices_attached[].

Still the same question: Where the store happens in the code?
I cannot find it in the patch below. This have to be clarified.

Daniel

> This way we avoid unnecessary devices rescan, and speedup the
> reads in case of a degraded array.
>
> Signed-off-by: Goffredo Baroncelli <kreikack@inwind.it>
> ---
>  grub-core/fs/btrfs.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index 0cdfaf7c0..6e42c33f6 100644
> --- a/grub-core/fs/btrfs.c
> +++ b/grub-core/fs/btrfs.c
> @@ -588,7 +588,7 @@ find_device_iter (const char *name, void *data)
>  }
>
>  static grub_device_t
> -find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
> +find_device (struct grub_btrfs_data *data, grub_uint64_t id)
>  {
>    struct find_device_ctx ctx = {
>      .data = data,
> @@ -600,12 +600,9 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
>    for (i = 0; i < data->n_devices_attached; i++)
>      if (id == data->devices_attached[i].id)
>        return data->devices_attached[i].dev;
> -  if (do_rescan)
> -    grub_device_iterate (find_device_iter, &ctx);
> -  if (!ctx.dev_found)
> -    {
> -      return NULL;
> -    }
> +
> +  grub_device_iterate (find_device_iter, &ctx);
> +
>    data->n_devices_attached++;
>    if (data->n_devices_attached > data->n_devices_allocated)
>      {
> @@ -617,7 +614,8 @@ find_device (struct grub_btrfs_data *data, grub_uint64_t id, int do_rescan)
>  			* sizeof (data->devices_attached[0]));
>        if (!data->devices_attached)
>  	{
> -	  grub_device_close (ctx.dev_found);
> +	  if (ctx.dev_found)
> +	    grub_device_close (ctx.dev_found);
>  	  data->devices_attached = tmp;
>  	  return NULL;
>  	}
> @@ -892,7 +890,7 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>  			      " for laddr 0x%" PRIxGRUB_UINT64_T "\n", paddr,
>  			      addr);
>
> -		dev = find_device (data, stripe->device_id, j);
> +		dev = find_device (data, stripe->device_id);
>  		if (!dev)
>  		  {
>  		    grub_dprintf ("btrfs",
> @@ -969,7 +967,8 @@ grub_btrfs_unmount (struct grub_btrfs_data *data)
>    unsigned i;
>    /* The device 0 is closed one layer upper.  */
>    for (i = 1; i < data->n_devices_attached; i++)
> -    grub_device_close (data->devices_attached[i].dev);
> +    if (data->devices_attached[i].dev)
> +        grub_device_close (data->devices_attached[i].dev);
>    grub_free (data->devices_attached);
>    grub_free (data->extent);
>    grub_free (data);
> --
> 2.19.0
>
