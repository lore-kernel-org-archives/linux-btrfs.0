Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162D26ED41
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782320139; cv=none; b=GCaBYl+abUq2OipdD7l0lSJD8OB4nBlQArq3HxqkGMUC9wONVOUPqVf3hpsm+Sa2ki+39+hPjmR41TALsbs8MbHafJ62iihVuny1F/oEXf2W47+aWKdPgI7mZHEyqeau3ZqFFkHLqnGJ55gi/KluDifDM5V9kXk6bmaUJAWyp1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782320139; c=relaxed/simple;
	bh=f0KMzAkT8ioIGxQU8rUOPgrYqwTmT8ujdri8jUKAxOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eJT0AEI57GxtYJIMZwnpKDm1RVdIRs0xsQJlU0JtaJVsMrjI1lXAamshySGELwfVWVfeS0V3cEcIO6xeacjzK1RY1B+Mywl+GiBKt+kujrTrzwiVsMNsTujtpeGsET9VU/k6sPkHZ1keYQpn9mLdAVCUcFRvR4jF2AJPhpEFBi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WO0IzTY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WO0IzTY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC991F00A3A
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 16:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782320138;
	bh=7vvo86vLZesC5hw+la0U8iHe2gGkZHrQ13CurQlxCzk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WO0IzTY7wPyEmgCp+eTWZ5YGavBXutHe4iiYALpg+BEs1dR/bwbHOOhgooBwv/cyP
	 QbZd6S/Xlb9w3jp0+CKJ+Tx274SgynQIIPIj3vzX/ibxvdKR4947Awq1oa+kQaYjOT
	 E6lLamaydqMdS3vIoW9EvAarK+jwcneYx6eWC5dk+c/TZSutM52E3RIqvvuR0ZgGUp
	 eCrHPC0soscK1cRU7Av9sWr7LwPYAJTttEvzxmVDwMi6+TFc1jmAwN2xvNDA0Qd+tj
	 pP69kgcTUpeMkYNf2XzEhXXVROH1p1Rtz/yl8W4alYGe2GjXTco/5jFnJIh7K11gUG
	 XbWpcGW9n46RQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c029505b389so6606666b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 09:55:38 -0700 (PDT)
X-Gm-Message-State: AOJu0YwGGDZfAkPdLNkBSH2/pk786rNFZvTDDsu/ZNGPkvmXSfAkZcpC
	uftkG1fKLuVrfeRXnSG6Dbr0K5dEKLzba+AxQ3QplqSPdyra8wD/0s7R0vWb62drBLLX6pJ0h15
	OGZ64+hZotET5UMsZ+jdXE+TVY2CuRlE=
X-Received: by 2002:a17:907:8687:b0:c11:97b:140 with SMTP id
 a640c23a62f3a-c11f8cc9caemr77323266b.1.1782320136998; Wed, 24 Jun 2026
 09:55:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4402ee2dd45308bdcfade989e0fb5a917cfc3f6a.1781541942.git.fdmanana@suse.com>
 <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com> <243935fe-6c73-422f-901f-c2a26b010c6d@suse.com>
In-Reply-To: <243935fe-6c73-422f-901f-c2a26b010c6d@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 24 Jun 2026 17:54:58 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4DGWe54UmJb4P+p3JZEwP=iMXjUQxXjQvghjRexA2f+g@mail.gmail.com>
X-Gm-Features: AVVi8CcpNq9m6ykToP9YOaLQBnPFx2Z_rN44M-_9TtND7MyXwS2ftn966V6PfAo
Message-ID: <CAL3q7H4DGWe54UmJb4P+p3JZEwP=iMXjUQxXjQvghjRexA2f+g@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: send: fix is_current_inode_path() to avoid path
 resets for common prefixes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 11:38=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/6/16 02:44, fdmanana@kernel.org =E5=86=99=E9=81=93:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > In case the current inode's path is a prefix of the given path, the hel=
per
> > is_current_inode_path() will return true, which causes the single calle=
r
> > to reset the current inode's path. While this is not a functional issue=
,
> > it makes the caller recompute the current inode's path later. It could
> > also become a problem in the future in case get new callers for
> > is_current_inode_path() in more sensitive contexts.
> >
> > Example: the current inode path is "/foo/bar" and the path we compare
> > against is "/foo/bar_xyz".
> >
> > Fix this by returning true only if we have exact matches.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V2: Simplify and avoid false positives in case of something like
> >      "/foo/bar" vs "foo/bar/xyz".
> >
> >   fs/btrfs/send.c | 9 ++++++++-
> >   1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index a3c8f2d889bb..d664e470fd77 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -627,7 +627,14 @@ static inline bool is_current_inode_path(const str=
uct send_ctx *sctx,
> >   {
> >       const struct fs_path *cur =3D &sctx->cur_inode_path;
> >
> > -     return (strncmp(path->start, cur->start, fs_path_len(cur)) =3D=3D=
 0);
> > +     /*
> > +      * Path may be a prefix of the current inode's path, so return fa=
lse if
> > +      * the lengths are different.
> > +      */
> > +     if (fs_path_len(path) !=3D fs_path_len(cur))
> > +             return false;
> > +
> > +     return (strcmp(path->start, cur->start) =3D=3D 0);
>
> Can we just use strcmp without string length check? It looks like
> fs_path is always NUL terminated.
>
> E.g. fs_path_prepare_for_add() always reset *p->end to 0.
>
> So we can just use strcmp() to compare two NUL terminated paths.

Right, it's safe here. Updated in for-next, thanks.

>
> Thanks,
> Qu
>
> >   }
> >
> >   static struct btrfs_path *alloc_path_for_send(void)
>
