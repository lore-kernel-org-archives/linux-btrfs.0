Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA292F851
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 05:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791609981; cv=pass; b=hgXZ4sznvBJ26DMx9bm1Ly2PVd3AxkZJkGL5U+ASWKCS5d0HlwAd3+SlGwZwJ2zE9IX3v3xkw1NRwGz1yP4WcX8o341dCfv+LuSPzWflT6HSSwu9qFL+NvCf07zc4dkq3yY+qJ8YBOAmGnF0B+cV/k6SaOkmifkqUzqNCL0wcBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791609981; c=relaxed/simple;
	bh=xJlZtu4gZ1Q/wUxJ4v0Z+q7qp7T+HQc5GxoV81hKDgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k3d2mDz+PyiaEOXH417nnsPXOkMR/UuMiGa4rjCvkFrJgFS0UjxFFGlqcvnSKSDaXwQgWsd+4eAKE/nr89GNJ31IFc7a3IydNT4nlta+90se5HW5pYWGpi312v0iKTeXO6SId9M9sdxGohCMxCIm17lRapFH6dAnYdCESfMiGhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FIPNZFYx; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FIPNZFYx"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2055573c8cso54944566b.3
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2026 22:26:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791609978; cv=none;
        d=google.com; s=arc-20260327;
        b=gZt5sbxuzv7nCTlOKto4ofYqf4pDWTeFWeGF47Zrcm9iV/F7RjsoqcfEIjESNUWtBn
         UxemB8ocIcjvDVgr9RfEOpPtSCFPm1KTw3/arQAUwBPJ4l7Q5BWp7B3GLTlfGXiMx28N
         y+LwKASe5TJwROLgBuuGJbQPu1cFSjPzrqDns5t9mG1ROoHnF0wWJZowLhppwgCwN4lA
         vRTLSaLTEuuJn1Frn5on9hJxo/XrUzyVGmceFC/bxvLc4wmF3Mb/P1Yc2NfgT1GCmdGu
         SKH5rlmGBaIcEl2OHui9GuEJKfbQ9eX/N4fZoBNgIcuf3c0PH1forXqto5G8oKFODUsZ
         MXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iUG5P8TpbXM1cR64jG1OKwKWeYWAjpLTM/syjxzdBKI=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=d+TJ0aK9W6nkLMdn0ROzXR+WsBrWVWkxOp5IcK3uVuxLFXIaC9gC8n5EM49+1zy+kH
         /oWgJ2lothfQqo0DEtHjzufvS20E6zEdIGkNPQPbd54CyVOJyM23Y8DUyBa8VWp2yZL6
         CCP7W1b6HM67WZIFRpQvuxKQaZ8TzwMuKNPd9nXNr2zvorROGXCKNduPnK0Z+wwvwilq
         ZafILa8mNSosi6GBsPNBxUuGOUlq3dlQddo8+5LO7KaoQqAV+52TxfyR3sBwsExuIC8O
         5zAHqnDopgHEQa8BXzSWGX4iV3alj0XsvKCr1PyzgreUPXjzPQQ/eiZdNqbAqrAV1/Al
         Ttyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791609978; x=1792214778; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iUG5P8TpbXM1cR64jG1OKwKWeYWAjpLTM/syjxzdBKI=;
        b=FIPNZFYxQJg4Pv8dcGMjwUPHxVkCy6tIMafy9/kedNCk90yMSnxAXEV/hPit5ikfnK
         ji9DiSRH2gqe5IL8VX3yfzbBjEhLxq/5KAHE1/K6yjgigWArWg4/VJ7d2oMD1dDdghu+
         iyS/Qni47N/xu8J92LBeGL1h1AAEVugLhAHNE4lFn0okSIvd4Ittr5eg+jdGuYCmW/yt
         qCMlPnUD0Z8Ed9AwplnSobFHBTj/ujMuRzxlC0QX25YFQPd2+XsAhi8DVV/JyhKhPGLj
         eXB1oafeJVzrlP0Sja9nsWeUEe7fbHrfAUpUcR8PN2Sf4ePY+X7HQKy56ZwOeBaIct+k
         tRRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791609978; x=1792214778;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iUG5P8TpbXM1cR64jG1OKwKWeYWAjpLTM/syjxzdBKI=;
        b=imgDlAL+X+sxmrtGYpj8oAjiSanOQnul8H7+Q8dDW3HGjKmyDwZuY9DJL6TiRa4Yby
         ucfP50WOjaJViKgJ1y2ibmdcfkxixNQkrVVjNNVHHCEyfpyDcGw3qD4OA7aITwS2KYjm
         subuWmpOBHbIu26EXYO3SDJgJSQSU3bE39SIJXJT4y6D12erSFYBm62nZAPt5IM8h4CV
         dZnkOh1ixYYWpqax0D/eAyH0mrXyS7uFQwyGHWZuX/znnqGT40Su37ezOMlkyVcTwKfe
         lV5Rp6S4o6faMkIdsV22RX0ardWnLSLszGbzKBzvaMlQETX+W0I+MlAkmqtt49mXGIom
         S6Iw==
X-Gm-Message-State: AFq9FYI2OWkYt8/viF4xLJ5J8aulZ1LLo2UKb/gBafrBA/DxkzpOdlov
	JYA+9MCMrjGq6I2a/X8BgtCvoFUre2NbBJZMs/Ja+RwKNC/8axMdobJDcBbiuWI8DuVY6S89En/
	Xp/68WNgJMzjPSRW4zG2f/R/uj5op6q/MXueM
X-Gm-Gg: AYBFou3tXcLxQldMag9BeTk1yiWWzOj9GvxisU6URWqHDcCKrO2ss7qRWXX8ATn/pMt
	m9RwOyizD5wsX9pI7QFzt0d921Z6mds7hXIwVh2e2zld91djujdiK3zMk2n9jKYUIAAQgLQjZZX
	YBCCynDpVETMq8p1TzH8YL3/Tn6pVuEqTYzScKaYWXZKvQIQ4s7RDr99ylQm5QlQtHCYaE5ORJd
	BZ30syQhWzQHKpwbdctynEfCbwfEA3qQDL/J7StCjAZbXwyhIOAlGKgmUs/w1PIG5yymH2BE+5X
	GUWrBJMT4l1s1QOBf5w4pRrowlAbKuq2pu0rnQJEgQFWQy8Gwomw/WPPt61SRT3nx3sXwRtQpAm
	d63WJqbFnES53tijMv2mpjq6iCzOOV0ZZit3CNNnm
X-Received: by 2002:a17:907:8692:b0:c2e:2720:8f68 with SMTP id
 a640c23a62f3a-c31aa01b41fmr348868066b.46.1791609977602; Fri, 09 Oct 2026
 22:26:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c1cbf7c27ca3685b6440c04c87b70fe779a2535b.1791591949.git.wqu@suse.com>
In-Reply-To: <c1cbf7c27ca3685b6440c04c87b70fe779a2535b.1791591949.git.wqu@suse.com>
From: =?UTF-8?B?Um9nZXIgQWxhc8Og?= <vonbloom@gmail.com>
Date: Sat, 10 Oct 2026 07:26:06 +0200
X-Gm-Features: AclHuK-8n1aDx3QSuTddUfvYrcVfbZzCB26jsojJIvra09ZTyXmrLgdOeeXja9w
Message-ID: <CAELqY9=KEwhaJygnTvfPYY56EB5UyuXZeuQbQU9COXznehbo7A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix the fsverity callback where unexpected range
 is verified
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Qu,

Thanks for the quick fix. Tested on top of v7.2.9 in a KVM guest
(Arch's config, 4 vCPUs, virtio disk, btrfs root mounted with
compress=3Dzstd:1), vanilla vs. patched:

- the reproducers from the report: 10 "FILE CORRUPTED" messages
  without the patch, none with it;

- a copy of /usr (34969 files, 855 MiB of binaries and text, closer
  to the composefs repository where we hit it), SHA-512 verity on
  every file, each pass from a cold page cache:

                                                 vanilla  patched
    cat, sequential                     20        0
    cat, 4 parallel readers         10        0
    mmap page faults               11        0
    diff -r against the original    30        0

No read errors and identical data with both kernels.

The counts are lower bounds: fsverity_msg() is rate limited, which is
also why the report always showed 10.

A small note on the [BUG] paragraph: in all these runs read() never
failed, only the messages were logged.

Tested-by: Roger Alas=C3=A0 <vonbloom@gmail.com>

Thanks,
Roger

Missatge de Qu Wenruo <wqu@suse.com> del dia ds., 10 d=E2=80=99oct. 2026 a =
les 2:26:
>
> [BUG]
> There is a bug report that on v7.2 kernel, compressed extents with
> fsverity enabled can lead to read error.
>
> [CAUSE]
> Since v7.2 btrfs has enabled large data folio support, now a folio can
> contain multiple blocks even if the page size matches the fs block size.
> And even before that, btrfs already has block size < page size support,
> thus all involved code should assume a folio can contain multiple
> blocks.
>
> However the function btrfs_verify_folio() calls fsverity_verify_folio(),
> which verifies the whole folio, even if the read range only covers part
> of the folio.
>
> This forces fsverity to verify garbage data that is not yet read from
> disk, and causes verification failure.
>
> This is a long-standing bug, but previously it only affected bs < ps
> cases which is not that common.
> Now with the large folio support, it's much easier to trigger with bs =3D=
=3D
> ps cases.
>
> [FIX]
> Instead of calling fsverity_verify_folio(), call
> fsverity_verify_blocks() to verify only the read range.
>
> Reported-by: Roger Alas=C3=A0 <vonbloom@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAELqY9=3D=3DTer2XQPRp=3DgjW5T7=
5T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com/
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 55e9144d4759..5ff630630490 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -504,7 +504,7 @@ static bool btrfs_verify_folio(struct fsverity_info *=
vi, struct folio *folio,
>
>         if (!vi || btrfs_folio_test_uptodate(fs_info, folio, start, len))
>                 return true;
> -       return fsverity_verify_folio(vi, folio);
> +       return fsverity_verify_blocks(vi, folio, len, offset_in_folio(fol=
io, start));
>  }
>
>  static void end_folio_read(struct fsverity_info *vi, struct folio *folio=
,
> --
> 2.56.0
>
