Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CD53BB115
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 06:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792303732; cv=pass; b=nc9aZeH2qzZ3vcjnlSGEY27coICu4LzdEWGLB4bAMlX82rRANc0xoj4ltB1SFCGkkRHYIzu6fLXfwZuovxF5YjP0qo1jhmBjsUx+OY9casx7OWVrO3tpP1ixtMFblXCB3PLvv62mG7K8eu60I3V58jkgfoM0qL02tfSkczJLgkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792303732; c=relaxed/simple;
	bh=MboR7Bk8fuMrfeFecuoU83ysjkKGJKX2ENSRatNmfko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mL1J+pzrLcPieE25W8xW4iCSeZyMUw9wEmIPX7Xv7fUxw4fU3dX3IRTfc05nm7uadf8bYmOk/1AkzGxzv40KP5w/kZhNxLCISgeb0Qs7XnKwn0Gckiqw+g7c1NGwohx6JFVhEx3Gs6SOhUl+EpyXOK4SwBQtXFztL+YZspZlihs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D+ekrEmQ; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D+ekrEmQ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e0d885929so545311f8f.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 23:08:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792303729; cv=none;
        d=google.com; s=arc-20260327;
        b=l7xRT54DGT2EsoZU64NYmCdQ460aPdUrd7KogUKMpZ2Fx0uiaeFr8+HYOanqHs+iAs
         JdRQyye8wJdh4SQGlXKBhSDGQdgv+AgRh0jhgQPSmNjhOSVRrQbDZMElmdR/2R6DiZUU
         wUDKnzHQptF1KQ+YNiJA6U1shUAVqrnNA+8NZBNMS/tv8QNUB9KSKh2JoIZc4+DmNeBF
         SmJr3bjiuHOg425NT84kpLBiWKo436pymOscyWLung3/OUqU3aHDTvC5VaKozaqxXxS4
         yqBhu9c+6xePlOXcrcpAH8kX7CqeP5lzjrL2BFVG8Ey8kTAC4cY2VivkfqFxGPeh6cE/
         BFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+FfNue2CFa26P8+JqoXTE0ukIk0RZ1873O8a1vJvsz8=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=egmJBh/R4rqckIub3mizgrVSpDZFjPu9Xd1TslFcTSXlcHzzmuxnCXaTJ8ZFClA9+X
         08KN60p4+dRIgvQiHVLihBjNaM7IipMl7rc+L/CR7RPGpy2f5Wc0uc9uSMXFJWhXnA+3
         WxF62EIK4tanAfogZkwKNbkJ52kGietoYDD7To5QOj/a7UsZeQvHVOsNf4sGl87qzkwn
         uhaC6VnKuNklWax6CZgIgxBdt5byH3i3qYHqP3DpaTFpc3wXlI+QdEoE3fSa4HskOS58
         qXdM7ezZxwkE3oweuvs6UVay2RRpDNGuIpKgxInWYG35KT/ZDA/No/20cOV56ieSh5NI
         1Otw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792303729; x=1792908529; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+FfNue2CFa26P8+JqoXTE0ukIk0RZ1873O8a1vJvsz8=;
        b=D+ekrEmQs2mcZcPBaDeLNT8HqmtBNHa5/8r/ntelqN8KBCz6WBkdX3Ul/h1DQLf5cS
         3MlgtOV+KCxllAP8FOSQIIXZ/pAPedKWZP/fbmOcGnkN3vT4Wfb0Tp3Gc8F47EYPvAzO
         BtYt5jpWniraD5k9nDfjR9wVDjPV0jynOLEKrZd3BpgAAhqI16WtGSUcrG6GRk024dm6
         SJI3H2jF0UZ7xkiqZW4r6NxXzRW5CLLUM6IVJf4mK4w1nXL/AB2pg5Izfw7OBOZ9rLK/
         CoBso/zXUH4ZHDEd6l3MfB9gRjk8xyd3IGa0RSXb8IhcmcJPTrCaCFCf1g3UO0Dg0yYs
         I1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792303729; x=1792908529;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+FfNue2CFa26P8+JqoXTE0ukIk0RZ1873O8a1vJvsz8=;
        b=pQ8BTbZ9l7jtdtWpFB6iuD1NcmJ4jCXogsVuu/ywm4y8zNIfPupjztsQtV80TRcxVI
         sCQfXbCdkne2smK/J7p/hZwnaIA7mjIPtnKlE5Z6d2ORRexJhoUrUjdZmfvuRVPQZn+/
         nIzlZpYudyYRPZ5uvc6mAQP/71Kgoy8ENfsZrFUvpzMqEbhDcFFL730ADtrs/tEgrtVI
         dpXcnik1s0NTyf0n8l8Szz4XONTtFflAUK0kPNvxpa6NFAVCj8vSeBzO+DRyBBAnpYmN
         vxC21Pwk4MVODvn86gJZUHC25vb7rUW2buo18YdCBMDyeLIXUh+QOJGIc0JD1S7KfJVu
         Aozw==
X-Gm-Message-State: AFq9FYKxNfnvxnTPvYeP2WvfyKypmSG9T3Ik2dpGltNges+kw7asUvDO
	sc4xPqZvKFFzkrN7v9aRGP7FfAS34V9GOWmIHhIZXk4ydZa4KGhU2zg6HkGiPPOziUsywz45pLs
	alAJHMntWql7lNDzQebwPzO5KfwPJfoyV1wXmD0Y0DQ/TicIhJ4q7yak=
X-Gm-Gg: AYBFou0W5/n8Rr17z+N0fb4X4PLQpWvbONpxcaxEhi6uISZu6UQKes6znDVo96Q9lvZ
	K4QbjY0AYz1IMlQ4ktpo+csZnTU+6cVvKbn+Qns7OGsZrm5prxGhN0JU16+52OuN3wRszfVoDGZ
	yIXaTr6uQZRerewm+JErADj26TtqlK+HvhBYsGJBgrSNCF7JxBEbdMEMcP9G8iDRpBop4MU+FWh
	i712OXKPq20x6l0/CARggkOxf5o4egkOWIMpMFwCRYfSSVA90a0DH3cd11Ynu+s84fLswsI7qUt
	ohywIpcJ20T7boOcntUretE/T7dsMb+1W+I+gGF+9hr7/VfeUwdEpzpbxPOsqNXdWhbXxpkoB0X
	tMN/iMkldkvOVexprVVbZLbpRTND60dqbgd0ic7IYu14cK/wIs09H
X-Received: by 2002:a5d:5f51:0:b0:48e:bf0:321 with SMTP id ffacd0b85a97d-48e0bf007d5mr5429520f8f.40.1792303729196;
 Sat, 17 Oct 2026 23:08:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cbc634179ac86780dfe0aff9c5e2cbd3c96f5235.1792168617.git.fdmanana@suse.com>
In-Reply-To: <cbc634179ac86780dfe0aff9c5e2cbd3c96f5235.1792168617.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Sun, 18 Oct 2026 08:08:38 +0200
X-Gm-Features: AclHuK9ntaIZaB8lr-yykz5xZC71Td-b5L4aVfkASXECGaADUbhpm7VPZ8VITeQ
Message-ID: <CAPjX3FfmeQoczE5ri8pBJB0maPDLs+5aT+VEd2P8mBX2iPQAow@mail.gmail.com>
Subject: Re: [PATCH] btrfs: scrub: remove unused first_free member from struct scrub_ctx
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 at 18:52, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> It's not used since commeit 001e3fc263ce ("btrfs: scrub: remove
> scrub_block and scrub_sector structures"), so remove it.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/scrub.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 05768e28fd95..0eb30625439b 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -188,7 +188,6 @@ struct scrub_ctx {
>         struct btrfs_fs_info    *fs_info;
>         struct btrfs_path       extent_path;
>         struct btrfs_path       csum_path;
> -       int                     first_free;
>         int                     cur_stripe;
>         atomic_t                cancel_req;
>         int                     readonly;
> @@ -460,7 +459,6 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
>                         goto nomem;
>                 sctx->stripes[i].sctx = sctx;
>         }
> -       sctx->first_free = 0;
>         atomic_set(&sctx->cancel_req, 0);
>
>         spin_lock_init(&sctx->stat_lock);
> --
> 2.53.0
>
>
