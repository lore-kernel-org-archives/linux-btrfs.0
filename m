Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA02342B75F
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785171734; cv=none; b=OVrKfXpn/FwCgwTsNXZYaJ+rJ8y5qMQr4vBq9LoWvrpMkkis4S/kCXO0wLqPAt3re4JmRtYkgMhpkuJ7sdoaNkbOiklE5G6xXWriWrz+S028WEaXJjEgLWjx6/oNlN/GP2TMPbtOqdufwiFvuy+ciIdNpWQK6VephdeNwiXz0Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785171734; c=relaxed/simple;
	bh=T/jcUJXr8jaM34Qw0/qiAJhqubohUoK9iwslTIO0osU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eV4bBWYXWldQGUEZpapKAIVYHGnHOMOO+zp++HicKskfq99mig+Uk8qYdr/5YoM3kSf8OwbRdbRpAZKCKdwfK1lvISIVVIvlEVvKkKQsBlIRDCXuyDxedGGeN0dlGhfczGL0zrtdq8Yo5M5ZGiJBcl0feZpae9uUB3kbuSNU6ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAty3jF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAty3jF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957131F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785171731;
	bh=1dA4ta4GSMxnOuHprCViFzOv+ivVLXGCkRGBfobkap8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TAty3jF1cAS07odz4lUh64/vk663LuM9Jli0f8xzHl5ONAmyeV48V7fpHE8w2vlGF
	 X+qVkcofrc6OSoqDRDytamnq03F86dWjJhDVKfOmhi7iC0PsFms4+0oT/FsKcIonSn
	 bTPaAM5yLn3XLjmYNx/Xgt/uJ1/H92m+L48rCGBNfqR5y7RtsHnMWmYu5hkWjnfnzZ
	 cZ1LJIDJ7gvRkMuNys8pH/L3msWg+yGNanDwwWOhdS7y0Rw7c8Yv2aVk+mjJUIqOEa
	 BX/5Y6vrDExsWbmykxDnmUIaXOHJguSqvrBLk8Vf1MAVb0kG4DWUANMRvVI9mYmRMb
	 vDyu8pi+uJ1Fg==
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5bfa99f8ef8so76310e0c.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 10:02:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr2at3hklvcIboxi0oXL+8wOlHzzpCLuDSayA/pDmmx2lIi1v/QNs8I5TF89HE/lnjp76e6Pgfasd48/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+9z/3I0bvXCt7DFnyScIt3BXRJ3R8TEvLaZMrP4p7D8nQeI4B
	T2BMQS3gtdp49uVUdv3HBqugP7Md4QLKDxE5ALXllWZyd226W1K+yqJ6wEkNGWc2APxdTYzayxz
	8aiLWTw//rPXPUTxbIFC8tzZ6P68vEYk=
X-Received: by 2002:a05:6123:2eb:b0:5bb:fa79:56dd with SMTP id
 71dfb90a1353d-5c33952f5dfmr125928e0c.7.1785171730744; Mon, 27 Jul 2026
 10:02:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260727115352.12622-1-dmantipov@yandex.ru>
In-Reply-To: <20260727115352.12622-1-dmantipov@yandex.ru>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 27 Jul 2026 18:01:34 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4ZQVwTMUEKyME=Hv0RupZEQ5-EaRm72jmg+Wc3aVgj1Q@mail.gmail.com>
X-Gm-Features: AUfX_myRYfE3JRG0YOyZ3y5W_QrLUYv6i8MYMj52kOuwgTb_TyH7KTEDUqxCFJ4
Message-ID: <CAL3q7H4ZQVwTMUEKyME=Hv0RupZEQ5-EaRm72jmg+Wc3aVgj1Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix memory leak in btrfs_do_encoded_write()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 12:54=E2=80=AFPM Dmitry Antipov <dmantipov@yandex.r=
u> wrote:
>
> Local fuzzing of 6.12.94 has found the following memory leak:
>
> Unreferenced object 0xffff888018050a80 (size 64):
>   comm "syz.0.17", pid 10297, jiffies 4294953601
>   hex dump (first 32 bytes):
>     00 10 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>     10 0a 05 18 80 88 ff ff 10 0a 05 18 80 88 ff ff  ................
>   backtrace (crc a8a6fc29):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>     slab_post_alloc_hook mm/slub.c:4152 [inline]
>     slab_alloc_node mm/slub.c:4197 [inline]
>     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
>     kmalloc_noprof include/linux/slab.h:878 [inline]
>     extent_changeset_alloc fs/btrfs/extent_io.h:207 [inline]
>     qgroup_reserve_data+0x1c5/0x7d0 fs/btrfs/qgroup.c:4305
>     btrfs_qgroup_reserve_data+0x2e/0xb0 fs/btrfs/qgroup.c:4355
>     btrfs_do_encoded_write+0x92e/0x1040 fs/btrfs/inode.c:9746
>     btrfs_encoded_write fs/btrfs/file.c:1482 [inline]
>     btrfs_do_write_iter+0x280/0x610 fs/btrfs/file.c:1507
>     btrfs_ioctl_encoded_write+0x3d6/0x490 fs/btrfs/ioctl.c:4738
>     btrfs_ioctl+0x6f9/0xc90 fs/btrfs/ioctl.c:-1
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:906 [inline]
>     __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:892
>     do_syscall_x64 arch/x86/entry/common.c:47 [inline]
>     do_syscall_64+0xbe/0x1a0 arch/x86/entry/common.c:78
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Unreferenced object 0xffff888018050a00 (size 64):
>   comm "syz.0.17", pid 10297, jiffies 4294953601
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 ff 0f 00 00 00 00 00 00  ................
>     90 0a 05 18 80 88 ff ff 90 0a 05 18 80 88 ff ff  ................
>   backtrace (crc cb5c9580):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>     slab_post_alloc_hook mm/slub.c:4152 [inline]
>     slab_alloc_node mm/slub.c:4197 [inline]
>     __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
>     kmalloc_noprof include/linux/slab.h:878 [inline]
>     kzalloc_noprof include/linux/slab.h:1014 [inline]
>     ulist_prealloc+0x9c/0x110 fs/btrfs/ulist.c:114
>     extent_changeset_prealloc fs/btrfs/extent_io.h:217 [inline]
>     __set_extent_bit+0x16b/0x1a70 fs/btrfs/extent-io-tree.c:1086
>     set_record_extent_bits+0x50/0x90 fs/btrfs/extent-io-tree.c:1821
>     qgroup_reserve_data+0x274/0x7d0 fs/btrfs/qgroup.c:4312
>     btrfs_qgroup_reserve_data+0x2e/0xb0 fs/btrfs/qgroup.c:4355
>     btrfs_do_encoded_write+0x92e/0x1040 fs/btrfs/inode.c:9746
>     btrfs_encoded_write fs/btrfs/file.c:1482 [inline]
>     btrfs_do_write_iter+0x280/0x610 fs/btrfs/file.c:1507
>     btrfs_ioctl_encoded_write+0x3d6/0x490 fs/btrfs/ioctl.c:4738
>     btrfs_ioctl+0x6f9/0xc90 fs/btrfs/ioctl.c:-1
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:906 [inline]
>     __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:892
>     do_syscall_x64 arch/x86/entry/common.c:47 [inline]
>     do_syscall_64+0xbe/0x1a0 arch/x86/entry/common.c:78
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Fix this by freeing an extent changeset before returning from
> 'btrfs_do_encoded_write()'.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks good, thans. I added it to the github for-next branch with the
addition of:

Fixes: 7c0c7269f7b5 ("btrfs: add BTRFS_IOC_ENCODED_WRITE")

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
> To whom it may be interesting, C reproducer is available at:
> https://drive.google.com/file/d/1KxCiyW9Ewsh9ySEyxaz1FWN9s9FdJLIY/view?us=
p=3Dsharing
> ---
>  fs/btrfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b446c3014b24..1ad41087b94c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9954,6 +9954,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, =
struct iov_iter *from,
>         if (cb)
>                 cleanup_compressed_bio(cb);
>  out:
> +       extent_changeset_free(data_reserved);
>         if (ret >=3D 0)
>                 iocb->ki_pos +=3D encoded->len;
>         return ret;
> --
> 2.55.0
>
>
