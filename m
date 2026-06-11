Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B061DDC2B
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 15:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781191407; cv=none; b=O2c2BhN8z0mt9BuqL8+ZZbFiO2T7gzd+eVKf1SGaBPPO5cBFYZJB9asWe+/0oSCdfzVnUEEcHoJG5SD3dErGyaY8WhNRjhTFmVaqb4a8vLCKdXI+9B+52fQCUfo3REc+p84Ymld2Ck4nxqxRANB8upg//uXgHgEsphISueA45mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781191407; c=relaxed/simple;
	bh=rC3H3QFyk8D/v9jpioFkWOLpD3UdVgo2121Nso1MeHQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=JDqz8uANtUpjsfQqwcSQPJaa5/dJDsu7quzrfkTQnc3RYpvi7wMNfTWEpstKF+rJXdTAnJyCqpu7RmKLnTcbVjsKjJEoqbxZvRUNh9ekSFT1Gz713NnRAVdkmhrwYoMhmXeAqet/DMxC+gMH5+gEgNcTtPvjen1dZ/4WBfG17M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UnRpkKiK; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UnRpkKiK"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-304e83724bfso10361925eec.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 08:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781191405; x=1781796205; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhYn0erU1t7N3AKfK2U9MsBMuI2QDn3ZYRcJwkkfniI=;
        b=UnRpkKiK3Zivp6ZPJ5DTOlyqQLZGNbgT6eUrKRXDWdkNR+Of7M72wnWKEB6pBsKT8u
         9yKDgCxTIVJfwLcrSL17+Qu48xG3jlkVtZfZC3sRwOE6YrET+WxvusXyjE0c6ZWv6dBX
         hs9ksZH/qxSQgxKDUOdvqw7W2xuqVwJIOsXw5feFNNtaCKCu+zUFDdMYC7V3agbkL3N6
         zBhrjJf11+IbTC440Yx2EAQF7kChOQAu/iNCB3za8X6Y24fFTFe9hnVLPNiV4kHgRqG4
         GcLRNucqZzLd24ZkZk18YceJD10gmOYd5vV3nTJJ6YHEweDTSj4t6DxixzLJWHnXzVV7
         r9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781191405; x=1781796205;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fhYn0erU1t7N3AKfK2U9MsBMuI2QDn3ZYRcJwkkfniI=;
        b=bL11wxCesqBjVs3jzMjg5fCNSAbzgIJ8CXvhHl/t1yek/DGpZT0a/G5zOFmbq4L/yu
         2qoe3MZNB4NWRcK+5Lb97Rs5m6ndDmb6JfQkBZIAZjLlVWkkN2kGdcnR3Tvrh80JAJL2
         Q7YPieY/4SZiCX+IOHlHCVdR7Bs+sdvDfmineTudLGbJgV3KB3uQpQEMLAyf7VC3khs9
         Euqn8tj3Ogru8RSI1HYVEPVzSJqHOPXHS+Hyig3GALDkcuHZl8KgCuXDDutaMmaDjTxQ
         UTRNxV35IumIIzN/7PEDr4Y1uDG1wkmnyggtTm2bYHKw/NRimxz26U0HapqsLqLT8lkR
         Lxlg==
X-Forwarded-Encrypted: i=1; AFNElJ8uH21aK9TJWiEErzfkggc0E64siI6IyQCS+ghhYR4HwwVcdV0vbHQUt9kYmFmQ2hEu85qLV52JHdX5QQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YweSIw8z/p+xCLNT4CkpMZrc87r7A5oKSRYL6cFx0I16NPa5KFC
	/5KZs1kVh8ChCUZdkxJLS2zlaM0MxMIFTiruDg8WAX6N+TXEwfKouG43
X-Gm-Gg: Acq92OG33iN4aGVVNDp0QMBXI+ntRPPgX+kSQFCb9AYHYvxENH3WKttpVECaj4dS8UG
	L/+mbwneHkHrLMLuRy57s9Ey+xiUG1O2BCx9jRu3Ase042HHUDTWz9o6HW+uvMNnMBvLf8y/Ct1
	qDu0MF0d7UdR+rLE04K9qFZAHnwhL26a+uwURStKe/Mccgd5ziJwwB2YWw2FZaEKyK2FnXw2z7u
	n07OPAOSCUazkQOXdH3OewUwksDfumlAbKHzi9usQKd/KIgH3Z06uKyg/S+borL5xvnKhViMJYY
	7bPWyI/hKgrvyiKUtxX6fWBKCYMloWEyaMT6hgsYZf7xlCUBil/c4p7G1rS9X23EwOKw+2koXwk
	MgX5lnyILeMQHK+tNPqkZKh/Xr+siN/RFoq5YhvmeVgw8C15aueEjQVA85UpQnuBnWCB498CmYx
	328lw0yWRKyfmO7LCBu5skEXYYz2ySayC/jx276Cl1EIfqlpp7ujfs67Qk6l2COQ==
X-Received: by 2002:a05:7300:2306:b0:2d9:a799:3c4f with SMTP id 5a478bee46e88-30804ced98cmr2345165eec.24.1781191405173;
        Thu, 11 Jun 2026 08:23:25 -0700 (PDT)
Received: from localhost ([198.176.50.157])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30806e8b141sm2109704eec.15.2026.06.11.08.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 08:23:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Jun 2026 23:23:21 +0800
Message-Id: <DJ6BNLF5MM1F.38S84NCG5XW97@gmail.com>
Cc: "Weiming Shi" <bestswngs@gmail.com>, "Xiang Mei" <xmei5@asu.edu>
Subject: Re: [PATCH] btrfs: tree-checker: validate INODE_REF's namelen
From: "Weiming Shi" <bestswngs@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <581e4f2fddc1a4cbf1ba6954ece973c36da60dd1.1781130368.git.wqu@suse.com>
In-Reply-To: <581e4f2fddc1a4cbf1ba6954ece973c36da60dd1.1781130368.git.wqu@suse.com>

On Thu Jun 11, 2026 at 6:26 AM CST, Qu Wenruo wrote:
> From: Weiming Shi <bestswngs@gmail.com>
>
> [BUG]
> A crafted btrfs image can trigger the following crash:
>
>  BUG: unable to handle page fault for address: ffffd1dc42884000
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  CPU: 9 UID: 0 PID: 1034 Comm: poc Not tainted 7.1.0-rc4-custom+ #383 PRE=
EMPT(full)  46af0a92938a63be7132e0dfd71e62327c51d5c2
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2=
022
>  RIP: 0010:memcpy+0xc/0x10
>  Call Trace:
>   <TASK>
>   read_extent_buffer+0xe4/0x100 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1=
f92a8f]
>   btrfs_get_name+0x15e/0x1e0 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f92=
a8f]
>   reconnect_path+0x165/0x390
>   exportfs_decode_fh_raw+0x337/0x400
>   ? drop_caches_sysctl_handler+0xb0/0xb0
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  RIP: 0010:memcpy+0xc/0x10
>  Kernel panic - not syncing: Fatal exception
>
> [CAUSE]
> The crafted image has the following corrupted INODE_REF item:
>
> 	item 9 key (258 INODE_REF 257) itemoff 11544 itemsize 4106
> 		index 2 namelen 4096 name: d\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000
>
> The itemsize matches the namelen, but the namelen is 4096, way larger
> than normal name length limit (BTRFS_NAME_LEN, 255).
>
> Meanwhile the memory of the @name is only 255 byte sized, this will cause
> out-of-boundary access, and cause the above crash.
>
> [FIX]
> Add extra namelen verification for INODE_REF, just like what we have
> done in ROOT_REF checks.
>
> Now the crafted image can be rejected gracefully:
>
>  BTRFS critical (device dm-2): corrupt leaf: root=3D5 block=3D30572544 sl=
ot=3D14 ino=3D259, invalid inode ref name length, has 4096 expect [1, 255]
>  BTRFS error (device dm-2): read time tree block corruption detected on l=
ogical 30572544 mirror 2
>
> Link: https://lore.kernel.org/linux-btrfs/aik0hEV6ehKx6Ldv@Air.local/
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> [ Rebase, add a Link: tag, add an simple cause analyze ]
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index b7ff3e3d3a63..9452414e2164 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1896,6 +1896,12 @@ static int check_inode_ref(struct extent_buffer *l=
eaf,
> =20
>  		iref =3D (struct btrfs_inode_ref *)ptr;
>  		namelen =3D btrfs_inode_ref_name_len(leaf, iref);
> +		if (unlikely(namelen =3D=3D 0 || namelen > BTRFS_NAME_LEN)) {
> +			inode_ref_err(leaf, slot,
> +				"invalid inode ref name length, has %u expect [1, %u]",
> +				namelen, BTRFS_NAME_LEN);
> +			return -EUCLEAN;
> +		}
>  		if (unlikely(ptr + sizeof(*iref) + namelen > end)) {
>  			inode_ref_err(leaf, slot,
>  				"inode ref overflow, ptr %lu end %lu namelen %u",

Thanks for the rebase and cleanup, and for the guidance on the report forma=
t.
Looks good to me.

Acked-by: Weiming Shi <bestswngs@gmail.com>

We will follow this format for future patch submissions. Thanks again for y=
our help.
