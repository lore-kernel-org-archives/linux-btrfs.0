Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902201;
	b=eZ14QJ65AUiyT29TNxvegJYi7kUg1jcxoi9o6TEbI0BKQ5K0Dw3Ah1VBj3+GcYtvKtTV
	 7DfzmVbFp52bJnsvjB5D0Hknbz3K8hkMixNqHhfhIz4BZPAqSsmRRE8b3tWXtVvv6r+x1
	 j2hC8F+VNih0TGDQO3sSwa3ZH+ZCkvr2Ep9yLFpRHpLFGIYRlkT7lWtYoiNZHrmTHn2Zb
	 +UnxAPBlqjaDBZ8HMZYlpoyW0pOzkWUo56rtjkc14ozrot3gLiByZN2B1inQpt71xlfUi
	 QwnNrPDfEimd31l427vbiWrkLkHykLxrhsyDE1YpmcFhkQruelL+7orkxDm5QmwoVog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902201;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=svzwUjpzc18bNmCn2FtBgFSJLBlcU9pJ6jkD+JU6xOQ=;
	b=Tmr4qwdcLOViQCcmGcqX/QrIVPycbMsMRcnYg/m9DF9+bCjiOQNvL/Zs/HkJKP7FqmHz
	 5qJdLox/q3m71HJVfs/KWFyYHSQazlkvfkx0zOTI/+9uOo01WC4xqVQWv55EyIHsfcx9i
	 0+8BdjX3RhRs+CLdLsRI0Cn+LOZN/zHYKrfbXL08zYZsUCNrc6H+TiCbV0iDWNaYkdrYk
	 3CvZm0YWgqFTiLhdseTQMASWnlr4avVinU4N2dgc61Kbdi+pMwWKpDsJnJFTm/yXVvMmr
	 m7msCqg1c5rGVidf6/bmJcm+jjopdRsIEqLtgtP9QhlTRkii0yXWMo7tqN2DnTKpt3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T3208Cze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D04B606A31B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T3208Cze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB0E1F00919
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902201;
	bh=svzwUjpzc18bNmCn2FtBgFSJLBlcU9pJ6jkD+JU6xOQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=T3208CzeqIuiRzbM7QpT/xWTWImh68arQ+v6ndTvC+7XDPVKK4R32Ul5XXBcJ0QCT
	 u/fN4OMvM0+7fSgMvjM/ABoq9qVDR6e98tuz2/NhSHvq5Cdp9r7J/UlpNK8UsryAEI
	 n+Q2ZAYQ9YGNuqmFhZErYVMluFGpLy0BMCIpgWnV4HC9VdyHYEoGXvvEYWio9NK7Ts
	 jcRrA6+gPwuTBuVLaYR4y+rkipsFg61i+tmuTV990l0D+3tXexx0ndXaK02YfQrxwO
	 nFmWnz9oZZtjEvqG3ve8/s1rDWza1FB1VmKMjXPQpeNnb5Ei6Rv7ggd3DrxWPnj7Ch
	 k7TG3/3kkomTA==
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-9905d61449cso605620241.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 10:10:01 -0800 (PST)
X-Gm-Message-State: APuU4Z/Jdzi4QlNbEBhwaZ/zAYukG7ZhaWpPX2T3GuvNfNwEAc5IuJVn
	TjUb0Kk6qt6LY9K2+Sy/T0+go6mQq75Na3AGkx7peZ8IgFg9XzXmCw0aRo8btr/sKBsRL4mA9oJ
	PjEm02cWMIII4BkNHR4JIP0jCZJF+5xw=
X-Received: by 2002:a05:6102:c09:b0:7d2:7c8b:3d8 with SMTP id
 ada2fe7eead31-7d2a16e4764mr296525137.36.1793902200356; Thu, 05 Nov 2026
 10:10:00 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <14e0d19262452be0d9e08478f47be08ec6fa6d6f.1793852473.git.wqu@suse.com>
In-Reply-To: <14e0d19262452be0d9e08478f47be08ec6fa6d6f.1793852473.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 5 Nov 2026 18:09:23 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7JCSuTuGvmwrf3ckBwhm-5Wnnub-6C1mXGX=ZTi0Yo8g@mail.gmail.com>
X-Gm-Features: AclHuK_lAODWkSUfpMM9Y4CMvP2n7tJsIk-neBUDYBJRxtqyCZyYuHORCrWGkkc
Message-ID: <CAL3q7H7JCSuTuGvmwrf3ckBwhm-5Wnnub-6C1mXGX=ZTi0Yo8g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: skip fast sync for inodes with encoded writes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 4:48=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG REPORT]
> Sashiko reported a bug that encoded writes can have its file extents
> recorded before their data reaches disks.
>
> [CAUSE]
> An encoded write returns to the caller as soon as its bio is submitted,
> and its folios are not in the inode's page cache:
>
>   btrfs_ioctl_encoded_write()
>    \- btrfs_do_encoded_write()
>        |- btrfs_alloc_ordered_extent()
>        \- btrfs_submit_compressed_write()   <- returns before the bio end=
s
>
> A fast fsync only waits for writeback of the folios in the page cache,
> so it has nothing to wait for on such an ordered extent:
>
>   btrfs_sync_file()
>    |- btrfs_get_ordered_extents_for_logging()
>    |- filemap_fdatawait_range()             <- no folio under writeback
>    \- btrfs_log_dentry_safe()
>        \- ...
>            \- log_extent_csums()
>                \- log_csums()               <- csum_list may be in flight
>
> This has two problems:
>
> - fsync can return before the data of the encoded write is on disk, while
>   the log tree describing it is already persisted.
>
> - With async data checksum generation, the sums are attached to
>   ordered->csum_list by btrfs_csum_one_bio() before the checksums are
>   calculated.  log_extent_csums() can then log zeroed or partially
>   calculated checksums.
>
> For buffered writes this is not a problem, as writeback of a folio ends
> after the bio endio, which in turn runs after the checksums are
> generated.
>
> [FIX]
> Fix it by requiring full sync for the inode which went through encoded
> writes.
>
> Encoded writes are mostly utilized by btrfs-recevice, so it's never on
> the hot path.
> And receveied subvolumes are set read-only, so normally no one should
> even call fsync() on those inodes. Thus the cost of full fsync on encoded
> writes should be very acceptable.
>
> Link: https://sashiko.dev/#/patchset/8eb322321cac98013cc46dfe8d89fa58c1ad=
3dee.1793766229.git.wqu%40suse.com
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog
> RFC->v1: (RFC at https://lore.kernel.org/linux-btrfs/c284dccd8c27a6434e56=
ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com/)
> - Require full fsync instead of waiting for encoded writes
>   The common usage of encoded writes are btrfs receive, so we shouldn't
>   need to bother fsync on those files in the first place.
>
>   And this makes the fix much simpler.
>
> - Drop the REASON for RFC part
>   Which contains quite some incorrect assumptions on fsync() and direct
>   IOs
> ---
>  fs/btrfs/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ab60b7d4f389..65714380a935 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10035,6 +10035,12 @@ ssize_t btrfs_do_encoded_write(struct kiocb *ioc=
b, struct iov_iter *from,
>                 ret =3D PTR_ERR(ordered);
>                 goto out_free_reserved;
>         }
> +       /*
> +        * fsync() of the inode can not go through fast path, as there is=
 no
> +        * dirty/writeback folio in the page cache for fsync() to wait.

Neither there are dirty/writeback folios nor do we wait for the IO of
the ordered extent to finish (bit BTRFS_ORDERED_IO_DONE set) before
unlocking the inode.
The comment focuses too much on this not being buffered IO, which is
somewhat confusing because fsync works for direct IO.

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +        * So fast sync can return without waiting for the data to reach =
disks.
> +        */
> +       btrfs_set_inode_full_sync(inode);
>         btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>
>         if (start + encoded->len > inode->vfs_inode.i_size)
> --
> 2.56.0
>
>
