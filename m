Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628345;
	b=Zk2bz3UGsr+sZKVcemRtdGl2PJoQE8y9iiiVXcwnMk4UkWebHm4PjuSWGhalvInifPHK
	 hG39iSqWVdXx4liK//Dp50G3a6uMJJacbDtYHmjPiffhQWY6lIOpH9gB5jjKyP0iNrToo
	 Y/xNFKxvj4Vw1hNAe2UBpvotQIY85WJl13hZpDH/ErHqM+gn9vbPLNDUUVuP0GthZemSX
	 Swk8DXaNdO73IApST73ckv5/IRhFL/Y684a0NJfgZV51aZXlc/wCXRxhVwZwhtQncjT+e
	 VxAMujHrZThRisfCl5OjJh0KpQJgQSxUWPswqCrjU55DC+3KgmbRaIWNQttRKS9w/Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628345;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=xxGrvOgZ1FbLL1BMnkKogdqK5XFmDhvmznjfuq1uz2g=;
	b=DWS5bfYYkCy+VopjbY6b2KYY6weWTxTTAMQmVF3SFMpZ1Z7CgNNSa0fWSg5byXOWNc7a
	 W4CcF+sDh7d9PvkcKtxSjOSizmW+wj8M0swzPtEKgeQfT6VRJcfkUjzBA7+3t11KYzrm2
	 kF/tQoZ9E8p97STsaEJZlkYbnnNyfQoZqTDEn+Eg/wWwCJOCfaQoisPmLT08qGDNOslG/
	 lOFt9SicqVvnyPd+SkhJpI3Sy2MuXcuV+h1CAnO42+wgVs22J/swu9V1RqmcFTZVdoW5x
	 LpdHmujdKv4ra/u3qDyvJMs1blMleleiSk7kRqdBHYWTFv+l0hJbSDuQEXekX6Aycww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCnRzRp1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF114606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCnRzRp1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB211F000C0
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628345;
	bh=xxGrvOgZ1FbLL1BMnkKogdqK5XFmDhvmznjfuq1uz2g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jCnRzRp1J5qEWDP+bWnMrlcpeP8JBMLmtGKC5OoBsR0z4GV5xUcdSmaQlSaDGnHRY
	 gnME6U+3bz2hRpxuzOaMWb+LGzIs2OoTPV/fGgLRoUzzyOK5Q9o+ogXkbji5l9UnDb
	 5j8aMk5C+cpY88CuB2hTHikw0BXS1O8funTkL1FwRGfCW600rElhwHwlb39wKGSlft
	 y4dhq6ys6q6TVwWxlCHM5w2+CUn0+8dFPQTzrFgK6VycKirTgH1hSGyFktv3tHKPaB
	 cA+gNVhM7EJsW+5bWtYm0IBQn3WmikFeQqEhrx1tiNODuar6E/TPmd3kn+/cQZldqp
	 E28szhSkpvZJg==
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-99071945aa7so3348135241.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 09:39:05 -0800 (PST)
X-Gm-Message-State: APuU4Z+NjZ2pjUrs/JiWa2i/913D1GBIPE0Y6oL9AZZ+fyqTT2ABWr5w
	hutH6CfeRM2LaJpH6bCq9wzhPWkq3/0aXhO5fuPvm4dCxmHoFAKC1F4B1JtO40F/F/7rqB/arbz
	QOVv9dzm4NAvDEzr4VAJtcGVDKhGykwg=
X-Received: by 2002:a05:6122:78b:b0:5ea:e324:7c15 with SMTP id
 71dfb90a1353d-5ee8af739cbmr11356598e0c.15.1795628344540; Wed, 25 Nov 2026
 09:39:04 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795466145.git.wqu@suse.com> <220d8ed1b3a8d502c4260d01e4ac4ece942873f4.1795466145.git.wqu@suse.com>
In-Reply-To: <220d8ed1b3a8d502c4260d01e4ac4ece942873f4.1795466145.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 25 Nov 2026 17:38:27 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5tgvbVegbN8V6D5dNxWExz2tqbGGnK=6T=kqndq0L9Mg@mail.gmail.com>
X-Gm-Features: Aa3M54ouyZa5FPft4esKfxkRqXd8isZCQsufDIGGHr5rtPvGZdvFfkdik2-fqvk
Message-ID: <CAL3q7H5tgvbVegbN8V6D5dNxWExz2tqbGGnK=6T=kqndq0L9Mg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] btrfs: reject too high tree level during backref walk
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 8:38=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> In handle_indirect_tree_backref(), if we got @cur->level set to 7
> (the max level valid), @level will be 8, then later path->slots[level]
> and path->nodes[level] will all go beyond the array boundary.
>
> Fix it by rejecting such high level before calling btrfs_search_slot().
>
> Link: https://sashiko.dev/#/bug/linux-8a4f92b4-daf7-4f57-8369-8e6ef323652=
f
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index a0fb90b7a9ed..e9434e033372 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -3316,6 +3316,11 @@ static int handle_indirect_tree_backref(struct btr=
fs_trans_handle *trans,
>         }
>
>         level =3D cur->level + 1;
> +       if (unlikely(level >=3D BTRFS_MAX_LEVEL)) {
> +               btrfs_put_root(root);
> +               btrfs_err(fs_info, "invalid searcch level %d", level);

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Don't forget to fix the typo in the log message, thanks.

> +               return -EUCLEAN;
> +       }
>
>         /* Search the tree to find parent blocks referring to the block *=
/
>         path->search_commit_root =3D true;
> --
> 2.56.1
>
>
