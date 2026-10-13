Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C5240DFB6
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910393; cv=none; b=h5zJvMO97+Tg26RSqBLpbczN5WWgN8aHjGJSmoGdxgPYHQESjocwCzjCc0Pcr7gi9DtiGk9BPWUiTujXSvt4Jqu1y6zkWncGo3MHkAmNSIQr6/6ZdydBoPBlV12yDkHybkJj4PSaczVOw4oJimOKobBQOffRTdLsbKviqIe5mgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910393; c=relaxed/simple;
	bh=Tuc9Ife7eemX7kDNjb4XzbRzrxmMj6quAyr/1ixRTCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/sGfnhi5EEig4tps4xIXeHl9hQM6tyF4vhyTIyD+HU/IJKJ5LJxPAH18exC9M8oMsJK8NiyR1OyaovAyZcJm+vBTFiIYr2SegwoIeDqt5xODSOIA0ok1drNoFrylIeVG+odo9BaPyRWCQYWMlA1smA4tDSPrl4Bj1SRJe4kzgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdC+KoW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdC+KoW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6AA1F00899
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791910391;
	bh=x2FWCQp60fGOhu+u3us8NGABYbh4jTqKjmx5nd4yt1Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kdC+KoW3qq3smhc2hpOwQ9erAkrt9IfdePG/i7xROvFhI7okUVdr/8OkfNLaZoAmX
	 uUxVQIaVK+SJPv3b2CvbNpx/SRCd0OSwBxFyH0NSDP6OQQUl76EP5J19sAjtBqSAIg
	 nYS+dywCZzZ/eIwWwE6vm6XY3f9RrKJ46tj9+QEMDvgG7r6CR7Rw5/VfeR2j8XKXRv
	 n+D06wnuRH8lLNFst7olLU8CAk1L8KJ5+xOLtCTtRab/zVkQxQnA5lmbYPWSVVdnmG
	 Jlet5i8DbxLa7T8wVCgA1WOqGmHYLS3z/n2kziui/TBo2zgtqRnz4GwRoDazONDAvn
	 4+9is7NolygHA==
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-98c786605e7so1580425241.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 09:53:11 -0700 (PDT)
X-Gm-Message-State: AFq9FYIeK5saBVKeGbyXKvp9biJnaZ1m6Ic9ooh4VkVMHIJ6SPiJ7PQw
	qZZPeKpoIRzmCZMLDKorAfVPKSQf0TwuR/4wpS521GMnFIs7Wzxa/DsBePAFTH+f5fN6dkQ7Vb4
	OfpMo2KkLgBRETVXDXV3oLjgGxJrQxaY=
X-Received: by 2002:a05:6102:f9f:b0:7bb:a70:4708 with SMTP id
 ada2fe7eead31-7cb372f5c52mr3936302137.17.1791910390933; Tue, 13 Oct 2026
 09:53:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791869895.git.wqu@suse.com> <cad321ec81508ed69b1739cd91ff5c5408b5f1fa.1791869895.git.wqu@suse.com>
In-Reply-To: <cad321ec81508ed69b1739cd91ff5c5408b5f1fa.1791869895.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 13 Oct 2026 17:52:34 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6Lr6-aEawbkw7yesxQZ4h_otkdp9O-tU=NrBuNs-yBjQ@mail.gmail.com>
X-Gm-Features: AclHuK9Egg53f3_oHLYfSr-Ja8K6KqyRp4-vmdeyS0zt6bS7Osb7OlHIjiy2gp4
Message-ID: <CAL3q7H6Lr6-aEawbkw7yesxQZ4h_otkdp9O-tU=NrBuNs-yBjQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] btrfs: cleanup qgroup swapped blocks at root release
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 6:42=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Normally btrfs_qgroup_clean_swapped_blocks() is called when switching
> the commit root of a subvolume tree.
>
> However if a transaction is aborted before all dirty subvolumes are
> linked to switch_commits, those left-over dirty subvolumes won't get
> their qgroup swapped blocks cleaned up.
>
> And since a transaction is already aborted, no new transaction is
> allowed to be started, thus no way to cleanup the qgroup swapped blocks
> for those subvolume trees.
>
> Fix the problem by calling btrfs_qgroup_clean_swapped_blocks() inside
> btrfs_put_root() when the last ref is dropped, so that at unmount time
> those left-over qgroup swapped blocks are properly released.
>
> This fix is inspired by the recent Sashiko reports about similar cases
> on cowonly roots.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/disk-io.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 02adda065097..70c1ee40bf02 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1848,6 +1848,7 @@ void btrfs_put_root(struct btrfs_root *root)
>                 if (root->anon_dev)
>                         free_anon_bdev(root->anon_dev);
>                 free_root_extent_buffers(root);
> +               btrfs_qgroup_clean_swapped_blocks(root);
>  #ifdef CONFIG_BTRFS_DEBUG
>                 spin_lock(&root->fs_info->fs_roots_radix_lock);
>                 list_del_init(&root->leak_list);
> --
> 2.56.0
>
>
