Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E339FCD8
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775561059; cv=none; b=j+FeumK9C3zt7vMWTSWUxpl9wGXCDL+bI6pQmHRA5G9jU8+zWfgm6rEDd8ZC1kA8F9mMjilaP33idPPj961gTjaRVodorDRpEAb0472J7qsv/6vRqEi9N+IEUqzm1wKh6pWZvyEMziSLZHfA4Ki4uWsbReg/KHJ5f4XxYCZDVwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775561059; c=relaxed/simple;
	bh=JpO+0a6hLI0Qipk7dMcNJqLzTtGoylY7t+7+GLGXmaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/KA7o39vpALC/G58TdIn33OIdcv/3dV1r3DhUBEPpk3ifgL0+OyNv9X74nH4uqKSADBiEHG5Ol1iAKmicnl+tE8zdYXvvnU2R4uIm96L5plE28gITO0uE9sFShwQkx8vuythrqc3F1YpR3jvyGlgAJtaUMHi65/cwFleV4ne70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkV4j2Lx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkV4j2Lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D2FC2BCB0
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775561058;
	bh=JpO+0a6hLI0Qipk7dMcNJqLzTtGoylY7t+7+GLGXmaU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BkV4j2LxLCuN4COUrVxSgk0KUoDLbyQHh7XmzCKGpiUHnkWqasE8WXTWOR/ZZYJsh
	 JpXsTPgevQGbdsE4eTYAKB3LlO0vWj6DWOZPFu9M80nAcQH6IWu83z1WMNR5PibMs3
	 qNWHu1AAyvTgJzSTKx0JAQqAQ59AAbTW46fLWkwvYwuGsVhw1DpLFVv5MaYIbr9Ic8
	 aH4oxK9vo6sBBj2xB8h/VgmMLCgty+qKIskdAeCf1FGJlJzR58jrtkd6eQLIVd5aBf
	 TJ3b3e6Id6vEJhrdXBkMLu7SiI2MfV3tDbwhxvGqQubWNe4iWD7x5iBESBzfunH58H
	 kg8GiExPy7DJQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b9382e59c0eso778831266b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 04:24:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YwvW2U8Z2a7TQ0qxRUUf6qPt1uiEilKPBYh7v+USOeWathhNqkq
	HcP6pqWH32pE/WoZxWh11eIFWw4fMRP1eMcGrNjPf0uMERRlj4PeXjIFuF/A5X/p0DvRgrb5w4c
	bGaPjI9Rb1Opv6HZZRJdKxDVFOgteN2Q=
X-Received: by 2002:a17:906:9fd0:b0:b9c:24a7:510c with SMTP id
 a640c23a62f3a-b9c67447fcemr842414366b.1.1775561057442; Tue, 07 Apr 2026
 04:24:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260330033148.696942-1-davechen@synology.com>
In-Reply-To: <20260330033148.696942-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 7 Apr 2026 12:23:40 +0100
X-Gmail-Original-Message-ID: <CAL3q7H60TA-pZAzh33UpRNQkDesO9URLRwq1AA0a2RqhvnS9xw@mail.gmail.com>
X-Gm-Features: AQROBzCUmxrEXpBInl5htSOcwaT1NgOrJnsJZR9fJzcihCjM65Ly6c6TcRgwp8s
Message-ID: <CAL3q7H60TA-pZAzh33UpRNQkDesO9URLRwq1AA0a2RqhvnS9xw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: skip clearing EXTENT_DEFRAG for nocow ordered extents
To: Dave Chen <davechen@synology.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, cccheng@synology.com, 
	robbieko@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 4:32=E2=80=AFAM Dave Chen <davechen@synology.com> w=
rote:
>
> In btrfs_finish_one_ordered(), clear_bits is unconditionally initialized
> with EXTENT_DEFRAG.  For nocow ordered extents this is always a no-op
> because should_nocow() already forces the COW path when EXTENT_DEFRAG is
> set, so a nocow ordered extent can never have EXTENT_DEFRAG on its range.
>
> Although harmless, the unconditional btrfs_clear_extent_bit() call still
> performs a cold rbtree lookup under the io tree spinlock on every nocow
> write completion.  Avoid this by only adding EXTENT_DEFRAG to clear_bits
> for non-nocow ordered extents, and skip the call entirely when there are
> no bits to clear.
>
> Signed-off-by: Dave Chen <davechen@synology.com>
> Signed-off-by: Robbie Ko <robbieko@synology.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good. Pushed it to the github for-next branch, thanks.

> ---
>  fs/btrfs/inode.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index f643a05208720..80daf7e248ab8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3203,7 +3203,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_e=
xtent *ordered_extent)
>         bool freespace_inode;
>         bool truncated =3D false;
>         bool clear_reserved_extent =3D true;
> -       unsigned int clear_bits =3D EXTENT_DEFRAG;
> +       unsigned int clear_bits =3D 0;
>
>         start =3D ordered_extent->file_offset;
>         end =3D start + ordered_extent->num_bytes - 1;
> @@ -3214,6 +3214,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_e=
xtent *ordered_extent)
>             !test_bit(BTRFS_ORDERED_ENCODED, &ordered_extent->flags))
>                 clear_bits |=3D EXTENT_DELALLOC_NEW;
>
> +       if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
> +               clear_bits |=3D EXTENT_DEFRAG;
> +
>         freespace_inode =3D btrfs_is_free_space_inode(inode);
>         if (!freespace_inode)
>                 btrfs_lockdep_acquire(fs_info, btrfs_ordered_extent);
> @@ -3345,8 +3348,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_e=
xtent *ordered_extent)
>                 goto out;
>         }
>  out:
> -       btrfs_clear_extent_bit(&inode->io_tree, start, end, clear_bits,
> -                              &cached_state);
> +       if (clear_bits)
> +               btrfs_clear_extent_bit(&inode->io_tree, start, end, clear=
_bits,
> +                                      &cached_state);
>
>         if (trans)
>                 btrfs_end_transaction(trans);
> --
> 2.43.0
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>
