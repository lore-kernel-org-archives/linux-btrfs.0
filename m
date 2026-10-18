Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710EB1684B0
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 05:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792303126; cv=pass; b=PUMWhdzMisxhYev/TSHmS8ggc9Wq9m0lkieOjB2c+yK1IVLrZCPPASVYEzvqnRMTtyFzPPd7TRSh1zjbfcrbhQkjK5XqoIJIvSNMOPkLgQevwLlqufkutnIIU7Vpp9Y7naCnX2xiCSBtUJkIyXYOATHs5X72gh163L+Vn+ba4+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792303126; c=relaxed/simple;
	bh=4imD56LGhVnH3yKYunrPp1kx51RcWPlngWSaw3yIhFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZFVpDQdJ+kS0Y5NdwNcwCwyrrhYKCSQvOrGaXHmJ5w2loer5m9ilh3RL+DIzV1tJgXLDL4mLI+ey8zJQOqFXRUyVkc7JHAv7qtVEz4pDJwGUUbJpfLYSAz9bSkPtoroJiWztmMXiIdXn5xHS1K0yrGvoLmw4X2uw4CPPRPDYoVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G6Sv1w8w; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G6Sv1w8w"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a0e1b0681bso8056385e9.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 22:58:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792303122; cv=none;
        d=google.com; s=arc-20260327;
        b=H46woA/XxHyrZti+RJVzF0wK3qiNT7sVq4PQEkSyokSGqGhpM8sr7MM9IqSI4uXsko
         mmBkFWc4SJ9buMv9NR/t8SFOi6EBCReAGn53cb5D3JqwnE1yB+Y1GRREVG2vSyClRlfU
         Qu6M5AVw+K0cLFHspEfLi/EiYRkBZwRrC8XAgnrSzrpqy0e/iYTD7C5ZmhNz1A/92wGb
         jO2S6AgrV8fCZAxn0cgVAa42k43qjO1/mkc/5tfQkdncLEyzN0D5zSc24B5LFXfDFCeD
         fOsjPIo9lkny4H7uWCjp0hODvo64mrHuMBEGN7f8AQ1sYSxJs82rOkA/zgrx+bT6RO1v
         lB2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=g1BZ6kkjNswPdRfI/h7dZ+6qEmaknQoomYsrmkFihbs=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=PBTwASa/aIX+eRskuzOwDepB+OWAYBzqTq7r2R+6fWqvLxEhljkpBpecI0bi7MkK2W
         eDXZKGhv7OBcXC8iSFE6QgkrFJi/sRlz/8Gq19mGQrReLUq5HHj6k9j8jDJPN9I+mz9A
         /wD1WeRP5f9eilgWuQTD+Qgc3bM8er25MVLAG0DU9+zGRcfRHw0u8s4ZCey6//mf0dgv
         NGnBCnYl6vprOG4JewDzIzl204XL5x9LMzt4+H2SvfWiiVIhOgIeHIkDsNrD5JVsmCdL
         5SuXyUc5F8qbNzMHitqlP2FLcquLpngtjMX0vHR7wtErlegQeqKRu75rIRJSpvybnAgD
         K1/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792303122; x=1792907922; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g1BZ6kkjNswPdRfI/h7dZ+6qEmaknQoomYsrmkFihbs=;
        b=G6Sv1w8w5HK6Oe+PoUFBGOwqNjRBzPrMhgiHYzc6S/cZ0doxkz2UUzCzuJdQiYPhEl
         i1ZWwLT+R5lFXVrTCqv73T9CHNVW8oV9s3tvYktOvh3LfL9cY6nr0fGn+fdEY8HXdRLr
         PDlA9YQF+rkRZfoLFGq4athHI6GbeWOifwIJgoTsOnZ7gRMlIj2TUXzmXYfPpyXcYpLS
         gR7Xi8bTo98Msjbv4aJsyGAzsqMgoWhJPkw6bd/DB5V3n6sscomydJYFDJGN9HQdeEp+
         ktwVmsLgO0eukJxw6a88AD8B0t0qZyUhUOqhZBKstVULDcWZn5myU2pdOsX7yTqmupHc
         YyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792303122; x=1792907922;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=g1BZ6kkjNswPdRfI/h7dZ+6qEmaknQoomYsrmkFihbs=;
        b=TQLxPgdCbqB0gLmtdl9arcBpXpJ3XUoVgTTS76qVRrAGcXZrCNnCh9hkvhXFFNO8XZ
         4BTFF3fx2gtlShrHiyyh9TIjlGnaUsJYs/CdGvM9KiwB+8X00PYHIP3QOqiYjCkEMa9a
         7h0f7XU0Hs/+uFlqIXO90UFjjiOA3/JFT9A6fPSdUc5fz3Ku1bWcXLQHNva9XjqLRxpa
         ETAabxCqtXr+cbBZkZKqcv4Y/ds7epGQFy5QyZV7ix6wGwlV7xlf1H3m/SpGIm5R96T7
         CMndWbnLKnYNx9dOhSncoaRijHvNfh3+GjROY+pl2llCtCmA+RqxglWjy1sNEQcZfRyi
         cU0w==
X-Gm-Message-State: AFq9FYKBh3cw7YM4LhpKMGQVTt7B/sdJEcQ8KsK4EY8v6Xugw54WWMHY
	1v42cUQvKz17dSS7E4T2JSKlejAd0NPT7ECL4IW177fX5xVnjeGN0LslAgmLb6wZ9mPKIX+jPef
	XE9A8X6FLqL79yx9Cfr3fo4t41uDGxDjHnE75DgRB+Usva0l2tCwCvsE=
X-Gm-Gg: AYBFou203RfPbCfly3YXHF28pwFQrn4wePjIo917pv49SRx5DnSZqI9onzUXNkbaEjr
	tVkGIBY6S4jbNe4cNII3vS02Dop3GnZbosKZFW3pzm1Nh+afrdTjjU2jW+pseaiMMeA7dzu+IDE
	fJxyYJzOlSrOn16TOmOWP2seI3tCdAMBDRd54zMgcRuolEGznKLp6TUM9eh184JyziLx0uyB2sh
	fDq818WV3OxedM6nP7BBqDE1mDxzluExNH5qg+QABNLC/Y1bm3UeOrWO15z1iYRDfbj8JliCXWm
	fDzUqf1pi12goD0hdQNnQHT3TQiShXI8PPIVjOVlSSxvYlsBb2jnPhL8TPfRm5uE35oNdYE/uiU
	QowsccoCnAgZJS2BYJsYNG7VInzCucsl302MzAbY7SrmGk+W4Ea6e
X-Received: by 2002:a05:600c:8709:b0:499:b65e:49c9 with SMTP id
 5b1f17b1804b1-4a1d75e4081mr78453275e9.10.1792303122666; Sat, 17 Oct 2026
 22:58:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9fbafebb95a3b9bbe4d6adf98c1ad3c65eb29aca.1792054757.git.wqu@suse.com>
In-Reply-To: <9fbafebb95a3b9bbe4d6adf98c1ad3c65eb29aca.1792054757.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Sun, 18 Oct 2026 07:58:31 +0200
X-Gm-Features: AclHuK-JXfwZUESPUYuDpVRM_kw1WtVWKLwNpieRA8-_Ih4ju6N20-7JEK6QXJY
Message-ID: <CAPjX3FfsDbbOmfMj5PoVFxZ-SQPtLDJ7qBfWSPdKYu0f2ra=gw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: lzo: remove the special handling inside one fs block
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Oct 2026 at 11:10, Qu Wenruo <wqu@suse.com> wrote:
> Since commit 3eaf5f082c4c ("btrfs: extract inlined creation into a
> dedicated delalloc helper"), even for inlined compressed extents the cb
> range will be exact one block, aka [0, sector).
>
> And several attempts to bring back the old compression range [0, i_size]
> all failed with extra races against i_size.
>
> So I think the behavior will stay. With that said, we can further
> simplify the lzo compression path.
> Since the range is always aligned to block size, and lzo compression is
> already done block by block, there is no reason to handle sub-block
> sized range.
>
> We can safely remove the @sectorsize_mask, @sector_off and @in_len
> variables, and always use @sectorsize as input length for each
> compression iteration.
>
> Finally add two ASSERT()s to make sure the range passed into
> btrfs_compress_bio() is always block aligned.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/compression.c |  3 +++
>  fs/btrfs/lzo.c         | 11 +++--------
>  2 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ad90e14032db..b12b7f1b31fd 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1010,6 +1010,9 @@ struct compressed_bio *btrfs_compress_bio(struct btrfs_inode *inode,
>         struct compressed_bio *cb;
>         int ret;
>
> +       ASSERT(IS_ALIGNED(start, fs_info->sectorsize));
> +       ASSERT(IS_ALIGNED(len, fs_info->sectorsize));
> +
>         cb = alloc_compressed_bio(inode, start, REQ_OP_WRITE | write_flags,
>                                   end_bbio_compressed_write);
>         cb->start = start;
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 2f0996692da0..0b2d9a825543 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -291,9 +291,6 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
>
>         while (cur_in < start + len) {
>                 char *data_in;
> -               const u32 sectorsize_mask = sectorsize - 1;
> -               u32 sector_off = (cur_in - start) & sectorsize_mask;
> -               u32 in_len;
>                 size_t out_len;
>
>                 /* Get the input page first. */
> @@ -303,11 +300,9 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
>                                 goto out;
>                 }
>
> -               /* Compress at most one sector of data each time. */
> -               in_len = min_t(u32, start + len - cur_in, sectorsize - sector_off);
> -               ASSERT(in_len);
> +               /* Compress one sector of data each time. */
>                 data_in = kmap_local_folio(folio_in, offset_in_folio(folio_in, cur_in));
> -               ret = lzo1x_1_compress(data_in, in_len, workspace->cbuf, &out_len,
> +               ret = lzo1x_1_compress(data_in, sectorsize, workspace->cbuf, &out_len,
>                                        workspace->mem);
>                 kunmap_local(data_in);
>                 if (unlikely(ret < 0)) {
> @@ -321,7 +316,7 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
>                 if (ret < 0)
>                         goto out;
>
> -               cur_in += in_len;
> +               cur_in += sectorsize;
>
>                 /*
>                  * Check if we're making it bigger after two sectors.  And if
> --
> 2.56.0
>
>
