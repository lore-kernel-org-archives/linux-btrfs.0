Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794218495;
	b=bF0XcRNzwpGbikVS2FcKDnlUUmt6+BEWco+Wtb5Rq5I2BRpVaQdXVfxkHeatYULhgQwK
	 RW0zU6HJG1qFUrlIJ98g3lGXDRR4r2IQEPOKFVVqhUi+dq/fX40cScdvHtM5B7Jm/TxJa
	 dLTyCmRtXh/b3+OfvRp16iVExoMMNKMdM8pAvOudCAL5XjjM0nBi+fUoBIHl/VmtJvPXs
	 rvkVYSkBYK14O0N1RGCFEC65ECXdre5nOKhmf8lW4pHFtFVxb6bySnL5h4EGYg8X39sB6
	 Aah9fZhdNFb3yzjVGZEY6W7qp81BCnuMqDCfsR3GHIwpFJI2XO2tPUOQd7IOzw7/dNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794218495;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=cP0Sh9fVrhoHCwJkmU1UvdqhwH/KzQ99VzRLHD1elZ8=;
	b=z/IevCjMNSuuv6zyaMLd7OAZZRhgTJdVqGqECzrrQf+UipR3a7uiiszguPbbrceFlQKO
	 fl2RHXEzXf0qUeCqfdQp4RhBhUq6xlu0CtciaeYwfc0GqWKaJyuN+SYv8NJzn1TbkhQYu
	 /53/IaJgOb10/nW2IK3v68MFlfCxlP9nK/9s+NKjU/FNoDiSJpT9w29V8Ooj/FnztPo/t
	 4wdBQTP+qQiqU1MOqOdJB7olyRV5FGHJX9Xxcq6xjCUnfKEhA0kwQOxL8Fz7h8z2baKSY
	 XqN+TKVT7apafinDXS5fspieRmTCJSkFhPj7ZnhLkUPxXggbPkuM0tDQjhVFv4VrT/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ys9ZELoH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.179
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DD5606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 10:01:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95DD5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ys9ZELoH
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3a49a022221so5993751fa.3
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 02:01:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794218493; cv=none;
        d=google.com; s=arc-20260327;
        b=JeXWbQfvjPTBgkHCDWOf+xiRfk+qadEzJ5vGuV5VVvpdps9ZHOibzRecV56T6IpwUC
         QXM0ModzmawFNj4xjZ67OlIAD5N3hXS3tqB9rpKjfJERZNr87jYUzXlo0CZMFz6UVl05
         deMHh7t7/UzPt+kbBLfFp5veotgHTe0T+Hr+DcPg8djNyzMMC5hiIL9d+6aUARkk3M0X
         fCtOLSuE+5AdvlKG0dp3K+DnJ58fHPmqZJBpjkLf5zXTkupgSAYhWxMsUT0fMQZn+3ca
         9UxOp18SZCGfR70IaRG6u7IkEXsRi9KnNgdljBsJqqeDSzdJ+lIozgxX1re+gMXFNslG
         /b+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cP0Sh9fVrhoHCwJkmU1UvdqhwH/KzQ99VzRLHD1elZ8=;
        fh=jpgkVGyZIqhYhcvauvotAY7gqb3OV3CU++nfFNL5y/A=;
        b=ABG6RxGm0jTkSSEfYnIOYCsvQgUbZphlU/IU5vIXhM6sgJ9/Kf2Gxo3EFiDEGSZvhs
         tDGdjYvYSafD5oi3BAXFZcCYJEIqGmwqXC1Oleq0kmBhQ6srQnI2YIOmtQ5QBAnN+vt/
         /tcU+SeTCbasW+DdhjooiJ/HoY7yWPF3x9zgc0fpjjE0ElqWNYegw+CoWkBVdg3wUMEf
         5B7onEZU9QbY8hcbf16uNwa62tYOEhXMe2BBpsRgUdgoVDCHsD5Z6OqfAMhnAItOeOEd
         u/StDVI+Bkk05uDh+HnXfD6etBAeJWXx6ZtsNf2PkqSnBTViHXw6kTpUbIE8zOmouu3Q
         dxXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794218493; x=1794823293; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cP0Sh9fVrhoHCwJkmU1UvdqhwH/KzQ99VzRLHD1elZ8=;
        b=Ys9ZELoHkdzKuEqaa+z0Wk1CyP9VOqSjTVRi8eW8K0kbRmkA518cTKzo312j03oTYQ
         1SdsLB5uj5tqje4w87FPLdaMLucLoioZVE2P+BDDIZ32V5lPJ9dXE++WBCp4agFp8jyb
         /+b+38yysqaCtdWGhYnkA4k00bcRFscMYbWaQLthY8OFwXclxwnAojj4YzKK0nnJrhtD
         No4cwEjNwONvHfgwkk/bqRxpcYbPudcbasSXlhayryt+1cpmNKQTnbIdGzse3lD2cZVH
         JQ9zkzNaTtfQxpxN5/wOKbjMQhQTPX9xPnyVw7jtZh4MRO8E0kF9edZmwFg93FFfz5EM
         Vp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218493; x=1794823293;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cP0Sh9fVrhoHCwJkmU1UvdqhwH/KzQ99VzRLHD1elZ8=;
        b=aH+KvCCaxpiwiku5N6/dLqlYVsCCR/LZpkUZzeFS+HvZ+iB1iQa16EBDGXyt/Qh525
         TRSYtYPwS5Tz9VZzFWJz4faI69gmMbp5+wH5l0c8pt1sZ9cY/mXrHDMTr1utISWilcvK
         eWc8pktsXouoAUe1oI/OtT8JEhPEYpxvfg6nVD4cGcWbQfXX/0myV5zgWmwTicoN7SYd
         PVGeArSMCittb2teXEpxGxTWReQXD60N4z6zcyS7NQf9ixn4yHdZTdvu95XaUuYKyA5T
         qQjfASDVD51RKpPT+P63FNXsbzTmbmnDO8Rv13TAriYuL1elAj7CGzXVHHM3JHCzyYuY
         yqDw==
X-Forwarded-Encrypted: i=1; AL+hErHnGtKHd7JYMw+Y+LwritioGQaisS/6CGfq6RcrAKbepBva0XVuHs4V7H/3iW2G7zf7sVjdspVre5L8qA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9/8EVQ3zj2EMoq8tHbRBFBXJtqvqQ4+YwGJ06NdE1MihP9QSPv
	AdIRx9LFKdOkvqEy3vRSOIDT21vqdVyydjFZgWQ9W/5hHRFfhJ9WG2vLd2lmtVyEQX3T++jYXwr
	/kKQykxgvEfj2u/4Sym2EfE6+Sp8YgzE=
X-Gm-Gg: AYBFou3d9hcP3Fl9Ejz1ouzK2TbIdznsOupjvxAnVrfKJuzpwJHziIfRlrDRiiIzDhD
	bG9p9qQTdiyE1XEOfGGvXyrS7WC7h7L0WCST+Sv3Njj8T9XW5IDc72BaM7Ky9Z/wcLto/otouyf
	bgIYdxDNOZWDTHkTOgKC8xLEzxtP2aMxuxqcgkIRwhX3gVmA2Iq4QHETwBOgYeUNY0cv2CsgdWj
	gydpwsXFNmOdA6jVxzxXfaWE/7okxihpJL815iBe/rI5/EFAZC4WnYQMkl+dinsuWTm2aXE5V2s
	7TLbFYZhoy+Uy26iWHB4lVdZhpcIBLWAuYEPr6FrMY4XxOhiRyLeKwW8dk8OkgvDe1pQTZpZ7R/
	/YFZuYG19i8orLCJkDJjH6Ok0QfOLiVLogDbJjMnuaY35sys6YF7Zruu7h+GU+akaLH0UmJsIQ4
	yLF5sJKJlCG9NjcABi+Zcmtyxi2MoKNtuY6hg/uXaQSK9wtlEZvtzm4wO4Y8LDgUsAUZs7NQ==
X-Received: by 2002:a05:651c:501:b0:3ab:751:6ba8 with SMTP id
 38308e7fff4ca-3adfa5cee6cmr8129141fa.28.1794218492411; Mon, 09 Nov 2026
 02:01:32 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com> <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
 <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com> <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
 <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com> <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
 <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io> <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
 <avGNQ29RVwByM4HC@mayhem.fritz.box>
In-Reply-To: <avGNQ29RVwByM4HC@mayhem.fritz.box>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Mon, 9 Nov 2026 11:01:21 +0100
X-Gm-Features: AclHuK-FuFIzoSdaeQDzIOp4kPLIOowmL__4SzaqQvvIzIGOY8W39sr3m3wv1kA
Message-ID: <CAD=K2o9Q2XHozQEY087HUa6AV1obAGQXFsan+B8Aomm0xyXcxw@mail.gmail.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Dongjiang Zhu <zhudongjiang@fygo.io>, linux-btrfs@vger.kernel.org, 
	Naohiro Aota <Naohiro.Aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

great news that you could reproduce it - thanks a lot!

My test machine needs a couple of days to get ready (new SSD and
thermal paste on the way), so no rush on my side. When it's
ready, which tree should I apply your fix to - Dongjiang's
for-next base, or plain 7.3? Or will you post it as a proper
patch / push it to a branch I could use?

Thanks,
Jochen

Am Mo., 9. Nov. 2026 um 10:09 Uhr schrieb Johannes Thumshirn
<johannes.thumshirn@wdc.com>:
>
> On Fri, Nov 06, 2026 at 08:36:16AM +0100, Jochen Philipp wrote:
> > Hi Dongjiang,
> >
> > thanks for reaching out - yes, I'm willing to give it a try.
> >
> > Johannes asked me to keep the on-disk state untouched while he
> > looks at the zone report, so I'd like to coordinate with him
> > first: Johannes, are you fine with me testing Dongjiang's series
> > on this fs, or do you need anything else from the current state
> > before I do?
> >
> > For testing I can set up a separate machine (bare metal, no
> > out-of-tree modules), so my main system isn't affected and
> > switching kernels is easy. I'd move the drive over there.
> >
> > Two practical questions, since I've never built a patched kernel
> > for testing:
> > - Which base should I apply the series to (e.g. 7.3, or a
> >   specific btrfs branch)?
> > - Is there a git branch with the series applied that I could
> >   use instead?
>
> I think I could re-create the issue and unfortunately Dongjiang's patch didn't
> fix it for me (I've only applied patch 2 not the whole branch). What fixes it
> for me is:
>
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 3192b86669b9..3724cc0120d9 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -3115,8 +3115,12 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
>                       (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>                         continue;
>
> -               for (int i = 0; i < map->num_stripes; i++)
> -                       map->stripes[i].dev->zone_info->reserved_active_zones--;
> +               for (int i = 0; i < map->num_stripes; i++) {
> +                       struct btrfs_device *dev = map->stripes[i].dev;
> +
> +                       if (btrfs_dev_is_sequential(dev, map->stripes[i].physical))
> +                               dev->zone_info->reserved_active_zones--;
> +               }
>         }
>         spin_unlock(&fs_info->zone_active_bgs_lock);
>  }
>
