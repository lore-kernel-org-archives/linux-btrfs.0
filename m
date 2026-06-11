Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0943EDE61
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 13:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186318; cv=none; b=gc9lEofwPVXT+JQW/WhPnlb68rZ11OjBORurqAi2dAYtTS2cVJRP8nXnitfmcJzaaWTNiqF1We/Slf+z7WZUiFFvsDOX2bDhSHWJWG0uNcjj42LqQ9nzo5PGhSQQM71LDj2SeH0oR+STajVuChZ+tYoxKV6CBxCLx3nrA945qpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186318; c=relaxed/simple;
	bh=xIJdNAINqMHY3wozYjPB/A3uLvZ4O8AYKbA3/Mtoyjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lmPo+TnDWX+zFzYKapD5n+Nbtb1ubEcwYcaC1Lid2bMGsuVynTdBxqzrlG19N/GwynXfwP5pLDhCZWrYN34GaN+22Jvjx2rxWYLa8rir4ft5q+FJ3E2nupZO60/SM1FG0+E02/ecc8kSyE28eBgYCxRGaWBCSbrBGLP/bs5o5yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUxdJjvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUxdJjvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E691F0089E
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186317;
	bh=qt0rAO3O4OzD7kus6DSawT6EwGSm1ycFDJui1h2LqMM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LUxdJjvyIcJRPgXd/+MNJN8uGfhJrjnibJ6v37ZBFA36E16aoiH97y+qCSQQDziFi
	 IQwCrEE9RyTqnm+CV0OHLrkLelC+Z5+Js3VqyXqB7YQnjPIDujdjw/jxdYMwKAVfpb
	 OCklcyjRL7WeKtDexn5zKEWoPpxpsZYpkJj+nyKRLgN9eKUUsFgVNhhj3xMkg790yd
	 txHVvGD+QdQSmPwK6vRTnONx6Q8PLer2EeEkiMjZ/n1hljE/NCDz4sIwK1IY61ACRF
	 8xBGM/QRtfH8EgGcYEXkQO6ZBZcAAaXyS7lRduxctIAIQf4wCUy/RA1PDyTHIMrTJU
	 BJ4EDxe5Qer3g==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bf0170c80f7so1379644166b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 06:58:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+Kg3iuvv4unR3fHD2LLry9Vfz+8yZMJYpLytKOCrZdvLtIDrdffpBB6UA1HXnnOEi9KuEDZujNpWlE3g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy57Vz4ltoDsixl5TKzocbq6kSrQde0MgQ42MYi4pAcsnSAY8lM
	e3K1D5WzO0OhZw53RBXLR4cRsO5l4bXjfezFz8KoOXQpHP/eqSiqiciljXe7Kkox+fT5FSwlh4Y
	b44IunrOKXFlNMP2dNwurobmI9L3jzdA=
X-Received: by 2002:a17:907:b09:b0:bed:a7d7:82c8 with SMTP id
 a640c23a62f3a-bfc889552fcmr97629666b.37.1781186316400; Thu, 11 Jun 2026
 06:58:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611132450.971236-1-runyu.xiao@seu.edu.cn>
In-Reply-To: <20260611132450.971236-1-runyu.xiao@seu.edu.cn>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 11 Jun 2026 14:57:58 +0100
X-Gmail-Original-Message-ID: <CAL3q7H46-8+f9MGbQYpB8k7HTyzA6Fy53_TZ5UStT00buPqHFA@mail.gmail.com>
X-Gm-Features: AVVi8Cf6TYXZDXzFEtHvShl-L8W5UnyyVCpjWZTo4fEuSHH9NhcD7cY_G45ryIc
Message-ID: <CAL3q7H46-8+f9MGbQYpB8k7HTyzA6Fy53_TZ5UStT00buPqHFA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: zoned: protect sb_write_pointer() reads with
 invalidate lock
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	naohiro.aota@wdc.com, linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 2:33=E2=80=AFPM Runyu Xiao <runyu.xiao@seu.edu.cn> =
wrote:
>
> When both zoned superblock log zones are full, sb_write_pointer() reads
> the last superblock page from each zone with read_cache_page_gfp() to
> compare generations. Those reads go through bdev->bd_mapping without
> filemap_invalidate_lock(), even though the same zoned discovery flow
> later reaches btrfs_read_disk_super(), whose final read already takes
> filemap_invalidate_lock(mapping).
>
> A running system can reach this while mounting or scanning a zoned
> filesystem whose superblock log has both zones full. In that state,
> sb_write_pointer() performs two unprotected page-cache reads before
> btrfs_read_disk_super() does its later protected final read.
>
> This leaves the early discovery reads outside the same synchronization
> domain used by set_blocksize() when it changes the block-device mapping
> geometry. As a result, read_cache_page_gfp() can race a concurrent
> block-size/layout update on the same mapping and see inconsistent
> geometry across folio allocation and mapping state.
>
> This issue was found by our static analysis tool while scanning
> read_cache_page_gfp(bdev->bd_mapping, ...) sites for missing
> filemap_invalidate_lock() coverage, and then manually audited on Linux
> v6.18.21. The same synchronization requirement is already enforced for
> the final read in btrfs_read_disk_super().
>
> A focused QEMU KCSAN test then raced the zoned superblock discovery
> path against a set_blocksize-style mapping update on the same
> bdev->bd_mapping. It reported a race between
> blkbszset_update_mapping() and read_cache_page_gfp(), with the read
> side reaching:
>
>   sb_write_pointer()
>   sb_log_location()
>   btrfs_sb_log_location_bdev()
>   btrfs_read_disk_super()
>
> Add filemap_invalidate_lock()/unlock() around the two
> read_cache_page_gfp() calls in sb_write_pointer() so the zoned
> superblock discovery path uses the same invalidate-lock contract as the
> final read in btrfs_read_disk_super().
>
> Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONE=
D mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

There's already a patch for this, and it's in linux-next:

https://lore.kernel.org/linux-btrfs/20260521122945.524890-1-lkangn.kernel@g=
mail.com/


> ---
>  fs/btrfs/zoned.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index e14a4234954b..edc797a43fb5 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -130,8 +130,10 @@ static int sb_write_pointer(struct block_device *bde=
v, struct blk_zone *zones,
>                         u64 bytenr =3D ALIGN_DOWN(zone_end, BTRFS_SUPER_I=
NFO_SIZE) -
>                                                 BTRFS_SUPER_INFO_SIZE;
>
> +                       filemap_invalidate_lock(mapping);
>                         page[i] =3D read_cache_page_gfp(mapping,
>                                         bytenr >> PAGE_SHIFT, GFP_NOFS);
> +                       filemap_invalidate_unlock(mapping);
>                         if (IS_ERR(page[i])) {
>                                 if (i =3D=3D 1)
>                                         btrfs_release_disk_super(super[0]=
);
> --
> 2.34.1
>
