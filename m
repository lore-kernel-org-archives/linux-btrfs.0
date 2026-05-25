Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73153345CDD
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779703934; cv=none; b=HON3ivOce95UDMe74iV88fBopL/geq2PtsvgQYIjxQDHAeThm2+sBualrnWXq2q+oTqQ7vxhGqmES1QAb7iezBUQfSixZZ+lkHspXqZS0dcMGk7P3Lp9eNnbFL+1qFX9AaFKkm26eNpRcVqRrxF+22LUXIxiYcuhmOxfGvMYkn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779703934; c=relaxed/simple;
	bh=p1Yt63RJo25DqRYZJxMfSwfwExjNyM/BSSWtN8a4o5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fGKJIhs+CxCUM2HMlx78OkEK6bwJFm3ZkdqTwb1hgw+MrBd6rLkXuGfoT0uWi5UwTgB5nTp6pcK4bSQTgNdSYm5asSZUflShi0mzExP1nKhSBWWyi5XV29vy0h/5Fn4u86LG3JpTz0g4ay1er3yz3qgP5Q7fdmIvtfM5zXumZe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F35sCeFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F35sCeFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE0E1F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779703933;
	bh=61EoaxjS90KDps9jKhlIYZGVX1beebyG36qARrhRIxI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=F35sCeFZGuijQlBSSmEj4fpiZqcdxzFeOf13FgkyEJ7eB5EdYbIQUQQx7VEMCgSsw
	 d4EZ+xVlu08HIYW16jtGfW73R2tgyohKZHWtWg7iKtp3XfYlO1rI5xEjevvpIOV2QR
	 zXcE6Dlwp2GFgo0Z2FAnAXkKtgq3Qnpl7V9RVXJRTVeYXeHvAzGO6UJuhfgFITe489
	 uSXf9xWk2ZhyePJwACVBinV2QD3yd/IAOzV2CsgzanG5nOIkkHJVHw4PyMR7kfCX0l
	 isP8hzR1EKax7ping20XMitJw1TAS5+5yCNxrSkK2+T/ihauo5fhrhjYrDZF2o8sn2
	 OUnABT8BAXJ9A==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bd8f6ef4ba6so1384491766b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 03:12:13 -0700 (PDT)
X-Gm-Message-State: AOJu0YxzJG6zsAEOkb1ZFbG2gB7Dr78xV6EK6SMoIfUJojEXtHp05ljU
	lzm7XTNGHOvZ8qN4lxcxpilbj3wgIV3ZQkdVa3xudmxY8WvAZLDpfwYPhyfnQoLWFpdsn5hat/m
	oxCeYbS/AN5MiwWgY/GFy9MM2ZS109Ww=
X-Received: by 2002:a17:906:844b:b0:bd5:2e64:afba with SMTP id
 a640c23a62f3a-bdd2580be79mr593030266b.29.1779703931834; Mon, 25 May 2026
 03:12:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1778776706.git.fdmanana@suse.com> <238c79ed66ab85e05394448aeddf91899839ca22.1778776707.git.fdmanana@suse.com>
 <20260523175114.GK183694@twin.jikos.cz> <CAL3q7H7g4JCCw=n0DDq-tRNiBuiOAO=Pc4SZxQZyoemOMV26Yg@mail.gmail.com>
 <20260524110730.GL183694@suse.cz>
In-Reply-To: <20260524110730.GL183694@suse.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 25 May 2026 11:11:34 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4c9b_mn6LD3=LxKcNcCEFeDTzzjQJ6L3Mn=Js9qwLdvg@mail.gmail.com>
X-Gm-Features: AVHnY4KcaT_g7G_mX8kFOAMA4lYTyhuvZuOLmzDIyxn3u4i3-8JlrI-3s4cE9YA
Message-ID: <CAL3q7H4c9b_mn6LD3=LxKcNcCEFeDTzzjQJ6L3Mn=Js9qwLdvg@mail.gmail.com>
Subject: Re: [PATCH 19/28] btrfs: tracepoints: add trace event for add_conflicting_inode()
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 24, 2026 at 12:07=E2=80=AFPM David Sterba <dsterba@suse.cz> wro=
te:
>
> On Sat, May 23, 2026 at 06:57:32PM +0100, Filipe Manana wrote:
> > On Sat, May 23, 2026 at 6:51=E2=80=AFPM David Sterba <dsterba@suse.cz> =
wrote:
> > >
> > > On Fri, May 15, 2026 at 06:00:16PM +0100, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > > +     TP_fast_assign(
> > > > +             TP_fast_assign_fsid(trans->fs_info);
> > > > +             __entry->root_objectid          =3D btrfs_root_id(ctx=
->inode->root);
> > > > +             __entry->transid                =3D trans->transid;
> > > > +             __entry->ctx_ino                =3D btrfs_ino(ctx->in=
ode);
> > > > +             __entry->conflict_ino           =3D ino;
> > > > +             __entry->conflict_ino_parent    =3D parent;
> > > > +     ),
> > > > +
> > > > +     TP_printk_btrfs("root=3D%llu(%s) transid=3D%llu ctx_ino=3D%ll=
u conflic_ino=3D%llu"
> > >                                                                  ^^^^=
^^^^^^^
> > >
> > > This looks like a typo, "conflict_ino" as the variable names.
> > >
> > > > +                     " conflict_ino_parent=3D%llu",
> > > > +                     show_root_type(__entry->root_objectid), __ent=
ry->transid,
> > > > +                     __entry->ctx_ino, __entry->conflict_ino,
> > > > +                     __entry->conflict_ino_parent)
> > > > +);
> > > > +
> > > > +TRACE_EVENT(btrfs_add_conflicting_inode_exit,
> > > ...
> > > > +     TP_printk_btrfs("root=3D%llu(%s) transid=3D%llu ctx_ino=3D%ll=
u conflic_ino=3D%llu"
> > >
> > > And here.
> > >
> > > Otherwise no other typos spotted in the whole series and the formats
> > > look consistent. I'll fix the two in for-next. Thanks.
> >
> > No it's not a typo. It's intentional to call it conflict_ino - as ino
>
> conflic_ino ... with missing 't', or did you reall mean to write 'conflic=
'?

Ok, I thought you were mentioning "ino" vs "conflict_ino".
Yes, that is a typo and I'll fix it in for-next, thanks.
>
