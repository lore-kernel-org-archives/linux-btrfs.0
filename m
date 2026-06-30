Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DC434251B
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 09:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782813274; cv=none; b=hEFD7F19y0IYo7c8f6Y5HdVKK6pUZIJfaLTndPLjMmmhS9K/7xPfU2DjTm0fodHfuIXnEprPbEnyY4UrDe05vUl1XjA+bD9lxJilB1xVRETWjcJvi8BMSnSZdaQ9DH83M91eJeyD0+09JmK0TNA+cIT5eLIP1NzufYTYxstoifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782813274; c=relaxed/simple;
	bh=ueAg+SZ3iG1aFG/BwHV2kX8IqLdHgxG/QrJOsEWsYf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YpbhnkVsUbPtvNTtCoaig34rZQqur3hZfeJWqsE0z+9aWbNbwglQerArm/xY7/CEpMRuhG0DuqaQ1iP8mL0SsTiIZBXecCjMCk3ND+Lo2jyZgVBzDEKEQkBvIjAJ30lcY/2OnGSkvu3HHNTx+u/ZKdubaEBv8FQRWOF68wKugj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhPZtiOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhPZtiOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B661F000E9
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 09:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782813273;
	bh=LCb+CzJECOPUv3mvw+JO0Hfr7W/61Qo2tUyxqb2/bDs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JhPZtiODgphcGEeS1TjQgqKOyJag19GgTFhO4nsjP55qjdYgseRR3HpQg8NUR6+D+
	 Lz1KoqCigvbOWVbCt/EblJqbFu5xdEHZTRn8w67zMk6KWD2Vu6XyaLjZiP+51UiBAa
	 nDLc+GvwDIWlb8pI6K/zEWH3ozGZwOMm8IjG/1rV/I29/XSraNEhYWSxlYOTYLdzu+
	 J7izjrQCvi3ilf+3qC1ELGsjIwZOchPBAr3WHKwwcU2+/zFnpNEF7gjhy+lhVnXdNC
	 ScgeLWo4NV164NYWPg93kVHrEeD63DBUPwzRs7HL9QSX751V77I2ZdrlpQemt/Glv4
	 btsfihRXCH9bQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c0efc7ef797so748719066b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 02:54:33 -0700 (PDT)
X-Gm-Message-State: AOJu0YzyPW9RP3S6gyl3i6T2Y03WyMQVXpaCUthNkTRRc1lz/t6QLski
	lfLQ5UFFZi8dFbW1CUQOOmMaBIq4L/vfKGF/JTxiXS182FNocbZMV0M5KSdxXeF1dt5HovHWAgG
	A1W4ZoGp0R3WrYtwKkrq9iucB97rWRos=
X-Received: by 2002:a17:907:9484:b0:c12:79aa:828c with SMTP id
 a640c23a62f3a-c1287159ae9mr141248066b.18.1782813271989; Tue, 30 Jun 2026
 02:54:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782321584.git.fdmanana@suse.com> <b3c3ddd783250773e264ebc76a0984d0276bc664.1782321584.git.fdmanana@suse.com>
 <20260629225508.GA2398896@twin.jikos.cz>
In-Reply-To: <20260629225508.GA2398896@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 30 Jun 2026 10:53:54 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6MEAeoCf+n7wT_823vUX5JuDYXFPiU_3fiauZiK6Sdiw@mail.gmail.com>
X-Gm-Features: AVVi8Cd9jMfPnpQzp0r8zvxQSKVMe7tmvxpLa3PMz-yw7GCT3Ng-qSKUfUITkzA
Message-ID: <CAL3q7H6MEAeoCf+n7wT_823vUX5JuDYXFPiU_3fiauZiK6Sdiw@mail.gmail.com>
Subject: Re: [PATCH 4/6] btrfs: defrag: use auto kfree in defrag_one_range()
 for folios array
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 11:55=E2=80=AFPM David Sterba <dsterba@suse.cz> wro=
te:
>
> On Thu, Jun 25, 2026 at 08:20:14PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Use AUTO_KFREE() for the folios array, avoiding two kfree() calls, one =
of
> > them in a very specific error path.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/defrag.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> > index ad1d04d8f165..e454b59d6477 100644
> > --- a/fs/btrfs/defrag.c
> > +++ b/fs/btrfs/defrag.c
> > @@ -1169,7 +1169,7 @@ static int defrag_one_range(struct btrfs_inode *i=
node, u64 start, u32 len,
> >       struct defrag_target_range *entry;
> >       struct defrag_target_range *tmp;
> >       LIST_HEAD(target_list);
> > -     struct folio **folios;
> > +     struct folio AUTO_KFREE(*folios);
> >       const u32 sectorsize =3D inode->root->fs_info->sectorsize;
> >       u64 cur =3D start;
> >       const unsigned int nr_pages =3D ((start + len - 1) >> PAGE_SHIFT)=
 -
> > @@ -1196,10 +1196,8 @@ static int defrag_one_range(struct btrfs_inode *=
inode, u64 start, u32 len,
> >        * range or the extent lock.
> >        */
> >       ret =3D btrfs_delalloc_reserve_space(inode, &data_reserved, start=
, len);
> > -     if (ret < 0) {
> > -             kfree(folios);
> > +     if (ret < 0)
> >               return ret;
> > -     }
> >
> >       /* Prepare all pages */
> >       for (int i =3D 0; cur < start + len && i < nr_pages; i++) {
> > @@ -1251,7 +1249,6 @@ static int defrag_one_range(struct btrfs_inode *i=
node, u64 start, u32 len,
> >               folio_unlock(folios[i]);
> >               folio_put(folios[i]);
> >       }
> > -     kfree(folios);
>
> There's non-trivial work following this freeing, down from

I'd rather disagree it's non-trivial work.
Everything below kfree() is trivial, and it was placed there in patch
1 by chance.

> btrfs_delalloc_release_space(). I consider using auto freeing in such
> cases as anti-pattern and have skipped converting them.
>
> In this function there's only one early exit from the function so the
> auto freeing is underused, I'd rather not do it.
>
> >       btrfs_delalloc_release_extents(inode, len);
> >       if (last_defrag_end < start + len)
> >               btrfs_delalloc_release_space(inode, data_reserved, last_d=
efrag_end,
> > --
> > 2.47.2
> >
