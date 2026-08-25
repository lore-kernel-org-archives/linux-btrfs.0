Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B221943E9F9
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661564; cv=none; b=u8tehJnZyuHyqXZVHcYTwWIRKPMymJ9iupM9dpaEdHGJB6XcfYbRAFayKp8I6tYtYOhUnRA3kDclznpeCMTcnFlo/oScyPsFntDzTXxtY1kz8p39YD+gD2WQ3pEVWdBkez4m2YpJGNjrvrO/UCAm6br1v8+pbJz3uz/Fi9g6Unw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661564; c=relaxed/simple;
	bh=nkTtciDKApCGHGMeUPefiPEL9ssJeDFWYjsRYS6wXRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uC+9kyoxGbhK5eyYaZQyLoESiD3QXAgEkYGr2OLPSkLoBzk5GE8fK18IGOgwGwb7rUW6jqaqal2dAt+tSLHTeJx2ImEQ0C7seerXUMm8OJJ3gscXLOSDY+qAHgZUd4cTNVAvbtgsQrPtxpATEL4zoCtl9cIKWjLK1t+imuIZhl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNWcMgZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNWcMgZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0ED1F00A3A
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661556;
	bh=o6jijhziZexvZgymh1wQz4LiG/EWuSvA+f+6Fl4I5kw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CNWcMgZP4p5Q/XFOGkbMx0C5+a/T7BwuPcGv6JZUhaSQOGQvcfhs0aIXTZyVrR9WG
	 xKvy+wHXIhVJBzh1jSmg5LDckOxX89vkyMasPTVP99SupcoOXZxZ/bDKnhXzz0zhEL
	 qIlf2nHS/aDQSxGpmF/GSfqfnqXjzDEGoWzcVHpxEXqRSUOIi0I4IsFyyeElB/vbi8
	 W/ShZhfti+ONo47pl+TefQWklOfsvQd/A0paLaeRZPVuBq+dq7wfXIYUUE9C1pH2W8
	 TUuoCPz2Vom5rLQl7SgD63CGDna5WKQXp6ZpB7lBXxrDFepkzb7uooikS84FzYxwn6
	 94+3+TGd9MPUw==
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-77e35e008e8so622092137.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 05:39:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpXH82CV+hbxjppxbHsFCWh1I1VfStAeBoPCkRmqtk9XBFuFfJC7Sygxv//7qyOBRQBNi5LmqvAgq4RMA==@vger.kernel.org
X-Gm-Message-State: AFuF++nzPE9C7+Vhy/7rL1oP+gkjbxsSV5hjcnCY39ECesU9yL2kPZV3
	LGVdAtmJ7t/FF6bXsn13dvRlo11npynwQPhzy25lELot6/EPzWNme6rzbRlbNFc+eZDJDULokHg
	1M9/PUxWz4SlG0qM2div5df67NTaRJv0=
X-Received: by 2002:a67:ec0f:0:b0:778:290e:a080 with SMTP id
 ada2fe7eead31-77fd5608588mr1199175137.13.1787661555483; Tue, 25 Aug 2026
 05:39:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260810094701.1349706-1-thnkslprpt@gmail.com>
In-Reply-To: <20260810094701.1349706-1-thnkslprpt@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 25 Aug 2026 13:38:38 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6UoS_=XJj=pa97o4P8upbbqY3axJAnmSg6H_XZfZZdsA@mail.gmail.com>
X-Gm-Features: AcwNN1Vjw9r-Exjgl8k4rGuAqd6rTgU9yunlB8WctOajcYQ-qz-SDCrSvR0uAgY
Message-ID: <CAL3q7H6UoS_=XJj=pa97o4P8upbbqY3axJAnmSg6H_XZfZZdsA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: send: propagate errors from is_inode_existent()
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 10:52=E2=80=AFAM Avi Weiss <thnkslprpt@gmail.com> w=
rote:
>
> The direct-return refactor in commit b3047a42f55d ("btrfs: send:
> directly return from will_overwrite_ref() and simplify it") changed
> will_overwrite_ref() to return directly instead of going through the
> common out label.
>
> That resulted in a negative return value from is_inode_existent()
> to start being converted to 0, making lookup errors unable to be
> distinguished from the inode not existing.
>
> process_recorded_refs() expects negative errors from
> will_overwrite_ref() and aborts processing when it receives one.
>
> Return the value from is_inode_existent() to restore the previous error
> propagation behavior as it was before the refactor.
>
> Fixes: b3047a42f55d ("btrfs: send: directly return from will_overwrite_re=
f() and simplify it")
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3ae480c7474b..a888202397ed 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2066,7 +2066,7 @@ static int will_overwrite_ref(struct send_ctx *sctx=
, u64 dir, u64 dir_gen,
>
>         ret =3D is_inode_existent(sctx, dir, dir_gen, NULL, &parent_root_=
dir_gen);
>         if (ret <=3D 0)
> -               return 0;
> +               return ret;
>
>         /*
>          * If we have a parent root we need to verify that the parent dir=
 was
>
> base-commit: af5534fe2fbc006e83d75d6283dfc5ec75d5d780
> --
> 2.43.0
>
>
