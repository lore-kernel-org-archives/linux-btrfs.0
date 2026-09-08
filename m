Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5828B233941
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788853145; cv=pass; b=ihUBO1rmbpfPWaeoOuSng+yZEDEXLmr/VUVQu5tqGSr3tAX4H3tRVfcUPcmSy46KsbU5Tcv78VrY/w77e3K4xSOTOgKK3EhIuvt/1DTkFOh8pDDMD8gljYnJ/tBIE0cRik74ThPLLKgDXwDy5JWRvn5HoHmqdBZZwc6PCTWtuns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788853145; c=relaxed/simple;
	bh=uGiQ+IVl7Un19VxsmdB7C9q1R2fn1YX7hXmA0NgISqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQhzF2cc3KEB/6sUgV/mTLeaW0s4Gajn0S6Dxky5066IBrUqky+5Vuekerzp3QgvIshn44NblUoXV7MsXyirtnBYLhSnWQImP6gRNTAx/hE/oP88jOhZPhHCTg9KMwCkVdtthhwwgiwfKOeWYnhEOP/JGgK5gmNgaUFeTKNpJDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dEg0CgX4; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dEg0CgX4"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49b0d78a801so43226315e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 00:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788853141; cv=none;
        d=google.com; s=arc-20260327;
        b=ooZMahzt85BYQ5X2G4m1OX8Bc13AUCMQARv9mQVMcFuuqRg+Pz9K38TdXd7S4jHUfG
         l2a5fg2K2La+fWmCl1HxqNNxWqwHxxyajuZ3J9jcLy86itwHfSdpP1EH4q8rT7j4WhfA
         xpCWhLS/LXWgVIiBe8vnJraQtOwo6PYQti7O367eaVIuESPZDZn4zjQZGbJV+rTr87wO
         d49ntbHr4l8IDusmtKUT67fxsKfOM4O8PC8Yd7tVmbLYXpFSNrsuilSaLLdfOzEvQ6eI
         LJE6g1NhdT9uA+p0InPr8b8iD9u/Z7MuC41J5Xv4tDt9rowrTCnBk5WLtPCWANk77n5a
         1FPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eMDjYUexmjhNK+afv9E4kCut96M4vRcvGMwzHijp4rY=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=CLdqfzzbC94/Kp4ySTEyubEDiyYnWP6gXDE81LV6DZ/Hdw8QgI+Z5uGvjNHClAr/xr
         BSF1FzJsc1Qr0x05rCkpjwhLMN3W6C0y6B8chUEvFQ85dQOd9BnmUIn3UUVsNpk9XqQp
         aSaiHwYnVJCMmLIgGDWlo7KFLj/tu59tx21HmRrazq4M29HhsOCurnSG7ptOdaJLADLn
         DJui3P9gyTljEAtFHylBjK5XWHxt1R9z7keFe7NqCZPj6E9PLAFmDwGsjMV4CR9P+Tnr
         cdpD6LFvB/W4zg8TTcKRWPbM59v+F8tOPYI1ZkJLUds7a5Z2Ah23cDp0P7wFDtVfFXsR
         lNAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788853141; x=1789457941; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eMDjYUexmjhNK+afv9E4kCut96M4vRcvGMwzHijp4rY=;
        b=dEg0CgX427+zcOQ2wufJsbQnet5p34Xnfe2ytvtjgudzE7QE/HriEs7DodJkwihMm4
         qfFVFus9LPwsqg+K/Pc8WkmLw14a38xChSvk/pb73QYMP1IZw9OQKkEWtJ32dM7/Tf8o
         CWKc19LhiRSCnxEf1shG4bT+8LO98sxuceN/Ai6jitBay7bphOjv5A0qEIRjz7LB9K3x
         +hMnGEsBi+myfHgLG1iqvlWZAMGeLfiI1QOu13H7NVsZUK7EzcZ0HUBoUffxZNlldYUi
         LqoUhXFzPeO7rRmlTdUetvMZyqlnNAqyJLMJfRs2luBYG8VUbDx/pe21zgZtgFGZEqMy
         EeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788853141; x=1789457941;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eMDjYUexmjhNK+afv9E4kCut96M4vRcvGMwzHijp4rY=;
        b=rOvje/h/oHbgCmltMRbrko//eKTgHlNod4kpdIKfbiZfTgTw0IiKbyq9pO4QFKUgWk
         0WGq1tx6ozDXCxQqgF2dN4kELnGwgrLQUziWLi5GOcM2DqxiX8HVM3uKLUVIFgEKCZ2k
         c1dktfsSy/Kiv1q0Ha0boMw5BVppxfj6GEmdARAlztHH/nfXMeu4kFQqBHxOU413duvX
         JuuAnJiOibHfb+34XzFKEY5N1GByCM0rylmtfIa5YwAgbxmsRFzjuLmOb2Je5oSLeY3s
         IeAGFkfLwLxTvktFPOdjAIoTd4mZa/ir9goWFxLl1KYr9ErMM/ATwrNxuJYrZ0Rou699
         pcuw==
X-Gm-Message-State: AFuF++n6frhxylJGQJhtd/j2+o6MIYSjk6wGc5W0/ypX1genPP2lJuqh
	e5yc7KeG1vrSadcVWER6W5CjfdrpUJlyBbuN9hAPABrTdhFbmld8HA/mUGDU8hp7ZDHgztoLPul
	Q6Qy9HB3RTNqqyupbfx8O/j/CyvvF/n60Fg4az2buKw==
X-Gm-Gg: AYBFou1UjDuiw50PPj48R9qNPSIe1V0j99gnjY32g45mGUia0EJixwFnYe9Hh7jhgnA
	SSJDYy6Xctudx/4kZFPfDtZxRuSCYXgFXeUrTBK4HJ+MGWf+eC/Gr+Y693ZNvRE6qEQfwTK1EMQ
	XPnWithb6ne2I/o5jtjR1xE4yyepv6msycZqZ/C22ns7mQ85xd0u0a4bKC6YYtU15PYjaSgwIPr
	aZxb/HgLBA4bf4XxMzuONGga/U40ix/s+wIaVkrElXcVHKkxZwGbodi0OeMk/DMxeZwzDhLpAXB
	5ShK/IbOj/t1UkwxB34TvAd9H5ImbUQ+sQWYiJCBbYz12MT0Vec3cKDAXoBXzbkJeIzZHB1YKzT
	/Q/L/96NXGJQEEiqgg9Zynh9R1qXDlEBumL6ZeWjk2g==
X-Received: by 2002:a05:600c:1f93:b0:49c:ffa2:1f3d with SMTP id
 5b1f17b1804b1-49d0e0f55e5mr115754645e9.30.1788853141457; Tue, 08 Sep 2026
 00:39:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1788851649.git.wqu@suse.com> <6feca601145a668a4d1365003bd390270706ea92.1788851649.git.wqu@suse.com>
In-Reply-To: <6feca601145a668a4d1365003bd390270706ea92.1788851649.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 8 Sep 2026 09:38:50 +0200
X-Gm-Features: AcwNN1V5YhHPHGTuISAnwri392wzqDiGiKJZR7QaukaIFPbnqQ_kGhQy5dKsbns
Message-ID: <CAPjX3FdhXKJoPGxXfqrrvrJwwzWsnMgT2L416xGh5iCEDtDF0Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: use kvmalloc() to allocate compression
 workspace buffer
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 09:35, Qu Wenruo <wqu@suse.com> wrote:
> With the experimental bs > ps support, the workspace buffer for both
> zlib and zstd can be as large as 64K, and on 4K page sized systems such
> kmalloc() calls have a much higher chance to fail, as that requires
> physically contiguous memory to fulfill such allocation.
>
> The same also applies to S390's hardware accelerated path, which
> requires a buffer size of 4 pages.
>
> Meanwhile lzo is already using kvmalloc() for its buffer, and there is
> no special requirement for any physically contiguous memory anyway.
>
> So change the zlib and zstd workspace buffer allocation to use
> kvmalloc() to reduce the chance of memory allocation failure.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/zlib.c | 10 +++++-----
>  fs/btrfs/zstd.c |  4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 486b52db583e..e995d0b1452b 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -49,7 +49,7 @@ void zlib_free_workspace(struct list_head *ws)
>         struct workspace *workspace = list_entry(ws, struct workspace, list);
>
>         kvfree(workspace->strm.workspace);
> -       kfree(workspace->buf);
> +       kvfree(workspace->buf);
>         kfree(workspace);
>  }
>
> @@ -84,13 +84,13 @@ struct list_head *zlib_alloc_workspace(struct btrfs_fs_info *fs_info, unsigned i
>         workspace->level = level;
>         workspace->buf = NULL;
>         if (need_special_buffer(fs_info)) {
> -               workspace->buf = kmalloc(ZLIB_DFLTCC_BUF_SIZE,
> -                                        __GFP_NOMEMALLOC | __GFP_NORETRY |
> -                                        __GFP_NOWARN | GFP_NOIO);
> +               workspace->buf = kvmalloc(ZLIB_DFLTCC_BUF_SIZE,
> +                                         __GFP_NOMEMALLOC | __GFP_NORETRY |
> +                                         __GFP_NOWARN | GFP_NOIO);
>                 workspace->buf_size = ZLIB_DFLTCC_BUF_SIZE;
>         }
>         if (!workspace->buf) {
> -               workspace->buf = kmalloc(fs_info->sectorsize, GFP_KERNEL);
> +               workspace->buf = kvmalloc(fs_info->sectorsize, GFP_KERNEL);
>                 workspace->buf_size = fs_info->sectorsize;
>         }
>         if (!workspace->strm.workspace || !workspace->buf)
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 280ac5273438..cc92d0b1b948 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -373,7 +373,7 @@ void zstd_free_workspace(struct list_head *ws)
>         struct workspace *workspace = list_entry(ws, struct workspace, list);
>
>         kvfree(workspace->mem);
> -       kfree(workspace->buf);
> +       kvfree(workspace->buf);
>         kfree(workspace);
>  }
>
> @@ -391,7 +391,7 @@ struct list_head *zstd_alloc_workspace(struct btrfs_fs_info *fs_info, int level)
>         workspace->req_level = level;
>         workspace->last_used = jiffies;
>         workspace->mem = kvmalloc(workspace->size, GFP_KERNEL | __GFP_NOWARN);
> -       workspace->buf = kmalloc(fs_info->sectorsize, GFP_KERNEL);
> +       workspace->buf = kvmalloc(fs_info->sectorsize, GFP_KERNEL);
>         if (!workspace->mem || !workspace->buf)
>                 goto fail;
>
> --
> 2.55.0
>
>
