Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111143;
	b=F0y26hkjqQYnIiTJ7yrBcEzcYqRHQjl4jLqIxLqbH6Rq83UxK2BOgYlADefehbTV3LOk
	 Y/qcRCArbLILlPPGbs82itoCAdXWiiNe7EMcRYfLx3t+ztlWTobba5BPk80h37510istJ
	 qENkbtOpHAGz69iDigwsJqfAA8C6XPiR7zpUOV4dAqGlY5u6gF+I8p1qEcEYnQNL22kbU
	 uZTYbQpE2g3E4zKgGi/miPBCqvlNH1aId/9O5QctWKR3geJ8cIzWtx2Zcnhwegs4hJyEn
	 /GX8aWjQ3fIuSR4dWjtEguAA5v2/mxZ6og09S+MPjCBRJ0L5aUg4hpzlOR5f4zpM7eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111143;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=s7npAINni3dlvyd2joYzfLM/wx6v6yTUThILXLH9+YE=;
	b=tvR5u52akJppDhSqy+gkj2n4vqOs/nH9pKPEX6iNh/k0KrrCIY5SyfAGxzn7lEyyFkPI
	 QLAtDOFKBZk4CiPFs1VUlZ3zCokJiUg3J1KXuFaTMUhsdmPZ9PC+CsXAhzVPAQuhNBEL/
	 gqHMVVF+AspJwruGYVhF93DpK4g6//CnO9AEX9Re3XFWPNUvZlSQq43hsf9uIgqCk5sgr
	 ULyw6BGTWAhXNrgSKjY84FlUTJsj6lvtxzU1UZ+QRw94RgFyrJe3N8xdNLsfSzV3NtX6D
	 fCn41Fve6r3EltG5bSfcS0o3s3t2v01nW4aG9YurXVw6VsuK5fwV1tcTyR/8KXrbORQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlhCqgQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7486C606A334
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlhCqgQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189171F000C8
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795111143;
	bh=s7npAINni3dlvyd2joYzfLM/wx6v6yTUThILXLH9+YE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JlhCqgQczMTaJY1WUFah4muhhQqclMvtpGs3NRl3IFb70bD0JNrpwkLbV+c9I7in2
	 zDpuOyBApuvhRVbhVW1J3fTinyqCw7rnOaB/ZGO3ph2vlbsPTwSHqZbPptBUVPTNbX
	 vnsIthjZiWxg3fYXDv/CoS4PxfMrfZXEWOVt6Ki0cmSvYlmaYGdg3O7YXk71xxwilh
	 +5/Rwpf96Ax2ldBG4B4ydnqDRGTg8ttTTYABVpOpDIIED4HuPjMavOpU2LSwU+pQ4k
	 6Ly4Ld1/f+K8m4u4dVDYqLkfq6Ab6Kc9BjkbYnO9scZ+ATYgN8M3+9t4HzieHgKIGO
	 WqheKTUvFsCnA==
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-99ac154431bso18070241.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 09:59:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE+1q8neQdz9LBPI0r5Fg8UV63iP7GjqhZ7ZAzy64nYzuRiu4skjigNgCa85BSes1B0nCGvnyyhziQ3Sg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+joVit3JXPU6apxXqZIkUCFs4dUXsuGun97IRL+fxEb3MuwvCT
	Y9Oz/rw0QLtHslcRDDOdheMBeXZPL4G3BwkDTaXh7EXHtNYHOkeeJqKst8QhEezkJgT/SzGJ+84
	LSUQHkUkNn+42hLw7/L8fjMuqvCTwCX8=
X-Received: by 2002:a05:6102:5811:b0:7d2:76af:fcce with SMTP id
 ada2fe7eead31-7d7393c88e2mr104268137.9.1795111142173; Thu, 19 Nov 2026
 09:59:02 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119151750.4178311-1-guolingxing@tju.edu.cn>
In-Reply-To: <20261119151750.4178311-1-guolingxing@tju.edu.cn>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 19 Nov 2026 17:58:24 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6uS-nzby8Q9hGp=MdEoyBYK0kx0p1xOLd6mzkeSkk+mQ@mail.gmail.com>
X-Gm-Features: Aa3M54p5Z_gDLuSV47P-48yb74LhRiWbt-pwpwajiD2M4FFDOZHo3Htg8cgqCvg
Message-ID: <CAL3q7H6uS-nzby8Q9hGp=MdEoyBYK0kx0p1xOLd6mzkeSkk+mQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: report writeback errors on initial COW allocation failure
To: guolingxing <guolingxing@tju.edu.cn>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 3:25=E2=80=AFPM guolingxing <guolingxing@tju.edu.cn=
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
> Record the error before ending writeback when the first COW
> allocation fails and no ordered extent exists to report it.
> With the fix, fsync() reports ENOSPC under the same fault
> injection.
>
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> ---
>  fs/btrfs/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index abaa334714566..3329a104a9072 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1455,6 +1455,14 @@ static noinline int cow_file_range(struct btrfs_in=
ode *inode,
>         return ret;
>
>  out_unlock:
> +       /*
> +        * If the initial allocation fails, no ordered extent exists to
> +        * report the error. Record it before ending writeback for the
> +        * failed range.
> +        */
> +       if (start =3D=3D orig_start && !cur_alloc_size)
> +               mapping_set_error(inode->vfs_inode.i_mapping, ret);

Having such a condition seems ad hoc.

The problem is that when we try a compressed write, we do it in a
dedicated thread, and if we fail to compress, we fallback to COW mode
and end up in cow_file_range().
There if we have an error we don't call mapping_set_error() except in
some special condition, which is often triggered when we fallback from
compressed to uncompessed (like in the scenario you describe).
For writes that never go to the compressed path, it's not a problem
because extent_io.c ends up calling mapping_set_error(), but for the
fallback from compressed to uncompressed path, that does not happen.

Just uncondionally call mapping_set_error() in the error path and
remove the existing special case:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 347e5e295fa7..0ec27a364315 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1440,6 +1440,7 @@ static noinline int cow_file_range(struct
btrfs_inode *inode,
        return ret;

 out_unlock:
+       mapping_set_error(inode->vfs_inode.i_mapping, ret);
        /*
         * Now, we have three regions to clean up:
         *
@@ -1462,9 +1463,6 @@ static noinline int cow_file_range(struct
btrfs_inode *inode,
                clear_bits =3D EXTENT_LOCKED | EXTENT_DELALLOC;
                page_ops =3D PAGE_UNLOCK | PAGE_START_WRITEBACK |
PAGE_END_WRITEBACK;

-               if (!locked_folio)
-                       mapping_set_error(inode->vfs_inode.i_mapping, ret);
-
                btrfs_cleanup_ordered_extents(inode, orig_start, start
- orig_start);
                extent_clear_unlock_delalloc(inode, orig_start, start - 1,
                                             locked_folio, NULL,
clear_bits, page_ops);

This is simpler and saner.

Thanks.

> +
>         /*
>          * Now, we have three regions to clean up:
>          *
> --
> 2.34.1
>
>
