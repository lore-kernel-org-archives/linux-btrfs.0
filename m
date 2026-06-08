Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043BB3403F1
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780918104; cv=none; b=gbnjv3dP99KfIrky5lS7qLS7phCJMAaNLIqQo/FOibIZdKfQcPvmzSOegR1YTd5PQYFlSbaxXR9/pUTVC3fVfZkOdouzRPKQRCTc1diU2XYBTI8sKNoKpHQH9vz6BP4oXdPuJewZoBb4E+HDWaPJsyav8Q6AY3Vgnni5kRc0haM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780918104; c=relaxed/simple;
	bh=07CSvOfsMYb3ovv7HYqEN4Di2ZjJu+tnq+ZAtUpg44w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gikG2HX2Gvih/ng5n8sASq7kHMaeIn+CV9Ak/1Hm1oLb+AmSwTI91Ev3Cefr8egSpRdMSVjDAIe9n4aioFmtbi9k8pHe1/arwe8+8Pt6vxQSwb7JYgom1sWzvubk/MSIE1oeqBY9xIA7kS/58EA9XjGiDYfC/mvTeju/FSC9FfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHjUrUdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHjUrUdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37411F00899
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918102;
	bh=4eFAXYAlisMyZROgtZjN8snyvOoXYIYrf26FTR3yVQU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fHjUrUdx0hoKW/FOqYFDOJaO7gJHJgVLzsv7gqG9H0LZRpU3SdshU5JDOaIH1PpWv
	 cpZnvusVGqHAIitduytREP91IKoj09mVqZ9K6YO1ELZAwr3fHiVQNP3MxuU5HFfUS5
	 u+jcK5uo6A8OKY9aEULcG+ze8RrFbZZ23pvtLFp5SnJjswD0UwcujlHa6CaPV9RE/U
	 PwC4hKS0CAYp1HUi/8/tc4ClRx7RpUX1S2HP95SjHZqMTe+p8CqC0tyZjsvy/P9Upr
	 SrssscSaTYq2fF0/ZNqZQ0/BxdsyHZj/EFGBoeQgJH28PNX54mVkcSJPbpOmPpV/df
	 SBSBeylPAB7jw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bef8b97655eso826219066b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 04:28:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9BUWUsK0kwZ7ECE8Y+dtzcHTNjRtBjHr82GF5F+Qz4LGH0FBjwxYyme/j7JjhI5W8c6eNGC/Vfw+Kgzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKjrHQ4UuHsd9TCEom+zpfUgO/XbVn4gd3gO8JZyboJZBTMiBQ
	iUFcPY8Xcfk77YmfCdTk8aiLxmN7aPzwpC5tyoXWokhB/+2GPGfwl+ISBeVboFnuO0KX5DwRnV8
	hmB2c7/XA4vstwXsBYJH+uLnuDz6Ph4c=
X-Received: by 2002:a17:907:6e8c:b0:bda:3469:6ed with SMTP id
 a640c23a62f3a-bf3a93177efmr619421966b.32.1780918101331; Mon, 08 Jun 2026
 04:28:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e0be9c192cf8896a7f02ae23880f8e4921102129.1780912039.git.wqu@suse.com>
 <CAL3q7H4SXDUCsKrLK27GwT0itbSd_aozt5A2TvVR5e34gZD51w@mail.gmail.com> <2408e64c-ffac-4276-8631-a9f073fb5892@gmx.com>
In-Reply-To: <2408e64c-ffac-4276-8631-a9f073fb5892@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 8 Jun 2026 12:27:43 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4rQzMkjLsMOT4a_hbQ7q8SV-1_TG1M4nP2XsSQHB+ngw@mail.gmail.com>
X-Gm-Features: AVVi8Cd1JMqYFuiORN521m4K2GSBIIFUm5NtF4jZwqVnLguaJuJIT8FlmWLANdk
Message-ID: <CAL3q7H4rQzMkjLsMOT4a_hbQ7q8SV-1_TG1M4nP2XsSQHB+ngw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not overwrite NODATASUM flag when removing
 NODATACOW flag
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 12:23=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/6/8 20:44, Filipe Manana =E5=86=99=E9=81=93:
> > On Mon, Jun 8, 2026 at 10:49=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> [...]
> >> Previously such operations will revert to inode flags 0, but now it wi=
ll
> >> revert to inode flags NODATASUM.
> >> This is due to the fact that we have no way to change NODATASUM flag b=
ut
> >> only through mount options.
> >>
> >> I know this is not ideal, but at least "chattr +S" removing unrelated
> >> flags looks more serious and more like a bug.
> >>
> >> So here I'm fine to slightly change the behavior of "chattr -C".
> >
> > I'm not sure what's best here or how common this use case is and I
> > wonder how it might affect users.
> > I agree it's better to not remove the nodatasum flag, the only concern
> > is if it affects existing user workflows.
>
> I doubt if it will affect any existing user workflows, at least not
> directly.
>
> But the biggest one is no way to remove NODATASUM flags.
>
> This means those files will never be verified by scrub, which will
> eventually affect existing btrfs maintenance.
>
>
> I'm wondering if it makes more sense, to only set NODATASUM if the
> current mount option has nodatasum.
>
> This will fix the test case but also provide a way to keep the existing
> full revert behavior.

We can always prevent the test case from running if nodatasum is in
the mount options, we have the helper _require_btrfs_no_nodatasum().

>
> Thanks,
> Qu
>
> > I can only guess it's very rare.
> >
> >>
> >> Fixes: 7e97b8daf634 ("btrfs: allow setting NOCOW for a zero sized file=
 via ioctl")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>   fs/btrfs/ioctl.c | 3 +--
> >>   1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> >> index d4981d2a42d7..74849a4208b5 100644
> >> --- a/fs/btrfs/ioctl.c
> >> +++ b/fs/btrfs/ioctl.c
> >> @@ -336,8 +336,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
> >>                   */
> >>                  if (S_ISREG(inode->vfs_inode.i_mode)) {
> >>                          if (inode->vfs_inode.i_size =3D=3D 0)
> >> -                               inode_flags &=3D ~(BTRFS_INODE_NODATAC=
OW |
> >> -                                                BTRFS_INODE_NODATASUM=
);
> >> +                               inode_flags &=3D ~BTRFS_INODE_NODATACO=
W;
> >>                  } else {
> >>                          inode_flags &=3D ~BTRFS_INODE_NODATACOW;
> >>                  }
> >
> > This can now be simplified:
> >
> > if (!S_ISREG(inode->vfs_inode.i_mode) || inode->vfs_inode.i_size =3D=3D=
 0)
> >      inode_flags &=3D ~BTRFS_INODE_NODATACOW;
> >
> > Reviewed-by: Filipe Manana <fdmanana@suse.com>
> >
> > Thanks.
> >
> >> --
> >> 2.54.0
> >>
> >>
> >
>
