Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5C837A488
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784011277; cv=pass; b=r5EPMiV+7TRA7lLQs9S7bjvF1gOlTFFRxCXSKE53ptv2Eki0rHtnVF4UpgMM91gLhVt+5OxL5d/llNVL7mScQ6GO5f6voCp8InWvtlJhkAS2dYrwgc2tDMpZO1snskoXDLoZKDCGHLTFpFY+8MikjQR67lW7wcYbKQaLaRD4qRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784011277; c=relaxed/simple;
	bh=ir8BQBRCKwTf+RogCk13Rm84PoG+rCErYXpsd8jDRqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AIesLkgFmAeYQ5x9Axih5mWr6rTxI1HYu1Bu9plm0q1KOOWnJBbkuwstfQBd66YirCmJs/TONTFUp3Oqa+EGv4YjPCrjyD1Xw6NjIoV6gFNn7NcUTepQThvSPz0y7icT62hCHksY1XyYCwZB/QKUeHLeCFfoKHdDcB/4kg7grh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F4KmT1XT; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F4KmT1XT"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493b7612475so30584175e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 23:41:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784011274; cv=none;
        d=google.com; s=arc-20260327;
        b=HlGt3ezXR6LqgOk1jCAFkBrmEXRpz6NkAOxAgLtDyl+KtfKgoucgJ5/uyKh1Pb4XDb
         jiyqzGH5VjavRyElsEf3h2lmlRv5FImo1GtiGxkiaiHuEoZitcoFr4NAkWhU4JyitsoI
         RaNJYg2uixiCVHBtQ85qjhJ8sHG+mFS3/h5Szhg2ZQ4ttl86GIK/3NbydFGuFinv9aPT
         /Piufi6XFjRkbFyYeaum/TPW2N/wc/82SB9qejZyQvZEYoJ0/aFMu1WWNedkIIa21I8r
         BFBV+q8JamxyjXyNqZoef/n1mS/3zCEemOsiKwx9tfZE2MTTP2tkYMXhRhUDCSlgOJnX
         kqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5GYexmfLYE7f6AsYpjFBmtbGsKj7qeN8Aupm6bbq2Wk=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=sxpKwA2ysC+N+nZHNd9+IER5iRGzzSpu1+4tFJgAz4iNs3m0KKazVRXMhMRLX/pxTK
         0Kd5cxeVH5cOQONsXi0SttqogaDawZOTGOGfPXewpxUeSKnXYWvOZj9rptMzWiiye6Jj
         r9Wq9Hur/OcIlIVWrG1dJKKidcu6XQn6zMbwOo+szz4TKiuMDoHs20E392zzgvCBKT9C
         P+h21YyTfa/NJCgFOWVk37uNksyrV0fnRjbp1IyPefh0ox4O+lTaOu1/e5WwTeSs/S11
         CFQmBb7sY6kxmNKQqnBjT5mQT71qkMoccNePpY6TMWkm81JaxUzfs77ew6uSWIQyvv6N
         Uv0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784011274; x=1784616074; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5GYexmfLYE7f6AsYpjFBmtbGsKj7qeN8Aupm6bbq2Wk=;
        b=F4KmT1XTC4GOdEHbF0cxlVengWLluYb/OP7kvbWnroiIOGAwrGj6QHWO5qBTsOXwoX
         yUFXmYFXRcd/OryXu4wrMtvqowcSOCBBSjfHldtZ41miGUsrK9eH4vW7P/uO6DIpJqTt
         apkUp4OCVIvdeQF906ODi++oz6KmrGvNoquqbjLTIWNChb3+26CjrMByb3JIujBCtb2L
         b14u8vN1cUIwuldb9WXibuqvhwEX0C8n/oFpm8bO5l1re9Zf7S8/2K7nvD7fT73ooCPb
         Yryc/TaGdcXIht9Gag5sZaKxALYTQIAlY3eTL/bJYopnnIxgP85q/cBtUKgRolcfNpWG
         YqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784011274; x=1784616074;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5GYexmfLYE7f6AsYpjFBmtbGsKj7qeN8Aupm6bbq2Wk=;
        b=GWNzCk2IJbpY9lfe9//DxfSAaab8ilAzxRqbCexkJ+npyGFma9cbZnoZSc+A4KuhWd
         7pVebG5j+qaPTFOuV/SLlNZNiNnACtDliQ8J4L/w4wO3sHToFpyK7suJllYcM6GQyRcv
         fimq3HjKsbm8k6NKqRYROmSfqNybtVxG3qb+hPil9Q9TV+SSTs4nYawCb23FELrVhGxB
         3BCORTg2HaXbu7VEDJACLi7xlVtEHN5iJjyfmXzmyrPJRIHZncikyeuCrbPyCBXbCRGt
         BBsQSFVANYwIH9RPDVVN5xQ6kVM7Wvc6TE/id3sa9CnIMxlGOth+1nPrNq4rDgCnEYge
         GYYw==
X-Gm-Message-State: AOJu0YwzQiNPZej81bEai567rWtWaEYUSp7nPxfcMeJFPCZad3zZy8GY
	D982PYp/uqLt1IbS3GiQ3NqaGePeUZFROBXkMXy4hkPF8KPMoXQZre9mBquZbo8m+hVJVOU9O0x
	fyYM5SMRcje6cTvETxVDWu/rKU1V00yb7L6Lp6ZaDJwdt/BVqU/m1x+I=
X-Gm-Gg: AfdE7ckqV8Un4Vyc0U8XnPUbBuTSW9i/VnXZ4+d2up9uknMHyQJFUGq8RL7rxe3X360
	70Tb6JFAaDsrrb87TzpB36lLfPJj695ex76z5E6GN0GTZzAZC7rAfK+9JJWPX+wJGazE6bUdJ92
	BMCaHFZKOMQiarl5My4/57TsYo8u5n5yhows75GlOmoXyZFVzDl2fItXvqrJWCCKWkI3B38oFNh
	Sskqwa/9aQlSIbATuoDJ5CEqHI471jebbfMu3BJPaUtKk4JjVK3Gj2uDWtQhIXNKkSAR9moY7lR
	tHUXcsqj+bSxextwXo0C4wSgt/TNtt5e/AiUJwsEXPT+vw5yc2yvtDbxZCtqbDP7cOZsPA==
X-Received: by 2002:a05:600c:1d9a:b0:493:c535:3934 with SMTP id
 5b1f17b1804b1-495384a43aemr14974755e9.36.1784011274563; Mon, 13 Jul 2026
 23:41:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d687c3aa28b09bcd90bfea33afc9e907f2ee57ef.1783827722.git.wqu@suse.com>
In-Reply-To: <d687c3aa28b09bcd90bfea33afc9e907f2ee57ef.1783827722.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 14 Jul 2026 08:41:03 +0200
X-Gm-Features: AUfX_mwWrTgyY2NKZc9xSoYC22CKNbj6K1bwb35z9YjF2vROjX7HT48Zxzo49Ns
Message-ID: <CAPjX3FdHP-cU0HQj-ibUbWZscvOFRceL9=A+PGTU875KWGdqyA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: raid56: fix an incorrect csum skip during scrub
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 12 Jul 2026 at 05:43, Qu Wenruo <wqu@suse.com> wrote:
> Commit 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all()
> helper") uses the new helper to replace the nested loop inside
> verify_bio_data_sectors(), which simplifies the code.
>
> However that also changed the behavior of "continue" when a block has no
> data checksum.
>
> Previously the "continue" will skip the old for() loop, which will also
> increase @total_sector_nr.
>
> Now the "continue" will skip the new btrfs_bio_for_each_block_all()
> loop, which doesn't update @total_sector_nr.
>
> This means if we hit a block that has no data checksum, we will skip all
> the remaining blocks no matter if they have data checksum.
> As @total_sector_nr will never be updated, and that test_bit() will
> always return false.
>
> Fix it by increasing @total_sector_nr before calling "continue".
>
> Fixes: 7425a2894019 ("btrfs: introduce btrfs_bio_for_each_block_all() helper")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Thanks

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/raid56.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index baaa18b3c958..885602ab6448 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1679,8 +1679,10 @@ static void verify_bio_data_sectors(struct btrfs_raid_bio *rbio,
>                         continue;
>
>                 /* No csum for this sector, skip to the next sector. */
> -               if (!test_bit(total_sector_nr, rbio->csum_bitmap))
> +               if (!test_bit(total_sector_nr, rbio->csum_bitmap)) {
> +                       total_sector_nr++;
>                         continue;
> +               }
>
>                 expected_csum = rbio->csum_buf + total_sector_nr * fs_info->csum_size;
>                 btrfs_calculate_block_csum_pages(fs_info, paddrs, csum_buf);
> --
> 2.54.0
>
>
