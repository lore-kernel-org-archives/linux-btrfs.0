Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC1F4E4C4E
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 09:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846009; cv=none; b=lfmdKjOFxezANjr2a5gunFdMuJo+K12H2HIBrO4FUTbG0V1UXCbkVim6kYB//awPbC6PtY3o2fViVozRhDmPIndQNCHZD/gkb6PBbnhhFnVCfuQZ2sxOni8g1eZ9cXQSLnvKvrqCe2Z0rdNUGeALofa9wYtXuV+89V2GbDn9wMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846009; c=relaxed/simple;
	bh=+U64cDZT7ToMCSgN7GhX8/wLnr5qWuSW9VzZc63JcH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oGV62APDdl3T9caCSVCGna6vC4E13XLSPH+zCBnKfv0+hr2WrjXItDrr860fWT3NHF+ti4Yu7gBMrXsxKql1SlB1jAcAtwizNTwehERAMPFbYmEJYvtRA9qBdNypEQpr/0hWEz64MaLywZZ1SzKqgjecDIvoIzYHVU9ZmBXJIbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZICoOhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZICoOhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE041F000FF
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 09:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790846006;
	bh=0Y1pGmqEjuKazOqCGlTyPOQrbisidfuL9CMADMqAeL0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GZICoOhR8aADjOZKcf7yqRwqym8JMkN58rwIUtQuSwHiDs5Maq5mPYUlYFlOKOnBb
	 mNDhABIgAG2ZSRjUl+hTMFWa0+06NmH1bmTeUEaKvEubqy00XPJbc69TP2iB0JD7Q0
	 v5XCnUYZz1rZey/o8JcNnp5Sf3pte6qplPyy+ABxw5kCfjs/B0DvpUGvgVIR8OqoAn
	 dx1ezWeLJjwA8x/bsJ1kNNA2I3eA7QH4hrSYAJrXu5Lvo0sicjEZDx8sm3+4YwCO+8
	 kenopl0rT0B3vgyjTPwe8iFFhXLTabKTH4bFeICC3c/GCxudWbLs6K/HE6Icb6bPhf
	 mulDEWwB8NLbA==
Received: by mail-ua2-f43.google.com with SMTP id a1e0cc1a2514c-988bcf76ce8so1028215241.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 02:13:26 -0700 (PDT)
X-Gm-Message-State: AFq9FYKwkviBOH2sNg8SYVp3gid0R4Uibit3itgl4v/6kOyVHNijMsxc
	yiOP1OVlj8nHr/qEMxEsBWGsSypccpzmB1cpxCiCxOYuFxJ/T8VDGDwUfR9/6c/WKmWIok/jch/
	PwuXPumczt4a7r6GWGQe1rS1EYReboVA=
X-Received: by 2002:a05:6102:4b12:b0:7a7:ce1f:6b95 with SMTP id
 ada2fe7eead31-7be622a45a7mr1095458137.2.1790846005564; Thu, 01 Oct 2026
 02:13:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4ee4d3cf8971d35eb863407808c896d6120bcc59.1790758765.git.wqu@suse.com>
In-Reply-To: <4ee4d3cf8971d35eb863407808c896d6120bcc59.1790758765.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 1 Oct 2026 10:12:49 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6-7FX90GQcv_-AEfqgCOe7eyGWx8166fM+GvK-PdF=-A@mail.gmail.com>
X-Gm-Features: AclHuK9hsVU1wkCBVZFW29Nc9Qq2ysbzZJWb_HQ6DwuuDuIBgLkbIgcSGPjX9-Q
Message-ID: <CAL3q7H6-7FX90GQcv_-AEfqgCOe7eyGWx8166fM+GvK-PdF=-A@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: raid56: do not verify the content if there is
 no data checksum
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Bartosz Fenski <bartosz@fenski.pl>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 10:04=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> There is a bug report that fio can fail to sync the data on a degraded
> RAID56 mount:
>
>  # mkfs.btrfs -m raid1 -d raid5 -f $dev1 $dev2 $dev3
>  # mount $dev1 $mnt
>  # btrfs balance start -d $mnt
>  # umount $mnt
>  # btrfs dev scan -u $dev2
>  # wipefs -fa $dev2
>  # mount -o degraded $dev1 $mnt
>  # fio --name=3Ddegraded-write --directory=3D$mnt --rw=3Drandwrite --fdat=
async=3D4 \
>                 --bs=3D4k --size=3D512M --randrepeat=3D1
>
> The run will fail at fsync:
>
>  fio: io_u error on file /mnt/btrfs/degraded-write.0.0: Input/output erro=
r: datasync offset=3D142254080, buflen=3D0
>  fio: pid=3D2064, err=3D5/file:io_u.c:2008, func=3Dio_u error, error=3DIn=
put/output error
>
> [CAUSE]
> With extra debug output, it shows the problem pretty well:
>
>  rbio=3D2876243968 faila=3D0 sectornr=3D0
>  rbio=3D2876243968 error=3D0-15 csum=3D2 bio=3D15
>
> The first line shows the rbio's full stripe logical, and stripe/sector
> number when verify_one_sector() failed.
>
> The second line shows more detail about the rbio, the sector range [0, 16=
)
> is corrupted, which indicates the first data stripe is corrupted, matchin=
g
> the missing device.
>
> The important part is that the csum bitmap shows the data csum is only
> for sector number 2, meanwhile the failed verification is at sector
> number 0.
>
> This means we did the checksum verification even if no corresponding
> checksum is populated.
>
> [FIX]
> There is already a similar check at verify_bio_data_sectors(), but
> unfortunately there is no such check at verify_one_sector().
>
> Add the missing check to skip the csum verification if there is no
> corresponding data checksum.
>
> Reported-by: Bartosz Fenski <bartosz@fenski.pl>
> Link: https://lore.kernel.org/linux-btrfs/a72409af-45ef-45df-9970-2e38bcb=
22ea6@fenski.pl/
> Fixes: 7a3150723061 ("btrfs: raid56: do data csum verification during RMW=
 cycle")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
> Changelog:
> v2:
> - Fix the calculation in the total_sector_nr
>   Which used "+" instead of "*" for the stripe_nr part.
> ---
>  fs/btrfs/raid56.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 8ec24dbb180f..5ec31299f1c3 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1889,6 +1889,8 @@ static int verify_one_sector(struct btrfs_raid_bio =
*rbio,
>  {
>         struct btrfs_fs_info *fs_info =3D rbio->bioc->fs_info;
>         phys_addr_t *paddrs;
> +       const unsigned int total_sector_nr =3D
> +               stripe_nr * rbio->stripe_nsectors + sector_nr;
>         u8 csum_buf[BTRFS_CSUM_SIZE];
>         u8 *csum_expected;
>
> @@ -1898,6 +1900,11 @@ static int verify_one_sector(struct btrfs_raid_bio=
 *rbio,
>         /* No way to verify P/Q as they are not covered by data csum. */
>         if (stripe_nr >=3D rbio->nr_data)
>                 return 0;
> +
> +       /* No data checksum for this sector. */
> +       if (!test_bit(total_sector_nr, rbio->csum_bitmap))
> +               return 0;
> +
>         /*
>          * If we're rebuilding a read, we have to use pages from the
>          * bio list if possible.
> @@ -1908,9 +1915,7 @@ static int verify_one_sector(struct btrfs_raid_bio =
*rbio,
>                 paddrs =3D rbio_stripe_paddrs(rbio, stripe_nr, sector_nr)=
;
>         }
>
> -       csum_expected =3D rbio->csum_buf +
> -                       (stripe_nr * rbio->stripe_nsectors + sector_nr) *
> -                       fs_info->csum_size;
> +       csum_expected =3D rbio->csum_buf + total_sector_nr * fs_info->csu=
m_size;
>         calculate_block_csum_paddrs(fs_info, paddrs, csum_buf);
>         if (unlikely(memcmp(csum_buf, csum_expected, fs_info->csum_size) =
!=3D 0))
>                 return -EIO;
> --
> 2.55.0
>
>
