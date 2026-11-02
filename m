Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635387;
	b=mU4t5WFk8f0SJBj8fEkbGiX3Z7G0gQSJAbPiTm5yf3TpAh82BtCklZA9f5RL96v7oNDM
	 W3/SXpvzVPk29/xbFaLdRstHBqyZYWhGA8Mi807VpIJbZMK9kchENEteC7ktB7A4CRws0
	 yXN/3AdnBxDP1cfUo46Ti1CKFmquaB8QW7Au+t/SSc3JmJdFetWyMhGtnM03EHs6toIeO
	 JCneA0XuKzvEy4+alD2I4WS+ZhS6eVhb3wTmW9HG9yEDDE6kByVFkAF1FjzLgfKxQVjF1
	 JbQo21ROekisZD2kg2LWZlsSD9qDJh9bkSJ1Qi0FOY39AExjhiqFgMwtX7PFU7DvEKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635387;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=bZtDBjzgkv5xQcYlp5Yum+2Qy7bTJw3wf4TUeP34ezY=;
	b=XPYCV04nKGlsrZm4/rk0bQlwBNlzDeXaN7v4+XKuwUtjEhI9Tz3w608LrsBoHPeTo/Lh
	 L2O4WnPgwFOTH1y/4GhKGufs6TWhAyw8NiIU+ccazyXuYRD8sxQ7427n48kSbNVnWDa7W
	 8DW9kZFwYmDq5gBowjLGndPTyJZFgPG4btJAZEEs5YXtRU1P30BTiTrPRzw//Go17S3v1
	 tY+4g2rNDNrtcI48M+7LR9Gqd0OzJ5Q1zK9f2KmfcNFvAx8GSQR8L98rQC3E7rSev/plt
	 cwhy1iEzqcDrzYsyS154vzQOzWA9UisbPIqs83o9kFm8F4FHfUppE7ObS++6xdcHmcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNRl1L5s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F47606A5A6
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNRl1L5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF601F00A1A
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793635386;
	bh=bZtDBjzgkv5xQcYlp5Yum+2Qy7bTJw3wf4TUeP34ezY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KNRl1L5s6/wEyvvsLuFpJ6plEXwOmrCadaiQnku6A1vaHVWQtMmYscsY9m4HRFLoK
	 eS7l2l/rzSvw7FCzbD+wftk5ezxRbLYqX1a/7EFKjsl1CClVhwnY9KF7jv0Qcyh2n6
	 vtulGe8hNAvgiXu6HVmquT9II9muR5M2r1GJpFWEDTdW/aEPK/OgvuTgwsbQbv0+v5
	 cucbeCjXYXFaA6zy9XHdqmZNiDyCKvZC4+Di0z+5y0fm6+rhR3iAyEpb28STEOFgLn
	 WkLSK37mZNco1WUUF9HNi0uLmrYzZGbJKpyuIrnnFDZJ+cJHq29ZHfSw4z2auSsRdN
	 3HiDujdROvHSQ==
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5ec690faf85so887497e0c.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 08:03:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw49hJbS0F7GbsET11xELRU1ONNXUJouOWPucx/fqWBvlfQGzfN5aD7wMbg/P6xcuHWglfRXh/Zl4JUvQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+T/YFUNvz/5C4tbSvC9VZ78u+GCkrySTGXZzJPNDua2FL4Sk8D
	YF3qFdnig8B1qOdTVYEtv8jhL2d6upZjVE1kw3Xhl8EhKSmBCVNLMhSuhQEjsYjtD275wXBV2Xj
	E66+COl7dndbpoZ6tmFinXs2XIwpDdNg=
X-Received: by 2002:a05:6122:c88:b0:5ea:d03c:f0e9 with SMTP id
 71dfb90a1353d-5ec68944736mr4322887e0c.12.1793635385467; Mon, 02 Nov 2026
 08:03:05 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
 <20261030-b4-btrfs-data-integrity-v1-2-f4d4196731e6@toxicpanda.com>
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-2-f4d4196731e6@toxicpanda.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 2 Nov 2026 16:02:28 +0000
X-Gmail-Original-Message-ID: <CAL3q7H69Ci=+6xdadWanzMNFwKJXzCzQwgBP2AZNz-GjVkSmKQ@mail.gmail.com>
X-Gm-Features: AclHuK9hJ6ZkQF9NbDoC3yqIUdGKzYNetSEDAGDD0vFFCJQvSJFv8xogAO1abdg
Message-ID: <CAL3q7H69Ci=+6xdadWanzMNFwKJXzCzQwgBP2AZNz-GjVkSmKQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] btrfs: clear dirty blocks after a delalloc failure
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Qu Wenruo <wqu@suse.com>, Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 2:38=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> If writepage_delalloc() runs the first delalloc ranges of a folio and
> then btrfs_run_delalloc_range() fails, the blocks that already got an
> ordered extent are finished with an error through
> btrfs_mark_ordered_io_finished(), but their dirty bits are left set. The
> next writeback then submits blocks whose ordered extent is gone, or is
> about to be completed a second time.
>
> Fix by clearing the dirty bits and cycling the writeback state for those
> blocks, as submit_write_sector() does for a block it fails to submit.
>
> Fixes: 72dad8e377af ("btrfs: fix double accounting race when btrfs_run_de=
lalloc_range() failed")
> CC: stable@vger.kernel.org # 6.14+
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/extent_io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5ff630630490..3283835ccb5e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1746,6 +1746,16 @@ static noinline_for_stack int writepage_delalloc(s=
truct btrfs_inode *inode,
>                         u64 start =3D page_start + (start_bit << fs_info-=
>sectorsize_bits);
>                         u32 len =3D (end_bit - start_bit) << fs_info->sec=
torsize_bits;
>
> +                       /*
> +                        * The blocks are not going to be submitted, so t=
hey
> +                        * must not stay dirty. Otherwise they are writte=
n back
> +                        * later without an ordered extent, or worse, wit=
h this
> +                        * one if it is still around, and invalidating th=
e folio
> +                        * would account for them again.
> +                        */
> +                       btrfs_folio_clear_dirty(fs_info, folio, start, le=
n);
> +                       btrfs_folio_set_writeback(fs_info, folio, start, =
len);
> +                       btrfs_folio_clear_writeback(fs_info, folio, start=
, len);
>                         btrfs_mark_ordered_io_finished(inode, start, len,=
 false);
>                 }
>                 return ret;
>
> --
> 2.55.0
>
>
