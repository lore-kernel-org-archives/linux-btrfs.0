Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569072;
	b=qdUL++/4E5myZ1KdxqOUXPij6uLWfQ6QYweEgTrWgiq6WDlrhjHfSNfNfjju5bnPGYGG
	 jSQmnkVooY08mxFMlJZUbPPq2+jdS+i7ljfp83G1B9i0GJU1CMc6hP4wrzynO6MRqZApz
	 Rv5jreEJ0/3C2OIxdzcuUh7zIQM4rwAkoV6PAMKzNB95a/HRF2M+KgFLxkc3seL+YCgxC
	 szb4a1eV5AZIv+hxChCL3n2fgHkUbg39fvjpm1fufuq036pI5APThVvYsYz2iAmKZazCi
	 Lsrey9b+QerQA6HU5JJgjXZSl74nfjywpF1Xm4pGM9MHh4SyQFnRYFi0NHIaXu0EpYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569072;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=gYOqv0WIKZ9yb8Pcn/HunXhDz9YkiUpozyHC08IbV1k=;
	b=eEFaVIWd64X+WoT4tuIZLzxASdNUiqz6GrqIk/kVN4LBX7X8lgGZkmcVWJlxHHCAiXsl
	 mMi3xFqMTc5Fp4A7ve7EKajrHVQWIEBPCH3y+fkntBygz11CyqHkWyAE2NTyLwHzqtq8K
	 RYjFZTrTf/UTYguCrk83NyN3zS4ZOs02//uTMyALaqbhK8ThGQmOC+3ogl/+vuH6Fe8u5
	 N0fN1MkpkpNDb9dwO8FrIPM8Tbe+yBNFHIiPdvvjIEWdvaW8g+tLrloJmMV/mxTsVLdsw
	 4hG0TB7YkzeqJQodLqxJ9ssmIARCeyqk6sEiwhyhTLe8yutFtrDsZM1rbzhPA2lm9Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DeB+5k/Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD82606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 11:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DeB+5k/Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AE51F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 11:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794569071;
	bh=gYOqv0WIKZ9yb8Pcn/HunXhDz9YkiUpozyHC08IbV1k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DeB+5k/QDInM/lQDfumcM4CaveGydI9YqrThnPdkFKaJB7z45hsjEPNdVJ0Np06Tg
	 VVZJI2ul4zkkh6b54naGXJcIIAQewy3J0CfMu3maoHM+6+vXAUPHAAOaD2qaGpXyVg
	 /jQtyCr+LoRNb12uCdo7QAxKMNlG1ktzO6MP8PklN7EUCG7t0pNd+ftljaa9mhPLKw
	 5zHq895l26p2Jnc0ReiRdpbhTGucf6zcH8DmDCAtH8chH60bmC7611rdcQsKCfQBio
	 PywshDRCEnLjGJ67KB/rQqb78IhXe9u2gYh3et0+s79oGZpU9uIoZ+KjQ5jZqTxfY+
	 qLHjvX6wM9k4g==
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-996eeadfbeaso1231373241.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 03:24:31 -0800 (PST)
X-Gm-Message-State: APuU4Z+nizsKGalg2HQsgmeLlGqnfsYwEfGPDAAv3EVKz0GJrQ9KUeaT
	gkG4ZDcQbEUUfycceQd/ZFxMQx8TnLkQJXHrvucJhU0OsFDsiX76Hujuursrg3yCdA5BBK1u+AY
	qI7sfMr3/UKOrimN7YIKpRp7XsdUWJDM=
X-Received: by 2002:a05:6102:6e89:b0:7cc:2bb7:1335 with SMTP id
 ada2fe7eead31-7d64d83f7f8mr518133137.33.1794569071124; Fri, 13 Nov 2026
 03:24:31 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <521fda24cf9375242f53a4842475957d8231214b.1794521916.git.wqu@suse.com>
In-Reply-To: <521fda24cf9375242f53a4842475957d8231214b.1794521916.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 13 Nov 2026 11:23:54 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4qc6B7sPqCTO9iacc-xEKsciEyDO+05RaNwLf7M6vjHA@mail.gmail.com>
X-Gm-Features: AclHuK93j9aC1HDjpVFAZR7P8eSmVFsfhFuGbJ7O89jhx2CrBMC-nStVhLNcTYc
Message-ID: <CAL3q7H4qc6B7sPqCTO9iacc-xEKsciEyDO+05RaNwLf7M6vjHA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: abort transaction if btrfs_commit_transaction() failed
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 10:38=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> All other error paths of btrfs_start_dirty_block_groups() abort the
> transaction, but the btrfs_alloc_path() failure doesn't.
>
> This exposed a very tiny opening that btrfs_commit_transaction() can
> return an error without aborting transaction, and none of the callers
> expects to handle such situation.
>
> Fix the only exception in btrfs_start_dirty_block_groups() path
> allocation failure, so that btrfs_commit_transaction() always abort the
> transaction on error.

So there's a reason why we don't have an abort there.
It's because it's not critical. We try to start flushing all dirty
block groups before entering the critical section of a transaction
commit, to avoid blocking other tasks for long periods if we have many
dirty block groups.

However if we fail there, and have not caused any inconsistency in the
fs (like the failure to allocate the path), we can either try again
the commit later or continue the transaction and then update all dirty
block groups with btrfs_write_dirty_block_groups() inside the critical
section.

Currently, if a task tries to commit a transaction and fails there, it
returns the error to user space. However, if later the transaction
kthread tries to commit and successfully allocates the path,
everything proceeds correctly.

Instead of adding the abort, I propose changing
btrfs_commit_transaction() to continue if
btrfs_start_dirty_block_groups() returns an error and the transaction
was not aborted.

Thanks.



>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/block-group.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 027830a53f7d..e4859f7e0323 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -3397,6 +3397,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_tra=
ns_handle *trans)
>                 path =3D btrfs_alloc_path();
>                 if (!path) {
>                         ret =3D -ENOMEM;
> +                       btrfs_abort_transaction(trans, ret);
>                         goto out;
>                 }
>         }
> --
> 2.56.0
>
>
