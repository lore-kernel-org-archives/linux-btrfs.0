Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A6B39183B
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788852772; cv=pass; b=Uz/wQvD4ZYyDX4TTzWdVYZRiJo1AlM9qLi1DKS15xdbLsAZA15d16NQLQJbcUR9ZIzegkOKQKfiPHL4hZgH1YpeYMNVXGOw567KwwXPrDtbG2AxNFruR5nyMvHbUASb0YtW9LBIeG7OkSkrr8MiBxBENhyi0RQkOHpGsvUlxLcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788852772; c=relaxed/simple;
	bh=9WsY5k9OJRdYbUIMHlVp5U/Za+jyOIfodPnlzPn/3NM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XZ3VTgZZJ6PDs8Jwn9ooGKarY16jYbLgpRDinbti4yo3d7q/kvnVN1WsEh3Z+P1v0oEXF7LOcO3EqJbTGmz06yIw9PWIBFOhO1zMhSC2h0zr0z/D+Mo22rWtxkSh5XSgiDU2pUl28BKzk7n1ihsrwyR6K+Fej0wNPFPpBn7EHps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XsCOF0Bl; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XsCOF0Bl"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4957eefd361so33768845e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 00:32:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788852769; cv=none;
        d=google.com; s=arc-20260327;
        b=aTT6ibmzqORBmHXKSRs6qovQ7CR+fMlTRj2gRcZxsR8WuZpxrWBdLVuu0smPAbj5nC
         s8Whcffz8oZXqHBOj4MQkdAgPbgZGWf82+N3N1udGdZIzcpl37WNpCNuaDy9ddx3Pv8P
         nj19ODlvfeWcMRaWET2VCrmz7slewR1BQlxvAj4Uv8LrnZ7mGwwz9EEjhRJgwsKeFT1r
         is/AcqlP3P/k1ezDqOSUpoCtmHeXudin4eb/2RJPme/cvdTuFrw1shNTej0UGAdGkO7G
         KxTY3cYjoQRbLT5cxRO3E3dTMrD5XHS/D0MPF6jlMs5QhVVZJBy2zcHqVze6Nr/EQoSe
         wykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7V0IDX6L56LyKj2ILpre4AHNNK6GIYstcIHZixdCsdM=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=L+dPP4talLMJCmZax+MSVsf5Z4Bn6S8Go7dkGGTs/hczyWiqWw3Y7k6oXEqNr+yCik
         K84/msaskxnSABDYQkq/vIq5gP/I0vouXp87di+Ek9gNcGh5XubRO8w7yh/mzyYH9Kvh
         Kck8Aosz9RXuyoYL8PxRiZ0KAQIaP/XIqH4xMJmRrCHHGXzQBKcmRsHTjtm0lvdktiox
         c4PVqYl8pnSf4WtrV/VQys4VuTXpyGMvaXspf4U8m6jBOimExSb4b7lubsf/z1hKBHL/
         3ovxJVAoA9TFOlh1v8dfOj3u4EcjOD05UoSD1FZ2E1Ji5Fpic5jkOiHV4oyLm4q9fi7M
         xMqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788852769; x=1789457569; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7V0IDX6L56LyKj2ILpre4AHNNK6GIYstcIHZixdCsdM=;
        b=XsCOF0BlBx7xci2be55ys1xC7JqVdoMC+nZy5QB8jfTNN5az6fiqe7pIT+8kYK2ZkO
         sYnheKNkw69q5ocMutpiw0v6QatNPvGF+OvCf+/cbe2OlOne37DYQ+y0lnUceTGVstED
         fJOyJeN3zHVvCCV0cpqhBeDsrX+NNysUf9q/c+PE/mZML3w0Z3zTELHX4gfSf4rSozhb
         fxSl1OZ/X76ZVkkMxcchbu447PPs+7GU3bM5ijO9UfiGdF8nbBoBuRs41QQuJGlJjNN6
         GY4kOZ73zwisLKD3pA8u2+LmbqrjHgz9ava/x9mTo1QBr6YKnggwv3RY/p6x599B0Yl2
         +nJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788852769; x=1789457569;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7V0IDX6L56LyKj2ILpre4AHNNK6GIYstcIHZixdCsdM=;
        b=Iac6lgTkQPsPjc5wTDB8tXvluHWEaU/iK8Kv6OcAuWr3VmwUlQ2qzUPh64FcU9Xln2
         1BMheOtjySRzvzHrceY/+zYQlrA6fd8uB5pyjGCS1Pd/iA5aHJFAFKqW53UND1dyAn7Q
         3VMVrIYkUcJahSr2IR3XQx53mYldu1UvOimnx+Eir7tlUjKJOhj/G9cqNvABjeebO1+o
         fQTHkrvGTT8LJrMosaSprIEB1JmmGPrIcrxSH+D9XuDyV4KBpoexwyqjvnW+N5pIYpGv
         dGtbK9giJuYRZdszdt6yXqKPrywJ04AyZHYnRMEHWr42PmXqlnJQbRNZAjzQdtrOUDvz
         Cy8g==
X-Gm-Message-State: AFuF++mXwWTBpLn5kAq/DY/X6EIsF2OS16+bKI/uwd8cM0IDYaPo3eTM
	Xjls+q+cfQmABFhLAdjsOp7/5e7I6huyXx+WB1suMpqn/ZQqO5gd/tbeEHzK81I0DwMx0+AOC6G
	pC7JybGee7VhLeT0/qd70PLlDcuHjbpMoGxnTOFxl0nqAUh/0zcqw6lg=
X-Gm-Gg: AYBFou0FunJ6QyBtgSyuIYWocWsdFII4xG6tW/vYRTyAaAFQGbRP7gY2VsL36MoK97N
	cjPQwOldNPNYoT9ACo098FzyvPzV8MwKPlpkFxiUi7u8JCIc1PAyPGvTwGZlBD1DDFALwmcP/+T
	XAfRQ/xANG7RX2f5GK8JEUQUQLHOMoSNiB9iXyu1k7MdSypZwCsnixYCEc7ziP6StdgRPEZ6CbT
	j+8pXvMNICPocBrafFUYyOfUeoZhjd6MArGPPuZdLPTIJlrwSkwtvYR88WA+d8xsv9nKTQgLcH7
	LNwpxdF1qPSH6F8nv5k/OztUWltaq/02yPy9Kuv8+SNlg7ZqPQQL/YmqVdu3Vf6iZX707gShP7n
	uph1you7pHEQAcMJXRYV5DzkIDxZi/JThbxLGb6IHBGEiTbkA7+oE
X-Received: by 2002:a05:600c:310d:b0:49c:dc14:d681 with SMTP id
 5b1f17b1804b1-49cf81e5449mr268835415e9.3.1788852768891; Tue, 08 Sep 2026
 00:32:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1788851649.git.wqu@suse.com> <59afd3cef54b5d120384b676af642ed2377079cb.1788851649.git.wqu@suse.com>
In-Reply-To: <59afd3cef54b5d120384b676af642ed2377079cb.1788851649.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 8 Sep 2026 09:32:37 +0200
X-Gm-Features: AcwNN1WBiQwP1zg3CZK42RyCZZ3YRPIu98XlMCuhdXHPFUbrYT0tJQiGESAphnw
Message-ID: <CAPjX3FfOJaCNz3b-GvAR1CfWhVOdSDFh9PcmpGk+yztFdsd0yA@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: use kvmalloc() for overwrite_item()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 09:22, Qu Wenruo <wqu@suse.com> wrote:
> The @src_copy buffer utilized inside overwrite_item() can be as large as
> the nodesize.
>
> For an existing btrfs with 64KiB nodesize, it means there is a high
> chance to fail the kmalloc() call if there is not enough physically
> contiguous pages.
>
> Meanwhile there is really no need for such physically contiguous pages,
> as we only use that buffer to compare the content of the item.
>
> Use kvmalloc() to replace the kmalloc() call.
> For most cases that kvmalloc() call will be easily fulfilled by regular
> kmalloc(), but for really large items and large nodes, kvmalloc() will
> have a much higher chance to get memory allocated.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/tree-log.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index cfb0b0e9e124..7fb476b19eb4 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -503,7 +503,7 @@ static int overwrite_item(struct walk_control *wc)
>                         btrfs_release_path(wc->subvol_path);
>                         return 0;
>                 }
> -               src_copy = kmalloc(item_size, GFP_NOFS);
> +               src_copy = kvmalloc(item_size, GFP_NOFS);
>                 if (!src_copy) {
>                         btrfs_abort_log_replay(wc, -ENOMEM,
>                                "failed to allocate memory for log leaf item");
> @@ -514,7 +514,7 @@ static int overwrite_item(struct walk_control *wc)
>                 dst_ptr = btrfs_item_ptr_offset(dst_eb, dst_slot);
>                 ret = memcmp_extent_buffer(dst_eb, src_copy, dst_ptr, item_size);
>
> -               kfree(src_copy);
> +               kvfree(src_copy);
>                 /*
>                  * they have the same contents, just return, this saves
>                  * us from cowing blocks in the destination tree and doing
> --
> 2.55.0
>
>
