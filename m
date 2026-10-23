Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792745522;
	b=139weZ/ZJ+eaYZ29rIb9E+5tRjVb8U26LtM5Fr1ftBNe7X1cdVotyUeaQEeysjbWRJYW
	 ukN/th/dinoWShaKZSHGbpnfG6GVYYim3XEyr415+4VPJz93cOxkjXIHTxnE2NyQNQ3sD
	 cz7Z+zIDpmfnZVZmJr11rqrchQ7VtQjSFYhQcKFUwfZi3YI6AhvGej+6odPmqV80mKmBZ
	 5OwFlLxbJbPm4jh/AHoDwuziPp03mteeWm2aygCdTAQG4oprqZW+EDZkbwAcaQ3UjnMXD
	 cmFC8NFdvYAQnumaQDY+1DAEn4PdkHRzPDit7Iq0mS3pEBzEGxLTIONtjFRV2FE+IlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792745522;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=kjKs2ugBhVLa3Zw0ZNYMnUgCeH2NfBtm3pbvNDkoBG4=;
	b=NVUcjYJVOeyl/B3uO+0TSfUhG1Am9O5DzPmqqVdLIyJn3ydObVTqH9JIjlWlwYjQ5Tsj
	 8yILLc7n1on5NQREnArH75ZaroZWreqR+LWGxvIqKvZQZzR1VkgSbCLDIPP1p9+JIji+5
	 RTARUlwYaB+zdHlI5reyE3qk8MPvmhIBLEYjC2ymcCs7ETj3k4zeEcgcZr9DTnOomHYvj
	 ts7Tbtrp9Or7LpX5alvy2JP2l9fT9NS+hVpHap2+6Wr28AjdJ2I7QlAb2taDn24wila0V
	 D7iCHgj2/9tzT/c1gu/K5FXr1qt7LL6DklZEfILRPj37w4EmKHq3R3V4yfyiYDRcu2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWDxxEas;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CA3606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWDxxEas
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C281F031E6
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 08:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792745522;
	bh=kjKs2ugBhVLa3Zw0ZNYMnUgCeH2NfBtm3pbvNDkoBG4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hWDxxEasAHboDOK7VeYbudXwnpU8/AT0yseoq6EN1hI7i7Ogw2KAL46dybQggZw9+
	 lC9nRux59GS+wyMYr4L05SASfES1odpV02/xPWJDx+E8BmL+gibIOrsaZ/Xf9arSXN
	 7IKTqZZnACEMQat5+DnbnWglJWEgrIXb49l7K462cnuEetriMRUKGMIjwdRo/tpyJI
	 1NMomyv0HKm34LupgjkU+JwlCOoeDAz6K9KtO8hDy79pYu+4+gXDar1GMLdk9/Z9OH
	 WtD8CQGTiHhuirXUYsssIJBkvxhvXqeKYoBso3jWIKfNtLFu1FuN/21srN/s7geU7J
	 oJB6c9Qh2xTSw==
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7cb6dc850c7so216909137.0
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 01:52:02 -0700 (PDT)
X-Gm-Message-State: AFq9FYIs5sdFhJ9Uvd0nVRPpDtQWaUqpjin9hehQEqu+yHDlnizrk0r8
	vs+owd214eRKS/AbCSJX1nh/CItTjbjPmYa2NdXg/8szBe3gj3YF7LgKX6BOcyVFEKn1fR2bsVX
	HqJMSAr83AT+3p7UOImFlF5uL2jZxtgk=
X-Received: by 2002:a05:6102:442b:b0:7c1:75c5:c4c with SMTP id
 ada2fe7eead31-7ccc33558f2mr628956137.25.1792745521468; Fri, 23 Oct 2026
 01:52:01 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <25a6b104e8af433508c425cd7470426470f811f2.1792613378.git.fdmanana@suse.com>
 <087634ad0970d81654b2f1cc72cd35bbde47df97.1792618636.git.fdmanana@suse.com> <31e4e491-c331-43fa-bbf5-7459860834de@gmx.com>
In-Reply-To: <31e4e491-c331-43fa-bbf5-7459860834de@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 23 Oct 2026 09:51:23 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6r_2REGMQvCdO+O7L6aPus=FsmfdRV3Pzh1rrAB+PF1A@mail.gmail.com>
X-Gm-Features: AclHuK_8H9JZYFnpgbmf1VYD1bjTjLpGOvwNU7n-FnL_VqQzQb-B0EXL7ffJUI0
Message-ID: <CAL3q7H6r_2REGMQvCdO+O7L6aPus=FsmfdRV3Pzh1rrAB+PF1A@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: send: fix missing hole punching during
 incremental send
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 7:39=E2=80=AFAM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/10/22 08:11, fdmanana@kernel.org =E5=86=99=E9=81=93:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When using the no-holes feature (enabled by default since btrfs-progs
> > v5.15) and doing an incremental send, we can miss issuing a hole punchi=
ng
> > command when the following conditions happen:
> >
> > 1) A hole is punched in a tail section of a file extent item that happe=
ns
> >     to be the last item in a leaf (for example the extent covers the fi=
le
> >     range [1M, 3M) and a hole is punched in the range [2M, 3M)). Betwee=
n
> >     the end of this file extent item's range and the i_size, there are
> >     other file extent items;
> >
> > 2) The next leaf was not modified in the send snapshot, remaining share=
d
> >     with the parent snapshot.
> >
> > In this scenario we are unable to detect a hole was punched and never
> > issue a hole punch command because with no-holes there we don't have an
> > exlicit file extent item to mark a hole.
> >
> > Fix this by teaching maybe_send_hole() to detect such case.
> > A test case for fstests will follow soon.
> >
> > Reported-by: Tristan Elvers <tristanelvers@gmail.com>
> > Link: https://lore.kernel.org/linux-btrfs/CAFoLKK+aErV4p6ZJPnVeH5SHQ5++=
0f=3D8ZgxPWe-E-CkeKBs8PA@mail.gmail.com/
> > Fixes: 16e7549f045d ("Btrfs: incompatible format change to remove hole =
extents")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V2: Address a couple issues pointed by sashiko, simplify a few things.
> >
> >   fs/btrfs/send.c | 62 +++++++++++++++++++++++++++++++++++++++++++++---=
-
> >   1 file changed, 58 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index c523bf950c89..cec1aae5ce14 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -6371,6 +6371,8 @@ static int range_is_hole_in_parent(struct send_ct=
x *sctx,
> >   static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *=
path,
> >                          struct btrfs_key *key)
> >   {
> > +     BTRFS_PATH_AUTO_FREE(next_path);
> > +     u64 next_offset;
> >       int ret =3D 0;
> >
> >       if (sctx->cur_ino !=3D key->objectid || !need_send_hole(sctx))
> > @@ -6397,14 +6399,66 @@ static int maybe_send_hole(struct send_ctx *sct=
x, struct btrfs_path *path,
> >               ret =3D range_is_hole_in_parent(sctx,
> >                                             sctx->cur_inode_last_extent=
,
> >                                             key->offset);
> > -             if (ret < 0)
> > -                     return ret;
> > -             else if (ret =3D=3D 0)
> > +             if (ret =3D=3D 0)
> >                       ret =3D send_hole(sctx, key->offset);
> > -             else
> > +             else if (ret =3D=3D 1)
> >                       ret =3D 0;
> > +
> > +             if (ret < 0)
> > +                     return ret;
> >       }
> >       sctx->cur_inode_last_extent =3D btrfs_file_extent_end(path);
> > +
> > +     /*
> > +      * If we are the last file extent item in a leaf, we may have had=
 a tail
> > +      * section that got a hole punched, and if there is no change in =
the
> > +      * next leaf, we must find out if we have such a hole and punch i=
t.
> > +      */
> > +     if (path->slots[0] !=3D btrfs_header_nritems(path->nodes[0]) - 1)
> > +             return ret;
>
> Just a nitpick, do we need to check NO_HOLES features? IIRC without
> NO_HOLES, we should always have a file extent covering i_size, thus
> without NO_HOLES, we should not need to check for the next leaf?

It could check that, but NO_HOLES is enabled by default for quite some
years now, plus skipped it for consistency with the existing code that
is exclusive for NO_HOLES but also misses the check.
Since I have another optimization to skip that check and sending empty
holes, I'll include it in the next version.

Thanks.

>
> Thanks,
> Qu
>
> > +
> > +     next_path =3D alloc_path_for_send();
> > +     if (!next_path)
> > +             return -ENOMEM;
> > +
> > +     ret =3D btrfs_search_slot(NULL, sctx->send_root, key, next_path, =
0, 0);
> > +     if (ret < 0)
> > +             return ret;
> > +     if (WARN_ON(ret !=3D 0))
> > +             return -EUCLEAN;
> > +
> > +     ret =3D btrfs_next_leaf(sctx->send_root, next_path);
> > +     if (ret < 0) {
> > +             return ret;
> > +     } else if (ret > 0) {
> > +             /*
> > +              * No next leaf, must punch hole to i_size and set the pa=
th back
> > +              * to where it was before.
> > +              */
> > +             next_offset =3D sctx->cur_inode_size;
> > +     } else {
> > +             struct btrfs_key next_key;
> > +
> > +             btrfs_item_key_to_cpu(next_path->nodes[0], &next_key,
> > +                                   next_path->slots[0]);
> > +             if (next_key.objectid !=3D key->objectid ||
> > +                 next_key.type !=3D BTRFS_EXTENT_DATA_KEY)
> > +                     next_offset =3D sctx->cur_inode_size;
> > +             else
> > +                     next_offset =3D next_key.offset;
> > +     }
> > +
> > +     btrfs_free_path(next_path);
> > +     next_path =3D NULL;
> > +
> > +     ret =3D range_is_hole_in_parent(sctx, sctx->cur_inode_last_extent=
, next_offset);
> > +     if (ret =3D=3D 0)
> > +             ret =3D send_hole(sctx, next_offset);
> > +     else if (ret =3D=3D 1)
> > +             ret =3D 0;
> > +
> > +     sctx->cur_inode_last_extent =3D next_offset;
> > +
> >       return ret;
> >   }
> >
>
