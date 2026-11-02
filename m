Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635339;
	b=p5Q2C4JscMAn6r6FrWLCbcvVuo4yxlIZgwT+4zbWPADCqVvoFIc3l+KdshgJ7b26B4dF
	 0JrGv6/Co3TbJfxDGjmsxLMS9d1+YuQ+rU9IRiApHbrFfesjDiL79I/uG0Wcr1Zcwaxcm
	 DJIPkw5+bPV4PRaIuehkVL3muvo4vDVk6zbKYa/M6Wn+MJ9JE4Q6F0zEKET8WYS2X2ehs
	 httjusNELNI1znX7XQPuYWAMOpNo/6XDBa+5zJBhXkGMFbFgev9wzz7DGpeRe5xEYTO5I
	 ixNL5M4W1rCcxwcYlOILr7+SPYStvPmf3RzSqrePnAWx/F4NPeysG5qF/4S+sWUGuAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635339;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=my3Gy4VhBcCnxn3lpGePp3/MUKijhn1RD2kN7QnV5ow=;
	b=NOM582adoo50uFyoza6RtbcnczFx9W4/rjaZ8Zgxy0pmg+QIvmoQqioF3CmrnmRIWaIG
	 PE1z36BM/9Dko8zCLiy1f7aOUI18FegFE8nj8dhoOR7/e6sbPy+SrPX0xu4NlFh5ofgXK
	 Q0TAgadOELRxQRMVxG3jAoHS8zOKfkON0YbO4u/gTSx1HF0nw44BXFCnTgju5GodmSLhZ
	 KN01dMe6027VUuXAxaPUGGHkRq9I2WdprqnWoN6nBR7qV1JEk3qj5q1ARl3cniEjPTNou
	 RsDJ0D/15sBaFwsme0gdz3Nt6DlOIVFKUufNk89Xx70OrT+DrsC9nNgCCvaLbQCBMmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJ5U5Pab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C30D606A598
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJ5U5Pab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CAB1F00A1D
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793635339;
	bh=my3Gy4VhBcCnxn3lpGePp3/MUKijhn1RD2kN7QnV5ow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DJ5U5PabOmA/ey/5VjSH6gWp7xcsN6kcQEujnrwH8+5TEy/9vQyT+8QkLM/rdd8+4
	 /9Feok7QwkpV+5tHZ3qaBHqaleIelJ+CJVi9Llm9JosTvkF2T5N6JWsRqkb5YPBk5G
	 egTyxaSZ3B4YcHsINFY9oxatYAUBFFP+UZgN9LwGQMw3qqBKyCaZW9uAjmb8igLIIj
	 b/5z7rAJeWMccktDeDU0dHO3oAYBc48vE5+b/6WYPnL92ynFGemx/G/txA8UiJG/bd
	 mNLD8YCSC95hMpOBhCVE1Zk6FVAB5a80/J2tuLR1sPIu4LhBJ8kyNVwb1FSDkSR5Uw
	 +ZBQv5SmG0j4Q==
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5e948e56af3so1019391e0c.2
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 08:02:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByy4AcvAQwnmpBSwLJPl/NBDfzG97RrljxgatSKbjG5w+qNIzmNLHaRVHZHuz5aX+rXd8FEo5lTGn63Nw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+j/cTVjH3eu7BHr6081oU46Xtyw6GwERxEU60WQrt3jEnRat+6
	ioyFbIG+21CQg0qjfX0j5pJjCpabfWjgT0rYHjQmPS1onROFXAKifdOFIRSVEBEMHO1/6pGnxWv
	p1+bcQ1+CXhLfpbsu6FJ3C5TZwwBtyuo=
X-Received: by 2002:a05:6122:9006:b0:5e9:5e79:ab3 with SMTP id
 71dfb90a1353d-5ec689b817amr4907502e0c.21.1793635338188; Mon, 02 Nov 2026
 08:02:18 -0800 (PST)
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
 <20261030-b4-btrfs-data-integrity-v1-1-f4d4196731e6@toxicpanda.com>
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-1-f4d4196731e6@toxicpanda.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 2 Nov 2026 16:01:42 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6VYYcfH+WHVZW482_6f2EPoyPFE-_qbyPfcS580LhPhQ@mail.gmail.com>
X-Gm-Features: AclHuK_KPgnKhXM8k7V-XuqKmmKo6NZT17VCZXB4CaNbVG-gg0vK1J3OI0FLct8
Message-ID: <CAL3q7H6VYYcfH+WHVZW482_6f2EPoyPFE-_qbyPfcS580LhPhQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] btrfs: don't drop the error of the last split bio
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
> When a btrfs_bio had to be split, btrfs_bio_end_io() saves the first erro=
r
> of any of its parts in the status field of the original btrfs_bio. The
> part that completes last is supposed to load it into bi_status of the
> original bio before calling the end_io handler, but that is only done if
> that last part was successful:
>
>         if (atomic_dec_and_test(&bbio->pending_ios)) {
>                 /* Load split bio's error which might be set above. */
>                 if (status =3D=3D BLK_STS_OK)
>                         bbio->bio.bi_status =3D READ_ONCE(bbio->status);
>
> If the last part failed, the assumption is that bi_status was set at the
> top of the function. That is true if the last part is what is left of the
> original bio. If it is a split bio, the assignment was done to the split
> bio, which was freed right after. If the original bio has completed befor=
e
> without an error, its bi_status is BLK_STS_OK and stays like that:
>
>   original bio (tail)                 split bio (head)
>
>   btrfs_bio_end_io(orig, OK)
>     orig->bio.bi_status =3D OK
>     pending_ios 2 -> 1
>                                       btrfs_bio_end_io(split, IOERR)
>                                         split->bio.bi_status =3D IOERR
>                                         bio_put(split)
>                                         cmpxchg(&orig->status, OK, IOERR)
>                                         pending_ios 1 -> 0
>                                         orig->end_io(), bi_status is OK
>
> The end_io handler covers the whole range, so for a buffered read all the
> folios are marked uptodate, including the ones that were never filled, an=
d
> read(2) returns their content instead of -EIO. For a write the ordered
> extent is completed as if all the data had reached the device.
>
> This can be reproduced with raid0 data on two devices, one of them slower
> than the other and with a bad block, by reading a file whose last stripe
> is on the fast device.
>
> The saved status has the first error of all the parts, or BLK_STS_OK if
> there was none, so always use it.
>
> Fixes: d48e1dea3931 ("btrfs: fix error propagation of split bios")
> CC: stable@vger.kernel.org # 6.12+
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/bio.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2c6234f6182f..fc0b021cdefb 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -127,9 +127,12 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_st=
atus_t status)
>                 cmpxchg(&bbio->status, BLK_STS_OK, status);
>
>         if (atomic_dec_and_test(&bbio->pending_ios)) {
> -               /* Load split bio's error which might be set above. */
> -               if (status =3D=3D BLK_STS_OK)
> -                       bbio->bio.bi_status =3D READ_ONCE(bbio->status);
> +               /*
> +                * Load the first error, if any. It may come from a split=
 bio,
> +                * including the one we were called for, in which case no=
thing
> +                * stored it in the original bio yet.
> +                */
> +               bbio->bio.bi_status =3D READ_ONCE(bbio->status);
>
>                 if (bbio_has_ordered_extent(bbio)) {
>                         struct btrfs_ordered_extent *ordered =3D bbio->or=
dered;
>
> --
> 2.55.0
>
>
