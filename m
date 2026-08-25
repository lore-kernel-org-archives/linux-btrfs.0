Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69D3D6473
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661874; cv=none; b=u1NGcJOEC/oOHljxQdOFKY8vJfGJrLgdTDa70m+EY5LeaO/xWn9ChOp35rXyUEIyizl5TlaILpf9V+CCnh8d++T75DdnXZLfc5qzZFzm9JtccYnaLeAxVW2f7ipwjKvTSgQKF7I1D/LcM4UOvPtgKsJWLBUdq9fKmJ3p3GHej6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661874; c=relaxed/simple;
	bh=ll6y75ooCRchgyxZeUHotaBUZUK9DPrvl9IIxYpiJvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ItYWWI9OjqRcTlfaq6r76NLD+H76TCm6SALAqHs5VO0fhhiBAXo0o9Ax1d4g9vrvaGjjSym7VsJDvlR8Mada1NsyD7c+YJq1QU2BEAoJhhBexWdHnANts0pAPNg6qAyEE7jEtWv5yaK3wxnCT7pnQvnVlUT1JXLM6g3YZoga2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQEVmlsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQEVmlsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EE71F00A3D
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661873;
	bh=Up1r2Wfz6GePYl0MoxARHjDx1lLB/XUFX/+T+I5ItIA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AQEVmlsPkRW4dkV3+2yMnbo0I+lfp/GxXsib4Ya7j4uUvk3AU+p57yS5WU9yeeioj
	 wFajWuDEDsEWpd6TxbIMMqWXhYgoIP/vJoFu2heMY9u+MyH3kVoYnZ++H4qKZS9veQ
	 dP+o9VIUjuSBhuJfpLRzhjnPKGbRn9pKbs1dcKP2znst5gfDO4d9iWqQL/vul2rMwl
	 y9npSx9J8Tbi6s09I2buiWGC3RV5WFixwc58M8pj2GN3y9EmIhEGPVKKIcY4d9GSG5
	 tY9S5OLpkeUjF64GjrYNvveWTU63hWCcbaK/Pt4juGMW5C01N2bO6Jyxd4OqbOJx0O
	 hD870jkKCnFCQ==
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5c2c46a428eso3628033e0c.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 05:44:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro2Yo9RU2+yoGywZZ4F5MSoatZTUY8ugNJ2+UFi5rlt7tgB2tDWPEYDcEyZlUGLflGOMZjYqy2GnJ+96g==@vger.kernel.org
X-Gm-Message-State: AFuF++mXHqKqylubI2ITsjV7ue5A2PSxvso2c2cA4TvzlCZ05dYkDdYD
	KENYNaHL9sExTAVftMRqC+QZHw3clZNjSoKL/OTM+mVIjrPDCdcQJvQwGD2mQTw/dQ7kkhWafqi
	n112quEfYmcwK1wpXQ/p1G95+PNqrqys=
X-Received: by 2002:a05:6122:3306:b0:5c2:acd2:5b44 with SMTP id
 71dfb90a1353d-5c642ec21eemr3107682e0c.3.1787661872487; Tue, 25 Aug 2026
 05:44:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260810094701.1349706-1-thnkslprpt@gmail.com> <CAL3q7H6UoS_=XJj=pa97o4P8upbbqY3axJAnmSg6H_XZfZZdsA@mail.gmail.com>
In-Reply-To: <CAL3q7H6UoS_=XJj=pa97o4P8upbbqY3axJAnmSg6H_XZfZZdsA@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 25 Aug 2026 13:43:56 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6G9vEDVMU5e=p80o3+3zOUaL+pdk9_-cCqw3FCEXew6Q@mail.gmail.com>
X-Gm-Features: AcwNN1Wq4iAJigkviRTcY8Ftbjr-5FTodFOSV_-Kh1q6XtLk7o07nDfts36h7fw
Message-ID: <CAL3q7H6G9vEDVMU5e=p80o3+3zOUaL+pdk9_-cCqw3FCEXew6Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: send: propagate errors from is_inode_existent()
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 1:38=E2=80=AFPM Filipe Manana <fdmanana@kernel.org>=
 wrote:
>
> On Mon, Aug 10, 2026 at 10:52=E2=80=AFAM Avi Weiss <thnkslprpt@gmail.com>=
 wrote:
> >
> > The direct-return refactor in commit b3047a42f55d ("btrfs: send:
> > directly return from will_overwrite_ref() and simplify it") changed
> > will_overwrite_ref() to return directly instead of going through the
> > common out label.
> >
> > That resulted in a negative return value from is_inode_existent()
> > to start being converted to 0, making lookup errors unable to be
> > distinguished from the inode not existing.
> >
> > process_recorded_refs() expects negative errors from
> > will_overwrite_ref() and aborts processing when it receives one.
> >
> > Return the value from is_inode_existent() to restore the previous error
> > propagation behavior as it was before the refactor.
> >
> > Fixes: b3047a42f55d ("btrfs: send: directly return from will_overwrite_=
ref() and simplify it")
> > Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>
> Looks good, thanks.

I changed the subject to be less confusing, as the change is about a
specific caller of is_inode_existent():

btrfs: send: fix lost error return value in will_overwrite_ref()

And I pushed it to the for-next github branch.

>
> > ---
> >  fs/btrfs/send.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index 3ae480c7474b..a888202397ed 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -2066,7 +2066,7 @@ static int will_overwrite_ref(struct send_ctx *sc=
tx, u64 dir, u64 dir_gen,
> >
> >         ret =3D is_inode_existent(sctx, dir, dir_gen, NULL, &parent_roo=
t_dir_gen);
> >         if (ret <=3D 0)
> > -               return 0;
> > +               return ret;
> >
> >         /*
> >          * If we have a parent root we need to verify that the parent d=
ir was
> >
> > base-commit: af5534fe2fbc006e83d75d6283dfc5ec75d5d780
> > --
> > 2.43.0
> >
> >
