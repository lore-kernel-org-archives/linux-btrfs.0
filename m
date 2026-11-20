Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795201258;
	b=4K2bMP3nQVjfcApoPP7Ltk18OGNT1uEP2iNPMJ4vw7iMjsowOX4Yu+7MOEiRi87R3szL
	 Dgwha6Zg2gnp5Gz+4BGJsUx2asIa6IzvS+nC60oOfZNtZWY0DQZPGFohhT/xyuwa8zJ5r
	 pZke9UjnIKnGSZF4f/xgWbAGV78sVF4DzeN5NUcPp7XcYcvgfsUWKzu5cKhtl8M0JdW8C
	 OM9V2BL9YzGPbV2JrM7nSAU9A+RDUn4gWEvTZ0EcXkN3ubWVYz+EM5EMiJyx8miIWhm5b
	 UBeyvDtUENcq4/VvTOwHkGrEpT0h0yXTAhZdYYDauTMKUHI41PxF/s7DnfhQcUu6eog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795201258;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=mMkZza2ij1qmVsCMIfToh1j9H5ueh7x6KJf0iwhJSXQ=;
	b=1Luyx2whXKa51dX4fgVlceLPz9XSeci7GlX4+PNVKifh/azjDEm3fLm6iXDtBra+uxNT
	 DrWZvLO6MvmT6skStg3zSUREUIM9A2GjuCYpz0zayBgrapvdjyibA3Q8zydJoM4q18XDy
	 3aOo3hOz6JVOLC5pG5sguclTZ4aLouZOhuLPziFIl7O8FBlQxRyk8PuS4GkpG2ZQ6Jiur
	 BVJfMrF/l0+9E4DMDtWT436pYaBxc2CXfDCX0kO3q5ITmYqfAFaSesDP+vDn6Etr5j4Xm
	 ORcVhLF8vHb+54coITXNthMRlQDfT39k/q4vO/QCO8Ouoso7YOsbDIA3hSGayaL/lCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nUNBvAAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAB860A3814
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nUNBvAAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DED31F000D2
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 19:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795201257;
	bh=mMkZza2ij1qmVsCMIfToh1j9H5ueh7x6KJf0iwhJSXQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nUNBvAAWYgwE6wHIE8ut0y0+6GFGj/QrLMULeXwMEbz+uDZX0QbJESztmmrCde6rL
	 rxBoxwqocVBTuSyNlPqzUUjYuyH/iTpwwYfVDevCQcQG3MtODNnIaTOIOCO98DVkto
	 +HomJYQ/yXhekB8cFjYJDD5ODOd0LcLLypwE1bk2tPeYuhfT3Qdk3J2YDEoX4ui0vW
	 eALgknpez2WjNXdi8uM+VlhK658a2PHaHHl1LPulp0IjSzy2m6zER8dEaY41fGKGMf
	 egJOJT53j1HgEZGKcjhURa9vhrqn4XqRWJmHV+JbIwV9VSCXD09NYqrZcLx4mHRgLK
	 2vfJAAkwGhRyA==
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7d6554d96d3so713815137.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 11:00:57 -0800 (PST)
X-Gm-Message-State: APuU4Z+JkiQzPik9KAwsUSfIaJeMkCnHmBs0AWH0V3twWPihadwjcS/i
	d1jsTphNFIn1sVBo3Yds4qXoCf5R/eD6ep/9BOyNOIhUnMNqneTFZsHsJoLUxxIxhSAdBi+WyeH
	Ik83yePnPz3kr+TYdg84EHngl3B3dWxs=
X-Received: by 2002:a05:6102:548a:b0:7d0:5688:f4fd with SMTP id
 ada2fe7eead31-7d739440c46mr2037012137.17.1795201256753; Fri, 20 Nov 2026
 11:00:56 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795168584.git.wqu@suse.com> <b7bb9a6e4195a65e10f31b81485d0e29af7a9da3.1795168584.git.wqu@suse.com>
In-Reply-To: <b7bb9a6e4195a65e10f31b81485d0e29af7a9da3.1795168584.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 20 Nov 2026 19:00:20 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7tG1Zj-XXDOybHHB84ASMRdwG-F0-XLjWndEyo1vNRQg@mail.gmail.com>
X-Gm-Features: Aa3M54o8z-QcjV3cn4B2CM_2cMpbP3skUvBJOAejUeNihRiN2d3VzrnUrBFGnoo
Message-ID: <CAL3q7H7tG1Zj-XXDOybHHB84ASMRdwG-F0-XLjWndEyo1vNRQg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] btrfs: qgroup: show the "qgroup scan cancelled"
 message correctly
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 9:58=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> There are several reasons why we won't output the "qgroup scan cancelled"
> message:
>
> - We always clear BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN before the
>   message check
>   So that test_bit() will never return true.
>
> - @stopped has a higher priority
>   When a rescan is cancelled, it has a high chance to be caught by
>   rescan_should_stop(), so in that case @stopped is also true.
>
>   Then when checking which message to output, @stopped has a higher
>   priority, thus it shows the rescan as paused instead.
>
> Fix the problem by:
>
> - Save the previous CANCEL_RESCAN flag into @cancelled, and check that
>   variable instead
>   And @cancelled is only updated if the rescan is stopped.
>
>   This is to handle finished-then-cancelled rescan a little better.
>   This won't completely solve the cancel race with rescan though.
>
>   But the cancel-race is already there, not caused by this commit, and I
>   don't think we should bother too much on the mostly cosmetic error
>
> - Change the message priority so that cancelled has a higher priority
>   The new priority list is:
>   - Error (ret < 0)
>   - Cancelled
>   - Stopped
>   - Finished
>
>   And we no longer go the complex "if () else if ()" way, instead each
>   hit branch will return, so only one branch will hit.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/qgroup.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index afac7402af36..ab382f41957f 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3900,6 +3900,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs=
_work *work)
>         struct btrfs_path *path;
>         struct btrfs_trans_handle *trans =3D NULL;
>         int ret =3D 0;
> +       bool cancelled =3D false;
>         bool stopped =3D false;
>         bool did_leaf_rescans =3D false;
>
> @@ -3970,8 +3971,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs=
_work *work)
>         }
>
>         mutex_lock(&fs_info->qgroup_rescan_lock);
> -       if (!stopped || test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
> -                                &fs_info->qgroup_flags))
> +       cancelled =3D stopped && test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL=
_RESCAN,
> +                   &fs_info->qgroup_flags);
> +       if (!stopped || cancelled)
>                 clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgrou=
p_flags);
>         if (trans) {
>                 int ret2 =3D update_qgroup_status_item(trans);
> @@ -3989,16 +3991,21 @@ static void btrfs_qgroup_rescan_worker(struct btr=
fs_work *work)
>         if (trans)
>                 btrfs_end_transaction(trans);
>
> +       if (ret < 0) {
> +               btrfs_err(fs_info, "qgroup scan failed with %pe", ERR_PTR=
(ret));
> +               return;
> +       }
> +       if (cancelled) {
> +               btrfs_info(fs_info, "qgroup scan cancelled");
> +               return;
> +       }
>         if (stopped) {
>                 btrfs_info(fs_info, "qgroup scan paused");
> -       } else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_i=
nfo->qgroup_flags)) {
> -               btrfs_info(fs_info, "qgroup scan cancelled");
> -       } else if (ret >=3D 0) {
> -               btrfs_info(fs_info, "qgroup scan completed%s",
> -                       ret > 0 ? " (inconsistency flag cleared)" : "");
> -       } else {
> -               btrfs_err(fs_info, "qgroup scan failed with %pe", ERR_PTR=
(ret));
> +               return;
>         }
> +
> +       btrfs_info(fs_info, "qgroup scan completed%s",
> +                  ret > 0 ? " (inconsistency flag cleared)" : "");
>  }
>
>  /*
> --
> 2.56.0
>
>
