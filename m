Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60DA4DDB48
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168079; cv=none; b=aYRZnRrNhOexa1tx4WTnvGedhZU/NIgFNsKgXem+SQOLRyVgGL+GMepPFmXlVjgRaRHtLGpqSQuNELkjIAniH7eyiNuTXWCP7RanOIJtlF4aXdB4b+TvpU445C+Lgt9bD1n+TmcIIk9d6hvVxEKRTS+E6hWYa3Dffh+1g2qrRzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168079; c=relaxed/simple;
	bh=RIWzGZOC7E8nNysDBvycNTD3HX8kMZZIbBX5tTmn8xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AvbGmyuwqiAPnPWk/7U5cOHH7V5d9E8o5tY2e8aZOfqs/bMqFiimePDkc9Hxx0eWov0V/D8TK5YCC9LSS73Fu7Ga/A9vfndtnDuDPukYXBK+ewOvNxTDO/wSBYn4S8RdxtFZjnwOo39rnI6Dr3z7fUw/Sh/yrk+2tf2ghOAg3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAwbXjN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAwbXjN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E851F000C8
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792168077;
	bh=bvTNFZxkwVQ+f4tMPfaAulKAKSGVujV2MrkQI89X3ZQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aAwbXjN9RDPac5OYFKwgmkhZe1PctB8LsSqUZC2g4rM6mPwyQLt7GHSqKmX8Tg+Vd
	 2U0YZ0gI6bsYdR2bfUzkrnvzpZjoStJWq96Wuj3PHDh33v8Qqg5TeOUlT70br7D2rm
	 xHCRljtwzrK4IqIb1N4KtoS85EFhLDCrWNNKZOY2Rv2kYxoNz5D9Va356jdS3K//rF
	 Cq1sBXHbb20hbZu65Eem30TYJshvLgt44/8TuUX/6whY/rauCPQVDCC6LUH8hzywtg
	 NVu9SjgVugUHYyA3ZHmXGDoLGBXYPSmQIZg5Mg46fSTCMUWpwk/nyw3CKvz6uf/elJ
	 o1rz6xuBTaIWQ==
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-99075306daaso64601241.3
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 09:27:57 -0700 (PDT)
X-Gm-Message-State: AFq9FYIw/C/cY26pTDiwwrYOAt8UdnA/PzFGqXQYex2Jl8e6rS09keal
	6Ql/fPoU8b10rKweGKx19o8Nxta9gtuENv/P2JPYBFTnDGyUb/+LHp3PVttnzP671Kh9DqzZ9Vn
	lBikuLti3l0DY22ugCBuFwMUwoaNElaY=
X-Received: by 2002:a05:6102:448d:b0:7cc:115:ddf1 with SMTP id
 ada2fe7eead31-7cc369f6e7cmr16441137.23.1792168076762; Fri, 16 Oct 2026
 09:27:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792111604.git.wqu@suse.com>
In-Reply-To: <cover.1792111604.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 16 Oct 2026 17:27:18 +0100
X-Gmail-Original-Message-ID: <CAL3q7H69R9ZJ7Qd1O__wvaUw6uyq-GaTfFxdkc5AFUsmAj9dCA@mail.gmail.com>
X-Gm-Features: AclHuK_jyZURkqJoGj6NKE6F-Mlme8b1EvAq8joQncb0NJRpq70Lbu3B28rebZA
Message-ID: <CAL3q7H69R9ZJ7Qd1O__wvaUw6uyq-GaTfFxdkc5AFUsmAj9dCA@mail.gmail.com>
Subject: Re: [PATCH 0/3] btrfs: minor changes related to btrfs_chunk_map
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 1:48=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> The first two are renames of "stripe_size" to avoid confusion with
> "stripe_len". Both names are similar but have completely different
> meanings.
>
> The last one is to enhance the chunk map reading to reject overlapping
> or different chunk maps from the existing ones.
>
> Qu Wenruo (3):
>   btrfs: rename btrfs_chunk_map::stripe_size
>   btrfs: rename stripe_size inside volumes.c
>   btrfs: reject existing chunks that don't match

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

>
>  fs/btrfs/block-group.c            |   4 +-
>  fs/btrfs/scrub.c                  |   2 +-
>  fs/btrfs/tests/extent-map-tests.c |   2 +-
>  fs/btrfs/volumes.c                | 138 +++++++++++++++++-------------
>  fs/btrfs/volumes.h                |   4 +-
>  5 files changed, 83 insertions(+), 67 deletions(-)
>
> --
> 2.56.0
>
>
