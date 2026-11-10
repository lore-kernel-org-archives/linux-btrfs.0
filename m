Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794304926;
	b=YkC6I1+DkyQ78EAl+zJdEyF5m3B2+2VYzDjB9G+h/TZ6aZliQrJmdN6Wb103gt3GRSWL
	 EDPGZwszYbafnZZ9U8Hz6ZJvht6D49Ob60pjbST0p0Uoii+LQ46bCSysfhbK+xKyXB/p/
	 Fl/trd5jgwGg8f3zwduGBZf010ffSDTlxGteTj39iV5Gw0+bQnX7KmDbzXyuDDZl+LuWv
	 Ask8gt6JTUT+1ohPaN8Ufy7t9Nj3nVAUpk8VHgPQWr3Ew/rE4t0Z5NpQcbYahI4yDh2d4
	 KO3U1CTJUpARJVkB8JMQ7i9x+RhM1T/z/5dI1KJVT72Z4/YqizdjS1E5OoUM25kMl3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304926;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=0tc0bVM93tYUsmwT6MRApbpGX6I3156s3Zc+aQGOOWY=;
	b=zCzXFesVmT+HvZdtELNiEml3b/Lyyt6eAUB/y4QQn93oqcsX9RXtk/XWoNLbv1R9u2Dy
	 bcXaDfDn6BiYKN+2m91SdD+tzVAtKUN6BTYpHDo/eq+t2Li1xeVSrbgojvMB9rlQH5+GS
	 fK/aW/viRDwj/mE6UFmLxLkeKQyRpK3n0AjfuxNL3USsvl5d5RhwlrB1l10lTAO4FZU96
	 oNywGjQGf8rGRFuXklPgkERvhO4B/B0rtnsBee9BPbZmJSA36+xA6kkFYhz5/MoM1JqVC
	 3bWQhxdSJVNxdkceEpQuhNsrTNDTy7OADvyKn1qaYrM34wtxN/zRvJ92c9V80kNxu4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WlSzH2/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF82606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 10:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WlSzH2/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C7D1F008A7
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794304925;
	bh=0tc0bVM93tYUsmwT6MRApbpGX6I3156s3Zc+aQGOOWY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WlSzH2/WfpBwddUnPiNtHA/NkJ0ij1wfl1X3/9MXzAXC24VWsYWhmKItSb6f5bGoz
	 HibWOvtbEdtWcPqKdXIFL+uXaDYMytj4xORogiG/XoNA0l8cXOkcJQuw14D3JlIARX
	 m1s/k8ir/VRjDgxPh4jCrTy+516FLtP1k4kINlF/2ajRhAxwZrB1SgBnIl5zis50H2
	 gwpfvblSUlUuIXZ5p7bxlirZJdUvxrn/XUPnaMmzcH39lT4iILEFRgITSWWIQNUy2I
	 J5W2vruomeXCQtUOprGuRn0RoC0Xr6xHAKZezymj2liGNZvfbpG32tO3ibpwmZI8Lp
	 ubs2IZ9QvjP4g==
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7d2dc1ac787so580129137.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 02:02:05 -0800 (PST)
X-Gm-Message-State: APuU4Z+0w6/zJX23of9a+UBcqCEpcwmSU90l87YY7d+Th1JvV50coxpU
	FIEyutXRYY6uvceRetqD91hU1M8smnQ/Wfc8/tmhW9GhDP4MTadWt0UDHxhQCv+3xRYIsUL/X6x
	PjshB2fu8BPkdZT5s1WK9ply+YDS12zI=
X-Received: by 2002:a05:6102:f9e:b0:7cc:21cd:9b46 with SMTP id
 ada2fe7eead31-7d301c16882mr505703137.33.1794304925022; Tue, 10 Nov 2026
 02:02:05 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794290876.git.wqu@suse.com> <aa2343bbda662ef5f425c0dfbb5c84cc67940fcd.1794290876.git.wqu@suse.com>
 <6399e4a7-8a3a-4c64-9e80-9cd26a4613db@suse.com>
In-Reply-To: <6399e4a7-8a3a-4c64-9e80-9cd26a4613db@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 10 Nov 2026 10:01:28 +0000
X-Gmail-Original-Message-ID: <CAL3q7H58WgEFz5EH0ikgoZooH136gRGXsdoog0nJMnA_k9B+4A@mail.gmail.com>
X-Gm-Features: AclHuK_wogBvlvzd6-Adbj6Qusw0__JVL5ndAo6y-JPJQxRN40qXUA6JwnzEg6I
Message-ID: <CAL3q7H58WgEFz5EH0ikgoZooH136gRGXsdoog0nJMnA_k9B+4A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] btrfs: do not allow fast fsync if there is any
 async dio write
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 7:06=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/11/10 16:42, Qu Wenruo =E5=86=99=E9=81=93:
> > Sashiko reported a possible race where an async direct write happened, =
a
> > fast fsync() can return before the write reaches the storage:
> >
> >    CPU0 (io_uring/AIO direct write)| CPU1
> >    --------------------------------+-----------------------------------
> >    btrfs_direct_write()
> >    |-btrfs_dio_write()
> >    | \-__iomap_dio_rw()
> >    |   |-btrfs_dio_iomap_begin()
> >    |   | |-btrfs_new_extent_direct()
> >    |   |   ^^^ new extent + ordered extent, data not written yet
> >    |   |
> >    |   |-btrfs_dio_submit_io()
> >    |   | |-btrfs_submit_bbio()
> >    |   |   ^^^ bio in flight, not finished
> >    |   |
> >    |   \- return -EIOCBQUEUED
> >    \-btrfs_inode_unlock()
> >                                      btrfs_sync_file()
> >                                      |-btrfs_get_ordered_extents_for_lo=
gging()
> >                                      | ^^^grabs the incomplete OE
> >                                      |
> >                                      |-filemap_fdatawait_range()
> >                                      | ^^^no folio under writeback, ret=
urns
> >                                      |    immediately
> >                                      |
> >                                      |-btrfs_log_dentry_safe()
> >                                      | | ...
> >                                      | \-btrfs_log_changed_extents()
> >                                      |   ^^^ logs file extent item for =
the new extent
> >                                      |       OE only marked PENDING, no=
body waits for its IO
> >                                      |
> >                                      \-btrfs_sync_log()
> >                                        ^^^ log tree is on disk, data bi=
o still in flight
> >                                            fsync() returns
> >
> >    power loss, the data bio never reached disk
> >
> >    mount
> >    |-btrfs_recover_log_trees()
> >      ^^^ replays the extent item, file now points to unwritten blocks
> >
> > To prevent such problem, disable fast fsync for async direct writes.
> >
> > Fixes: 487781796d30 ("btrfs: make fast fsyncs wait only for writeback")
> > Link: https://sashiko.dev/#/bug/linux-ee047626-2fa7-46d5-b543-861136993=
fc7
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >   fs/btrfs/direct-io.c | 11 +++++++++++
> >   1 file changed, 11 insertions(+)
> >
> > diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> > index ed3914257d39..6e796163015e 100644
> > --- a/fs/btrfs/direct-io.c
> > +++ b/fs/btrfs/direct-io.c
> > @@ -974,6 +974,17 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, str=
uct iov_iter *from)
> >
> >       if (IS_ERR_OR_NULL(dio)) {
> >               ret =3D PTR_ERR_OR_ZERO(dio);
> > +             /*
> > +              * The async direct write is not waiting for its IO to fi=
nish.
> > +              *
> > +              * If fsync() went through the fast path, the direct writ=
e OE
> > +              * will be logged, but the data may not yet reach disks.
> > +              * And fsync() returned without waiting for the data.
> > +              *
> > +              * So for async direct writes, we can not go to fast sync=
 path.
> > +              */
> > +             if (ret =3D=3D -EIOCBQUEUED)
> > +                     btrfs_set_inode_full_sync(BTRFS_I(inode));
>
> Unfortunately btrfs_set_inode_full_sync() is not safe if the caller is
> only holding a shared inode lock.
>
> So it can still race with fsync.

How can it race? An fsync takes the inode lock in exclusive mode.

>
> The shared inode lock for dio writes is introduced by commit
> e9adabb9712e ("btrfs: use shared lock for direct writes within EOF").
>
> This is making me wonder if the shared inode lock for direct IO is a
> good idea in the first place.

Why would it not be a good idea?

>
> Or should I change fsync() to wait for direct IOs instead of using
> btrfs_set_inode_full_sync()?

Under which conditions is  -EIOCBQUEUED returned?
Are these async writes (like io_uring)?

If that's common, then forcing full fsyncs badly affects performance.

We had fast fsync long before 487781796d30.
It got introduced back in 2012 in commit 5dc562c541e1, then removed in
b5e6c3e170b770 and then added back (in a slightly different form) in
487781796d30.
So are you sure 487781796d30 is the culprit?


>
> Thanks,
> Qu
> >       } else {
> >               /*
> >                * If we have a synchronous write, we must make sure the =
fsync
>
>
