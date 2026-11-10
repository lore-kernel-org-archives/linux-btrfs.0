Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794305780;
	b=3lx17CsT9BABE/XR4OQYuLEIY9enSWmChIuVRH3TUqzbYcK9FLJYe4+Ptcb2O1Cs1IOL
	 Vb8rvsQTIqSz6Ab+AjbCc9S/kIoqZAukHmrA73S1qhVgMU/WWYlLdUEpsu306yVKIOtpy
	 wohc+bdzRpzQVr2iRPNxHW7VomqhzHl8ubuTtSzyXQA1x2N4PB/qSTxCSHTw3LdfnHBJD
	 4w14icH1qb9LxUbbpWgAm/RlTVi5JnrOKPJwbIYo8bXCs8kywRD7kzmkcWFK39g6VIThS
	 TXRj7ozlx6rlOyGgbcrvEsZ0ucozWSB2abIHTR04N/LRa/8qOOA7RiZLv2lIui9SkcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794305780;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=l3JC/ixlfcJ95CJk936zRUaGSjufLXggqToz6BYa2wM=;
	b=S2mqrh4YWcdkREBZKQ1h3ZVSIWJF9ZhlRK2Sxrr1pERFdoGCuXooKm13fG2QP/4dmagn
	 gnjhUIOtFSsosupC9ricmhhFKItBxOCF5xU1LE/xqMIB8lt3hXBsyEsHwyN8QzSP3eDHG
	 dkEld5rx4vp4e3OaHwUh04T+ZrlYvW6AQfHSS7ygQVeVsnhzyldqjYfajkF6aUUwngjjF
	 tUYYOBzkl6TFMT7p6UkZb0ti+8sZ/6ZA1JnQMkaFXohYRD4a7WA5zA3hctB7nmv0vybGI
	 0/+gOYZDXAoORYtVoSQEsnC1zm6lrHa6w1/up0Q4X4k9pUQjwALVWWUW7EH5PLNvC5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SDJ+8Fpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A340606A326
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 10:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SDJ+8Fpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A9D1F008A1
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 10:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794305780;
	bh=l3JC/ixlfcJ95CJk936zRUaGSjufLXggqToz6BYa2wM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SDJ+8FpeGvFJOfnm1QTv19DNsMu7PP/zcK4wKccMq6nr2Tevn2lPt/u2h4rgGKDjB
	 jLRD3L3qAquLLn1Mgs7oNUUBLlpIDO9UFJQ5i0cMkOuHxEmfqra3LZY2wOp5BdcWow
	 5MsNAZOUopVMoEicEhUbhg0+pm+8ZgPZ/0oARDUPFEYC8LKm1544Sonym1OP9JT0/i
	 gNw5ngYrrYpSaIZtKProxHBXekSSuoSu/aq5veWUSoRUat7QoXaPIa9HYX6ImpNxZD
	 +dLYyLHHQAYZIxSRa1B8ZGMQSFOVVr/4KAgwAKx/qAMaS+feRqJdOUdLhyJSb+zDil
	 p5zkSKpSeWfnQ==
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-992f6d8cb51so376033241.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 02:16:20 -0800 (PST)
X-Gm-Message-State: APuU4Z+buMGfUA/kadTz+HYB5g5XPJYGrdKDJaylYCkupzv6l4XcvQW5
	V+Is/bYUWZUme+KiAmFGZdYz7vso39fMFCOG24ok4wi0K79QH/pec0jNdssij7bxpBnwbSy9kFz
	54YLj7rqy25dsPMl45lOFnPB/m4iVZ00=
X-Received: by 2002:a05:6102:950:b0:7c3:6466:3155 with SMTP id
 ada2fe7eead31-7d301c35810mr685011137.33.1794305779134; Tue, 10 Nov 2026
 02:16:19 -0800 (PST)
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
 <6399e4a7-8a3a-4c64-9e80-9cd26a4613db@suse.com> <CAL3q7H58WgEFz5EH0ikgoZooH136gRGXsdoog0nJMnA_k9B+4A@mail.gmail.com>
In-Reply-To: <CAL3q7H58WgEFz5EH0ikgoZooH136gRGXsdoog0nJMnA_k9B+4A@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 10 Nov 2026 10:15:41 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4uevQr53Jow-HeHDzvHLcGqkdQyoVqBXFRCZyvxQ0Wxg@mail.gmail.com>
X-Gm-Features: AclHuK_dtnauujJJ2wYwiR-dRwdDx67vmldcvHm-jLnwlxUC-l0CoK-nM7ZyF64
Message-ID: <CAL3q7H4uevQr53Jow-HeHDzvHLcGqkdQyoVqBXFRCZyvxQ0Wxg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] btrfs: do not allow fast fsync if there is any
 async dio write
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 10:01=E2=80=AFAM Filipe Manana <fdmanana@kernel.org=
> wrote:
>
> On Tue, Nov 10, 2026 at 7:06=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> >
> >
> >
> > =E5=9C=A8 2026/11/10 16:42, Qu Wenruo =E5=86=99=E9=81=93:
> > > Sashiko reported a possible race where an async direct write happened=
, a
> > > fast fsync() can return before the write reaches the storage:
> > >
> > >    CPU0 (io_uring/AIO direct write)| CPU1
> > >    --------------------------------+---------------------------------=
--
> > >    btrfs_direct_write()
> > >    |-btrfs_dio_write()
> > >    | \-__iomap_dio_rw()
> > >    |   |-btrfs_dio_iomap_begin()
> > >    |   | |-btrfs_new_extent_direct()
> > >    |   |   ^^^ new extent + ordered extent, data not written yet
> > >    |   |
> > >    |   |-btrfs_dio_submit_io()
> > >    |   | |-btrfs_submit_bbio()
> > >    |   |   ^^^ bio in flight, not finished
> > >    |   |
> > >    |   \- return -EIOCBQUEUED
> > >    \-btrfs_inode_unlock()
> > >                                      btrfs_sync_file()
> > >                                      |-btrfs_get_ordered_extents_for_=
logging()
> > >                                      | ^^^grabs the incomplete OE
> > >                                      |
> > >                                      |-filemap_fdatawait_range()
> > >                                      | ^^^no folio under writeback, r=
eturns
> > >                                      |    immediately
> > >                                      |
> > >                                      |-btrfs_log_dentry_safe()
> > >                                      | | ...
> > >                                      | \-btrfs_log_changed_extents()
> > >                                      |   ^^^ logs file extent item fo=
r the new extent
> > >                                      |       OE only marked PENDING, =
nobody waits for its IO
> > >                                      |
> > >                                      \-btrfs_sync_log()
> > >                                        ^^^ log tree is on disk, data =
bio still in flight
> > >                                            fsync() returns
> > >
> > >    power loss, the data bio never reached disk
> > >
> > >    mount
> > >    |-btrfs_recover_log_trees()
> > >      ^^^ replays the extent item, file now points to unwritten blocks
> > >
> > > To prevent such problem, disable fast fsync for async direct writes.
> > >
> > > Fixes: 487781796d30 ("btrfs: make fast fsyncs wait only for writeback=
")
> > > Link: https://sashiko.dev/#/bug/linux-ee047626-2fa7-46d5-b543-8611369=
93fc7
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > ---
> > >   fs/btrfs/direct-io.c | 11 +++++++++++
> > >   1 file changed, 11 insertions(+)
> > >
> > > diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> > > index ed3914257d39..6e796163015e 100644
> > > --- a/fs/btrfs/direct-io.c
> > > +++ b/fs/btrfs/direct-io.c
> > > @@ -974,6 +974,17 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, s=
truct iov_iter *from)
> > >
> > >       if (IS_ERR_OR_NULL(dio)) {
> > >               ret =3D PTR_ERR_OR_ZERO(dio);
> > > +             /*
> > > +              * The async direct write is not waiting for its IO to =
finish.
> > > +              *
> > > +              * If fsync() went through the fast path, the direct wr=
ite OE
> > > +              * will be logged, but the data may not yet reach disks=
.
> > > +              * And fsync() returned without waiting for the data.
> > > +              *
> > > +              * So for async direct writes, we can not go to fast sy=
nc path.
> > > +              */
> > > +             if (ret =3D=3D -EIOCBQUEUED)
> > > +                     btrfs_set_inode_full_sync(BTRFS_I(inode));
> >
> > Unfortunately btrfs_set_inode_full_sync() is not safe if the caller is
> > only holding a shared inode lock.
> >
> > So it can still race with fsync.
>
> How can it race? An fsync takes the inode lock in exclusive mode.
>
> >
> > The shared inode lock for dio writes is introduced by commit
> > e9adabb9712e ("btrfs: use shared lock for direct writes within EOF").
> >
> > This is making me wonder if the shared inode lock for direct IO is a
> > good idea in the first place.
>
> Why would it not be a good idea?
>
> >
> > Or should I change fsync() to wait for direct IOs instead of using
> > btrfs_set_inode_full_sync()?
>
> Under which conditions is  -EIOCBQUEUED returned?
> Are these async writes (like io_uring)?
>
> If that's common, then forcing full fsyncs badly affects performance.

And Josef's pending patch actually solves this issue already:

https://lore.kernel.org/linux-btrfs/20261103-b4-btrfs-data-integrity-v2-3-5=
77dc2690061@toxicpanda.com/

It ensures we wait for IO completion for all ordered extents.

>
> We had fast fsync long before 487781796d30.
> It got introduced back in 2012 in commit 5dc562c541e1, then removed in
> b5e6c3e170b770 and then added back (in a slightly different form) in
> 487781796d30.
> So are you sure 487781796d30 is the culprit?
>
>
> >
> > Thanks,
> > Qu
> > >       } else {
> > >               /*
> > >                * If we have a synchronous write, we must make sure th=
e fsync
> >
> >
