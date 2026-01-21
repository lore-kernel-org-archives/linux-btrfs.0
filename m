Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697E93B5306
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768992184; cv=none; b=Z22fzItXweYDJ6EuSGOuZasZ6mKTLLc2DtJbQuTubBIdADbvCfrqW2+gajFQ/1Ml6mEU3pTHFDZjB4oI2+ETYUZbDWvTwV6Y3kpkdEr2alVpxKASRJGGixcmG7edvzgReocFX0u6yegdYqImaOrJlWbFuFOhSdv2GQPPWLQkfBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768992184; c=relaxed/simple;
	bh=RGeL/xScXSiZmEzjKzZtigLupwl9cFB8OrHjXURQ4a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C9kKspSazEJStdlCfqtgPTmNeXTRcZmu9mnHkdyeOfIZgn9NFQxbLOspYHaxm90sJ/R21DJe2l/PFO39qgRUotquXB5lu7vS4Dt2jG8VKQbUHf6am9mk7pFqBBcCNToM388As/uds7TS7ExGmOPqZFVuYL8Cj6lABr/XVhnUF4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YChsGjRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YChsGjRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7F1C16AAE
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768992182;
	bh=RGeL/xScXSiZmEzjKzZtigLupwl9cFB8OrHjXURQ4a8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YChsGjRlLC4JX8007g4ja8BqS7yjxwDOrxbBzLymcuynn8IzkJxIb4ipiOCyPQZju
	 yivOwU1LwmwbyKg1iAY4Er/1SCNVaCWxcVa62add7gljrOMe3HlSGaoS3DO9i0HSt7
	 NSErmqW+7TooC3854QeW60VcwW9gcrp7kU2U4Mo+//S2FT0s83ZZUrX4AJ9wI1PsXd
	 +ExRZ6T5FFZYKOMcI+yh3R04DTnEBDhXeP3C/UUFEmIlGnc8h2eFyzYw8QOL6F/3vc
	 Gt9t/joqMXbULxzlXcUXVm5fwNXR3UNHO1tbqpHzccZVAbJWlmA96z2C31/5M/GRLb
	 KtR8f0E8vfPSw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b874c00a39fso131742466b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 02:43:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV1wIB+POh/8agTeVH6ztwWRU8o9X1pHGYnZgwbQs2a7EIK7gRfza2iVW7nf8EgfwWCT15xh/HairivoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw23JzzqLb7fM8XJv+60bXtaVvZjBMUsXNbnZ2t4yCsfaYKDG/a
	tTBZrVjGWK04rFKB0y7KVtrqBJwsS+cIihjkjcX/CTylHd3JhrTj8Ndr6oXGKhWrEddNYgaMLxB
	qgWohet5gA2JBQIhx8MHktut13M9yvnY=
X-Received: by 2002:a17:906:3091:b0:b87:23b4:11f4 with SMTP id
 a640c23a62f3a-b8777a0b1admr1475580966b.2.1768992180538; Wed, 21 Jan 2026
 02:43:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768911827.git.fdmanana@suse.com> <05452a804b036b205a791be1c1c5e09d0279812d.1768911827.git.fdmanana@suse.com>
 <3a5d1472-7ff0-447f-9d02-f75a60161ead@gmx.com> <20260121042455.GO26902@twin.jikos.cz>
 <b1f7072a-57de-4df5-abcf-a9e975e5c58f@gmx.com>
In-Reply-To: <b1f7072a-57de-4df5-abcf-a9e975e5c58f@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Jan 2026 10:42:23 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5NRKqd4drKJfsLfcG8TB+tVo4p+KQyz2M6p7CnYg_b6A@mail.gmail.com>
X-Gm-Features: AZwV_QhtcuvhgLzOq4LA0qJut94weTJsSqdk-J1HWkDqZuRcHUL0PykjT5h3hsQ
Message-ID: <CAL3q7H5NRKqd4drKJfsLfcG8TB+tVo4p+KQyz2M6p7CnYg_b6A@mail.gmail.com>
Subject: Re: [PATCH 2/4] btrfs: allocate path in load_block_group_size_class()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 4:40=E2=80=AFAM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/1/21 14:54, David Sterba =E5=86=99=E9=81=93:
> > On Wed, Jan 21, 2026 at 07:16:06AM +1030, Qu Wenruo wrote:
> >> =E5=9C=A8 2026/1/20 22:55, fdmanana@kernel.org =E5=86=99=E9=81=93:
> >>> From: Filipe Manana <fdmanana@suse.com>
> >>>
> >>> Instead of allocating and freeing a path in every iteration of
> >>> load_block_group_size_class(), through its helper function
> >>> sample_block_group_extent_item(), allocate the path in the former and
> >>> pass it to the later.
> >>>
> >>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >>> ---
> >>>    fs/btrfs/block-group.c | 32 +++++++++++++++++---------------
> >>>    1 file changed, 17 insertions(+), 15 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> >>> index 343c29344484..a7828673be39 100644
> >>> --- a/fs/btrfs/block-group.c
> >>> +++ b/fs/btrfs/block-group.c
> >>> @@ -579,24 +579,24 @@ int btrfs_add_new_free_space(struct btrfs_block=
_group *block_group, u64 start,
> >>>     * @index:        the integral step through the block group to gra=
b from
> >>>     * @max_index:    the granularity of the sampling
> >>>     * @key:          return value parameter for the item we find
> >>> + * @path:         path to use for searching in the extent tree
> >>>     *
> >>>     * Pre-conditions on indices:
> >>>     * 0 <=3D index <=3D max_index
> >>>     * 0 < max_index
> >>>     *
> >>> - * Returns: 0 on success, 1 if the search didn't yield a useful item=
, negative
> >>> - * error code on error.
> >>> + * Returns: 0 on success, 1 if the search didn't yield a useful item=
.
> >>>     */
> >>>    static int sample_block_group_extent_item(struct btrfs_caching_con=
trol *caching_ctl,
> >>>                                       struct btrfs_block_group *block=
_group,
> >>>                                       int index, int max_index,
> >>> -                                     struct btrfs_key *found_key)
> >>> +                                     struct btrfs_key *found_key,
> >>> +                                     struct btrfs_path *path)
> >>>    {
> >>>     struct btrfs_fs_info *fs_info =3D block_group->fs_info;
> >>>     struct btrfs_root *extent_root;
> >>>     u64 search_offset;
> >>>     const u64 search_end =3D btrfs_block_group_end(block_group);
> >>> -   BTRFS_PATH_AUTO_FREE(path);
> >>>     struct btrfs_key search_key;
> >>>     int ret =3D 0;
> >>>
> >>> @@ -606,17 +606,9 @@ static int sample_block_group_extent_item(struct=
 btrfs_caching_control *caching_
> >>>     lockdep_assert_held(&caching_ctl->mutex);
> >>>     lockdep_assert_held_read(&fs_info->commit_root_sem);
> >>>
> >>> -   path =3D btrfs_alloc_path();
> >>> -   if (!path)
> >>> -           return -ENOMEM;
> >>> -
> >>>     extent_root =3D btrfs_extent_root(fs_info, max_t(u64, block_group=
->start,
> >>>                                                    BTRFS_SUPER_INFO_O=
FFSET));
> >>>
> >>> -   path->skip_locking =3D true;
> >>> -   path->search_commit_root =3D true;
> >>> -   path->reada =3D READA_FORWARD;
> >>> -
> >>>     search_offset =3D index * div_u64(block_group->length, max_index)=
;
> >>>     search_key.objectid =3D block_group->start + search_offset;
> >>>     search_key.type =3D BTRFS_EXTENT_ITEM_KEY;
> >>> @@ -679,6 +671,7 @@ static int sample_block_group_extent_item(struct =
btrfs_caching_control *caching_
> >>>    static void load_block_group_size_class(struct btrfs_caching_contr=
ol *caching_ctl,
> >>>                                     struct btrfs_block_group *block_g=
roup)
> >>>    {
> >>> +   BTRFS_PATH_AUTO_FREE(path);
> >>>     struct btrfs_fs_info *fs_info =3D block_group->fs_info;
> >>>     struct btrfs_key key;
> >>>     int i;
> >>> @@ -688,14 +681,23 @@ static void load_block_group_size_class(struct =
btrfs_caching_control *caching_ct
> >>>     if (!btrfs_block_group_should_use_size_class(block_group))
> >>>             return;
> >>>
> >>> +   path =3D btrfs_alloc_path();
> >>> +   if (!path)
> >>> +           return;
> >>
> >> Considering the function is only called inside a workqueue, we can avo=
id
> >> a memory allocation by using on-stack path, which also reduces one err=
or
> >> path.
> >
> > As a generic pattern we could switch to on-stack variables for the
> > functions called from workqueues but it may not be obvious that it's OK
> > to do that (unlike eg. the compression functions).
> >
> > But I'd like to have an assertion or a debug warning for that, not sure
> > how exactly to do it, maybe something is in the task_struct.
> >
>
> I was looking into that during async csum development. But I didn't find
> a good way to determine if we're in workqueue.

We can do this and it works:

/*
* Since we run in workqueue context, we allocate the path on stack to
* avoid memory allocation failure, as the stack in a work queue task
* is not deep.
*/
ASSERT(current_work() =3D=3D &caching_ctl->work.normal_work);

I'm adding that to the patch and will push into for-next soon.

> The closest one I found is in_task(), which can not distinguish
> workqueue and regular userspace falling into kernel situations.
>
> Maybe there are some way to poking into the current task structure, but
> I didn't find a straightforward helper.
>
> Thanks,
> Qu
>
