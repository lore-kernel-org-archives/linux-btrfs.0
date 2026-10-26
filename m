Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005831;
	b=h6p4QYriKMJOUtweqSwN8QZst5C5Hxv7usVcNRR4+Pq1PSgwyb8HHfBC3dJg6EYx5x4T
	 QX2X4bRuI2FXaqWKW0uVLeMKuVRcm1GCKHzQaWr/APblZY480XReEioT5cDfHNaUI7B4q
	 1nGeA9WM0vkV+yUda/NB282OIu5Qqe6EBE+B/w51thmod9khyTe+aKyy5EQcqfKg6zAgY
	 OL8Wrbx0nnCJLfyLmWCKKj71/CQcAXNWvT9+foR4C4VHIKTmq8wo6zYxEqHiiUSKY6S+9
	 JgaBYz3v4n20QI8IREIhguT8EN511vfOTVs6GiZNgZGy+NdKwAEgNUrYCjtiTbx2FHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005831;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SVu1DeEO1ETbeCmNztnv6Ojujj6Uh2JAgOnpKOwVVKc=;
	b=erEXRYZaYzYjRtdbAgxhmaf+zX7n4uFwOXiFlegfzESDXV7cg+6Izc2WgezklYqlmhjc
	 rvXvQBfJXTGxf/gCsDhr3k5ePsy9kmkIzPoRQSoumOf83EqLDksew0UumK4FYM7+V/T0h
	 izOY+SzBwDSNKUtdO/6fiOQhVxNfMii0S7NH4jZGKLyoqebaSl/y9tyF8S9s4iP0AJV0f
	 Xb6bvSEL6zY5RvSt5BdwdK5ac5vP2MTCVN+oYI4XpmfuxwuffPC7YwLQilWw67Z8d66L1
	 5FCkSTynE5njsVKxk1PNo5JAxule7NgKws7Zc2HT/hbobXrSnJsK4f4LozjGCgJ0/0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnTYDEkL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C450606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 09:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnTYDEkL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234A51F031E1
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793005830;
	bh=SVu1DeEO1ETbeCmNztnv6Ojujj6Uh2JAgOnpKOwVVKc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jnTYDEkLhzMMevVmdYW2nBzxjrBRKN7AjzcRREch2Kwm3Ldue13VRQ2UEgP1fex+G
	 5VBr6HtFZ9aOyXPIg5vi/0m3SWkGWDa1Tlx5Hv2bTuBT3Xjdu7nCR6jNAtonMSsKAa
	 BwzNszaFa9jN/FXDxUNi4hRl+gkglb2VGHSd6XagcFN0YLoUWoiGN8OMNvTb7isVi3
	 tqw7imfWNWn6pS6g8/SfceVnuZ6WUER68PBPNtMiVFi0VVt1fLShodQ8eH42Q7VAwy
	 Y8E7kdVzZp/6H2DVGri/UptzZ+YSFF8c2BlYTvKRLPzK2HloITgmmcvXLsTBpMDBSp
	 EdklBtGFJ1new==
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eabf7d5bbeso2771301e0c.1
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 02:10:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz6m5BeeNVbILMyqWjNXh31mbJowPFPLV1mL0Np92O2px4DJeTZGU7sxMEu0e7iC/OmS2+OAfSwKaKXWg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKkjerKkkzQJfXthpa6W8MgxqJLkBiBi14pgeSxssBladkzygEc
	IUkQGdk1LNmdTtMQqrMx2WpJIY6kFknSRQf/9jR38fLvZEYzcVlqSphDP8TwQmmGHGzCUXEPdlE
	dPxPsuP3WzIJKDFO1quxlQuqa5rvlIYM=
X-Received: by 2002:a05:6122:218e:b0:5ea:bfe3:6035 with SMTP id
 71dfb90a1353d-5ec23239b28mr1869905e0c.8.1793005829306; Mon, 26 Oct 2026
 02:10:29 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261025180304.349254-1-teel4res@gmail.com>
In-Reply-To: <20261025180304.349254-1-teel4res@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 26 Oct 2026 09:09:53 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5v8Q-8Be2eRKszfmi4Rh4oLmuOP8dWWfTprRb8VbHxdw@mail.gmail.com>
X-Gm-Features: AclHuK-nKpWzWnf_ehGUOGNEqkLBaBeTpBcvTscSsSlzGy6A2o8V0eQ6wgxgdPQ
Message-ID: <CAL3q7H5v8Q-8Be2eRKszfmi4Rh4oLmuOP8dWWfTprRb8VbHxdw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: return an error for unrepaired RAID56 scrub sectors
To: Cheng Yongkang <teel4res@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 25, 2026 at 6:05=E2=80=AFPM Cheng Yongkang <teel4res@gmail.com>=
 wrote:
>
> scrub_raid56_parity_stripe() returns the leftover value of
> scrub_find_fill_first_stripe() (0 or 1) when it detects unrepaired
> sectors in a data stripe.  Scrub callers only treat negative values as
> errors, so the unrepaired state is masked as success and P/Q
> regeneration is skipped; a device replace can then copy corrupted data.
>
> Return -EIO so the unrepaired sectors are reported and the corrupt
> stripe is not treated as healthy.
>
> The masked-success behavior was reproduced 3/3 times: baseline scrub
> returned 0 with "finished ... status: 0", left P/Q unregenerated, and a
> device replace copied corruption.  With this change scrub returns -EIO
> and the replace is canceled; healthy RAID1/RAID5 scrub still succeeds.

This information in the last paragraph is rather useless.
Rather than state the obvious, just check why we were not returning an
error when we should have. If you checked the git history, you would
see this is a regression.
Also, add a Fixes tag identifying the commit, as this is a bug and
should be backported to stable kernels.

You should also check the for-next branches (in kernel.org and on
https://github.com/btrfs/linux/commits/for-next/) before sending
patches, as this issue was already fixed:

https://github.com/btrfs/linux/commits/for-next/

>
> Assisted-by: LLM
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
>  fs/btrfs/scrub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 479c0e0..ba2e27c 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2250,7 +2250,7 @@ static int scrub_raid56_parity_stripe(struct scrub_=
ctx *sctx,
>  "scrub: unrepaired sectors detected, full stripe %llu data stripe %u err=
ors %*pbl",
>                                   full_stripe_start, i, stripe->nr_sector=
s,
>                                   &error);
> -                       return ret;
> +                       return -EIO;
>                 }
>                 bitmap_or(&extent_bitmap, &extent_bitmap, &has_extent,
>                           stripe->nr_sectors);
> --
> 2.34.1
>
>
