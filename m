Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774562EB10
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782217022; cv=pass; b=pFMD7a8ZonW/zA99tRMlScDjEx1tr0sMU9OjD7uWnJV1ubSftVaFFg//ShJydYFxqxQJP4EFcqI1h4fhMqYGMulOd5HGDdTMSbm1MUHDi87prhvcmGqwYcX6hqDMXx1a2z7qEv8hD0sYFgtBHqGDfFqPZeRMj4C5dpfgSrBPx2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782217022; c=relaxed/simple;
	bh=19eQ/1p3PoebmWFYdCtjeeXgNlaIIpLVB0xBBLmUz1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=psQe1PoxRwMeVOpt6wps5gtC9oSOa+/VeQY63GCy4LKdvsdizo/SVSdqMDRkOlWGFdeCt1yh4SnWh3vDDgN0G6cc5DYr0M4+wQUsjTgmcJcaGXB3Xm+A91uXg1Iu2k5G2VFy7i4jja+RkjLL7ySJE30zCln7U2+BsDsMJV/cDwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WveV8Lvs; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WveV8Lvs"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4629051c9d1so3747588f8f.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 05:17:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782217019; cv=none;
        d=google.com; s=arc-20240605;
        b=MqCGCHaUHlzxAdCUrDjV4Q1gtKuqsUap7yQNZ6gfN4e5KEzX4fZZjjHGii1pyKLFEq
         fM8x57lUigaEseNjviTW1MlCcsiLSP8zgjXrMxOc2YwCFRn4oeJds1yikh8AobJsfJ4n
         8jaItSBgxs94SrVRBVy6Elxhf+xMoDLbHyi3u0h9Hl6DU9rOatp3pSZazzisZ0H4LlF4
         9z0rH/rlNdjiLuB886wMwjjz9Y2M7XMCp1SIuegtEDPYwaUV5PTPaor8I1BSGKzAguwJ
         pr20FajPEV/tiCQ7B1W/0j1ET8QxfrvECVFy2SIWvF2h7B25sfnM2qAsIG6ROvPRSCpV
         yK6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JDWrWjWAu+vl742udUwRulQOLJgA6LIov7JVe5pC4d8=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=a7ZbdTUJ9LkkmFthwOk7wbo+C+P1sHKGcNhd/HIhkhly2CDw/iEDOC4iR/j0Dahqod
         dn6MXL33Vxu/3aqChWQJQkFtLLcQmGBZPt5TOKJtKZ7KiZEC6UVY81DDkUPG69cogV6I
         DCxjm7RD5oLVfgEoX69OgUR9ZpErUjL+wnTd4PMq8lKJhP78u3f6PZa+mqRax3ZOui5X
         DCEKVbTblmYQz9Pcu4R6VxgBlzjH3ODy4jaXHdJu+e6kxbGZkxLulK13unTkPxwJcAEh
         7hldkVHqHHYrMDnvf5OzSPLaUVxrPtPDTzEGqFKdw7Hcr1cGr+ST+NY4pPk3MVADh4Mf
         1PTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782217019; x=1782821819; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JDWrWjWAu+vl742udUwRulQOLJgA6LIov7JVe5pC4d8=;
        b=WveV8LvsuTiFQEOgfi7uVeMG6ebpcOHcUXeUeXVhLsvOF/xe2kx99HwXQEaXQJrADS
         XaAL01YzckPrZTUnFdko//TtiOxsJaJqq0/TRPf+gQssdkvXohfxxnExA1tufLjCr5ou
         He8XKzQTeR9oYYqb1TIlp+KE9yShCuaRmCH0XiAnrf5uPzjsyE/njOBVC4L0h9b46rr3
         qkgdbjGZ5enm3NpezRwOfSxNSVCBX+A9AMjC5xIXoTu+cQU+7k/wFHmS15/2HKfc+Mp9
         uHECNbtFDDcSMN2Ugree3ZXU13YMqwDRxOvwxJ3HjrDX/PK4d0ZWnpJB5mChrG/r+mnG
         Uybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782217019; x=1782821819;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JDWrWjWAu+vl742udUwRulQOLJgA6LIov7JVe5pC4d8=;
        b=cvOl9cLnjf/AvG0rVW3TdI2qGFaeJ/G1lukTZ+M0cXdNe9X5a/xzDryYpnESfFiI2W
         yqugrFr32PuVK7kgdnYjuboG3QMptABsoE//YhC3hSqP+0gBGF0OBmnX5oIt0yp0wwoh
         /svf3cY5ARQM4Wi27td2CIWIGgOjFdRBNpn/nx+/Z/YGj+5dKjsmltQi6ct6ft4YQCxa
         kqmrJ5oH9xQJ2rfDY2QByouxX1IIfEacyPrD/k8VdUoAKVBYYVRqOqWlQ3gjWR7SJkmY
         EYxPeX5XlJQeU+vl03oknCpBKgTev2Nu7/I7Qlz/K0yexoIlj+AwCdQa8OIZ5LlFrIfB
         +U5w==
X-Gm-Message-State: AOJu0YxXsS/1h8DUwwUufonkBXTkDW85TrBJMbGGm8hqLZBqhfGrcWE1
	CP5N8+GKboUgFFtsvW0blehZu2QkS1ss+cIrohGMGvqBCymvPIb78zt2lYlyw7klaHEdH+0n0ZY
	8Q02pnXmim84EFWJvMw3KzyAeIombkCC6QCMQZ5gz+g==
X-Gm-Gg: AfdE7ckgCVeY7EtAczVNpjlQv7X8z+SmW0bGK9Y3zjlkBUwYMugW0thkQ+gTrLXiaNv
	jqw1O/aiX2iky0x5oGV7dVUp+upzaAQkHf4TCCX87vFk+R8D+YJZS2LKUxu7zSijJVgxwgml0js
	g8Ian/7s9NqiR9Ut0F+ikdGfAMHit9T4zvMcLdornD2NQgZSOEyqm0YrxnelyMIob17GXB5i+ge
	s4wxBI9xf9Np/8wugvr+Y7DSjZ9+MDaHrF1tty14dpaVP4nrmEYP1gxwiouRXafIXMzUme153uH
	oIpI4Wl6F/PACet1R4ImnWgC8W0JtnADnY/BKRNK/pHSWMLC2VGZEHCOdcUgOUR193FvNA==
X-Received: by 2002:a05:600c:4e4f:b0:492:5bb6:6d56 with SMTP id
 5b1f17b1804b1-4925bb66e31mr30411895e9.35.1782217018929; Tue, 23 Jun 2026
 05:16:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4402ee2dd45308bdcfade989e0fb5a917cfc3f6a.1781541942.git.fdmanana@suse.com>
 <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com>
In-Reply-To: <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 23 Jun 2026 14:16:47 +0200
X-Gm-Features: AVVi8CdgNk13qYpKdzXMm7GRc4q-ltsEcdVC4_iIpVpONWILmaFnmkml-QA5ebM
Message-ID: <CAPjX3FfPYBHDS5vyOHfMQVKU-zkyG_hEcAeN6GRtT9eL_rJ_3Q@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: send: fix is_current_inode_path() to avoid path
 resets for common prefixes
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 19:15, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> In case the current inode's path is a prefix of the given path, the helper
> is_current_inode_path() will return true, which causes the single caller
> to reset the current inode's path. While this is not a functional issue,
> it makes the caller recompute the current inode's path later. It could
> also become a problem in the future in case get new callers for
> is_current_inode_path() in more sensitive contexts.
>
> Example: the current inode path is "/foo/bar" and the path we compare
> against is "/foo/bar_xyz".
>
> Fix this by returning true only if we have exact matches.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

This version looks good.

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>
> V2: Simplify and avoid false positives in case of something like
>     "/foo/bar" vs "foo/bar/xyz".
>
>  fs/btrfs/send.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index a3c8f2d889bb..d664e470fd77 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -627,7 +627,14 @@ static inline bool is_current_inode_path(const struct send_ctx *sctx,
>  {
>         const struct fs_path *cur = &sctx->cur_inode_path;
>
> -       return (strncmp(path->start, cur->start, fs_path_len(cur)) == 0);
> +       /*
> +        * Path may be a prefix of the current inode's path, so return false if
> +        * the lengths are different.
> +        */
> +       if (fs_path_len(path) != fs_path_len(cur))
> +               return false;
> +
> +       return (strcmp(path->start, cur->start) == 0);
>  }
>
>  static struct btrfs_path *alloc_path_for_send(void)
> --
> 2.47.2
>
>
