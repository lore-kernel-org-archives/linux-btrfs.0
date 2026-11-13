Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794589830;
	b=H/8cNSyqob70zVVxlqlGgFw02tUcfnCXOUNEhHZnnM82H/+0Ow1VzyVuz/qV6G3E3mz4
	 s2YQQUqOESAq/0sIPE2AC9n31cL3VV2z6u8hJ+NYj66u4eaJC41qP4nujgIwLLvCcXRED
	 4PCu7Epl5+ILHwkxM0lh5jIyBkLQ3UMBTwnVaURfKqnD6vOfJ2p6HsLVqVyPfmMDXvM7l
	 dwDX62J/g03aMxx7Y+W/tXcCkkYfsKvucPY1RrKmoHAh+tKI4EOcUaNMVMGSga7O6X1bm
	 s2b21q283aC6sByhf9+L2M/d7UhOpYi0lpvo9M41vB9K5/OFOt06y9F5xJXl3lnmzFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794589830;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=1UncZKHOj1Gj6FAFV1vhD+4Vnd42TlseCiBWW6E3Bl4=;
	b=drBmvgAVEOUlFJWRf1L0QTwybLdXbzDvhlYWq4ZVMRJCgrbXQX3D1TxtWmz93MlQaphn
	 pOSpyNqrF+yp4ghBeGFJA9sL8AuZXe+Ud8evHixbY6naqkMfo/iBZgxh7i7ga0PkpYihk
	 XWPaglchpB6gb1oc/F761BAWG0WV44UJRnDjsSYiM1MXOOJTqAJLTzNVp53PiyS89B9ao
	 Ajo8Nd50KITBnEezeTXdVNPAZakDxsc+fshlZRtE3dzkkKeTDPjuCDk0PzrryKZ4U7KFp
	 kkih14wsipKMmSitC0GTqVo3BPpUGiQNE/5VkENIjGpCxr+Pgjzur5cDRlbjC0qBL1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrzCfui5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5229A606A32D
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrzCfui5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C7A1F000C6
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794589829;
	bh=1UncZKHOj1Gj6FAFV1vhD+4Vnd42TlseCiBWW6E3Bl4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JrzCfui5uJ7Ur8WtJDBbJ8uudPd3S+9i2rdocMY79m12qgtLScB8EcVgu2tw4t/BI
	 W3oHUOGvmemBXCqrqT5Tyn0PTIoJ6h5EIvNTIZlVBE4oS/cSnkoqZLzTPecYhDxIOC
	 wrHQ117T7jxY1xFTkStl0ii7skXe5UNas11NG4SVW0a5JCYSyGcxksOKxs2IiCJiR3
	 cie6yYXUaRBnaT0F1aj0Nxn8EKWHGC92b4VzD+2qxFhL5SzKtfhGYaUf0z5KFmAP7R
	 9CMwq+wJqgtJ8XrA8z/xtucRkOAGcxhpJ5SALCGiebnjAr0jyr9zxaOZiIsus4jdXO
	 VPDpuhU8V+OdA==
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-99075306daaso1860878241.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 09:10:29 -0800 (PST)
X-Gm-Message-State: APuU4Z9uhrmZMEIPyST+w2jQtyQrOSKgp0nbn6CcEzlxlcx3gd9+gGA6
	2PvicL3vJ7AcpoZmRvGX1Lx/8dvsgn8Je5uXa5pQJzkoqqoctb2JKORaNLJxPaM4KmrH/VVQA9t
	ww7Y8Hi7lCLdnLEN/IVxwkF4A5efJxyM=
X-Received: by 2002:a05:6122:e22f:b0:5ee:200a:8cb7 with SMTP id
 71dfb90a1353d-5ee34aaf256mr1243645e0c.17.1794589829125; Fri, 13 Nov 2026
 09:10:29 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <27888031e07cccb13dcf61462472b132df7df99b.1794539183.git.wqu@suse.com>
In-Reply-To: <27888031e07cccb13dcf61462472b132df7df99b.1794539183.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 13 Nov 2026 17:09:52 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7mZu72dzjBjOAwieBD705nx3c5C2e+kE3L2iwXaQTgBA@mail.gmail.com>
X-Gm-Features: AclHuK-h8Y8KPARQRqXULV9c3k4aSzNyrUcfnK4uuyP-Rx5t0JUYWAedMmoOa0w
Message-ID: <CAL3q7H7mZu72dzjBjOAwieBD705nx3c5C2e+kE3L2iwXaQTgBA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix an off-by-one bug when reading backup supers
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 6:03=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> The check inside btrfs_read_disk_super() has an off-by-one bug:
>
>         if (bytenr + BTRFS_SUPER_INFO_SIZE >=3D bdev_nr_bytes(bdev))
>                 return ERR_PTR(-EINVAL);
>
> This means if a backup super is exactly at the end of the device,
> btrfs_read_disk_super() will reject it.
>
> This is not going to cause any problem, as btrfs kernel module never
> utilizes any backup super blocks.
> This also means Sashiko is overstating the severity of the bug.
>
> Only btrfs_scratch_superblock() is affected, which will skip the
> scratching the backup super.
> But even with that backup super block left, it won't cause anything
> wrong, since device scan/mount will never touch those backups.
>
> So just change this to follow write_dev_supers() to allow reading the
> backup superblock at the end of the device.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-2d915102-fe48-454c-ba6c-941e86a9ac4=
3
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8b94c509b85d..5ec2f286abcd 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1378,7 +1378,7 @@ struct btrfs_super_block *btrfs_read_disk_super(str=
uct block_device *bdev,
>                 return ERR_PTR(ret);
>         }
>
> -       if (bytenr + BTRFS_SUPER_INFO_SIZE >=3D bdev_nr_bytes(bdev))
> +       if (bytenr + BTRFS_SUPER_INFO_SIZE > bdev_nr_bytes(bdev))
>                 return ERR_PTR(-EINVAL);
>
>         if (drop_cache) {
> --
> 2.56.0
>
>
