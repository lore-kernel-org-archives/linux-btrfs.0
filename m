Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DB946AF00
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 15:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781017582; cv=pass; b=FGYtUlyHcvST+clcsaA15XbqPx9KgGlhNECTQ2OTAztSsHXZRgfwfHLi6bI98yT7hn74ZztZjUXm9omDSulyI3YA67HeBHDAdfHQ65q79wTBNAMMLxnMNPVG/yjYJJAPwVbBieSIUfs2ib48RSxTQFAS1i3m83XnBJFehcv2F40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781017582; c=relaxed/simple;
	bh=KIawsG2hBsJpQfgnoZ7tEpLVlIGRnLvqb6nrh5+a0ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LKFZ7tg8qqAfXWYgtI4QM8ngKsbUln9IPDVHL7+rf5PT4kTPvQFj8Yj/xCAiduRSHaS6DRNek4wgS5NVJ5xQfu40hKDWehjFPzLyRUBfg9P5FaGMqCMgwov+e81z3sZfMV73hxZQxuUdIIEhmMeFxjqkzjpfo7UgrLqvwc8wQr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UP+h7yLT; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UP+h7yLT"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-304f590dd91so6174238eec.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 08:06:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781017580; cv=none;
        d=google.com; s=arc-20240605;
        b=hllc33aJiSccpSctgwR7zjPsQqZ6Hik8ggJkOe930zogqdonN3/1CEDDgxu/NsM1ep
         jyXmUp184qrSfoUgJUserDhfXyy07MeFDhxLDnn2bICqx8Z5kttPPVlXtoaqo2tJuDkv
         RnJDKqRZLA/13HAf4BAUC4kHUHtDZEMz/sxx7tLTJUkAlo1+SB+0dONb20+LtZWvNPFa
         J5sY/6PPnpPUtO5Mto9dozhwfmLcW336UcIG1qgogwCOegEa9kSU+Zh1MtuF/9Fyw4Xk
         I7aLTZ0IYwKIiSzlRTcIyFdhhXM90sakJ5ZsgAlHxBGsTm0MR4dSAgej6EJUipQJyeIg
         3W3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1EmzkVfEtGS1lA4rV2+YC9qM03qMLzlB92/94lmWIqs=;
        fh=sb9FrIwXlWqSn5Lx+CcBjgSG4nw9snky/gEaCoGVX1c=;
        b=BfFySSVb4PNEPSp7m4o/YbmjIS8b56P8cGQEopfcbdBzQldmKxl0q7jwcXRKdRBaGm
         xM2yXrgTqgeclC5sdzQCj4Fgm4PAEKwhOzPPiX0+K+7wJcolIsw8h4QEfi9yRyl670Bj
         2DSq8YD69Ylw24STBxIsF2C/YYXPw9EhaHBnN6WFonD6hlx6OY8sC+phGPtnDubLsd0x
         vnVDM6l3lcsBZavn5WRbyd5oSx8+wCWVCFO8ZmiPNb4SPTo74jkBtW4aCt4OXrWK9SKx
         BL7Wk9H71EqjXJiuj4f9uK11ePOYTr9gMjfSbW6Zay7SC5lfeqJYzWGkXyzpqeFYOLNw
         pxXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781017580; x=1781622380; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1EmzkVfEtGS1lA4rV2+YC9qM03qMLzlB92/94lmWIqs=;
        b=UP+h7yLTcV38b8f5t1atx8LaKtcxBOo1//hFZNzShZJxBN095k099LL1KYWNV7ZTTZ
         fgK7c+XPBS7Vkqdtt7spxXbUUx8xsgheipor2yQyqVtIM53hHEiG8kIiASPaLvYvnvKk
         NsKCgyiHOX1H5sjPRVGK3xhNSz+oADz3PDDZomc1XWLRynL6k1sQNdGy45sQ3uvBx9KG
         sreTcSGc1xnjCWMQIp8GcWxtTr4zoahQjwRIsABvcMKgoGAVMfKwuV2MmKgHJY1LavXF
         x8yn4ZRYsrRzbEbm8lYyQQjPb2L/2MiHhP4SViOxDuiKCNO1xquBvXFIT+myGsWdBbhn
         o/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781017580; x=1781622380;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EmzkVfEtGS1lA4rV2+YC9qM03qMLzlB92/94lmWIqs=;
        b=hIubQG1WdC23+8niwdds8wocvb7WXJdGDddUoNTg2S/Ujsh90/hXx1ufcuBL6Wgab3
         e+NU+25bCIJkYl979Lu7E12n+jhS7VZEYFZhxeb12AFRYD93Qd86zKdeUR0/M5uv1xA0
         eo0BLaq/fbKAES+s1Zf04lXEohawL29RrRgdhdlURQ57GjIeP48LozRe8xt8AtbB6ZDk
         Eiv/N5VtmYktRyC84AVo1vU64VTn07EUhTZRA89YPAWAzo5yJQreyQ7bVUS44CD6pF8w
         NVTRJf+j3/ZHhtzkhiakN+9ddSxFetDxPgmCrP3LNQiiTWTVa0McYApX+sdLvuAkapzK
         8+Kg==
X-Forwarded-Encrypted: i=1; AFNElJ/vwwSh9lnKL4PcK0ZPt6pIlwtTlX03knd0JmL2WQ0lI+XWgsc7B1bOkijvEtZsXXR3ysccce1wnV3Huw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwH1JPER0uvGQQaXF3BFefsB6GGNhw/8awhRPbPGCP/HAZeGYKJ
	L2HZCTVoLkKtMDJ+ClqgT41SeapWvAZ7gKBEHmKcree3Hfd51pJ08L3V81wHoGRkNLbtWwBuj0+
	X+SEhmwUvBrVS2CsCT01jBw4if4yVrko=
X-Gm-Gg: Acq92OHiO7sMp5YhyVJVDxmtN7zLsg4+oXmqH/XDBfWgzK/a4xLAy/nF2hDobv4tXf7
	NJOIgsLFKqHNTqCG4UYJTIq4Wctf1B98VKOvubsbwReyAI4zrGcgqiGSxcVIj1M76BILZDNeqzu
	qJOhUHG4vgZbiInxoBeozpxT4Y3eDsx6UZjiHxaJEmEuEbRYt6MwDkm4ly+hYh6p9B0H2k1d568
	tzLQwBTHEXbm3nPgraQGl2p88xb1PHLzHkj4y2jHaehUfriwPt9m0VYSYOTmRBaoHdo5qwVWdes
	EuOX0VLNEZteSQOnUJM=
X-Received: by 2002:a05:7300:748f:b0:304:29dd:70b6 with SMTP id
 5a478bee46e88-3077b4004a0mr11910298eec.13.1781017579677; Tue, 09 Jun 2026
 08:06:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260604121043.1425201-1-lgs201920130244@gmail.com> <DJ0RAMUVW89X.C3T31TKENNYN@wdc.com>
In-Reply-To: <DJ0RAMUVW89X.C3T31TKENNYN@wdc.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 9 Jun 2026 23:06:05 +0800
X-Gm-Features: AVVi8CdVJXmaC85QgrOIJaWgbpj1CWCCDkCXEvEs9RdmEmj82h88ZTwFygF-tSo
Message-ID: <CANUHTR8JifnJgdUU17Et0ugLZ6RiN1NSnLpE7JV5+eJnWk+9FQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix zoned sub_group leak on space_info sysfs failure
To: Naohiro Aota <Naohiro.Aota@wdc.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Naohiro,

Thank you for your review and suggestion.

On Fri, 5 Jun 2026 at 10:22, Naohiro Aota <Naohiro.Aota@wdc.com> wrote:
>
> On Thu Jun 4, 2026 at 9:10 PM JST, Guangshuo Li wrote:
> > On zoned filesystems, create_space_info() creates a space_info sub_group
> > before registering the parent space_info in sysfs.
> >
> > If the sub_group registration succeeds but the parent
> > btrfs_sysfs_add_space_info_type() call fails, the parent space_info is
> > released through its kobject release path, but the already published
> > sub_group is left behind. The sub_group also keeps its logical parent
> > pointer, which then points at freed memory.
> >
> > Remember the created sub_group before registering the parent and remove it
> > when parent sysfs registration fails. Cache the sub_group pointer before
> > calling btrfs_sysfs_add_space_info_type(), as that helper may already have
> > put and released the parent on failure.
>
> Thank you for the patch. The logic itself is correct, but I think there
> is a better alternative. My suggestion is making
> btrfs_sysfs_remove_space_info() responsible for removing sub-groups (if
> any) first.
>
> With that change, we can reverse the space-info creation order in
> create_space_info(). If the parent space-info registration fails, no
> sub-groups exist yet, so nothing extra needs to be cleaned up. If
> sub-group creation fails, we can call btrfs_sysfs_remove_space_info() on
> the parent to clean everything up.
>
> This change also has a side benefit. Currently,
> check_removing_space_info() is also removing sub-groups, which
> contradicts its name. We can remove those
> btrfs_sysfs_remove_space_info() calls for sub-groups from the function,
> making it a pure checker.
>
> >
> > Fixes: f92ee31e031c7 ("btrfs: introduce btrfs_space_info sub-group")
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >  fs/btrfs/space-info.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> > index f0436eea1544..03659dfcb830 100644
> > --- a/fs/btrfs/space-info.c
> > +++ b/fs/btrfs/space-info.c
> > @@ -296,6 +296,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
> >  {
> >
> >       struct btrfs_space_info *space_info;
> > +     struct btrfs_space_info *sub_group = NULL;
> >       int ret = 0;
> >
> >       space_info = kzalloc_obj(*space_info, GFP_NOFS);
> > @@ -316,11 +317,15 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
> >
> >               if (ret)
> >                       goto out_free;
> > +             sub_group = space_info->sub_group[0];
> >       }
> >
> >       ret = btrfs_sysfs_add_space_info_type(space_info);
> > -     if (ret)
> > +     if (ret) {
> > +             if (sub_group)
> > +                     btrfs_sysfs_remove_space_info(sub_group);
> >               return ret;
> > +     }
> >
> >       list_add(&space_info->list, &info->space_info);
> >       if (flags & BTRFS_BLOCK_GROUP_DATA)
>

I agree that making btrfs_sysfs_remove_space_info() responsible for
removing sub-groups first is a cleaner approach. It also makes sense to
register the parent space_info before creating the zoned sub-groups, so
the error paths can be handled by the common removal helper.

I will update the patch accordingly and send a v2.

Thanks,
Guangshuo
