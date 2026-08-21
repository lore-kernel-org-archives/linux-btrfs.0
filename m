Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1051623AE87
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 11:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787311085; cv=none; b=BXdj3FAfd1JdxVJcDKOiBjy6YAitcVB38Q52C7qAFFwt83SdCP2+8hNaVUS30iIkAP6AiTERi4EXmV/RUsQbVU3y1QXlW9wXFgh11ReNwJRdgKMbmF778ENR9YpdjyiK3rFQaSIpMQP72LjLKu7JtRiqiRgTyDqaQT2QwK9jzQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787311085; c=relaxed/simple;
	bh=8axq1u3vK0c492BGiKOoFXnQ1Yrr3Y8zJuwgbVfRzn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g0mC1i/sOSFgy+yFiCjJWZG+Ev5ODGbZPX5UDNkxoZoFFI6ILAjntLBXzzMT4AzhqEU2bvTuxMhYMT3OVN/7ms2W0DqkPRRDJ01zZKqQ7ByfaT29qO8NZXLiFcNa07yzZpASh3PfJvTuw5jCLQva4yI4ZnuwozVTZqNQSPdRWD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bn6Nnl32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bn6Nnl32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53261F00AC4
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787311083;
	bh=D8xIrcfb8M8Rb9Tcp8bytgaMt75MEiRhxhwjfOejITU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Bn6Nnl32AARlvXF2aIgN1SCb9aw0DvikTWcPYDcA/CD/gL1ob8Vflv/m2/8rPiaeh
	 /+0OLLb9n+zBtg2YLbvbECoyW6nKF1+nR3OOkb46h/IVbhQGML3JQob7TEWMA3L0lp
	 eaZzpI/HEGKV3IUJLLxR21A6NvVok5J8RNROqORRGLdT5/oTJTBRyrwsC1pr2oLWQM
	 WfWiSS1TY6vHoEuBOopXHlPJRXHOr26B/KXQ98K4IAcZAb6fF3rFbI+R9Kjy79//w9
	 QdZ0O7EyZHQ/8fe0yWWfX6vgU6k1hT2lFj2rbpPE8liq74CT9LJwaceGfqafDsCDYS
	 rJk6i+5JUIE4w==
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-779d18ef706so610724137.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 04:18:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq2F3PUEuw3udjzQrlD5Lg+5GPyvtRRuKQSVq0TPlk8iaqoeFOkT1oKghrzfy/h9QDzcBolnlMP1RBvIw==@vger.kernel.org
X-Gm-Message-State: AFuF++k4OpVU8VyIw4pmg+oCr5912BKGY31rPzqQ13R7aK2PGTAPqVvO
	U2dXFWOsBbTP7pq7hv2cleXN2t6EmKEP+AOwwTRCIIQS9p+x+EtxBHxQWchHwaUbVjjz+FPJNqA
	WlUXhD6vGfX9ia2FtN6J1uvWeiVESCDQ=
X-Received: by 2002:a05:6102:578c:b0:77b:4bee:6a8f with SMTP id
 ada2fe7eead31-77b4bfdafd3mr309061137.9.1787311083000; Fri, 21 Aug 2026
 04:18:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
In-Reply-To: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 21 Aug 2026 12:17:26 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4MW6AXhz=EnEawJNU_OEFVqdeXUaivY30cb1Lqxeqdfg@mail.gmail.com>
X-Gm-Features: AcwNN1WRYXbiElfqFDljhE_bxS2-1NDYrX332v92gtP24We4ys3kRIkmob5svxs
Message-ID: <CAL3q7H4MW6AXhz=EnEawJNU_OEFVqdeXUaivY30cb1Lqxeqdfg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: skip the extent map tree lock for inodes without
 extent maps
To: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, fdmanana@suse.com, boris@bur.io, 
	wqu@suse.com, layton@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 11:39=E2=80=AFAM Breno Leitao <leitao@debian.org> w=
rote:
>
> The shrinker (find_first_inode_to_shrink()) takes inode->extent_tree.lock=
 in write
> mode on every inode it walks, only to find out whether that inode has
> any extent maps.
>
> Most have none, from what I understand, so, avoid the lock  by testing th=
e
> tree with a plain read before taking the lock. tree->root is only
> modified with the tree lock held for write, so the unlocked read is
> a benign race: a false negative just defers the inode to a later scan.
>
> On my tests, find_first_inode_to_shrink() was a bit faster, so, if this
> patch is correct, I think it is worth having to reduce lock contention.

When claiming performance gains in a patch, please always mention what
those gains were....

>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  fs/btrfs/extent_map.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 6ad7b39ae358b..cdcd2b779050d 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -1219,6 +1219,9 @@ static struct btrfs_inode *find_first_inode_to_shri=
nk(struct btrfs_root *root,
>
>                 tree =3D &inode->extent_tree;
>
> +               if (!READ_ONCE(tree->root.rb_node))

Please use the proper rbtree api to check if a tree is empty:

RB_EMPTY_ROOT(&tree->root)

That's a lot more elegant and hides the use of READ_ONCE().

But really when there are harmless races, I like to see an explicit
data_race() annotation and a comment about why the race is harmless.

Nevertheless, first, I would like to know how much the performance
improvement was...

Thanks.



> +                       goto next;
> +
>                 /*
>                  * We want to be fast so if the lock is busy we don't wan=
t to
>                  * spend time waiting for it (some task is about to do IO=
 for
>
> ---
> base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969
> change-id: 20260820-b4-btrfs-em-shrinker-7382d7f0dd05
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>
>
