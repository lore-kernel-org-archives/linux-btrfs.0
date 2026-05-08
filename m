Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A515C313545
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 10:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778235760; cv=none; b=lv5b0zKYtcNQtxPvWIDvMu6xqSnv0ykVob5ZGPMFknUPkeSin3AT7DaQhXr426R/lPqCWxde2XchMYyqYraB2AAblk6+yZOv76V9wSugkAnOEB6d9EUleKfbO0/nVR5cHcdGssJYHjW35iq17yKx0V9qxiufyyzBi7koOu+UWbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778235760; c=relaxed/simple;
	bh=1IliTrnOeK1T7llHN/cQQnAFKEBtTPTAj1+8K8ZGZoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nu6HfFbBttxLTSrk2MPLjGLRu1Swhk8rEZYmuCQixVDJ225gGs2IrciLFYXJFeHDuNSV454KEcQVkpTCsDgHYfAjcE3k59+oiyMcbTtzsI3i804t0nfuH9ozz7gKddzzKLySWu/MwbqMwdXwOGLqnW6sDC5Rcagd3ftXUJFmn8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKVvAyQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKVvAyQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC48C2BCB8
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 10:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778235760;
	bh=1IliTrnOeK1T7llHN/cQQnAFKEBtTPTAj1+8K8ZGZoo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HKVvAyQNKF61YD++H2gEGuk+FqJv+sA6P+bXVYwyX0mUyK3EmT0KIrHtI8UUyjxZS
	 Z75ja25+tuUiLBgl7LlEGpsqYWHsNOruFJn5EUrC2qsrRrfSK4Eo3RqrfbST++caUG
	 AJi4H62MmjnAwZhDzrWjGkzmQwo8W+tuqqm7fcKxOtWihLWKSMO9v1KriExcpOFx1P
	 7tju1/r17BEX0vma7R8et/WyS47mybBSHBrwq1KpF8Urha8ew9AgX21guLRiUeh/HI
	 oeGD7HVZBB0tmjcag8CSNqXR99dtDguVugdokzvz4ly3mHnMnW2wIrcD1YuQSb8TuF
	 oOvGYKy9DpKyw==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6763cc8775cso5259564a12.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2026 03:22:40 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzbx/KGPdFm16eBmCbNVE+VZm2d7lpapfJmoTx9+E785ZW2Eh2p
	fkatA1tgvOtxrivG9MEWkFB0dPtT51KrbDbp4QXX3t86OUUngSlJ7Y4YJPSeGPr+Yi6D+rDlW06
	YwYlXntfTKouVwbl/O/VnvfXOj3HwSdc=
X-Received: by 2002:a17:906:ef01:b0:bc3:99d5:a29f with SMTP id
 a640c23a62f3a-bc84cc72ec3mr353289866b.5.1778235758834; Fri, 08 May 2026
 03:22:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260508033247.1400532-1-robbieko@synology.com>
In-Reply-To: <20260508033247.1400532-1-robbieko@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 8 May 2026 11:22:01 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5m8X6we-pQX8szJmHXhV354txC+Stsdwa4wfcvaLCj_Q@mail.gmail.com>
X-Gm-Features: AVHnY4LXNMmwDn_XNg5T7mZQYy4uGOPZaiOWi5MQXY1IbJUGvDk3RrYYBEUJJXk
Message-ID: <CAL3q7H5m8X6we-pQX8szJmHXhV354txC+Stsdwa4wfcvaLCj_Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: mark file extent range dirty after converting
 prealloc extents
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 8, 2026 at 4:33=E2=80=AFAM robbieko <robbieko@synology.com> wro=
te:
>
> From: Robbie Ko <robbieko@synology.com>
>
> When writing into a preallocated extent, ordered extent completion calls
> btrfs_mark_extent_written() to convert the file extent item from
> BTRFS_FILE_EXTENT_PREALLOC to BTRFS_FILE_EXTENT_REG.
> If the preallocated extent was created beyond i_size, for example with

Remove "for example", because the only way to create extents beyond
i_size is with fallocate...

> fallocate keep-size, and the inode is evicted and loaded again before the
> write, the inode's file_extent_tree is initialized only up to i_size. The
> out-of-i_size prealloc extent is therefore not tracked there.
> After a write into that extent extends i_size, btrfs_mark_extent_written(=
)
> updates the file extent item, but the corresponding range is not marked d=
irty
> in the inode's file_extent_tree. This can leave disk_i_size stale when th=
e
> filesystem does not use the no-holes feature, so after remount the file s=
ize
> can go back to the old value.
> Fix this by marking the written range dirty in file_extent_tree after
> successfully converting the prealloc extent to a regular extent.

Please use blank lines and paragraphs for better readability.

Blank line here.

> A reproducer is:

Another blank line here.

Separating groups of related commands with blank lines also improves
readability.

>   mkfs.btrfs -f -O ^no-holes $DEV
>   mount $DEV $MNT
>   touch $MNT/file
>   fallocate -n -l 2M $MNT/file
>   umount $MNT
>   mount $DEV $MNT
>   dd if=3D/dev/zero of=3D$MNT/file bs=3D1M count=3D1 conv=3Dfsync
>   stat -c %s $MNT/file
>   umount $MNT
>   mount $DEV $MNT
>   stat -c %s $MNT/file
>   umount $MNT

A blank line here.

> Before the fix the first stat reports 1048576, while the second one can
> report 0.

Can report? You mean it's not always the case?

I ran the test in latest for-next, and stat always reports 1M - 0
never happened.


Also, do you plan on sending a test case for fstests?
Please reply - I have asked the same question for a previous patch and
you did not reply.

> Fixes: 41a2ee75aab0 ("btrfs: introduce per-inode file extent tree")

The correct fix tag/commit is:

Fixes: 9ddc959e802b ("btrfs: use the file extent tree infrastructure")


>
> Signed-off-by: Robbie Ko <robbieko@synology.com>

And the only blank line the changelog has is between the Fixes and SOB
tags, which is where none should be.

Thanks.


> ---
>  fs/btrfs/file.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index cf1cb5c4db75..8c171ed07008 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -633,7 +633,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_hand=
le *trans,
>                                                          trans->transid);
>                         btrfs_set_file_extent_num_bytes(leaf, fi,
>                                                         end - other_start=
);
> -                       return 0;
> +                       goto mark_dirty;
>                 }
>         }
>
> @@ -661,7 +661,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_hand=
le *trans,
>                                                         other_end - start=
);
>                         btrfs_set_file_extent_offset(leaf, fi,
>                                                      start - orig_offset)=
;
> -                       return 0;
> +                       goto mark_dirty;
>                 }
>         }
>
> @@ -788,7 +788,12 @@ int btrfs_mark_extent_written(struct btrfs_trans_han=
dle *trans,
>                 }
>         }
>
> -       return 0;
> +mark_dirty:
> +       ret =3D btrfs_inode_set_file_extent_range(inode, start, end - sta=
rt);
> +       if (ret)
> +               btrfs_abort_transaction(trans, ret);
> +
> +       return ret;
>  }
>
>  /*
> --
> 2.43.0
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>
