Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794861595;
	b=VUYiKNHQTiTuC11TNQwAumxFDgWaQoVxGsFG0WwoW5oFOJq5pkLA9ujgwKSyw9QnNPvy
	 UWOO9zX4SXADGFOs0QQPjyJLVmO0YjrkQeMJmhEO1vfK/UggCgEkFLHGtp2tlFQ+jV7F5
	 AjiFFlKEp6F+uXsJLWFJKNXbyqJVQNzG7xgDvRGbGGvzAYGNHTujsnA7GZkvsKcM7Tl3i
	 nOrJCDICI4C5kzndz1ApHMwGTbdIPG9M8BKgWMtcjODk8+RQmC+n7l0AotNKffq9S4u/D
	 pHbKGaUO2x4W4PuIpm+R+lfUjCBvuOJSY9/qVfMJheI558DwToCf8cN7wNzUd9DR/rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794861595;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=JVpzGXMB055PVnX98n6sroCeH7sN9bXahPWD0UR4apc=;
	b=ZKJUq51ey2VZyQR4G3H23sgZBiRvHcZiIQIUJwAzIWdQlYKwis6IjQgNjVfoDhXkvY4q
	 Da9PpgCAnsBPLiilFv+pR2A0Y2nm4rR3zSymFTjuXxaRrbbvpAuicKfQwy6Hy4BE3+SQk
	 bH4GJCX5Xo0aAcxhqId/bgeXQR11qPARBNikP7XRtvjkqoJWCACpA+5ktg/64E9unrDK8
	 vXXfh7MipeJLwP4pkzc205Ule4Ikvf1C0RUdF8OHqYqzEmviE5A6Qp5hDVeOZNp8kOuXe
	 G9phYqJFj34TuNxPLRIkckg7To+ey03c/W7n9gePMCnvs/6QNd56HMYZ4RmkFPnzBIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="G/r9O0d2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B2606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G/r9O0d2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361321F000C5
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794861595;
	bh=JVpzGXMB055PVnX98n6sroCeH7sN9bXahPWD0UR4apc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G/r9O0d2ov42sKTj48DNZCrmiv0Y/bY4Sj1UndjBbFDznmjDxeD2ew9cq6KzBlfXm
	 DHhlwRXD9XvEm3YO3xJgYaBQxuzQxF+3H6BB2llMclWbMgWmeOC6iWXK6DSaWoCuCt
	 tTeqrzMSB0nWizmUpXwESZ3UshEOA2rz8zJxvoEe02vXno3D9Pvs3RAJXrzOtBpAeI
	 Vy9fgYIsTRSaYFasxSIgt77sbl8oqxARMdw4Dtk+xrXgCi+A+TPt3jiV72wd9plPzO
	 8nkbbJAc6KlxxNyuhgQiwcN5Eu8Vn33ZRzpZzaOr417brt1qwEPbk3DHHy7vZaDcZv
	 rK1SIDcuiawbg==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5ee1e4e3abcso1115553e0c.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:39:55 -0800 (PST)
X-Gm-Message-State: APuU4Z8by5CP0tWqBZD/lHI38OfVAejf3n6osaGv1FxcpT191EkqXlFN
	AIY6Nb82YrwZSWVMp4OcC0e28u6sSqmVW3mTblDm6vUQ9wCl2Auf+6cqt8bt1od9xhAVXNiI29m
	1LFBtbTSuOPqavRxsm27a+l6jpO44GCU=
X-Received: by 2002:a05:6102:61c9:10b0:7d6:864a:5509 with SMTP id
 ada2fe7eead31-7d6864aac91mr1089200137.24.1794861594416; Mon, 16 Nov 2026
 12:39:54 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <df971dad64e73d71fe7e9bd9188efe5f22e9bea4.1794833257.git.fdmanana@suse.com>
 <7eac394b-824d-48ef-bc30-2488195568e4@gmx.com>
In-Reply-To: <7eac394b-824d-48ef-bc30-2488195568e4@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 16 Nov 2026 20:39:17 +0000
X-Gmail-Original-Message-ID: <CAL3q7H463g6bc61LBVLK0PJh9kmQpYqrkVLJpnBBje=9xWbxxg@mail.gmail.com>
X-Gm-Features: Aa3M54q8BlKZeUrKnV4aLCQxpKAvx63NXzUaLo59aJ2U0n2v4zmzvEQxva8T9fI
Message-ID: <CAL3q7H463g6bc61LBVLK0PJh9kmQpYqrkVLJpnBBje=9xWbxxg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: add missing unlikely tag to branches leading to
 transaction aborts
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 8:34=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/11/16 23:18, fdmanana@kernel.org =E5=86=99=E9=81=93:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > We have a few branches that lead to transaction aborts that are missing
> > the unlikely tag, so add it to them as these are unexpected scenarios.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> [...]
> > @@ -4445,7 +4445,7 @@ static int move_existing_remap(struct btrfs_fs_in=
fo *fs_info,
> >       if (unlikely(ret)) {
> >               btrfs_free_reserved_extent(fs_info, dest_addr, dest_lengt=
h, 0);
> >
> > -             if (trans) {
> > +             if (unlikely(trans)) {
>
> This seems to be overkilled?
>
> There are a lot of goto end callsites in the function and @trans
> shouldn't be NULL for most cases here.

I probably missed that the preceding `if` statement already has
unlikely, so this one is not needed.
I'll remove it before committing to for-next, thanks.

>
> Otherwise looks good to me.
>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>
> Thanks,
> Qu
>
> >                       btrfs_abort_transaction(trans, ret);
> >                       btrfs_end_transaction(trans);
> >               }
> > @@ -5158,26 +5158,26 @@ static int do_remap_reloc_trans(struct btrfs_fs=
_info *fs_info,
> >
> >       if (bg_needs_free_space) {
> >               ret =3D btrfs_add_block_group_free_space(trans, dest_bg);
> > -             if (ret) {
> > +             if (unlikely(ret)) {
> >                       btrfs_abort_transaction(trans, ret);
> >                       goto fail;
> >               }
> >       }
> >
> >       ret =3D copy_remapped_data(fs_info, start, new_addr, length);
> > -     if (ret) {
> > +     if (unlikely(ret)) {
> >               btrfs_abort_transaction(trans, ret);
> >               goto fail;
> >       }
> >
> >       ret =3D btrfs_remove_from_free_space_tree(trans, new_addr, length=
);
> > -     if (ret) {
> > +     if (unlikely(ret)) {
> >               btrfs_abort_transaction(trans, ret);
> >               goto fail;
> >       }
> >
> >       ret =3D add_remap_entry(trans, path, src_bg, start, new_addr, len=
gth);
> > -     if (ret) {
> > +     if (unlikely(ret)) {
> >               btrfs_abort_transaction(trans, ret);
> >               goto fail;
> >       }
> > diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> > index 399414ae67c8..763487114f85 100644
> > --- a/fs/btrfs/tree-log.c
> > +++ b/fs/btrfs/tree-log.c
> > @@ -434,7 +434,7 @@ static int process_one_buffer(struct extent_buffer =
*eb,
> >
> >               if (btrfs_buffer_uptodate(eb, gen, NULL) && level =3D=3D =
0) {
> >                       ret =3D btrfs_exclude_logged_extents(eb);
> > -                     if (ret)
> > +                     if (unlikely(ret))
> >                               btrfs_abort_transaction(trans, ret);
> >               }
> >       }
> > @@ -2943,7 +2943,7 @@ static int clean_log_buffer(struct btrfs_trans_ha=
ndle *trans,
> >               int ret;
> >
> >               ret =3D btrfs_pin_reserved_extent(trans, eb);
> > -             if (ret)
> > +             if (unlikely(ret))
> >                       btrfs_abort_transaction(trans, ret);
> >               return ret;
> >       }
> > @@ -3019,7 +3019,7 @@ static noinline int walk_down_log_tree(struct btr=
fs_path *path, int *level,
> >                       path->slots[*level]++;
> >                       if (wc->free) {
> >                               ret =3D btrfs_read_extent_buffer(next, &c=
heck);
> > -                             if (ret) {
> > +                             if (unlikely(ret)) {
> >                                       free_extent_buffer(next);
> >                                       if (trans)
> >                                               btrfs_abort_transaction(t=
rans, ret);
> > @@ -3038,7 +3038,7 @@ static noinline int walk_down_log_tree(struct btr=
fs_path *path, int *level,
> >                       continue;
> >               }
> >               ret =3D btrfs_read_extent_buffer(next, &check);
> > -             if (ret) {
> > +             if (unlikely(ret)) {
> >                       free_extent_buffer(next);
> >                       if (trans)
> >                               btrfs_abort_transaction(trans, ret);
> > @@ -3617,7 +3617,7 @@ static void free_log_tree(struct btrfs_trans_hand=
le *trans,
> >
> >       if (log->node) {
> >               ret =3D walk_log_tree(&wc);
> > -             if (ret) {
> > +             if (unlikely(ret)) {
> >                       /*
> >                        * We weren't able to traverse the entire log tre=
e, the
> >                        * typical scenario is getting an -EIO when readi=
ng an
> > diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> > index cbee10b6b49a..1a71a1472c27 100644
> > --- a/fs/btrfs/xattr.c
> > +++ b/fs/btrfs/xattr.c
> > @@ -260,7 +260,7 @@ int btrfs_setxattr_trans(struct inode *inode, const=
 char *name,
> >       inode_inc_iversion(inode);
> >       inode_set_ctime_current(inode);
> >       ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> > -     if (ret)
> > +     if (unlikely(ret))
> >               btrfs_abort_transaction(trans, ret);
> >   out:
> >       if (start_trans)
> > @@ -446,7 +446,7 @@ static int btrfs_xattr_handler_set_prop(const struc=
t xattr_handler *handler,
> >               inode_inc_iversion(inode);
> >               inode_set_ctime_current(inode);
> >               ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> > -             if (ret)
> > +             if (unlikely(ret))
> >                       btrfs_abort_transaction(trans, ret);
> >       }
> >
>
