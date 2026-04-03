Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB928315D53
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 11:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775214859; cv=none; b=WNJNir1L7vvuRKOG75LQDb45sEYznXmdFNdJUd7QJtxxhxzNPPf9rBV/10G1YwebXIqMGTq5IuKfNghf388KODpPWfnaJcP6ejpXebmA00TP2WTyh0sC13poXZHLFfDXWvEQsvYhlrSA38nVgbKDAMQr6xGoJCDOFddkeOZfn1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775214859; c=relaxed/simple;
	bh=r5B70k8TFYNnA7KTrky0iiOuP0Fmm6+Aan59IrIERNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pnmlGE2et99lXLTb9HM80gAm7sx3coa8mX5vB201tX0lVOqqVK3P88dtEG2966npPDcVv6pFTsaYsUjbbfBDmzEewiccfGN/Tw3Aq/dw1Resnb95Asj2xQWdx01QHbrj0hKTEWuRRkI3L9Y0lB7aMU5kL7UJxznxVadLWmw091c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sH9vkXMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sH9vkXMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54238C19424
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775214859;
	bh=r5B70k8TFYNnA7KTrky0iiOuP0Fmm6+Aan59IrIERNY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sH9vkXMDZIkUgL1JFPZ4kx2XBBlSjlDTjcAlke5gGIAoSXNJuBIVhq1MAEckuDB+E
	 fRmvek8RjWHla8BRCR2lmoPY2aE03zTG5WiGfyLFranwRV9gbByno0zehDtVduw0Bo
	 DUePCa0ZXUbHL0I6vnifmCwpI81ZAwtJeUt1fNecDUQcejd3WhUvo9ayFBo1Sn3nmY
	 HRKoqLh+EfYpIcxL7BIJKI///fzR1REYHAYyCZzot1WQhLe5jPRt1yuefuiOL5diLO
	 7CgvTkufBcnX++VZrpuBFONtS1EPBQkodtgqdB8eRwogPUIZM/BO0ti0bc3tWv5Fl3
	 jqXe7otuNEXeg==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66b2f6e983bso2993477a12.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2026 04:14:19 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy4QaQXKvaD9cUgkEYgA5Dx+LjPsiY79rKeUElLkzQ1gvljhiQj
	1iiUWCtxfATvr4nWNJOp2Ny7LwJkQcb+q1mkZN31lSHHiZpj/5p+2H7f8JTEF+ikptimaDMIPvM
	lsGjVDjtpmB7hLA6VTYv2JVSmAAfGREo=
X-Received: by 2002:a17:907:1c13:b0:b97:f2b3:49b8 with SMTP id
 a640c23a62f3a-b9c67ba4631mr139611166b.47.1775214857836; Fri, 03 Apr 2026
 04:14:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8ea3a7a9c3c4e6123925646fa6484f6ba1524173.1775066198.git.fdmanana@suse.com>
 <64f5f5b5-d44e-44fc-90fc-96b4289aff34@gmail.com>
In-Reply-To: <64f5f5b5-d44e-44fc-90fc-96b4289aff34@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 3 Apr 2026 12:13:41 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6uqq5qfPzM287NMdD9O+VhtFiuQF4U8XoA9Wf-mq=9FQ@mail.gmail.com>
X-Gm-Features: AQROBzD6ocwybMjh-EtQ7bqNSL3MpwmrLqSTJnVYtP5vMR3xorTRcPSlCesxC-c
Message-ID: <CAL3q7H6uqq5qfPzM287NMdD9O+VhtFiuQF4U8XoA9Wf-mq=9FQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: tag as unlikely if statements that check for fs in
 error state
To: Anand Jain <anajain.sg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 3, 2026 at 11:49=E2=80=AFAM Anand Jain <anajain.sg@gmail.com> w=
rote:
>
> Looks good.
>
> Reviewed-by: Anand Jain <asj@kernel.org>
>
>
> However, I have a question. There is an "unlikely" opportunity that is
> not fixed [2]. Based on my experiments, it appears to increase the size
> [1], so I assume this was intentional. How did you determine which
> approaches would contribute to reducing the overall space?

It was unintentional; I previously used a different approach to move
the unlikely to the macro, but that does not work because unlikely()
returns a boolean instead of the error (and need to get the error
outside expressions of if statements).
If you look at the patch, I removed the unlikely() you are adding in
the diff below.

I'll add it back and update the changelog numbers before pushing to
for-next, thanks.

>
> [1]
>
> $ size btrfs.ko.after
>    text    data     bss     dec     hex filename
> 1732263  165668   19752 1917683  1d42f3 btrfs.ko.after
>
> $ size btrfs.ko.before
>    text    data     bss     dec     hex filename
> 1732257  165668   19752 1917677  1d42ed btrfs.ko.before
>
> [2]
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8c5e1eb7b363..5bc0a4b89ef2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4277,7 +4277,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_in=
fo)
>          * extents.  This will generate delayed iputs, thus we want to
> handle
>          * it first.
>          */
> -       if (BTRFS_FS_ERROR(fs_info))
> +       if (unlikely(BTRFS_FS_ERROR(fs_info)))
>                 btrfs_error_commit_super(fs_info);
>
>         /*
>
>
>
>
