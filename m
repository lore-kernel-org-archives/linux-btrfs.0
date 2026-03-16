Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62A8329E6C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677277; cv=none; b=WV2RUlXRGjA6tgkvlG9Ck4fRMt/nxukLMgA2q1jGGFxQGH1KrAzBRHkV4WRoNz4Gwmq0xbNmXk02XRUBVIvYDj9ZnP+69oKIJ7fsUHTZ3GBcKcYaM2hz0lU6D9012e7FmIUOxeFhO6N8J8IDCEv0PWZS5IQStoDCjYF7ZocBSIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677277; c=relaxed/simple;
	bh=I6YGkn9YIUTTj7inWAkt3Puj+rh+io5Bp179EGJvusg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Me2R/YzYSkpXFyOADcOlr5d5tUg/tlvBIPnLec60ORW7ebiWIoWbic5blhneHXyF1o+4wT1PQvoXwMZwOcoXPnhZrVP4gK6J/xDYXZgzbQc9KqXJMyNqf4SI9381wHN32xOAv+53j4EAfzMiLlxjxMmVLWdZuGc5RTRU/Q7BFAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkXnqoqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkXnqoqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C36C2BCB0
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677277;
	bh=I6YGkn9YIUTTj7inWAkt3Puj+rh+io5Bp179EGJvusg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nkXnqoqLnSklfhZJvA1+j3JSkNVJCVt/JzuxcheCguQ9kIS4b78V1Vvk9wgofnp5y
	 VdgVJFIeywqYrJDWsMV6Sk7xhK/RHT0dJcGpf864hVyrkOrXNeoyaGbHwBjGxt2Ooq
	 LlcAgtYXcWtx8IrcQ3cUqKz1k2nmlyPXvQS7qRfMOMewjJ7RlQcULwsqRDa5yKcEDF
	 wPPF6qTndKme1TLqPgEJNeo2x2fm9NqyrvVandFYlwtyrjA3xrmVfGjclpp8CWqsHt
	 OzEGI1dad8sTIWDN2KhA7Rts6mzMhbFlp/j9Imw3spZF6AKpJuvI+0CwueVUEyQLPq
	 Jn+Q94aOeOz6w==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b97b7e0368eso179707766b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 09:07:57 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy5lHjd4QRqp87/OgS0GBe6lBgXc5Bd6S+eMerhGGR7QGVZiajL
	zVicw9KHtEEzNnIFC1bkO27/VZcEroFLY+ANtLN6qVIXCxyUIHw7P02wkFUvB5aKNFSiBmKWhit
	Hj6R2r34HOgroKrd0ioc4vJoftXnIeN4=
X-Received: by 2002:a17:907:3c8a:b0:b97:7fa6:85a with SMTP id
 a640c23a62f3a-b977fa62f02mr668877166b.37.1773677275922; Mon, 16 Mar 2026
 09:07:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <188ad91e78cda1fe6430eaf0ae158a5554c2a4c7.1773610691.git.wqu@suse.com>
In-Reply-To: <188ad91e78cda1fe6430eaf0ae158a5554c2a4c7.1773610691.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 16 Mar 2026 16:07:18 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5Nh1kjcsewHaqLwpF=uk6jusQHGKNECZnisoiFEmtH-Q@mail.gmail.com>
X-Gm-Features: AaiRm53TBdkKmxauxQMeQ2DhmUKtOWca5H1qk44G-t0kedOxEJgO08T_OhnXwt4
Message-ID: <CAL3q7H5Nh1kjcsewHaqLwpF=uk6jusQHGKNECZnisoiFEmtH-Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: remove @atomic parameter from btrfs_buffer_uptodate()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 15, 2026 at 9:40=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> That parameter is introduced by commit b9fab919b748 ("Btrfs: avoid

is -> was

> sleeping in verify_parent_transid while atomic").
> At that time we need to lock the extent buffer range inside the io tree,

need -> needed

> to avoid content changes thus it may sleep.

it may sleep -> it could sleep

Also missing a comma between "changes" and "thus".

>
> But that behavior is no longer there, as later commit 947a629988f1
> ("btrfs: move tree block parentness check into
> validate_extent_buffer()") changed the transid check into the endio
> function thus there is no need to lock io tree.

Giving that commit as a reference, isn't very useful in my opinion.

It would be best to mention which commit removed the io tree locking
inside btrfs_buffer_uptodate(), which is:

9e2aff90fc2a ("btrfs: stop using lock_extent in btrfs_buffer_uptodate")

As that's what really matters and makes the function don't block/sleep anym=
ore.

With that fixed:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
> We can remove the @atomic parameter safely now.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.c       | 2 +-
>  fs/btrfs/disk-io.c     | 7 ++-----
>  fs/btrfs/disk-io.h     | 2 +-
>  fs/btrfs/extent-tree.c | 2 +-
>  fs/btrfs/extent_io.c   | 6 +++---
>  fs/btrfs/tree-log.c    | 2 +-
>  6 files changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index cdd6c1422b53..5c68c541de51 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1499,7 +1499,7 @@ read_block_for_search(struct btrfs_root *root, stru=
ct btrfs_path *p,
>                         reada_for_search(fs_info, p, parent_level, slot, =
key->objectid);
>
>                 /* first we do an atomic uptodate check */
> -               if (btrfs_buffer_uptodate(tmp, check.transid, true, NULL)=
 > 0) {
> +               if (btrfs_buffer_uptodate(tmp, check.transid, NULL) > 0) =
{
>                         /*
>                          * Do extra check for first_key, eb can be stale =
due to
>                          * being cached, read from scrub, or have multipl=
e
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 868afeb37235..75d8ab39601d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -109,7 +109,7 @@ static void csum_tree_block(struct extent_buffer *buf=
, u8 *result)
>   * detect blocks that either didn't get written at all or got written
>   * in the wrong place.
>   */
> -int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid, =
bool atomic,
> +int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid,
>                           const struct btrfs_tree_parent_check *check)
>  {
>         if (!extent_buffer_uptodate(eb))
> @@ -125,9 +125,6 @@ int btrfs_buffer_uptodate(struct extent_buffer *eb, u=
64 parent_transid, bool ato
>                 return 1;
>         }
>
> -       if (atomic)
> -               return -EAGAIN;
> -
>         if (btrfs_header_generation(eb) !=3D parent_transid) {
>                 btrfs_err_rl(eb->fs_info,
>  "parent transid verify failed on logical %llu mirror %u wanted %llu foun=
d %llu",
> @@ -1001,7 +998,7 @@ static struct btrfs_root *read_tree_root_path(struct=
 btrfs_root *tree_root,
>                 goto fail;
>         }
>
> -       ret =3D btrfs_buffer_uptodate(root->node, generation, false, &che=
ck);
> +       ret =3D btrfs_buffer_uptodate(root->node, generation, &check);
>         if (unlikely(ret <=3D 0)) {
>                 if (ret =3D=3D 0)
>                         ret =3D -EIO;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 343e332b17c0..9185f8f02eeb 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -107,7 +107,7 @@ static inline struct btrfs_root *btrfs_grab_root(stru=
ct btrfs_root *root)
>  void btrfs_put_root(struct btrfs_root *root);
>  void btrfs_mark_buffer_dirty(struct btrfs_trans_handle *trans,
>                              struct extent_buffer *buf);
> -int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,=
 bool atomic,
> +int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
>                           const struct btrfs_tree_parent_check *check);
>  int btrfs_read_extent_buffer(struct extent_buffer *buf,
>                              const struct btrfs_tree_parent_check *check)=
;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a0a0212c5f40..a55b910c755b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5780,7 +5780,7 @@ static int check_next_block_uptodate(struct btrfs_t=
rans_handle *trans,
>
>         generation =3D btrfs_node_ptr_generation(path->nodes[level], path=
->slots[level]);
>
> -       if (btrfs_buffer_uptodate(next, generation, false, NULL))
> +       if (btrfs_buffer_uptodate(next, generation, NULL))
>                 return 0;
>
>         check.level =3D level - 1;
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 980f16313e11..56a2c8e01b83 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3905,7 +3905,7 @@ int read_extent_buffer_pages_nowait(struct extent_b=
uffer *eb, int mirror_num,
>         if (extent_buffer_uptodate(eb)) {
>                 int ret;
>
> -               ret =3D btrfs_buffer_uptodate(eb, 0, true, check);
> +               ret =3D btrfs_buffer_uptodate(eb, 0, check);
>                 if (unlikely(ret <=3D 0)) {
>                         if (ret =3D=3D 0)
>                                 ret =3D -EIO;
> @@ -3936,7 +3936,7 @@ int read_extent_buffer_pages_nowait(struct extent_b=
uffer *eb, int mirror_num,
>                 int ret;
>
>                 clear_extent_buffer_reading(eb);
> -               ret =3D btrfs_buffer_uptodate(eb, 0, true, check);
> +               ret =3D btrfs_buffer_uptodate(eb, 0, check);
>                 if (unlikely(ret <=3D 0)) {
>                         if (ret =3D=3D 0)
>                                 ret =3D -EIO;
> @@ -4654,7 +4654,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_inf=
o *fs_info,
>         if (IS_ERR(eb))
>                 return;
>
> -       if (btrfs_buffer_uptodate(eb, gen, true, NULL)) {
> +       if (btrfs_buffer_uptodate(eb, gen, NULL)) {
>                 free_extent_buffer(eb);
>                 return;
>         }
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 6cf2828ba500..de4707b1227e 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -457,7 +457,7 @@ static int process_one_buffer(struct extent_buffer *e=
b,
>                         return ret;
>                 }
>
> -               if (btrfs_buffer_uptodate(eb, gen, false, NULL) && level =
=3D=3D 0) {
> +               if (btrfs_buffer_uptodate(eb, gen, NULL) && level =3D=3D =
0) {
>                         ret =3D btrfs_exclude_logged_extents(eb);
>                         if (ret)
>                                 btrfs_abort_transaction(trans, ret);
> --
> 2.53.0
>
>
