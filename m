Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEB74CEE4D
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771345; cv=pass; b=IhM6MFdRm/dt+JLEkbz0PLfyhs8oI7Msz2jkpha7yWojc9z3jX6uEwvZ/2oWhQeNnXM5uKpl/Yk23lsSApbdA/AMHYVJQuNi/gNyo27Mj1jUBprEWdM29m9SboccEbwLhkIuxSlqFjJQ/3yUgBBvPPNj3a2C+alcqJh3qgUYNTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771345; c=relaxed/simple;
	bh=m478kFP+nf4kBoRucOq4/8H+Rs2m3iv3Fo1tYmV3TTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KuIsq2Np4Es/b+Ya9uBPFzardqmDdm+/ZdwtjJoWRgUkC10nDYyST5mqvT81H8LBe4C2w4vQQnEA5SaxTXv0KBNRuclPmVN2AjqwijfPlZankfOzKjFmBZmjtyBfE+PaAsutJVTmTKLZ6JfPY3aWXvUPw8XSmFYI3X3cFKGpJWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fdpULLdE; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fdpULLdE"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d391aso40299665e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 05:29:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790771339; cv=none;
        d=google.com; s=arc-20260327;
        b=AAiX7/sLXky7qZAZlslthZlgIxlYfO8W+UZNnHr6m++8hdCaslkIlDuagVpNwfNXwm
         J6vWkF9Ydb2DBwSnE22R19xzUgEz+PWMjNlnofii/0SqQ+nEjmcAX26IbaFkCaQjPwMf
         iZhuUhU03fcBuu/AeL3y0KKHZoOiR06gL2cP32elsujLyp3/yix7ma0bnNN7h/+TDX+t
         nVv7yQ6DUmjsWwjpKkI1kcv+AFYuo3N0EofAYHHGfBi8DXUCj3jCGCDinMs+HAr3xuIC
         zwDprI8oekzON6vuBRkx7hqt3vUKFqKnWlcDPtE1k/cakzNirV3aP72GBHiDEbJBvNS8
         T5gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Oc1k3Z5WZVYZfjHfMlGFGik5mt6cfOcVLEe2vnSFnDA=;
        fh=DNhRoUogv4njemsTPAOB4Tb4wfg3Mu7IYlLDA9H4+4Y=;
        b=cBZFtT4n3wSPgReKF6qekGIDCQ+fZsj6wuUJNhZoH0L+uSOyZgwOLeXEMPiVXBK5Ub
         TT3/qECGrlxKg6a/hDeWa+OSWvlSK6GooF4sv9lznkOzm5PIYnvTFCCr7OmqPJR5wyhv
         RgDIfN7tmP3TPAPr4osX+21HflC93zBnvSB4BldgYXE3ylkKqc/2cnSng2kt6oKb651b
         a9QBykFtBk6puWbmEHvTAkKiLbM0aM3HHzidTaIX5nxcXxRghDQb9Sjxk2aYLVVqX86G
         wlTdyvG9s/TY0XcKO4FciTpZGmmwcMOCf+RAEDa6+JsaLSjMuHAkNMCO4mP35xsXUIFt
         afcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790771339; x=1791376139; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oc1k3Z5WZVYZfjHfMlGFGik5mt6cfOcVLEe2vnSFnDA=;
        b=fdpULLdE5eq8T9sXadMyZcwSFxdNhlwiemyy9bij/uJJ2v3DSsnGuerfMri3VBIm1Z
         qRe3i+GnwL/+g9Y6ibzvVAcNwa+3tLysArd6VAn4RaGzog0cOyJ7O7crzBjTMYySnD/E
         G5KmCCzdu1NoubNjwXJYeKLmsXutSa3g1qMbf8a5pgO1tM5IHX5lfA9PyAb3/oizQnC8
         MG4g+sO3HJdBr0pIJ1UOFHBWuPO82hj4AbD3E8OBFi/lOW3PYCDMl4ve5EGYlcN4+FRT
         bEs4Tr6hHQGErHmDMHwsC9dVgXGjR0SbKW9ifNTjV2IXJKOG6KDNidAySc0O5Q0aeB8v
         h04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790771339; x=1791376139;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Oc1k3Z5WZVYZfjHfMlGFGik5mt6cfOcVLEe2vnSFnDA=;
        b=mEmz86Yy5VGZXGnskN6D8Tp3wQSZ/oI7Lw2a8wleGYW0UqRBBeEydiiEeNkg+I5YLp
         mvrOQC/U690+W58laK67CzymisvjTTzy3R7bx72FoRT6E9FF76x5DfJBB5p2ECj8PaaM
         XZ6rCdiUmKPaeiiyEbanZJR4EnvrSOyRud0J9JN6auEKYcGENh9wWU6XuJ4RWmPoQbA/
         Uj2DlpXHgvuchSzdfpgw2g4mNwf80ttfyKCM70t7Xk7co/bhkgZgDhRl0x1duqjZKRmZ
         iyQLzpI1uhZdk1YOPKtXIse57/uW0qn40YITpb2PyNmiOlaXaW9ETBePcMuFr+iZQ6TY
         cnGw==
X-Gm-Message-State: AFuF++mq1rP1doxKVowVddZvsfqNLcJMHdER/eRkyUGQ0jKNXhYoEk0W
	bjdwkpY2uwV9/2KfnsU7EIIRbTB7o552IDQRNNBUrbr343Q5iuBOR+w7kLGS5VulPrKl6GmxuWp
	yGoUod4Odbfm9QtHqVzy5OmhZ7KB1HEGYfv723B//mA==
X-Gm-Gg: AYBFou1sv/OH0NSA1evIx6f+LEnybuieW9W9zQgK84WCkHMEVT4TrhyNOZr/cCvc4Eb
	edwDRSklpMJRqQVYrKfzgh2A3sdjYr+UhOeytmZmtSx7NYglY4h5EZjWsItHxMWrpZ0qVYPMaUd
	/CW/dcMYTLaEauiGESTX8tRGAx+aeViIS/9dN9e1Sh5iR4ccnbhhAc6Kt80nxf8e816efJPBizD
	YIsGBr0NbYmRxPgotTasaCpylOORmuJigDIo5GMynlJY073+tG3fdkFojTkJ4V93iOgbsLzGreE
	vFvJ0RGThAHto0MwCmfE5Izbvj+HN96LkJky/4cahMKAZ7dWKPsCXQeOYBPqJNWZftXXD0BFvYV
	RE7ax1mP/OgdtjBWLZROLTaF4B+XuEtJ1CWXi9y4HGKU62ylK32vX
X-Received: by 2002:a05:600c:1c10:b0:4a0:168f:d962 with SMTP id
 5b1f17b1804b1-4a01ad8f2eamr26643895e9.3.1790771339506; Wed, 30 Sep 2026
 05:28:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260929140219.3412519-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260929140219.3412519-1-johannes.thumshirn@wdc.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 30 Sep 2026 14:28:47 +0200
X-Gm-Features: AclHuK_F4JxOyB3_tFi5errPGzvhHrZDZo6-QqeDT5xO6YzBxE3bpdpurYCs5NI
Message-ID: <CAPjX3FdHEN=3frHPtoENakrcPrtYzL8R7wPn+9noEG97Eibktg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Sept 2026 at 16:05, Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
> For DUP and RAID profiles with zones in a mismatching active state, i.e.
> due to one of the zones of the block-group being on a conventional
> zone, btrfs_zone_activate() has already put the block group on the list.
>
> This leads to a double list add and refcounting problems.
>
> Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
> Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

LGTM.

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/zoned.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index eefc283dfed0..dbb3ce626dba 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2024,10 +2024,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
>         if (!ret) {
>                 cache->meta_write_pointer = cache->alloc_offset + cache->start;
>                 if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
> -                       btrfs_get_block_group(cache);
>                         spin_lock(&fs_info->zone_active_bgs_lock);
> -                       list_add_tail(&cache->active_bg_list,
> -                                     &fs_info->zone_active_bgs);
> +                       if (list_empty(&cache->active_bg_list)) {
> +                               btrfs_get_block_group(cache);
> +                               list_add_tail(&cache->active_bg_list,
> +                                             &fs_info->zone_active_bgs);
> +                       }
>                         spin_unlock(&fs_info->zone_active_bgs_lock);
>                 }
>         } else {
> --
> 2.55.0
>
>
