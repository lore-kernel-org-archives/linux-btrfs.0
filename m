Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794502502;
	b=o7Ohz5rmtnJDo1HeaHz5amQMwPxWwhR5h3p5kJm+urczDx+sbm9RmA7xV+Tc/J4xanvZ
	 PGOz6O8O2wlQzOgkqbsTqlQJhAiPdey09Pjz87b1zzGG4lzttP7GmNC5T6/eyWD2zcAhN
	 Oy+S0GtCtP/P3v87+JDBWAakNmIrds+2+gmjUrt4bGZCPRcKHHGlRZTJTmmBmY03soBI5
	 Aq0DQOoT53mQCh+NQoLQr5DJCs3APARHBPTLVe6ptV8sdSfVrTZtdaiUirNIukElday5R
	 aforiFAqjtIoGi94ZkNyTm0cWy0mxnmwo8sVzFGaigc+hZhK4ZRCFzTXhTXFwk6A+QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794502502;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=a97/kxgkWfQG3szv8pqZV1LLSWmn9TKRgxmUHup6U1Y=;
	b=SkR8RyN0OyIMKtNsbsiRvWk2raA2l8UDkv1l8lnXKvLvgFWG1HJBh280EGl71QMJjwa5
	 5GOV1SOt1/3KB/5Vod/nnH+lqmtvSeBxA9Pf8O4fVWFjiLfa0BwyawfyWJElAk3G8iP4k
	 Ut4wPuA1SKmqmDGop37QOsiyB1v7lkYR1oJfTqAuxpb+n4UC8bG6dK/L/4EQcQIYMxUX0
	 8OBCwh5A2KRlhcI8V5w3Rby2bzv7ZoYeZ+VfEV2GuVXrHn/VRjPNHd32mhPljRqICSg4x
	 nIpBT6caRaABz7jVliGplGLJkeqTMQwDcY6A5RfSBIa2uZVqlQpC9WuDtCh28+y4S9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RkOw+Dfv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBD7606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RkOw+Dfv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577341F000C5
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794502502;
	bh=a97/kxgkWfQG3szv8pqZV1LLSWmn9TKRgxmUHup6U1Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RkOw+Dfvh9zjuMwZKDpm/4yeWP2kf43fEzkM6qCsy/y629AJWAbBCTC6CFH+Nj0iN
	 uSWXDDQuB+948JpGzqNq3tyYieeOizDPX3rYCjz+eH5Aie2EHQuAlmJxl0Eb4LVgdD
	 +T7R97ChXUfFI6/Zr5DUnPNzDeyiSyB9b9Q+xHS41KIfBaugfWxnwFdP/IhFQ4kkGb
	 TldTpPZv4QLMRSCpDOpZwDALDTUp43NIr1AetRaf1VuEIUewISRjOj5qA3J3LRFkZ1
	 zmoO3tdNcVWjmczyflvGqsFdIiUnkC/PU1Pgk57md8+BhsXQYEcKVb48gPgAY/QnSo
	 rQ2zmwjw+vYeQ==
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6df0b02fe91so789238eaf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 08:55:02 -0800 (PST)
X-Gm-Message-State: APuU4Z8w4u/S/9+7VRJ+iD+mJ1NlWBZCAKRMjJBYMkFF/j3wNInuQthT
	JTBHjzt4L/p9Ohy0WUiOkLYHjWRq0VxzJy32LfySRGuSHuoL3lhlqaPKkdf5YZPaKx5ONgj+Y3W
	AHtHBbejXyj/2LUmgWpe5zV2IKqlUmQ8=
X-Received: by 2002:a05:6820:c5d1:10b0:708:cdb1:ec86 with SMTP id
 006d021491bc7-71974214421mr1133855eaf.35.1794502501357; Thu, 12 Nov 2026
 08:55:01 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <29f91f205377d9076610cacff756194285eb400f.1794371180.git.wqu@suse.com>
In-Reply-To: <29f91f205377d9076610cacff756194285eb400f.1794371180.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 12 Nov 2026 16:54:24 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4eWd8hrCdXf9pNESZJrVDL_Q=+cj=DNaGD1NR-bBrOEw@mail.gmail.com>
X-Gm-Features: AclHuK-2zQe3yCbOuc92iQW6RT5uach_F7YcCoWVp5kcBJBo789fJjaur5A_oZc
Message-ID: <CAL3q7H4eWd8hrCdXf9pNESZJrVDL_Q=+cj=DNaGD1NR-bBrOEw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: zstd: use a dedicated hidden max level workspace
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 4:28=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> zstd_get_workspace() relies on one max level workspace being hidden from
> the reclaim lru list, so that after a failed allocation under memory
> pressure there is always a max level workspace to wait for.
>
> But which workspace is hidden is decided on every put, by checking whethe=
r
> idle_ws[max] is empty, and that can go wrong. A max level workspace can
> sit on the lru list, e.g. W2 that was put while W1 was already idle at th=
e
> max level. Then:
>
>  Task A (level 1)                     Task B (level 15)
>  zstd_get_workspace()
>  \-zstd_find_workspace()
>    |-pops W2 from idle_ws[max]
>    \-req_level =3D 1, W2 stays on lru
>                                       zstd_get_workspace()
>                                       \-zstd_find_workspace()
>                                         \-pops W1, idle_ws[max] is empty
>  zstd_put_workspace(W2)
>  |-clip_level(req_level) !=3D level
>  | ^^^ skips the lru update
>  \-adds W2 back to idle_ws[max]
>                                       zstd_put_workspace(W1)
>                                       |-idle_ws[max] is not empty
>                                       | ^^^ no longer hidden
>                                       \-adds W1 to the lru list
>
> Now both max level workspaces are on the lru list, and
> zstd_reclaim_timer_fn() frees both of them. A later allocation failure in
> zstd_get_workspace() then waits forever for a max level workspace that
> doesn't exist, as only putting a max level workspace wakes the waiters.
>
> Fix this by recording the hidden workspace in a dedicated member,
> zwsm->hidden_ws. It is preallocated at init time, never changes, and is
> never added to the lru list. Every other workspace, including other max
> level ones, goes through the regular lru path and can be reclaimed.
>
> This means failing to preallocate that workspace now fails the zstd
> workspace manager initialization, instead of just a warning, so the
> hidden workspace is always there.
>
> Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> Link: https://sashiko.dev/#/map/240622
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/zstd.c | 46 +++++++++++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 19 deletions(-)
>
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index e4937f6fde29..7c70a7d3b47e 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -80,6 +80,11 @@ struct zstd_workspace_manager {
>         spinlock_t lock;
>         struct list_head lru_list;
>         struct list_head idle_ws[ZSTD_BTRFS_MAX_LEVEL];
> +       /*
> +        * The max level workspace preallocated at init time, which is ne=
ver put
> +        * into the lru list, thus never reclaimed, to guarantee forward =
progress.
> +        */
> +       struct workspace *hidden_ws;
>         unsigned long active_map;
>         wait_queue_head_t wait;
>         struct timer_list timer;
> @@ -191,15 +196,20 @@ int zstd_alloc_workspace_manager(struct btrfs_fs_in=
fo *fs_info)
>         INIT_LIST_HEAD(&zwsm->lru_list);
>         for (int i =3D 0; i < ZSTD_BTRFS_MAX_LEVEL; i++)
>                 INIT_LIST_HEAD(&zwsm->idle_ws[i]);
> -       fs_info->compr_wsm[BTRFS_COMPRESS_ZSTD] =3D zwsm;
>
> +       /*
> +        * Preallocate the hidden max level workspace, it is never reclai=
med and
> +        * guarantees forward progress in the worst case.
> +        */
>         ws =3D zstd_alloc_workspace(fs_info, ZSTD_BTRFS_MAX_LEVEL);
>         if (IS_ERR(ws)) {
> -               btrfs_warn(fs_info, "cannot preallocate zstd compression =
workspace");
> -       } else {
> -               set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &zwsm->active_map);
> -               list_add(ws, &zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);
> +               kfree(zwsm);
> +               return PTR_ERR(ws);
>         }
> +       set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &zwsm->active_map);
> +       list_add(ws, &zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);
> +       zwsm->hidden_ws =3D list_to_workspace(ws);
> +       fs_info->compr_wsm[BTRFS_COMPRESS_ZSTD] =3D zwsm;
>         return 0;
>  }
>
> @@ -255,7 +265,7 @@ static struct list_head *zstd_find_workspace(struct b=
trfs_fs_info *fs_info, int
>                         /* keep its place if it's a lower level using thi=
s */
>                         workspace->req_level =3D level;
>                         if (clip_level(level) =3D=3D workspace->level)
> -                               list_del(&workspace->lru_list);
> +                               list_del_init(&workspace->lru_list);
>                         if (list_empty(&zwsm->idle_ws[i]))
>                                 clear_bit(i, &zwsm->active_map);
>                         spin_unlock_bh(&zwsm->lock);
> @@ -340,19 +350,17 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_in=
fo, struct list_head *ws)
>         ASSERT(zwsm);
>         spin_lock_bh(&zwsm->lock);
>
> -       /* A node is only taken off the lru if we are the corresponding l=
evel */
> -       if (clip_level(workspace->req_level) =3D=3D workspace->level) {
> -               /* Hide a max level workspace from reclaim */
> -               if (workspace->level =3D=3D ZSTD_BTRFS_MAX_LEVEL - 1 &&
> -                   list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]))=
 {
> -                       INIT_LIST_HEAD(&workspace->lru_list);
> -               } else {
> -                       workspace->last_used =3D jiffies;
> -                       list_add(&workspace->lru_list, &zwsm->lru_list);
> -                       if (!timer_pending(&zwsm->timer))
> -                               mod_timer(&zwsm->timer,
> -                                         jiffies + ZSTD_BTRFS_RECLAIM_JI=
FFIES);
> -               }
> +       /*
> +        * A node is only taken off the lru if we are the corresponding l=
evel.
> +        * The hidden workspace is never on the lru.
> +        */
> +       if (workspace !=3D zwsm->hidden_ws &&
> +           clip_level(workspace->req_level) =3D=3D workspace->level) {
> +               workspace->last_used =3D jiffies;
> +               list_add(&workspace->lru_list, &zwsm->lru_list);
> +               if (!timer_pending(&zwsm->timer))
> +                       mod_timer(&zwsm->timer,
> +                                 jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
>         }
>
>         set_bit(workspace->level, &zwsm->active_map);
> --
> 2.56.0
>
>
