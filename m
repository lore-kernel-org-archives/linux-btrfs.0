Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5023ACEED
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 10:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801756; cv=none; b=fhRDirYMtvq5HccFxBRRYbr/pFNRkVVdeFevk26/ZZEod3t8boY/uMvB2j3dJAA6MJoI8vKqHC3QBheH8zbBng0jhpZmtfUyI9A+lBoTEB3QNxqFgdZ0L3ZOdjPzW2Nd8UcpPdykoPScUlRB/4ah0+aJANHXXuqr+wCbZQfr4qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801756; c=relaxed/simple;
	bh=l2dCYeEFbR4SQXuDQh8uOl3BnEzEv6+VQT2atgcNiDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cLK/3Y7YB2i3cZuoqxbvdhDB+z9HqzJldvL8kITbKpGUwEAvL4fEICEDKNHLhkaHo0NrC3xY8Bzw1qwFZvVyAQCRG/EQBIO12Vb7uFuPJViMwcx5nTuydoswnQzMQPBLOfNYfnIoRecMnVPLGXl+nfCaDWb9rvKlFaK27G9ndDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyO5joCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyO5joCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F01F0089C
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 10:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801754;
	bh=r5kS1FF69C19WefTneSJe6Ed53IbGcahQ+OvouOu1ow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GyO5joCLAedF+8wYtO1sDYWGXoMilNfibtlUdKafNtW6IRDv0EeO753ZvxWpr1LWV
	 Vlp9AwlpfgZD8NMhQqFf9vYZorMX7OROuw2tfsa+2A0OWgcJrSeqtNdT8xuwOXahqx
	 UPDv4czZuLTf2yH6Y4Dv75cQJcK9GmyUlh57x99r11X+CvsetNUqR5UWOdOoXjBdq2
	 bTUXmfiVTOj1510TrCbGYe2BFm2XoDS/VCfxfwuW/gFWuR99N1z9edfPPBqW8leGMV
	 UUe9lqNBabRyPXmKGvv9Zwfa4bnDzu/qmpqHE62l05AEhN1oUTphb6UkT8OyCRtRwC
	 bEjiiZ+7HRWtQ==
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-7c1916da745so3231895137.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 03:42:34 -0700 (PDT)
X-Gm-Message-State: AFq9FYI2l/WNi1zw9CiCwR2gVTlREwM0jxAinJPGkVztNbCLeQfyq1Vq
	yvcFTZesilN04Ld8icPbleYIBTqZxK5BE61dgFPyCzIvD4Lv2iknMOhB3nl6LsXRM+MSCbhNrYq
	JNdRuAN/yRtCNBGwDonNAdYXFrFCFkZ8=
X-Received: by 2002:a67:eb8c:0:b0:784:a925:3f0c with SMTP id
 ada2fe7eead31-7cb390df01cmr1613151137.0.1791801754146; Mon, 12 Oct 2026
 03:42:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791706855.git.wqu@suse.com> <e0dd7f862cab85c1961d6ed38ff130c3c58ae61a.1791706855.git.wqu@suse.com>
In-Reply-To: <e0dd7f862cab85c1961d6ed38ff130c3c58ae61a.1791706855.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 12 Oct 2026 11:41:58 +0100
X-Gmail-Original-Message-ID: <CAL3q7H59WmpF3Wu2CZRyGTFDTVz=L7EyJ6Td+1vfwppg9QEOCw@mail.gmail.com>
X-Gm-Features: AclHuK8GcE_WOQUdcWWBkatoMLw9PSIkEvQMDsvN_jvPaSw8kYxo1iHFijP5l8s
Message-ID: <CAL3q7H59WmpF3Wu2CZRyGTFDTVz=L7EyJ6Td+1vfwppg9QEOCw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] btrfs: prevent use-after-free in btrfs_transaction::switch_commits
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 9:22=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> If a transaction is aborted during committing,
> btrfs_transaction::switch_commits can be non-empty, but the
> btrfs_transaction structure can be freed at the last
> btrfs_put_transaction() inside cleanup_transaction().
>
> The btrfs_root::dirty_list entry still linked into switch_commits will
> point to already released memory, causing use-after-free.
>
> Address this problem by manually deleting all entries inside
> btrfs_transaction::switch_commits.
>
> And since we're here, also release the dirty_log_pages and qgroup
> swapped blocks for that root, which are only released during a
> successful switch_commit_roots() call.
>
> Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 66b054eb98c6..02adda065097 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4966,6 +4966,16 @@ void btrfs_cleanup_one_transaction(struct btrfs_tr=
ansaction *cur_trans)
>                 list_del_init(&dev->post_commit_list);
>         }
>
> +       while (!list_empty(&cur_trans->switch_commits)) {
> +               struct btrfs_root *root;
> +
> +               root =3D list_first_entry(&cur_trans->switch_commits,
> +                                       struct btrfs_root, dirty_list);
> +               list_del_init(&root->dirty_list);
> +               btrfs_extent_io_tree_release(&root->dirty_log_pages);
> +               btrfs_qgroup_clean_swapped_blocks(root);
> +       }

Sashiko has some comments which seem valid to me, roots still in the
dirty_cowonly_roots will get their dirty_log_pages and swapped blocks
leaked.

> +
>         btrfs_destroy_delayed_refs(cur_trans);
>
>         cur_trans->state =3D TRANS_STATE_COMMIT_START;
> --
> 2.56.0
>
>
