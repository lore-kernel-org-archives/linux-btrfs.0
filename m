Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187756;
	b=N7Elr58ULwIwd8mptJ/1DwXZ3161NJmJh0DbYref37U8T2f6hi7o9/jZpu5nZgQtyLs3
	 l02LR6XQnq2zjxa7gPDFfaKsO4bx4inTW86c7PbsQw1qoVu1Mv2rcXGjymXWKKBuTf1/j
	 gTb2lM3Wij/u5OPj5uM7LDeM1m5IP0DokG8lotxeFESd/0lMxQURYI1xl2Xnwogny5FgB
	 09t6pUVUpt5VCdRIB5PIYc8W4NWweD3MCnvq0o3o83LpLDcrMnspUIxb3R4zXDJF+qL02
	 aHtkeBvjWfniWEvlIjSSb/wfZbEWTvXP92XF3E6rQTU2QxYjniZQKEtGBebpa3xhhDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187756;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jKQqUGBTWXyVHon9PHQSIAdr1PbHBbOdcqgOyBga/XQ=;
	b=RsIXqZpwCQh3Q8OGHvg+Bb8tJMKW10RcqIhfvfefJ8Dl2U4jPZMsjEnm6PqD4eM19VYv
	 eTS95OrleRlGiBuRkNxuErjR/Os67wZUGuRzF1Sb/QuTVeZ6Q7H7C3+1J9RJlLCW2NO9k
	 RN3hFt5vNaTO8+SI1r77f1Nilnd/OQOO85xJJD9RmHERDIzQlb4q+xfSvTzA3+aqSef1P
	 ldCk5yhuPPBps1QHwLou0evOdAZTlwBX5d1Lc1fu6HgBdwNuC67sEB57+Uxogk6bb2ILB
	 Wr0UHjNX+JrDCYp3CGAmTuu26UkiIapdime/i+bSektE3Tq5Iyj7P1fRy2rGJTKagoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GfOzgotn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A18606A334
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GfOzgotn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1E31F000CA
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795187755;
	bh=jKQqUGBTWXyVHon9PHQSIAdr1PbHBbOdcqgOyBga/XQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GfOzgotnfvxtL0RmnvzAWLN+r+S8Cy7oiXAPd6PVEzgVgc5R4Jbl5RJAI/HDp2j3n
	 nakzHRZR2qSWnT9HHBFpm21j3M5CikCN63CI1aPc899uW5Vn8b6CDXkVt71Cmwr1yO
	 zA9BHHFfyADOJcsbpJKOH8J4O+tySOMXRnyY52y7lTvvjlzekM15CU2tkT5XXL0Trt
	 ZHCGjchi59tgWZcq8yFuKJ4+wUPdV6I5iVMABZvfSR7HXvevRAeNiDSA5WO+RnH7dg
	 Cd0geqisfFGwRLxGgTZBcPJoNcEPo+pd9ABM8oT8aNsf6YkBYUEm3W/0tAUoFZsFEC
	 vr41ubeKbtWsw==
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5ebf39def3aso337391e0c.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 07:15:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF+2GFO5hy4+4rBYN9OB4jGFs+iegQW+p/OEWxID5PxR6zkF7+wJ2TrWaw9cnqrflfE+wwbX+aV14hT6g==@vger.kernel.org
X-Gm-Message-State: APuU4Z8DNBY524r4QvWRLaW/DLMUsHng7hQLG2gT/il6FODI2ufpZ5Nf
	RRdSHf3XA7Xn8NffrF57QUhuMU020dPna+iNdyT+IXk/jf/PsIQj2Nu/nldouqHsqskAhNJdYG3
	vsGig5DBXpZRwBvLruyKZ4gIuJaW+ZmI=
X-Received: by 2002:a05:6122:338d:b0:5c9:66f7:2f23 with SMTP id
 71dfb90a1353d-5ee8ade9c12mr1506717e0c.2.1795187754189; Fri, 20 Nov 2026
 07:15:54 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119151750.4178311-1-guolingxing@tju.edu.cn> <20261120014059.1476966-1-guolingxing@tju.edu.cn>
In-Reply-To: <20261120014059.1476966-1-guolingxing@tju.edu.cn>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 20 Nov 2026 15:15:18 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5RGt9DQULPUndz8yex-s+kwPfrBYCgP10En6fTmAXphQ@mail.gmail.com>
X-Gm-Features: Aa3M54oCTfTzm4fb9XdeoJms1oGXeDX3wtHEcBmK3h6nHvkXXc4fdeTkbfaD4jM
Message-ID: <CAL3q7H5RGt9DQULPUndz8yex-s+kwPfrBYCgP10En6fTmAXphQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: report writeback errors on initial COW
 allocation failure
To: guolingxing <guolingxing@tju.edu.cn>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 1:41=E2=80=AFAM guolingxing <guolingxing@tju.edu.cn=
> wrote:
>
> When compressed writeback falls back to uncompressed I/O,
> cow_file_range() can fail to allocate the first data extent
> before any ordered extent is created.
>
> In this case cow_one_range() returns the allocation error
> without recording it in the mapping. Since no ordered extent
> was created, the ordered extent cleanup cannot report the
> failure either.
>
> The remaining range is then cleaned up, clearing delalloc
> and ending folio writeback without recording an error.
> The error eventually reaches submit_uncompressed_range(),
> which only logs it.
>
> As a result, fsync() can return success even though the data
> was never written to disk.
>
> This was reproduced by injecting -ENOSPC into
> btrfs_reserve_extent() on a zstd-compressed filesystem.
> A 1 MiB buffered write was split into eight 128 KiB ranges,
> all failing their initial COW allocation. fsync() returned 0,
> and the entire 1 MiB read back as zeros after dropping caches.
> The same test without fault injection preserved the data.
>
> Record the error in the mapping unconditionally when
> cow_file_range() takes its error path, before cleaning up the
> remaining ranges. Remove the existing conditional error
> reporting from the cleanup of previously allocated ordered
> extents.
>
> With the fix, fsync() reports ENOSPC under the same fault
> injection.
>
> Suggested-by: Filipe Manana <fdmanana@kernel.org>
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Pushed it to the for-next branch on github, thanks.

> ---
>
> Changes since v1:
> - Report the error unconditionally in cow_file_range()'s common
>   error path, as suggested by Filipe.
> - Remove the existing conditional mapping_set_error() call from
>   the ordered extent cleanup.
>
>  fs/btrfs/inode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index abaa334714566..214d6f9446adf 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1455,6 +1455,8 @@ static noinline int cow_file_range(struct btrfs_ino=
de *inode,
>         return ret;
>
>  out_unlock:
> +       mapping_set_error(inode->vfs_inode.i_mapping, ret);
> +
>         /*
>          * Now, we have three regions to clean up:
>          *
> @@ -1477,9 +1479,6 @@ static noinline int cow_file_range(struct btrfs_ino=
de *inode,
>                 clear_bits =3D EXTENT_LOCKED | EXTENT_DELALLOC;
>                 page_ops =3D PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_EN=
D_WRITEBACK;
>
> -               if (!locked_folio)
> -                       mapping_set_error(inode->vfs_inode.i_mapping, ret=
);
> -
>                 btrfs_cleanup_ordered_extents(inode, orig_start, start - =
orig_start);
>                 extent_clear_unlock_delalloc(inode, orig_start, start - 1=
,
>                                              locked_folio, NULL, clear_bi=
ts, page_ops);
> --
> 2.34.1
>
>
