Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E97F274B46
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 04:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788410980; cv=pass; b=EVBcIKMXNDM89knw7WwieHlKrnf9P8XXU3Nh2+SEBteZ52dnBk6NnyRv8SPzhDXhKMcK9pu4dxIywwWIMPe2xHE3Q7hZ6g5eGOPzt6TMT0c8vGx+IhvciTz59ztn0gA4Qv5d9cp1YcKRVhLG6czqESPZfKaevOTrlE5NwYXuYsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788410980; c=relaxed/simple;
	bh=WDBujGpFF48g9BOWj7qHVl6o2U9PlRL0uaEjw17S59Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gDTLcHYDw/a9Fo6NKqr/PZ57t6P0Kzqyfq9yzut5l7YdeM4uqRcY0l1LAH0kQnQxWXgN7wJiBPPsbuRvdjdQLWUPRSM29VrubsJ9JjvFyCWKZWh0W/LklajJ4gsMTzKfmyaLOhtmxdayWkCQlg0xuRg7CUf0KIOoSKveE9AgJmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c4LT84AR; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c4LT84AR"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48433e9562bso370644f8f.3
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 21:49:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788410976; cv=none;
        d=google.com; s=arc-20260327;
        b=KZrnbVNtS/fyjCOzAmxeZH+EggjN2xlNTSnorgmWs2bw22ajzxELbJb/eOdOd51Le/
         tQlyiVpQcI6VkFWRbp+MAp/NecvPJ0hAGBtRRUUR4LMLXOj06Bvaj1fGGLbZEOaOAA3v
         J1+0hqU6MbMdh7sxPYuFsBWwOHj2Vuo5vjCwZpbPmvCbkk919ylRjdxETAp3JgC1uUIC
         6gMJfBo8tKMDaOEPjdZi+7zasmNZPDFmSfE591iS2OcuPegmzrlyQ0argxmvK7KIosDT
         Fb0I5uR62wiTew7gDr2BobyJq85BkMq3nwwCt5tvmuzNplTMuVyYhLGERkNrgK7gqfYI
         qjhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=l0mlOS54FKRStMTSYedi1p7aaRjCgF5zp/ehhypn8MY=;
        fh=2uiT30AoQUgmRqiGR0flZAf+i2IrDtMeiHylFY5cc+k=;
        b=UBjymb7qaotOpzAQA3e6CXKMMhsN1+X4Wh712qk/PnEjR2ZGMRXqz8g7bwfH/SdDgo
         LTA4CZFz5WgLWmzAuIJU8IdHY5c+Q14VkSIJmiv8ysFSm+ZoiZXTDawtQs+h+4Z4kJqi
         0kBO2OAaFgO62B3x/otcgtoMsl6K4TPJfU785sYJezcu1xsQfOgI8KsFAEO+Mptw9QEF
         6uOD9PfcxjdSVZOrRd/9ntdTU/YI4fqilFMRSLKK0Y9MX4THWzT6TDOz09KEeVJgcyFt
         7wRdrkzXCvt0/ZcqisIBbMsekZd701ExHq4PF2dBCnMNc7MatHHv+kRZKWYYr9J1Wd29
         HCAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788410976; x=1789015776; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l0mlOS54FKRStMTSYedi1p7aaRjCgF5zp/ehhypn8MY=;
        b=c4LT84ARytV838sTxSqEl5AAdfW5APzG2BRYNvaWazEAuIAGrRys6rP8ftDHAY6zG9
         DrmXEyUBQLjlpz7n63KmGTERrbaNgykLAUmKBTWvidO7JeijjkFSPIlYId6yXFLWl1jr
         GwQXOmBifLEbu77ixKlEoEyY+v1rcUcSar3kx19LXxNN2IPlJ+uGtx9VwSj9TmUz7etB
         Kbn6di/TA0/NgXQuF65fl10fledj7T2LYRhOADYLgc4aeSU2h5U43jwU5p3FiZN1hecM
         MPeN347NtQAUYv511NocAgLy5sD+vFjkvRwaZ3G6jWJNhjnb4xCPZT7NugI7wVqqY7EN
         95Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788410976; x=1789015776;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=l0mlOS54FKRStMTSYedi1p7aaRjCgF5zp/ehhypn8MY=;
        b=m8f/28siZ2yE4+40yC0lOXTT88c8o0dZ2lfucS5j3NXS35kLDK21i+/Is9bpTKkVQp
         zq6ygQRwbZov7bs8w8e2kNLhb3H5V1w7hkL9AuEmejkDGGegiUCfmHVhizWjRZK+ezYj
         Sqsj4avlWksDK/cbTDo9HAYUKZewCfIDUooJN/+c+PJB0zKTFMmNsftLSqLmPBQ/KF4T
         Eb81e6pHV34Qq3MV7KAQE218Grw1Z3kA4CgCaNOnYBqvqoDDgNipz5fpCY6lh5c4n2mF
         9moHI78u2SuZwN0HjQgAtNMAtwCl/GrQk4pubfsN0UV8NWuxfnlTSJObPFl/lzsnM82s
         jhEQ==
X-Gm-Message-State: AFuF++m2X9WCdWYJmU4Y67ZGjmyMMd5/PlyEbwI6Qd43s+BO1ul3YnHr
	pVLh2v33vUtZ5q9AriKFND045NBNMVwcbc1oMK3uKC/e9D70dX07sd7WkyDeKC4QdTpomf5xC5/
	pAyKFrP/0zSZiZQoah/FortxUkpB66me/6oCKvn7E+Q==
X-Gm-Gg: AYBFou3tleNxq+f1jI587+9wVf9TyZN1+eJb8aQud7AhJzLSK5UhHdIZBWmsot5QG9s
	Pq5yhZX8rU01kasg0A5ZDL9S8siDhh6a3l7grdZ0O2osjZb1rIvIB8XvghGuzzUNHFGrFPwa3U0
	NxyIGs+quVnh4/z7T8n3KsKLG3xOyB2DUf7fw9u7IEwidioAgDC5S12pFiqiVKSvLRry7RgXyLI
	fOXN0XC6FT9ArfVihitjX5S6HaNyeq4QxlsyN6oIw0iJkqzZwEFCrzeeHOoG3j2lR8T3ORzUOCv
	twWsa1A/saFfGnJnasRUJV5t+E+K1sk6dyhLtfk1kjwribCCAzdy+NvNbZ/CKEPui2KWIQCu/yE
	cEkI3Je9vStuImXHO/LRQ7zG7lPxsSHwzQGA3OjW7ZA==
X-Received: by 2002:a05:6000:2f8a:b0:482:e64d:a1f7 with SMTP id
 ffacd0b85a97d-48488e0371cmr14895217f8f.11.1788410976438; Wed, 02 Sep 2026
 21:49:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902165137.3781696-1-neelx@suse.com> <20260902165137.3781696-2-neelx@suse.com>
In-Reply-To: <20260902165137.3781696-2-neelx@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 3 Sep 2026 06:49:25 +0200
X-Gm-Features: AcwNN1VDTxHl42Z1UbHon5enp5quP2u_4g3m91jG3ZzMwFnTqsQRlff87BfDWkQ
Message-ID: <CAPjX3Fcqyn1dFWqAYqPe+49zGQ3gSqXnet8riqH=-PnaamxaAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: consume the given iter directly instead of
 copying in csum_one_bio()
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Sept 2026 at 18:51, Daniel Vacek <neelx@suse.com> wrote:
> This is just a small cleanup to avoid copying the iter twice in async case.
> We already have a copy csum_one_bio() can consume directly. No need to copy
> again the second time.
> In the sync case we can copy in the caller (as we did before dd57c78aec39
> ("btrfs: introduce btrfs_bio::async_csum")).
>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>  fs/btrfs/file-item.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 581ca5653be9..5a5cffb18922 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -797,18 +797,16 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
>         return ret;
>  }
>
> -static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
> +static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *iter)
>  {
>         struct btrfs_inode *inode = bbio->inode;
>         struct btrfs_fs_info *fs_info = inode->root->fs_info;
>         struct btrfs_ordered_sum *sums = bbio->sums;
> -       struct bvec_iter iter;
>         const u32 blocksize = fs_info->sectorsize;
>         int index = 0;
>
> -       for (iter = *src; iter.bi_size; bio_advance_iter(&bbio->bio, &iter, blocksize)) {
> -               btrfs_csum_one_bio_block(fs_info, &bbio->bio, &iter,
> -                                        sums->sums + index);
> +       for (; iter->bi_size; bio_advance_iter(&bbio->bio, iter, blocksize)) {
> +               btrfs_csum_one_bio_block(fs_info, &bbio->bio, iter, sums->sums + index);
>
>                 index += fs_info->csum_size;
>         }
> @@ -851,12 +849,14 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>         btrfs_add_ordered_sum(ordered, sums);
>
>         if (!async) {
> -               csum_one_bio(bbio, &bbio->bio.bi_iter);
> +               struct bvec_iter iter = bio->bi_iter;
> +
> +               csum_one_bio(bbio, &iter);
>                 return 0;
>         }
>         init_completion(&bbio->csum_done);
>         bbio->async_csum = true;
> -       bbio->csum_saved_iter = bbio->bio.bi_iter;
> +       bbio->csum_saved_iter = bio->bi_iter;

Actually we can use this one unconditionally in both cases and save
the stack space.

And unifying both cases will allow us getting rid of the paramert.

I'll send a v2 shortly.

--nX

>         INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>         schedule_work(&bbio->csum_work);
>         return 0;
> --
> 2.53.0
>
