Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0245F371CEE
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 06:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781073144; cv=pass; b=cImqVrLAQ2OYbyfoPR+UTNHONo0AmnuZEgPT+1c1OD99q3hYXBY7ogq7Vo4RAglzZrYLTPI0xZD77EiOo42NeSqBmJh1D7GQNH/ayd2SywYBy/AuuF4D7Whn893c/Ye7b2E4Jnmz9rUvlHHTNfuq/REvxYZE+ZMYWW+hGzmL/M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781073144; c=relaxed/simple;
	bh=68w4doxNVLOC62ECpJcBwBnh0iaBGHwjlMP+I9eqIu8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g2nmdZNnFkpAcuiZxYMHUAcRtFk6MtFjK+5ECdpjGTetvL+Oxlaol+mUkcPVc3XHxspWq/moayixQ6USvy9UEPZhZTzWVsbcHxCCi3aBpaFf7+OCa0rmB4/mWo4PuB1LWHT5T3BRnp/I15P1jJiU/c9JR16fZs4dvhL6Lvfv6FQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmbTyFWD; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmbTyFWD"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-660e9ea26b9so6543606d50.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 23:32:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781073142; cv=none;
        d=google.com; s=arc-20240605;
        b=NZlrZuZjH+ckwGZ5cAs+F+mUWLRbFM4oiNQ18n+d+TTrBEk6kwLdvkUIxUIy7Ds/GZ
         q44WERPbwZr9iVjLAKn/e0HmSZyl16LpWdDh1rkwQiDsMfSCdUatKuNXqtZFdNg+uZ9v
         +/Z9yqSibpM9+DinAY4e7X5cVdIFOQEUR9ER5rOsfAz2QNFPFF0Yv4Qac5clfTWrLiJy
         kH8ASYskjwhPDNuABfsGIac20M1BIB4nEZAF07ycFuOHnJrDFgSwg3PXL4zpoCYaalkz
         O85zzJv6YRwqlrWAx0Auh6INaw0Ygx9MNI/QSu4dYjWwSRpmW1K0wLjhvkoF5uf/RK+j
         ZYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uBuQLhfrvpn8CFIggJgyRg7UJ1iMTmBuBrOsajhGSeo=;
        fh=MoAe/vdD/Mfr1xtC+Blbb9qnnCuLl3seJ8QO3sQIHlc=;
        b=CK8bWW3XpMJUftNxtSnCVKL+aqJTllr4UF1MzX4+Ux2YnbWQ/pUctomHyMhCPPTGd/
         Vb6Rp/NOCumM+q+ylEuJDhjJ1Z/aWc2zjE2Xg2fx5oFU8D5tmyMceAEAg/3n+f7bHnjC
         RrIC/ZuK9/Xz7iqRJMW67UqGIaoIx/dMaA8x6LYGQEcDw/wbmZQaaoCbY5ALqlwPIG5I
         DytzULsMzzxUWPh/FagLkGsFnLnZMy5dAu43hfcu/rh9jCaLfriSiZo8ZK3slDoqbg8I
         S1fBySVjlS1guMDv7wb8deckMenaWQJaEod5ljSxvZ1Cp/xGb+GPPEBJqVdPPWcCCGf6
         P0Uw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781073142; x=1781677942; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uBuQLhfrvpn8CFIggJgyRg7UJ1iMTmBuBrOsajhGSeo=;
        b=dmbTyFWDwa8ANXBgFnlyZ6hots4F1i2J2qsr18BqexZLyxktkq65f1vaG3Y4W3YmsD
         XTwAP6slwB1iRU1kp6+gPtikww8NSift2zYpO3wCyfDwKPuGcSygkhIeoTx8Spv+krZU
         QtMvx/Mvb3rJqG9uEoP9p6yGgwdsSPRYVo5105dh34j+Alq0HmjsBcoHPG8OMzsPCoHI
         LJf22vnR+vxFLSYB7m/40i8GMLAd2PT3AHAp0z1D2TMGJoVZe1iuCFgAqy46YSUb8CaR
         HOHz2MfCMS0fl8GBAlavdKW23tGdmwL+Ar5v3JqyheIC9cFdKLROFZ7Sp9+hA02qyCT6
         MFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781073142; x=1781677942;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uBuQLhfrvpn8CFIggJgyRg7UJ1iMTmBuBrOsajhGSeo=;
        b=Pfw7GKmLI582T1dKXgWtctWoztp4kL6z1tjc8j/cFidUn9b0V1ggngUyVbU61wZXpo
         Ewpl5afsi3i9lhqgczGIyoM7Y5Qxw3zhjiQWdMPjBi9xakMB75RV/Qiiab7mDq6umWEG
         pk1dvBbXsUpbw2IrcB2O//wnlJLU7vYdhgd0ZWtv6eVg4LtryL2MbZ0ujWwAj/Ydbwzx
         +GZfbAc9+T56aAHqOlO6yPa8ZQzVkHJL/zDW9IpXXoHAe4LdFm19EdU4nGD0L8cH3VaI
         BKNFLe6+wIkvqDeVjf8YSgxLQTp7if1RQp8z+FmfcpTtwOgZ/+zJrO65SlWOUzgTq+k8
         0yOA==
X-Forwarded-Encrypted: i=1; AFNElJ+qaeZO+/4QJ0nHJNIKe4t7UkwvQB57sg0DvzNn6l9/kh6jsODX3VpMrjh2ZER/pL7h6zM6sUbpcJNDLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrYFGwv0Lj+lpIYFog4GGnuTl3B8VY2tA/Rb3UojDYaCS2cuuF
	LFAw6gmbaK2JlC9DUcingCF7K5f2dSbHB2MkAOsodSVbvsEqjQH1G80yvohLs3pWwPs8UN6HRrj
	j91Zs8dI+pje3tPpHf8Xqj2ss/g8/ZB4=
X-Gm-Gg: Acq92OF9HKgFU+VD/kv+9lvGPvlpT16zJXH4/sK/cIznpjHWby34vsCVGwLwW2C6KVt
	AEqLE+KH+Kni3IbZF+oM19TU+aV01trogg9x/c6c84DiESJjYjX/M3v5p5uXXayYeK3Poixi1fX
	dKzbsCpYuY2P7C9yzK9pf8/PphfmtAGVRV9Axzyq3YtfyfHQqZ9sXuy4+QuNLTV+qdmDbRdxcJ3
	hWbUU8zRZ7YjcPEO83boRkwWS2OaoOEwT9rC1yTsDTapcV0e8PgUHuK8D0zWIIeCziK1ebeRctX
	8g8XJoaT88VBcWC4jHcjieo7IQo3lw==
X-Received: by 2002:a05:690e:d46:b0:660:82bb:e9db with SMTP id
 956f58d0204a3-66106f3b58cmr18664958d50.40.1781073142048; Tue, 09 Jun 2026
 23:32:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609152015.1586599-1-lgs201920130244@gmail.com> <0820a329-0f33-4f23-83b0-a4b849e9ae1d@wdc.com>
In-Reply-To: <0820a329-0f33-4f23-83b0-a4b849e9ae1d@wdc.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 10 Jun 2026 14:32:08 +0800
X-Gm-Features: AVVi8CeBUhxsP08qskJxkbft9I2y0DHdNABBHd-2tU_NPPh8QiN2XXzItQxqxFE
Message-ID: <CANUHTR8fbvA=Adwh+BPRj3rc7+BY9vysc_ofSdjT7du+GBg6MQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix zoned sub_group leak on space_info sysfs failure
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

Thank you for the review.

On Wed, 10 Jun 2026 at 01:04, Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> On 6/9/26 5:20 PM, Guangshuo Li wrote:
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 0d14570c8bc2..ce1109e47cc7 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -1885,6 +1885,22 @@ void btrfs_sysfs_remove_space_info(struct btrfs_space_info *space_info)
> >   {
> >       int i;
> >
> > +     for (i = 0; i < ARRAY_SIZE(space_info->sub_group); i++) {
> > +             struct btrfs_space_info *sub_group;
> > +
> > +             sub_group = space_info->sub_group[i];
> > +             if (!sub_group)
> > +                     continue;
>
> I think you can break here instead of continue. space_info->sub_group is
> not expected to have holes.
>
>
> > +
> > +             /*
> > +              * Remove sub-groups before removing their parent space_info.
> > +              * Clear the pointer first so recursive removal cannot leave a
> > +              * stale child pointer behind.
> > +              */
> > +             space_info->sub_group[i] = NULL;
> > +             btrfs_sysfs_remove_space_info(sub_group);
>
> That comment IMHO doesn't add any value.
>
>
>

I agree, sub_group[] is not expected to have holes, so using break here
is better than continue. I will also drop the comment as suggested.

I will send a v3 with these changes.

Thanks,
Guangshuo
