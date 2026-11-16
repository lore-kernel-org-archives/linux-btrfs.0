Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794862759;
	b=zCk/zwIyQ70Q67ROy7TZlyf9mGthaahb7fyD5PCPJ7Zk8QWYzeV3iqfFALYvjveC7UCo
	 HMnqK5sZMgpJrucz280BIt6To4eWQGsSmwIS8rSDDErt2qDWgEtODfscdfPVL0YJLywXl
	 sLnj76LuUTB96tU/p7qQiao4zV+fP0LL0+qvRGYxd8HdWiH2R6Qfv7ycG0vCXjtPXYbdI
	 ZIY+J8U//SJH+4ZgMxQ0cujthnnzxogPqAx1pTuNIc3r2dho65QotAvqC4JC7Z5rBNXul
	 GBtr1WHdS6kMr+kea54TAsyXSsTFM83qbzTdHEE7XVfnBggfJzW8NTyu77lHOvZHcIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794862759;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=FR+QVrR8rOv3ZozMVV4lfutH6Rk8lsMnEfwZ96tX/h0=;
	b=bVeSJvEWYhcEk3UxU1Z5eRHEtV9ngWSmIo1BZxLT9dI7xDjNw0GyRTLGpcfTv++rddw0
	 YZ7RnwK9o3agXu6H73EMRQZ4e0FRRHEsgBgu5BUSAWkOiXoBjLSJnNm3ttarUAlIUZ5Ps
	 wTxrET0noY1ImyedLS8oiQUlWWmoTv1kLNLnq94HoLaw8ks5EPeadC6J5M4HsGrrJBGiK
	 xFNdHYEoz/J/kLxpwZVHvjIsx5p8ju+OLj7c68Fa4Gvccw8y4TPMZB5OyZWCCb6jDrySQ
	 3JUD0oHK0ptjAO1/gtj5V922JI92a9JwrBPRu0gOEbGewewHK2E+6v8Upl//xvZl2dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eJ3zxJC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE563606A322
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eJ3zxJC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A6E1F000C6
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794862758;
	bh=FR+QVrR8rOv3ZozMVV4lfutH6Rk8lsMnEfwZ96tX/h0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eJ3zxJC99HRdIHFv8ZcqU627xRNpBou3NiKjBYUXp9Rz/X06PQQGmM9yShZm0E9Nv
	 qGfpdPXimD5h1l6iUCbEfb46jFSUigVBBspfTlHvrijhrrrp9sTbe0unVgqd8KdIoh
	 wpMQRKv7h8eXl8hrnQFuYtwyBFZu3GeJakI1VraSVkxnGKJJ9T7ytjXVvd2V6TuKNQ
	 S3SQ30TLrUKBx4jgkKNts/cPJ8LBslDSR5KqbY7saBDF84Cre0EQFmmyHAyCRvd370
	 5Gun3BI2/QBxYX1atBxDRtVOEaUk1or7Ml7/EAIwtwcrFwHQszVCX/uGytcJf0vRPN
	 h2Mz06MWa5GFA==
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-98fea7e52b7so2677779241.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:59:18 -0800 (PST)
X-Gm-Message-State: APuU4Z8uglc9R+q3D6jGtvRrcuyKgcPEdUnWcyd2KiWKIJDZfaflTdub
	MARZL0lGdJZKS0rdi0/nGgBfqRkEG4bptbKJREIJF0CNrmeYuU0k6JAtp8STg/xxH10p6nrw2wz
	35Tr6UoccqYmi9xoaxXWlpXgzp/449UM=
X-Received: by 2002:a05:6102:f0e:b0:7d2:c786:5a98 with SMTP id
 ada2fe7eead31-7d64d69e15cmr3978920137.8.1794862757706; Mon, 16 Nov 2026
 12:59:17 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110074523.1199319-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261110074523.1199319-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 16 Nov 2026 20:58:41 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5oBY-xH9+wEesAoQmd+3HTzEm8GbEDR2Xez8_MCsmd2w@mail.gmail.com>
X-Gm-Features: Aa3M54p-QtJFWlYHKPsbyoQElgvkgQtOlvVb0oNK9IOiLgEERLm02zTwQPEOZjE
Message-ID: <CAL3q7H5oBY-xH9+wEesAoQmd+3HTzEm8GbEDR2Xez8_MCsmd2w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: zoned: don't fail start_transaction() after a
 forced commit
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 8:05=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> On zoned filesystems btrfs_delayed_refs_rsv_refill() returns -EAGAIN if
> the delayed refs reserve exceeds half of the usable metadata space.
> start_transaction() then commits the current transaction and refills
> again. With concurrent writers, or once most of the metadata space-info
> is zone_unusable, the second refill can still exceed the cap and the
> -EAGAIN is returned from btrfs_start_transaction(). fsync(2) passes it on
> to user space.
>
> The cap is only meant to trigger a commit instead of overcommitting
> metadata. After the commit has run, continue without refilling the
> delayed refs reserve instead of failing the transaction start.
>
> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation=
 to avoid overcommit")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/transaction.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index cd7dff5ba59b..d2da7de4b905 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -725,6 +725,8 @@ start_transaction(struct btrfs_root *root, unsigned i=
nt num_items,
>                         if (ret)
>                                 goto reserve_fail;
>                         ret =3D btrfs_delayed_refs_rsv_refill(fs_info, fl=
ush);
> +                       if (ret =3D=3D -EAGAIN)
> +                               ret =3D 0;
>                 }
>
>                 if (ret)
> --
> 2.56.0
>
>
