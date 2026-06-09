Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACDE416CE8
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 13:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781012218; cv=none; b=YQAGClnqyx2HNR8Kg2gwsDum8IACLukBeqD+tAsrtJS6ZOwBIAmo2sW0heds+jCdcDx9DsscYDe9CJ2/DjSdVwqV5tav/OnZN/otKJKldlArBHw6K+p75TpREPmE/lvZ4YhPORFOs5EN9fmRU0KS5RBNoVWtX5F7zLznCssooLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781012218; c=relaxed/simple;
	bh=oTue5Qm9lIKGrPwGYq4HQ5n75jhFgHX2Mr6kgTa4SUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qj9t3EYJbfIBGSL3FsMN2jOg+QfGKeQk78ISypHcwSchjxW4kF5l0IsltwIYryl0V9NbpFJ7fvPChVLsehdaRzaJzgQKs26KXx67aSp9w79w00pbGij/ISjOHOvtglXiU83NU4R7uJb/pqo/qR7cWGs5HkdEeT1yELEWqKlN2m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAKsPxLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAKsPxLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7EC1F00893
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781012217;
	bh=Nj5VOpe5oIvhvRURdM7OWjVIaolD6e1dVicTzrH+o2E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AAKsPxLhC4xYMn3c39nqrQs8QOVWzpX9bacRVshLPIFC8YUVKro8Ii2dq+3sCtayG
	 cu6ia01Q5cyz0g7nVgmmgz4toOmWVcAOQURiWAPbEfafhzYx0ygzQPsHNIa0b4AhmE
	 lUySDcHLQlAvfXLeEVH++D8Dou1EirOfhkqU1Mfwd0/vYrt4ganAooWeWTQ5JA46S9
	 4m/iNXWrPYLIIzuJSrPrcAiNlUK7XdseByvxAA3TtjPbjkpOtw66VsntwiCZsJotkL
	 7zCk9Wc4+6HX4ZtuqjjPv57TS2nBdV99RpAt/t1QxYtTP/LExoSQu7OyKgyDPnLWKP
	 1f4hCmY1TSDog==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bec354815b9so568138066b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 06:36:56 -0700 (PDT)
X-Gm-Message-State: AOJu0YzKNY0l2xpidyHERpGONg9H7LLAXQ6kV17jhYrdlnY95cWItSUg
	IcU9+mgbyvCoN+pF6JMA1NvDlEPpQ9tl/yc1LRH889EOubLm6uN6Jr05zM9TIWYnzxqQ/xhA+fG
	3DDmTYUhBXgwExwv3Fowbp47prtrr6OA=
X-Received: by 2002:a17:907:3d16:b0:bd4:8b66:c374 with SMTP id
 a640c23a62f3a-bf36ff8e279mr985767266b.9.1781012215485; Tue, 09 Jun 2026
 06:36:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609115251.49325-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260609115251.49325-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 9 Jun 2026 14:36:17 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5+r1sUQoeny-aRY8ePW-RMXD0KadS-JQktqEC92txDxg@mail.gmail.com>
X-Gm-Features: AVVi8CdN90HTMAgXkfwrjbN9rNn09PxvWy8KgLQvKXlV_8PN0BzrT7ht-VFVp0Y
Message-ID: <CAL3q7H5+r1sUQoeny-aRY8ePW-RMXD0KadS-JQktqEC92txDxg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: zoned: fix assertion in btrfs_zoned_reserve_data_reloc_bg
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <joahnnes.thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 12:54=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> Remove the assertion that we've have a non-empty block-group list because
> we've picked the 2nd empty block-group. It's not valid anymore.
>
> Fixes: 06e6e8cc17bd ("btrfs: zoned: always set data_relocation_bg")
> Singed-off-by: Johannes Thumshirn <joahnnes.thumshirn@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
> I have no idea why fstests didn't catch that trivial bug...
> Anyways needs to be folded in
> ---
>  fs/btrfs/zoned.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 0f87701e38e3..97f06dd01693 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2813,8 +2813,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs=
_fs_info *fs_info)
>
>                         down_write(&space_info->groups_sem);
>                         list_del_init(&bg->list);
> -                       /* We can assume this as we choose the second emp=
ty one. */
> -                       ASSERT(!list_empty(&space_info->block_groups[inde=
x]));
>                         up_write(&space_info->groups_sem);
>
>                         spin_lock(&space_info->lock);
> --
> 2.54.0
>
>
