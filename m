Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793966633;
	b=wg4pmFM4I3hSrbRWa5oirDN87VftkzfL7qIgnKJ4wlHTrckRHurizJykHFx/rrSxdffd
	 T1tpaxRhZB/iRxB6Yj5BwFkQh4tSHKRqeo8xmFpNOYlCSnJox4BfTTRgqxyIthYQimoqs
	 /xGld6m/ap9goZy+jMar8U4B+/w6jDcK2V2T03HWj5lFdxAapFj4gu6prAuGNPnOQCOTK
	 PpRzX8Hm6M4tB7++XkX2Pgrg5Rf/6KqfFQv1ecMjNiN90VwbRxy8DFPABvvbjRkERSe9I
	 ZtoT9vTgG8ZpnTZld24nY7vb4Wo4d/+t6G3xgNs5mRr18us6Pnkl7Oxj7z9zjzS67oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793966633;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=wyYPPTXnF1ky1EOV9iMKwuhqeqdzrDAE8rQxJfvfPBA=;
	b=BnkFrGJhIC/KwBmuBbpXo9TdIav+IIOwgkkSJzUeLBrIsMaxyIW4yb1JVH8sN6tPmtkc
	 BIH/EviI6ZXl8gaj2+XYo2gNGVlE3zfUoaYrSHS3uqEOd8cG+s9wpYMiO5Pzd6pjkw81r
	 +llb3rBZrs7OcRmkcWgEbETi66cqg4DET71qCc/AG4x6HYTVNbwheSqAW8qDxo0KZLvmu
	 s48o/soqZ1eZbQHaux6JhkyY0q0VIRGCUYr4mEXjadAx2hAaUpmJzOtK95Se2ssUnsujk
	 oFpOVntI0YQ8zMDBG7JWzKFvtcglKzN23q8QcnxST/9Pja6Tv2VdsiobfrHw2T/P9Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzV3tGhL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1403606D82E
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 12:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzV3tGhL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622541F008BD
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793966632;
	bh=wyYPPTXnF1ky1EOV9iMKwuhqeqdzrDAE8rQxJfvfPBA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TzV3tGhLGAcV47JQjj7s3JEdcf6Fo/3yuAplG1ju1HFPFAb61KeXAtfesVwZ2sTNu
	 /grLW638AE2+orolVa2RTY9obE401IF9ZBmauubGgxH7w/eOO4n2TuhfC/Bu5TVhi2
	 6cfVIewuKHpGqHF9/bM5bBXJnZn/H3dleWHVdlHAmuXzAOjyFlaydC1LlV2plK145U
	 9JlHrrVXowLeXZ7NW8w4qyPTQj5RPdCRLGxQxNhzRc2K4kEpBbo39bm2ksWlAmERfH
	 JvERuZDX0I06Kf2aUvKvF3KNKf+4H8Y2q4hFtAr75hIm9x5fJCDLMiF9d4y3h630Mk
	 xwmG1Me+mIX2Q==
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5ebf39def3aso188687e0c.3
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 04:03:52 -0800 (PST)
X-Gm-Message-State: APuU4Z8WMBTkxWBCgWzF6z7RyXkGdolsm2xq3vNpIbX4GKYsTUcbbhmC
	zcsXc5x6mSqJ/aIV0ww0QY4lSKt3NZYIQX0lClqYs+sqWCZUTXoMzOJQZcNKP1oGOMdLapjU+mS
	iuLIalt1OgSb5TrYoNKbvRko1/Lah870=
X-Received: by 2002:a05:6122:21a6:b0:5ca:fc48:5634 with SMTP id
 71dfb90a1353d-5ecc43e5c71mr1030174e0c.11.1793966631484; Fri, 06 Nov 2026
 04:03:51 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <14e0d19262452be0d9e08478f47be08ec6fa6d6f.1793852473.git.wqu@suse.com>
 <CAL3q7H7JCSuTuGvmwrf3ckBwhm-5Wnnub-6C1mXGX=ZTi0Yo8g@mail.gmail.com> <29d5cd74-1613-4ee2-a9e4-ec9e0b430bd1@suse.com>
In-Reply-To: <29d5cd74-1613-4ee2-a9e4-ec9e0b430bd1@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 6 Nov 2026 12:03:15 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5S4qprU2PcGNyYyMjQQv2=KwF1tgOkBLiY12cXu5WPzw@mail.gmail.com>
X-Gm-Features: AclHuK9sC6wkNqRiezAjHaRVuhdjXRE5G_hP9Eejdr-IFvg2Qv8McIey2Qs4BlY
Message-ID: <CAL3q7H5S4qprU2PcGNyYyMjQQv2=KwF1tgOkBLiY12cXu5WPzw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: skip fast sync for inodes with encoded writes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 9:40=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/11/6 04:39, Filipe Manana =E5=86=99=E9=81=93:
> > On Thu, Nov 5, 2026 at 4:48=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> >>
> >> [BUG REPORT]
> >> Sashiko reported a bug that encoded writes can have its file extents
> >> recorded before their data reaches disks.
> >>
> >> [CAUSE]
> >> An encoded write returns to the caller as soon as its bio is submitted=
,
> >> and its folios are not in the inode's page cache:
> >>
> >>    btrfs_ioctl_encoded_write()
> >>     \- btrfs_do_encoded_write()
> >>         |- btrfs_alloc_ordered_extent()
> >>         \- btrfs_submit_compressed_write()   <- returns before the bio=
 ends
> >>
> >> A fast fsync only waits for writeback of the folios in the page cache,
> >> so it has nothing to wait for on such an ordered extent:
> >>
> >>    btrfs_sync_file()
> >>     |- btrfs_get_ordered_extents_for_logging()
> >>     |- filemap_fdatawait_range()             <- no folio under writeba=
ck
> >>     \- btrfs_log_dentry_safe()
> >>         \- ...
> >>             \- log_extent_csums()
> >>                 \- log_csums()               <- csum_list may be in fl=
ight
> >>
> >> This has two problems:
> >>
> >> - fsync can return before the data of the encoded write is on disk, wh=
ile
> >>    the log tree describing it is already persisted.
> >>
> >> - With async data checksum generation, the sums are attached to
> >>    ordered->csum_list by btrfs_csum_one_bio() before the checksums are
> >>    calculated.  log_extent_csums() can then log zeroed or partially
> >>    calculated checksums.
> >>
> >> For buffered writes this is not a problem, as writeback of a folio end=
s
> >> after the bio endio, which in turn runs after the checksums are
> >> generated.
> >>
> >> [FIX]
> >> Fix it by requiring full sync for the inode which went through encoded
> >> writes.
> >>
> >> Encoded writes are mostly utilized by btrfs-recevice, so it's never on
> >> the hot path.
> >> And receveied subvolumes are set read-only, so normally no one should
> >> even call fsync() on those inodes. Thus the cost of full fsync on enco=
ded
> >> writes should be very acceptable.
> >>
> >> Link: https://sashiko.dev/#/patchset/8eb322321cac98013cc46dfe8d89fa58c=
1ad3dee.1793766229.git.wqu%40suse.com
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >> Changelog
> >> RFC->v1: (RFC at https://lore.kernel.org/linux-btrfs/c284dccd8c27a6434=
e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com/)
> >> - Require full fsync instead of waiting for encoded writes
> >>    The common usage of encoded writes are btrfs receive, so we shouldn=
't
> >>    need to bother fsync on those files in the first place.
> >>
> >>    And this makes the fix much simpler.
> >>
> >> - Drop the REASON for RFC part
> >>    Which contains quite some incorrect assumptions on fsync() and dire=
ct
> >>    IOs
> >> ---
> >>   fs/btrfs/inode.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> index ab60b7d4f389..65714380a935 100644
> >> --- a/fs/btrfs/inode.c
> >> +++ b/fs/btrfs/inode.c
> >> @@ -10035,6 +10035,12 @@ ssize_t btrfs_do_encoded_write(struct kiocb *=
iocb, struct iov_iter *from,
> >>                  ret =3D PTR_ERR(ordered);
> >>                  goto out_free_reserved;
> >>          }
> >> +       /*
> >> +        * fsync() of the inode can not go through fast path, as there=
 is no
> >> +        * dirty/writeback folio in the page cache for fsync() to wait=
.
> >
> > Neither there are dirty/writeback folios nor do we wait for the IO of
> > the ordered extent to finish (bit BTRFS_ORDERED_IO_DONE set) before
> > unlocking the inode.
> > The comment focuses too much on this not being buffered IO, which is
> > somewhat confusing because fsync works for direct IO.
>
> Yep, I admit I focused too much on that.
>
> Do you have some advice on how to change the comments?

Maybe something like this:

/*
 * A fast fsync can't deal with encoded writes because it neither
dirties folios nor it
 * waits for ordered extent completion (or finish its IO only) before
unlocking the inode.
 * The consequence is that it results in a race that can make the fast
fsync log file
 * extent items without logging the csum items for the extent, as it
may not find them
 * neither in the ordered extent nor in the csum tree.
 */

Thanks.

>
> Thanks,
> Qu
>
> >
> > Otherwise:
> >
> > Reviewed-by: Filipe Manana <fdmanana@suse.com>
> >
> > Thanks.
> >
> >> +        * So fast sync can return without waiting for the data to rea=
ch disks.
> >> +        */
> >> +       btrfs_set_inode_full_sync(inode);
> >>          btrfs_dec_block_group_reservations(fs_info, ins.objectid);
> >>
> >>          if (start + encoded->len > inode->vfs_inode.i_size)
> >> --
> >> 2.56.0
> >>
> >>
>
