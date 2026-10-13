Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055B151EE03
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910586; cv=none; b=mBRmmsmt537a39cibkK0qcfz+dFreyQOkEmMthrg1SYnqPMvFulmA1JQi2yVohET1opfBCVW7bCc7Ph5g0ejStvHjaqTf1PwYn/6TZYIYOet5P4j1IONOzbRue3DFQK4+lGFqyF6acpxBIut6r/1FG7wqOnBH3MPLZNYNX2Nlgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910586; c=relaxed/simple;
	bh=BeJ4fnpM1+y4J18MMqy4Hi5Rozr0vAGzFDxfy3TRhC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLFLpTDLSceEgY3vm02A80HOGH8tUU223NSEv8CG/MRF1Yscw1CzglKc8EY5JMz308CkzzSuusBsbi1a9zuxi+vjlwspq+owN/VUjgbfwqMEAlVMoXxp6zBO43OtWoNj5j5airJFKLP520VjhO6/jzbmHrRJ7Q6x6SM8HiD5Tw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fq7P5T9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fq7P5T9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2A71F00893
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791910584;
	bh=owxhvoEDKTB7HEykLyBUbTZuykL2BTg6LZHxw97hcPc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Fq7P5T9ujO6jHP9jhP/XeGxi0DhGoaFisUc+7j8s6O+ofJ91UGSIAf2kk0rvLkn17
	 i1IBGWo5HLtXd+KTyjN9wvAC/tiwdj3tHdAW3PRpr1wKmEMqOp+rb0/B4HW3A3IRlf
	 wuPE8GsiDUC6o3rDpM15K6f4y3U2DSTbFVloE4QWPUzv5chfJx1+sRUMgxOdUXyqLn
	 U0torFJz/SmYAfBqK9NtF23/voVTM4A4NqtnnqWcu2RPteFwCCENo9yBhpIvqWbgzD
	 febHHMdMkm4LWcastb3P/r2w/85DFQpRJ6JDNfEHQtolPkKr+NGiQ2A1AsI/gTLv+7
	 USQZRnJ2o4QXg==
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-98c67e94e53so76773241.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 09:56:24 -0700 (PDT)
X-Gm-Message-State: AFq9FYLmBWAkx8wallJqOPFH89dvBIhLR5P0Q349QebTmMsL1kz/Ig7d
	ii5HyyISKnfscuAfI0zyv5mZel3ky08+vgYRXxWcKM04BgP5cWuE/RkLDRli2P8R4O23nls9emI
	+52jh+8+mogxqhkg0vt4hffCUlNvntDo=
X-Received: by 2002:a05:6102:a19a:20b0:7c2:b741:2391 with SMTP id
 ada2fe7eead31-7cb3a0a5fffmr2307804137.30.1791910584038; Tue, 13 Oct 2026
 09:56:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791869895.git.wqu@suse.com> <939508997b264d3b328d6d055a644a0f929f9280.1791869895.git.wqu@suse.com>
In-Reply-To: <939508997b264d3b328d6d055a644a0f929f9280.1791869895.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 13 Oct 2026 17:55:47 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5fjRO0LYFf0MdbcxWO+Ey1kumebD52pSybPc8NmjGstQ@mail.gmail.com>
X-Gm-Features: AclHuK_eHqQg2j_eo8qOQWXq0BzKRukBY8KqRrnoiI5cerbwYJlpJ6cUKkr9Gik
Message-ID: <CAL3q7H5fjRO0LYFf0MdbcxWO+Ey1kumebD52pSybPc8NmjGstQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] btrfs: cleanup dirty_cowonly_roots during btrfs_free_fs_roots()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 6:42=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [EXISTING ERROR HANDLING QUIRK]
> Sashiko mentioned an existing problem that, if btrfs_abort_transaction()
> is triggered during the following call site, some roots will be attached
> to dirty_cowonly_roots without being cleaned up:
>
>  btrfs_commit_transaction()
>  |- commit_cowonly_roots()
>     |- list_move_tail();
>     |  One root's dirty_list is moved from dirty_cowonly_roots to
>     |  switch_commits.
>     |  But there are still other dirty roots in dirty_cowonly_roots.
>     |
>     |- update_cowonly_root()
>     |  |- btrfs_update_root()
>     |     |- btrfs_abort_transaction()
>     |
>     |- return ret;
>
> In that case, those dirty roots linked into dirty_cowonly_roots will
> never be removed from that list.
> As normally we require a transaction commit to move them, but since the
> fs is already marked error, no new transaction can be started.
>
> For roots that are already moved to switch_commits list, they are
> cleaned up by btrfs_cleanup_one_transaction().
>
> This is not going to cause memory leak on the btrfs_root structure
> itself, as after a transaction is aborted, no one will read
> dirty_cowonly_roots.
>
> Furthermore dirty_cowonly_roots only tracks trees that are not
> subvolume or log trees. They should not have root->dirty_log_pages.
> And qgroup swapped blocks are going to be released during
> btrfs_put_root().
>
> Thus no memory leak from those two members either.
>
> But we're still relying on a hidden behavior to keep us from leaking
> memory.
>
> [ENHANCEMENT]
> Unlink all roots that are still linked to dirty_cowonly_roots during
> btrfs_free_fs_roots(), and do one extra ASSERT() to make sure that their
> dirty_log_pages are empty.
>
> At that timing there is no other thread thus we're safe to unlink roots
> without holding trans_lock.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 70c1ee40bf02..91eceb1ab4f9 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1864,6 +1864,25 @@ void btrfs_free_fs_roots(struct btrfs_fs_info *fs_=
info)
>         struct btrfs_root *gang[8];
>         int i;
>
> +       /*
> +        * Some dirty roots may still be linked to dirty_cowonly_roots af=
ter
> +        * the transaction is aborted. Cleanup them here.

Cleanup them -> Clean them up

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +        */
> +       while (!list_empty(&fs_info->dirty_cowonly_roots)) {
> +               struct btrfs_root *root;
> +
> +               root =3D list_first_entry(&fs_info->dirty_cowonly_roots,
> +                                       struct btrfs_root, dirty_list);
> +               list_del_init(&root->dirty_list);
> +               /*
> +                * The dirty_log_pages should never be populated for
> +                * cowonly trees.
> +                */
> +               spin_lock(&root->dirty_log_pages.lock);
> +               ASSERT(RB_EMPTY_ROOT(&root->dirty_log_pages.state));
> +               spin_unlock(&root->dirty_log_pages.lock);
> +       }
> +
>         while (!list_empty(&fs_info->dead_roots)) {
>                 gang[0] =3D list_first_entry(&fs_info->dead_roots,
>                                            struct btrfs_root, root_list);
> --
> 2.56.0
>
>
