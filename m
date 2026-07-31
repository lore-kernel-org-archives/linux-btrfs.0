Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897E534EF07
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 09:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489808; cv=none; b=tjMBw+Y4puZq0ZKLe/WGDiwDGo1lEptV/CCAfKaul+IK2LOTR/xFGMDk+IGEUnmT1l01sD6c3bGNex9840rKOyXL6XST55MxgwOS5P18wCVjdjYsxMjlnn/0Zv0vQnGhsEnCDA5njy80egsMopeFjputnESrYe6yopqrd3kTwjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489808; c=relaxed/simple;
	bh=Jkhfmd5RoNJO8GBdkHzxRgMChg5nXDrYar87mS9cV28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pTg9isb5NAY7QZQHuY5UfZoLelFxfz8LpaGP5XJUw9zQcVGevohhrQ9YQchqwj8m1B6OMzH5zN9WPI9PtCPnDmRjWA3ZsNojcYVbMe1no00ukeF2ayq9Ry4zj+uIQlfgzPzhi+Lbf52wnwxgTyucHlnqax3xztGVNxAeJFAlFQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adntV4Yj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adntV4Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364301F00A3A
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 09:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785489807;
	bh=8KrLAAOAIX6u+3WzGbXmHmMKSVkI+6Zo/BfxjyxiChk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=adntV4YjN/4y6P/2Q/t6Oa/lrPl8x0iTctDzwK0PtEviK+iCdUOTO94eFTQ+xtFQ+
	 fF2VdlBbjn2APDrdSu4Lv4h+Q/SjTF6HoMhuceo2yP6KtHWy+4DdX8MjCFe+TODCyI
	 DSJyBrqtytnthlG/dzV5RB1JHBVfsgGCfeeMkxbtt/tKlqg8JuIuakFZ9NWoreto5S
	 mKewFLykr4Qbucr0CyVdGA9XonBOzsK3boPBDjyNliCQKQqcKsjVSSjOmxiLU4r9Ea
	 mux7y2VT7S9fy75YNLUEkwqfGvN1kb5f1LAJT5+jaDDQNLs2MGhqhkEghEkGALqg2f
	 AkZCVAIudga9w==
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-738bcf9a573so257285137.2
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 02:23:27 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywh7GSE5H3dyoeBZT4Dr5+ywXbUmAPN3KMoMuUdiR9znLC0JkLY
	b64mgqAKwsnf2/pBTdA4z2Ck1UdW01sructEBmEGHLM2M5o1g6kGYJEEwDoxXByAADK+wtG1ZQI
	lse+q0bbw5HiFn5rrfTqG2ckKtdRLwkg=
X-Received: by 2002:a05:6102:3f48:b0:740:22ba:8a4e with SMTP id
 ada2fe7eead31-758f6475cf2mr321601137.6.1785489806416; Fri, 31 Jul 2026
 02:23:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785457950.git.wqu@suse.com>
In-Reply-To: <cover.1785457950.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 31 Jul 2026 10:22:49 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4giGJqO1MmkdF86xQkH2p6QEhU4QUiAwHuppP6muWQ=w@mail.gmail.com>
X-Gm-Features: AUfX_mx-LteUK4e1N4iwm-U16_sInjigXTFCOcUdr4MIc01tZk3EeWftqHgDPA8
Message-ID: <CAL3q7H4giGJqO1MmkdF86xQkH2p6QEhU4QUiAwHuppP6muWQ=w@mail.gmail.com>
Subject: Re: [PATCH 0/2] btrfs: fix generic/795 crash for bs > ps cases
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 1:46=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> During my development of the incoming data_size feature, it turns out
> that we have a new crash triggered by the new test case, generic/795 on
> bs > ps cases.
>
> It turns out that for cached inode items (btrfs_delayed_node) we can
> skip the inode mapping flag settings.
>
> This bug is fixed by the first path.
>
> The second patch is to introduce the extra debug ASSERT()s, which
> greatly reduced the search range by showing the mapping's minimal folio
> order.
>
> Qu Wenruo (2):
>   btrfs: initialize inode mapping flags for cached inodes
>   btrfs: add extra ASSERT()s to make sure the folio size is correct

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
>  fs/btrfs/extent_io.c | 19 +++++++++++++++++++
>  fs/btrfs/inode.c     |  3 ++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
>
> --
> 2.54.0
>
>
