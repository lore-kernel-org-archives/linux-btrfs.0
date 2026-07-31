Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288163F65FB
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 11:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499020; cv=none; b=Os+PMoVQObRYXnk+YB+5dUtXrX3CIfu0k+zs/SmUU7pF1mBWjmOwXOE9fNMnB0JTYGiV3UrwV4qFVYdtG3pMoEDaExU9NNDI6ZK+AYAm21UcZZpJFa4PGf4DGg8jB39KyRvicunvdM/gTaYHP/PcBBColl9AsAoewjCDTBUVw7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499020; c=relaxed/simple;
	bh=ApRNz3FzWVQMCuZ6XgLo6gydV9mGNaSyz1BAaUo1H4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lq02/R2TqSGvnq14RPgKDsjFxI/TSo10x27OHA4IdvmtqaWJyUKb8iJUsorcUUgAgF7olgnLBF2O2rMA2geyuVpif0mdNgb572rYhRmYBDr30ovcnnniJCz9UrpSGP0uY7YJdiXS2Zqq8cT3kHTvepEzUoma5K5LVMZGboWsFTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1GKHGCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1GKHGCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40661F00ADE
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 11:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785499018;
	bh=+HnlsQJ3tnor6cbdGME0wtt4wsQOJDX+Bt0sMn99N6o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=U1GKHGCdIAm5jhVBmju3GAymUq5bgF6/9ol2RtG5Dpu0mE4LD5G1zBkOdl6vcag9T
	 UDLQjMte0RQ7BYTPIqhoDZGC2a4Mav0uvwEjMkCRGeifRVWIDZjyROlzVXhbd34Ly4
	 534erzZZmYJOxnFD3gXB2Jd2eD5wC034Dopmg+T45rxIwwDU7b7NJHfOxF7bd0+FRe
	 +Qlug9UEd3sN4x8aEYR0wp28t2NOhBgGzDXXGIe+Kd8c1lQvaGgs/tUeN8/girPPff
	 WXpdhvUqlEvDMVZAVXGqngiYYSaUn0rYOexTj/tsSBneSQj3VSJ2gnb/zex/PM9xYt
	 z5b/MH7F3XOpA==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5bf8e1edc3aso512545e0c.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 04:56:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqGHOigfiVx1iPCX2Qsv6m2lNFXKYKxj52myv3AUCHD4umh2H7V1Bb8WtLIBh1xEVC56YWiD6cnhsM+Ww==@vger.kernel.org
X-Gm-Message-State: AOJu0Yymx2WyAdFlv/Ka8BX/fsie8LdV44WjT41JZha9Ko6XAfCTfyK0
	W1srwPy0g/C6Xcq1ofgPQIdsZU+RXU3mSnC07Ed+TLPf29ZiQOtxHQY30GFxw5t7o8XIfKrmpPs
	qqYbEbg3Nrdca3U03IRkAqr3Ozi3jmf0=
X-Received: by 2002:a05:6122:2210:b0:55b:d85:5073 with SMTP id
 71dfb90a1353d-5c37e36f12dmr582502e0c.4.1785499018011; Fri, 31 Jul 2026
 04:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731-btrfs_kmemleak-v1-1-9600453eef4e@debian.org>
In-Reply-To: <20260731-btrfs_kmemleak-v1-1-9600453eef4e@debian.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 31 Jul 2026 12:56:20 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5P6XngF7O8Pfp_WawazCeq26V+=G7OQnnNLsnD4EbZDA@mail.gmail.com>
X-Gm-Features: AUfX_mzSfc25Hh6uCprxdI-uahMwrD1XOiroRhpR17tsLAfZ_sI0kS20vo37teg
Message-ID: <CAL3q7H5P6XngF7O8Pfp_WawazCeq26V+=G7OQnnNLsnD4EbZDA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix extent changeset leak in encoded writes
To: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Omar Sandoval <osandov@fb.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, jlayton@kernel.org, 
	boris@bur.io, kernel-team@meta.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 12:52=E2=80=AFPM Breno Leitao <leitao@debian.org> w=
rote:
>
> Investigating some machines with kmemleak, I am constantly seeing
> the following memory leak that seems real.
>
>   kmemleak: unreferenced object 0xffff88869f7d01c0 (size 64):
>   kmemleak:   comm "btrfs", pid 1613416, jiffies 4316358595
>   kmemleak:   backtrace (crc ab59040a):
>   kmemleak:     __kmalloc_cache_noprof
>   kmemleak:     qgroup_reserve_data
>   kmemleak:     btrfs_qgroup_reserve_data
>   kmemleak:     btrfs_do_encoded_write
>   kmemleak:     btrfs_do_write_iter
>   kmemleak:     btrfs_ioctl_encoded_write
>   kmemleak:     btrfs_ioctl
>   kmemleak:   ... and 2 more object(s) with the same backtrace
>
> and
>
>   kmemleak: unreferenced object 0xffff88830d94edc0 (size 64):
>   kmemleak:   comm "btrfs", pid 1613416, jiffies 4316358595
> <snip>
>   kmemleak:   ... and 2 more object(s) with the same backtrace
>
> Looking at the code, it seems we don't free data_reserved, but
> we should (!?). I was able to come up with a xfstest test that exposes
> the kmemleak above:
>
> https://github.com/leitao/xfstest/commit/81c83a3fbb20b4ad695055ede7fcb73d=
3ffa2e52
>
> Free the changeset on the way out, as every other caller of
> btrfs_qgroup_reserve_data() already does.
>
> Fixes: 7c0c7269f7b5 ("btrfs: add BTRFS_IOC_ENCODED_WRITE")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

This is already fixed here:

https://lore.kernel.org/linux-btrfs/20260727115352.12622-1-dmantipov@yandex=
.ru/

Thanks.

> ---
>  fs/btrfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0fcbfc3939462..f8ad96256ff67 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9965,6 +9965,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, =
struct iov_iter *from,
>         if (cb)
>                 cleanup_compressed_bio(cb);
>  out:
> +       extent_changeset_free(data_reserved);
>         if (ret >=3D 0)
>                 iocb->ki_pos +=3D encoded->len;
>         return ret;
>
> ---
> base-commit: 95d6a9ccef99117115e41e9adb271243bd5e985b
> change-id: 20260731-btrfs_kmemleak-d44637bd2518
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>
>
