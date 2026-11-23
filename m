Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434083;
	b=h1v9IXl1potmJGvcqnW3TmRiVsjWMkamzproJUfHB/BMZCKTK781rohye7Nlj8Py58xE
	 NP/Zls97zoSeDWuaAVLKyaAONMYxs+4Yt9t9lSRkd+bmDS5LBFz8n96Vns7b0T56+/104
	 udxs6jUIcPtRmbb+X5Jswxqa3d5YSXBnKH+Hh1a/p4E9Mu1F9FFuFt5kAYGpVcrw9R35E
	 +Rao+xt/nCqA58FOMPx8H/mZOXA+DwmCTZ+JU7aCZB1Wc3SwLmmck3RAt7PgvEGi1Wfhr
	 cZizBH5+r/Sluy0+0ySLmNenLJYqWtNGfmlHJ1JPd/Q8y3GErfxOgxWQ9TMNfvNI/uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434083;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ERFaHxCLVQsUUIsvcpXdMSBU19+5T7vopoqdvkj/H7U=;
	b=MOd840lkqZvRDJzFpJKh7fTpDl4Yq3S53tNBReIR90BKlJQ1IzfUiN9WVLl1YfDCrr8d
	 G8+fawLbexD1tdy2V3Z81bHcoqm8S148NCHnjUQCh/TK8jCUj/NmZKQQjpujwlv2RHS4i
	 Xt8qmMAnuST7caax3sdyCVt0oA0ItPHkK8GUhfilQocdi3vEPiq3Is8GxBsn7iAQ5nKTt
	 Gq12tv+0WBaMn2Ph5rB7/iMIQqzY/FJpqg580CXPZjB4SHTJhS1JXyhdo6EnJaIxljLTG
	 0f8d6JuytMh+/NDSmotgXvYCLYamOrXQqKU8IEvEa6tXD/saHyhamXVTT7C0bSe1pog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D6hdlhgi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB07606A31F
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D6hdlhgi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA1A1F000CA
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795434082;
	bh=ERFaHxCLVQsUUIsvcpXdMSBU19+5T7vopoqdvkj/H7U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=D6hdlhgicMz7ZLUAPP3mohf8vx4wW8lsiyTvmuPZQi/mzRrxsis4xbD6R5D57deWM
	 X/9SLMFd4pwMbx1+NC09TZQgBzIS2SqUstXfmjFTjSO9HKo5+1kplXGrQg+KHjGP2Q
	 LXvhtkxzsVUM5ku3FaHmSsHvJFWUREVpmJ4leKlkp+gqsIRikViMC8kF+GDhdonhEN
	 fkdHyiFeVekt3Fhb4wsu2/uuLMdmqs8eEoTxJidrqd67NLRMACtMbE3QyUJMQlxkWF
	 v569u0NoO80dtDRJSINqTRQY5M6ZNPaPlOhR5y+cTNfAfKY1NCf9A49CYM/MToq8Eq
	 P2YQPSdaVEhlA==
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-9828fee1b4bso853676241.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 03:41:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGauLMTp9LBW/H7orK9cEC8VxO7nk/EWsm6yimJsunO3iTumu2QAkU0OqxJU2hUdFMLfzhBtoOWUannag==@vger.kernel.org
X-Gm-Message-State: APuU4Z81lrBpU/GPN3yEt0DseEGvUCe5VVqb2+5LzHdKQkqLV1n++yIZ
	HrV+tCdmgoRvIBHy0/39ipjQ/BzmL13o2c5YMwb+1C4RyEfPpEBAwAx/+YFZxRg4pxk5QP4N8iK
	H/8HKE63Wl4+VjBRV+gDzt43uptIyI8A=
X-Received: by 2002:a05:6102:c49:b0:7d2:d194:3dd7 with SMTP id
 ada2fe7eead31-7d7396744f4mr3650725137.36.1795434081708; Mon, 23 Nov 2026
 03:41:21 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261123-btrfs-link-unlink-fsync-v2-1-ed3f9f63fbd7@columbia.edu>
In-Reply-To: <20261123-btrfs-link-unlink-fsync-v2-1-ed3f9f63fbd7@columbia.edu>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 23 Nov 2026 11:40:45 +0000
X-Gmail-Original-Message-ID: <CAL3q7H74bjNuNn48FcgexyrN5okZQhhgVneJVfCYzD+McC_PcQ@mail.gmail.com>
X-Gm-Features: Aa3M54qxAiYf6pcKgdohKmPSKML04U9E8FbR4rrPYFuWsxhBQPiZtywlUYsDs-U
Message-ID: <CAL3q7H74bjNuNn48FcgexyrN5okZQhhgVneJVfCYzD+McC_PcQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix loss of fsynced file after link into new
 dir and unlink
To: mt4022@columbia.edu
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 6:08=E2=80=AFAM Mani Tofigh via B4 Relay
<devnull+mt4022.columbia.edu@kernel.org> wrote:
>
> From: Mani Tofigh <mt4022@columbia.edu>
>
> If we create a file, add a hard link to it in a new directory, remove
> its old name and then fsync the file through a file descriptor opened
> before the unlink, the file is gone after a power failure.  Example:
>
>   mkdir /mnt/A
>   fd =3D open("/mnt/A/foo", O_CREAT | O_WRONLY)
>   mkdir /mnt/A/B
>   ln /mnt/A/foo /mnt/A/B/bar
>   unlink /mnt/A/foo
>   fsync(fd)
>   <power fail>
>
> After log replay, B and B/bar don't exist and the file is gone.
>
> The fsync uses the file's dentry, which is still the unlinked A/foo.
> The inode is new, so btrfs_log_all_parents() finds no parent in the
> commit root, and log_all_new_ancestors() then takes the fast path for a
> single link.  That path walks up from the dentry's parent A and never
> logs B.  On log replay the inode ref for B/bar is skipped because B
> doesn't exist, and the inode ends up with no links.
>
> Fix this by not taking the fast path when the inode had a link, unlink
> or rename in the current transaction.  The slow path finds the parents
> from the inode refs in the subvolume tree and logs B and A.  Also return
> early for an inode with a link count of 0, which has no parents to log.
>
> The problem is old, e.g., v7.1 has it.  It was hidden by a transaction
> commit fallback between commit 0f24ea456ae1 ("btrfs: tracepoints: add
> trace event for btrfs_log_all_parents()") and
> commit 36f9aafa46f5 ("btrfs: fix unnecessary transaction commit fallback
> from btrfs_log_all_parents()").
>
> With the fix, the file survives log replay.
>
> CC: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Changes in v2:
> - Return early from log_all_new_ancestors() for an inode with a link
>   count of 0, to avoid a transaction commit (Filipe)
> - Drop the fdatasync mention and the reproducer paragraph (Filipe)
> - Rebase on btrfs for-next
> - Link to v1: https://lore.kernel.org/r/20261111-btrfs-link-unlink-fsync-=
v1-1-a817d4a890af@columbia.edu

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good now, thanks.

I'll leave some tests running and push it to the for-next branch on
github either later today or tomorrow.

> ---
>  fs/btrfs/tree-log.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 763487114f85..445374b06ee8 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -7541,11 +7541,19 @@ static int log_all_new_ancestors(struct btrfs_tra=
ns_handle *trans,
>
>         trace_btrfs_log_all_new_ancestors_enter(trans, inode);
>
> +       if (inode->vfs_inode.i_nlink =3D=3D 0) {
> +               ret =3D 0;
> +               goto out;
> +       }
> +
>         /*
>          * For a single hard link case, go through a fast path that does =
not
> -        * need to iterate the fs/subvolume tree.
> +        * need to iterate the fs/subvolume tree. But not if the inode ha=
d a
> +        * link, unlink or rename in the current transaction, since the d=
entry
> +        * used for the fsync may then be an unlinked one.
>          */
> -       if (inode->vfs_inode.i_nlink < 2) {
> +       if (inode->vfs_inode.i_nlink < 2 &&
> +           inode->last_unlink_trans < trans->transid) {
>                 ret =3D log_new_ancestors_fast(trans, inode, parent, ctx)=
;
>                 goto out;
>         }
>
> ---
> base-commit: 845c6105edd82f5d0aa72377ef6eb8592ac4e00a
> change-id: 20261123-btrfs-link-unlink-fsync-a3a915511369
>
> Best regards,
> --
> Mani Tofigh <mt4022@columbia.edu>
>
>
>
