Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792500634;
	b=hWAjAp8uKYhgwISnJYtNL0O+8Wk/1lf+rHMrcU/T1YLi/+yD2u9qFiYFs8tlQL1QXPRG
	 9bl2G8X89fvHnvTxz8Ry3X2pcFslvuWNi2qI2/n5q0grrbXKMm0uZIm4Z5K+Y2Y8vu3d0
	 9M+JPZG/yiY5K7pgQQgT33O5Cx5ptN+E+rIn67fbDlufYPSFCwizNQmv9xRP1IA+NeAiI
	 2EoRhd0V/GyCm+/ElxFalVlrQ7lw2H72S1PWzypM01bGqhmujwiCiUf6kYu2vr/x3BezA
	 G7IGTLMIxXFgpPrLFke3h/xfACFfDpg/5aXQfbuDpuwyxpy8Q6089QZvQpSLKDOHNLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500634;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=GNsw7v6W2tcQLqum+lnlv6NZVJmhrDudSVHjIuOYR2E=;
	b=17Oc47RjWdUiXRN+EmjRygtkb6rjqe+Jo4L5w5h0qeP6p10oePrY71xDkRbUFEriUvW3
	 cUJ6MeMsYZK4JuZkuAuuZlZw4mWNJmxkz4pt26eBiuU4msgNby+5dh/BHqZGVn3pURO5y
	 AabbK5yY9LlGYUAdoDlhfKPmzf8SCziGV2yURzOKGViyOIjmyxoG/Mol/QYQlO+npJpPo
	 RKBG4/m9eRTLUTNXw7rjMsvI2WjqqM4FXX2r8ZFUqV6+8+4fElzgd3GFW6YfGpwzTrqqp
	 MfPi7cWW57vtDVazcOREpy+YgdfqRBd6Oim9Hk2xP16/lU9X/BxatTVklID9D+Am7Nw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Rvc5zDnO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD63606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 12:50:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DD63606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Rvc5zDnO
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so30412915e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 05:50:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792500632; cv=none;
        d=google.com; s=arc-20260327;
        b=CB7Qnq1bsjHEyu3OLYjE42ejj0v0KM8dhQ0uCo9/aJBZPzynASMaolU9Y3icpFn319
         Eyy/Ly9jYpTjX2T4/n0ZBPV9RMJUTYKsmtNZul6B2bsrFTdg1wpXtu9PCgbpP87yVXbO
         ce2M7VHZR+1Symipv2Jp4gQMBkzSCYhwTPGq4pr6XMOFF3cc+Oavsx4all4eea6FitZ/
         pRr1ioQyrY9rfEN/suNMA+S5ztpfpLl5Q7ppHzLKNsgHKcyO+qTdUJCx5vkNag8uJePX
         xFlLiO+X6Vp5oeA/w35Mvb5CdiNUt4bJHs3tSrTUx4MqJM9BiAXH4F/av9y4FKLgy0zo
         52KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GNsw7v6W2tcQLqum+lnlv6NZVJmhrDudSVHjIuOYR2E=;
        fh=DNhRoUogv4njemsTPAOB4Tb4wfg3Mu7IYlLDA9H4+4Y=;
        b=WZl8UKdYAZPUmJ4NZd2+a5JcHm3SjNUoWtFUET+NEPcyxN4IZ/Yur1HbrAfc0W2pqK
         fHGpin4/cjGyl3egU+IcoIdFN2Ff9JAyLeEqGGg2/7qfl/LESS0WwI1rluKBodXHU+Fv
         1ZBWLWtbTBuLn9lNB77IWSdkBcrTl5t4ero2vHFyfxEVWzg8O7+19T/YSSSMThKtwXWD
         tEUXxeitBOfr3alzFIFzm7BcVvvnbZC71vj6WfrNvjYQSQ37h0+axw74g1tLfDRGrVlB
         nGn10bSWbMUDzfEmD0Z6Cg7g3xWyKWRYrVDQP+ixQzJcCy9pKzThsQtolQmoSrfEuHQD
         eR6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792500632; x=1793105432; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GNsw7v6W2tcQLqum+lnlv6NZVJmhrDudSVHjIuOYR2E=;
        b=Rvc5zDnOvFdzOtEgORoq/0FcBZHRO4AEItW5/zWlwt7TFxk4olqmkt2X5yTcA+CXxA
         IS1YZZqfOf5Wx1MXIGyFIoTmRhvC1+CkHw6ZpyIW1/C7A16ofUUsBqzA1u/AFwYiuZIF
         csMD4rDp7Y9R9zOi3TVozt9mDMmI9DL9hVuE6offjlUrZ7jFZ7N+hb87hy87LFnYRpds
         6zEbat6kpOjxmbkZtOx3svrkUV64181j9lKtKa8FraaKRwT609Bfsb9B7AApSaRUxjBd
         w3hh7it53qYlFH3Zi1bYZwC6GuLPYEgv5eu+pfqSJ8SANWi8NaURILv0t73LsFKrNzqE
         B7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792500632; x=1793105432;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GNsw7v6W2tcQLqum+lnlv6NZVJmhrDudSVHjIuOYR2E=;
        b=lwu78LNFRhoK+4MIhW4PQPutI5PrFDuWtVA2U8OTad6ha5Up/pPuLOGGQ7T/f/CeuX
         67wKzaM1aNK5rx8mqkNIkrF/ozLPejxx1Fc2zBHPXWoPIg/DAdbezvhGVDgWxxU1DZNE
         CzrVwn/RF1KJtf2abucc7H+szItPKuCZRZnMvMWnvk0oEmMmiw0vYs0lmwi7Q2y6m8ny
         NgzuZ96Zo+K+IO5CMQlcrhPCnt6Co8yhk3uYPYV8SqrGDdHLAN3JEOlJcdJ0tGYu54PB
         wBgLW+l2Ogs7Er58Gjn+/X8/dH8VEd91n3oaWixdI9B1suBz0WbKi89T8/k8fnfow/kC
         poKg==
X-Gm-Message-State: AFq9FYKsB17CrMRxp94FDzisBa8pY9k3DdBuV1F5Im68+UY/Nd1LdbTW
	MyXiCZ3HZYUEi/jpxJA0KF5oQLn2NbR90C5iwbGCzDxEztXtKA6J3u74C8en/NrLZ/DLYtHAAMS
	b6sHYGqfMj52giVvXzm9rml3icEa1cUZoI4eKpcE2lmFfItiOdLi7JlaRNg==
X-Gm-Gg: AYBFou2FXmKOhTjlInne+1NLMUh+ZYby2pDuHonxoCT5ALAUxxQbTq/f3RyCMK0bpIH
	kHLLtAv3CLvE9xeVfOdRVV/QDi0MYhDWEDMs6FoAZgjGrvjYIj0+pI9c1me9ZRe+SIJ/9vcp4wp
	ZcqSrQnHTFQ/dlOXZO7t/4BXGDCg1baLz2up+DMo2IsfTKswgs6oiHR0Npo4aNEr8N8AlcmWXKl
	IJ5W5ctp2rtFKpsTfAPRoDgduIJvkZb5u4q7z2bs2V/aAbyCGZwbTVCk6MdU6N4hjswfP/La9q9
	HorAAH9zjVOOhpYyeMcORYazReVaP107m0BRurDEbjmdzpUEt7WWsVY3Ww8M9jITXzhFRj0vqWq
	2tW1QY8ksNX3kW+SjkSVbkW8qwwHBOkTKO7Sygr8oXyVwgQXXG5T6
X-Received: by 2002:a05:600c:1909:b0:4a1:dbdd:d56b with SMTP id
 5b1f17b1804b1-4a1dbddd68emr219141835e9.19.1792500631821; Tue, 20 Oct 2026
 05:50:31 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com> <20261002073715.2191177-2-johannes.thumshirn@wdc.com>
In-Reply-To: <20261002073715.2191177-2-johannes.thumshirn@wdc.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 20 Oct 2026 14:50:19 +0200
X-Gm-Features: AclHuK-bRYfZNQ22wiwQMU2O8iGkUJic02LdUzkcTS3xHgwbgiMZF5QCGy6SvPc
Message-ID: <CAPjX3Fc37rdefgPUS1pwWMK9gMUEeoydc++TPZH3jKvGWDYVMQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] btrfs: zoned: only change active zone counter on
 successful (de)activation
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 2 Oct 2026 at 09:38, Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
> btrfs_zone_activate() unconditionally decrements the reserved_active_zones
> counter regardless if btrfs_dev_set_active_zone() fails to set the zone
> active, i.e. because it raced with another call that already set the bit
> in the bitmask, or not.
>
> This can lead to a double decrement of the counter in case the bit has
> already been set.
>
> Only decrement the counter *iff* btrfs_dev_set_active_zone() successfully
> marked the zone in the bitmap.
>
> Mirror this behaviour when clearing the bit again.
>
> Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

LGTM, with one nic below

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/zoned.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 9f562cc34e38..d68b91008e76 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1126,11 +1126,13 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
>         return pos;
>  }
>
> -static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
> +static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos, bool *new)
>  {
>         struct btrfs_zoned_device_info *zone_info = device->zone_info;
>         unsigned int zno = (pos >> zone_info->zone_size_shift);
>
> +       *new = false;
> +
>         /* We can use any number of zones */
>         if (zone_info->max_active_zones == 0)
>                 return true;
> @@ -1142,23 +1144,30 @@ static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
>                 if (test_and_set_bit(zno, zone_info->active_zones)) {
>                         /* Someone already set the bit */
>                         atomic_inc(&zone_info->active_zones_left);
> +               } else {
> +                       *new = true;
>                 }
>         }
>
>         return true;
>  }
>
> -static void btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
> +static bool btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
>  {
>         struct btrfs_zoned_device_info *zone_info = device->zone_info;
>         unsigned int zno = (pos >> zone_info->zone_size_shift);
>
> +

A stray line?

>         /* We can use any number of zones */
>         if (zone_info->max_active_zones == 0)
> -               return;
> +               return false;
>
> -       if (test_and_clear_bit(zno, zone_info->active_zones))
> +       if (test_and_clear_bit(zno, zone_info->active_zones)) {
>                 atomic_inc(&zone_info->active_zones_left);
> +               return true;
> +       }
> +
> +       return false;
>  }
>
>  int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
> @@ -2411,6 +2420,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
>         u64 physical;
>         const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
>         bool ret;
> +       bool new;
>         int i;
>
>         if (!btrfs_is_zoned(block_group->fs_info))
> @@ -2464,12 +2474,12 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
>                         goto out_unlock;
>                 }
>
> -               if (!btrfs_dev_set_active_zone(device, physical)) {
> +               if (!btrfs_dev_set_active_zone(device, physical, &new)) {
>                         /* Cannot activate the zone */
>                         ret = false;
>                         goto out_unlock;
>                 }
> -               if (!is_data)
> +               if (!is_data && new)
>                         zinfo->reserved_active_zones--;
>         }
>
> @@ -2516,6 +2526,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
>         struct btrfs_device *device = stripe->dev;
>         const u64 physical = stripe->physical;
>         struct btrfs_zoned_device_info *zinfo = device->zone_info;
> +       bool cleared;
>         int ret;
>
>         if (!device->bdev)
> @@ -2537,9 +2548,9 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
>                         return ret;
>         }
>
> -       if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
> +       cleared = btrfs_dev_clear_active_zone(device, physical);
> +       if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
>                 zinfo->reserved_active_zones++;
> -       btrfs_dev_clear_active_zone(device, physical);
>
>         return 0;
>  }
> --
> 2.55.0
>
>
