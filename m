Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B23235DA40
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782775387; cv=none; b=ktHJ/TXyNz7HuxmzWTDyhreJdSPAvGZ+880bqfClfo6dTR9xPE8xoGdNVRWT7d17WWoy8BV2RRJyZ+62NH3Jmc89U5qmqXKgG3Vkk1S3kUY4wtxWAbsPQDZ4DyPHrldScOeGJAYelawwb9GFYNJus6oAIRSwVCCNQ7j2s0IfrbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782775387; c=relaxed/simple;
	bh=oH0WHbmT2wL3m7PSIkvor+A+GRSqIr+J0MqgZilhTUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ewbspUW2m0qVNUJn3jQugdPngJv1iN5Ge1NXCHgvkihWl9u39gR9bQ6X092Un/VFTOQ4B3fByPOSARxKjQxkOm0iBHXumNFvvBti1ZEfvxXh7mx9azG/elzioT1xhqxsbEeYIGf1g9mb9uctqRDeZXNaDuh556exTQoEoHa5JvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=qd60aqUa; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="qd60aqUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782775379; x=1783380179; i=quwenruo.btrfs@gmx.com;
	bh=nAEY0Wop3OJd6sEq5ri3H1BgdOj5pFLnDpTWtYuGv+A=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qd60aqUaMpKlOa09Yz+LgvUhgV6D9yTa+TyMm9P0ng1gpos0PtGVmD/MRY+eTjFw
	 hLC/KunprHDVsEpgoX1GpxBkcw0qzH7mZljgt9TmP7+pm55Op5xYCNmadJljPrhlX
	 hjanU0jOthFvjd5WFRWc/lFhk1KDuGZOC7aB6kV0OjNvqlb2kJ/4EL9vX2bIyjVQq
	 opMhmgfmSeDRrvhwHKglFp6GP4gnVHFq5gDv1rxVf5kfqH+QkPx0MpShxmEYXDP5Y
	 mMOy/3N5Lmq/IYsCMfQEa1uw9WROwL51jsjhXE7key201JPt9iYlUVnSJjph+t14k
	 C6ojyscrR+vy9MSNag==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mqb1W-1xQYEt0ajw-00h39h; Tue, 30
 Jun 2026 01:22:59 +0200
Message-ID: <133034c0-2ca8-4a1d-80e1-352946c04d4c@gmx.com>
Date: Tue, 30 Jun 2026 08:52:56 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix NULL pointer deref during assertion in
 btrfs_backref_free_node()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <8bc196601d6cd471a97a175a3f328425e1efc62f.1782745731.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <8bc196601d6cd471a97a175a3f328425e1efc62f.1782745731.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fWSz40up1agscBPOvVyDmGFxEeDZs6XooHthPO+jQEXAU4ji7g4
 MgvB+vAjM9iJuyZ54Wl/qatqcI7eE0Bqu76iPRP+L6m4QLQeOkiMMdf0av850k979xPqqnM
 XWUKP1Hrc6S5PYwxUQR6nty+ms6Y6IEP1Le2SKr5fhSxXSWk3XTGEA/Rga6CN3MkKlxHDPC
 02JYTsw9Fz/EdOX17xXnA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yVQQ9KbNHCY=;02p52DXaDdkLc5Oovino4NxF2Nc
 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
 F9zQW9gBw=



=E5=9C=A8 2026/6/30 00:39, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> In btrfs_backref_free_node() we have the following assertion:
>=20
>    ASSERT(node->eb =3D=3D NULL, "node->eb->start=3D%llu", node->eb->star=
t);
>=20
> and a user reported the following crash:
>=20
>    Oops: general protection fault, probably for non-canonical address 0x=
dffffc0000000000: 0000 [#1] SMP KASAN NOPTI
>    KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007=
]
>    CPU: 0 UID: 0 PID: 10422 Comm: syz.0.17 Not tainted 7.1.0-02765-g6b5a=
2b7d9bc1-dirty #44 PREEMPT(full)
>    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 =
04/01/2014
>    RIP: 0010:btrfs_backref_free_node fs/btrfs/backref.c:3057 [inline]
>    RIP: 0010:btrfs_backref_free_node+0xb9/0x200 fs/btrfs/backref.c:3051
>    Code: 00 fc ff (...)
>    RSP: 0018:ffa0000006b0f3c0 EFLAGS: 00010246
>    RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff840eb78b
>    RDX: 0000000000000000 RSI: ffffffff840eafa5 RDI: ff110000742ab768
>    RBP: ff110000742ab700 R08: 0000000000000000 R09: 0000000000000000
>    R10: ff110000742ab700 R11: 00000000000a81f9 R12: ff11000107a92020
>    R13: ff1100005c182ea8 R14: 0000000000000000 R15: dffffc0000000000
>    FS:  0000555575536500(0000) GS:ff11000183985000(0000) knlGS:000000000=
0000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 00007fa3d0e9d580 CR3: 000000002232a000 CR4: 0000000000753ef0
>    PKRU: 00000000
>    Call Trace:
>     <TASK>
>     btrfs_backref_cleanup_node+0x27/0x30 fs/btrfs/backref.c:3133
>     relocate_tree_block fs/btrfs/relocation.c:2604 [inline]
>     relocate_tree_blocks+0x11b0/0x1a20 fs/btrfs/relocation.c:2707
>     relocate_block_group+0x499/0xf30 fs/btrfs/relocation.c:3635
>     do_nonremap_reloc fs/btrfs/relocation.c:5323 [inline]
>     btrfs_relocate_block_group+0x1749/0x5fb0 fs/btrfs/relocation.c:5490
>     btrfs_relocate_chunk+0x12b/0x950 fs/btrfs/volumes.c:3647
>     __btrfs_balance fs/btrfs/volumes.c:4586 [inline]
>     btrfs_balance+0x1c7f/0x55c0 fs/btrfs/volumes.c:4973
>     btrfs_ioctl_balance fs/btrfs/ioctl.c:3474 [inline]
>     btrfs_ioctl+0x38a4/0x5d20 fs/btrfs/ioctl.c:5570
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:597 [inline]
>     __se_sys_ioctl fs/ioctl.c:583 [inline]
>     __x64_sys_ioctl+0x18f/0x210 fs/ioctl.c:583
>     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>     do_syscall_64+0x11f/0x860 arch/x86/entry/syscall_64.c:94
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     RIP: 0033:0x7fb38e3b56dd
>     Code: 02 b8 ff (...)
>     RSP: 002b:00007fff04115788 EFLAGS: 00000246 ORIG_RAX: 00000000000000=
10
>     RAX: ffffffffffffffda RBX: 00007fb38f6b0020 RCX: 00007fb38e3b56dd
>     RDX: 00002000000003c0 RSI: 00000000c4009420 RDI: 0000000000000004
>     RBP: 00007fb38e451b48 R08: 0000000000000000 R09: 0000000000000000
>     R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>     R13: 0000000000000000 R14: 00007fb38f6b0020 R15: 00007fb38f6b002c
>     </TASK>
>=20
> It seems that this happens on some systems for some reason, when the
> ASSERT() macro calls the inline function verify_assert_printk_format()
> to evaluate the format string and arguments, causing the NULL pointer
> dereference on node->eb.
>=20
> So change the assertion to check for a NULL node->eb before dereferencin=
g
> it. Also, while at it, make the assertion more useful by printing the
> owner of the extent buffer as well as its level.
>=20
> Reported-by: Yue Sun <samsun1006219@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/20260626065542.38413-1-samsun1=
006219@gmail.com/
> Fixes: c4e7778580d6 ("btrfs: use verbose assertions in backref.c")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/backref.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 23c3eeb58dc1..1be632c742bd 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -3054,7 +3054,10 @@ void btrfs_backref_free_node(struct btrfs_backref=
_cache *cache,
>   	if (node) {
>   		ASSERT(list_empty(&node->list));
>   		ASSERT(list_empty(&node->lower));
> -		ASSERT(node->eb =3D=3D NULL, "node->eb->start=3D%llu", node->eb->star=
t);
> +		ASSERT(node->eb =3D=3D NULL, "node->eb->start=3D%llu level=3D%d owner=
=3D%llu",
> +		       node->eb ? node->eb->start : 0,
> +		       node->eb ? btrfs_header_level(node->eb) : 0,
> +		       node->eb ? btrfs_header_owner(node->eb) : 0);
>   		cache->nr_nodes--;
>   		btrfs_put_root(node->root);
>   		kfree(node);

